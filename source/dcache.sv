/*
  Vikram Manja
  vmanja@purdue.edu
*/


// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "dcache_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

/*
_________________________________________________________________________________________________________
|                     TWO-WAY ASSOCIATIVE 1024 bit DCACHE    (2 words/block)                            |
|_______________________________________________________________________________________________________|
|           |------------      FRAME 0  ----------------|   |------------      FRAME 1  ----------------|
|___________|___________________________________________|_ _|___________________________________________|
|Index| LRU | Valid | Dirty | Tag | Blk | data [2words] | | | Valid | Dirty | Tag | Blk | data [2words] |
| 0   |     |       |       |     |     |               | | |       |       |     |     |               |
| 1   |     |       |       |     |     |               | | |       |       |     |     |               |
| 2   |     |       |       |     |     |               | | |       |       |     |     |               |
| 3   |     |       |       |     |     |               | | |       |       |     |     |               |
| 4   |     |       |       |     |     |               | | |       |       |     |     |               |
| 5   |     |       |       |     |     |               | | |       |       |     |     |               |
| 6   |     |       |       |     |     |               | | |       |       |     |     |               |
| 7   |     |       |       |     |     |               | | |       |       |     |     |               |
|_______________________________________________________________________________________________________|
*/

//module dcache(input logic CLK, nRST, datapath_cache_if dc, caches_if dc);
module dcache(input logic CLK, nRST, dcache_if dc);

typedef enum logic[3:0] {
  IDLE, 
  LOAD_0, LOAD_1,
  WRITEBACK_0, WRITEBACK_1,
  WRITE_MISS_CLEAN,
  HALT_0, HALT_1,
  FLUSHED, SNOOP_0, SNOOP_1
} dstate_t;

  typedef struct packed {
    logic               valid;
    logic               dirty;
    logic [DTAG_W-1:0]  tag;
    //logic [DIDX_W-1:0]  idx;
    logic [DBLK_W-1:0]  blkoff;
    logic [DBYT_W-1:0]  bytoff;
    word_t [1:0]        data;
  } dcacheframe_t;

logic [2:0] index;
logic  LRU [7:0], next_LRU;
dcachef_t daddr_in, snoop_in;
dcacheframe_t  next_set [1:0];
dstate_t state, next_state, prev_state;
dcacheframe_t sets[7:0][1:0];
dcacheframe_t lru_frame, frame0, frame1, halt_frame, snoop_frame;
logic blkoff, match0, match1, match, lru;
word_t lru_addr, halt_addr;
logic [4:0] halt_count, next_halt_count;
logic [2:0] halt_idx;
word_t link_address, next_link_address;
logic link_valid, next_link_valid;
logic count_written, next_count_written;

logic readhit, read_tag_miss_clean, read_tag_miss_dirty, writehit, write_tag_miss_clean, write_tag_miss_dirty, snoop_match;
logic snoop_match1, snoop_match0;

logic next_snoop_dirty, next_halt_dirty, next_snoop_valid, write_wait; logic snoop_enable;

logic link_match, snoop_link_match, write_atomic, atomic_hit, write_atomic_fail;
word_t atomic_val;

/*
  readhit: read and data is in cache
  read_tag_miss_clean: (LRU is clean) so load data 0,1 from memory into LRU, set nLRU = ~LRU, valid =1 dirty =0, dREN = 1;
  read_tag_miss_dirty: (LRU is dirty) so write(dWEN=1) LRU data 0,1 into memory from cache, move to read_tag_miss_clean
  writehit: Write dmemstore to spedcied block, set dirty = 1; valid = 1; LRU = nonwritten frame;
  write_tag_miss_clean: (LRU clean)1st cycle: replace LRU tag, write dmemstore to LRU block[offset], set dirty=1; set valid = 0;
                                   2nd cycle: Load other word from memory, set dirty=1, set valid = 1, LRU = ~LRU;
  write_tag_miss_dirty: (LRU dirty) Writeback LRU 0,1, move to write_tag_miss_clean

*/
// OUTPUTS
 // dc.dhit dc.dREN dc.dWEN dc.daddr dc.dstore dc.dmemload
 assign dc.dhit     = ((readhit || (writehit && !write_wait)) && (state==IDLE)) || (atomic_hit);
 assign dc.dmemload = write_atomic ? atomic_val : sets[index][match1].data[blkoff];
 assign dc.flushed  = (count_written); 
 
// COHERENCE
  assign dc.ccwrite = snoop_match && snoop_frame.dirty;
// SNOOPING
  assign snoop_match = (snoop_match0 ) || ( snoop_match1  );
  assign snoop_match0 = (sets[snoop_in.idx][0].valid) && (snoop_in.tag == sets[snoop_in.idx][0].tag);
  assign snoop_match1 = (sets[snoop_in.idx][1].valid) && (snoop_in.tag == sets[snoop_in.idx][1].tag);
  assign snoop_in.blkoff = dc.ccsnoopaddr[2];
  assign snoop_in.idx    = dc.ccsnoopaddr[5:3];
  assign snoop_in.tag    = dc.ccsnoopaddr[31:6];
  assign snoop_frame     = sets[snoop_in.idx][!snoop_match0];

// LINKING
  assign link_match          = (dc.dmemaddr    == link_address) && link_valid;
  assign snoop_link_match    = (dc.ccsnoopaddr == link_address);
  assign write_atomic        = (dc.dmemWEN && dc.datomic);
  assign write_atomic_fail   = write_atomic && !link_match;

 // dc signals assigned in combinational block


// Internals
 // assign daddr_in   = dc.dmemaddr;
  assign daddr_in.blkoff = dc.dmemaddr[2];
  assign daddr_in.idx    = dc.dmemaddr[5:3];
  assign daddr_in.tag    = dc.dmemaddr[31:6];

always_comb begin
  index = daddr_in.idx;
  if(state==SNOOP_0) index = snoop_in.idx;
  if(state==SNOOP_1) index = snoop_in.idx;
  if(state==HALT_0)  index = halt_idx;
  if(state==HALT_1)  index = halt_idx; 
end
  //assign index      = daddr_in.idx;
  
  assign blkoff     = daddr_in.blkoff;
  assign frame0     = sets[index][0];
  assign frame1     = sets[index][1];

  assign halt_idx   = halt_count[3:1];
  assign halt_frame = sets[halt_idx][halt_count[0]];
  assign halt_addr  = {halt_frame.tag, halt_idx, 3'b000};

  assign match0    = (daddr_in.tag == frame0.tag) && (frame0.valid); // checks match and valid
  assign match1    = (daddr_in.tag == frame1.tag) && (frame1.valid); // checks match and valid
  assign match     = (match0 || match1);

  assign lru       = LRU[index];
  assign lru_addr  = {lru_frame.tag, index, 3'b000}; 
  assign lru_frame = sets[index][lru];

  assign readhit              = dc.dmemREN &&  match;
  assign read_tag_miss_clean  = dc.dmemREN &&  (!match) &&  (!lru_frame.dirty);
  assign read_tag_miss_dirty  = dc.dmemREN &&  (!match) &&  lru_frame.dirty;

  assign writehit             = dc.dmemWEN &&  match;  
  assign write_tag_miss_clean = dc.dmemWEN &&  (!match) && (!lru_frame.dirty);
  assign write_tag_miss_dirty = dc.dmemWEN &&  (!match) && lru_frame.dirty;

// UPDATE REGISTERS
always_ff @(posedge CLK, negedge nRST) begin 
  if(!nRST) begin 
      sets       <= '{default:'0};
      LRU        <= '{default:'0};
      state      <= IDLE;
      halt_count <= 0;
      count_written <= 0;
      prev_state <= IDLE;
      link_valid <= 0;
      link_address <= 0;

  end
  else if (count_written) begin sets <= '{default:'0}; link_valid <=0; end
  else begin
    sets[index]   <= next_set;
    LRU[index]    <= next_LRU;
    state         <= next_state;
    halt_count    <= next_halt_count;
    count_written <= next_count_written;
    prev_state    <= state;
    link_valid    <= next_link_valid;
    link_address <= next_link_address;  
  end
end // end always_ff

always_comb begin
  atomic_val = 0;
  dc.cctrans = 0;
  next_set   = sets[index];
  next_LRU   = LRU[index];
  next_state = state;
  next_halt_count = halt_count;
  dc.dREN   = 0;
  dc.dWEN   = 0;
  dc.daddr  = dc.dmemaddr;
  dc.dstore = dc.dmemstore;
  next_count_written = count_written;
  next_link_address = link_address;
  next_link_valid = link_valid;
  write_wait = 1;
  atomic_hit = 0;
  
  casez (state)
    IDLE: begin
      if (readhit) begin 
        next_LRU = match0; 
        if(dc.datomic) begin 
          next_link_valid = 1; 
          next_link_address = dc.dmemaddr;
        end
      end// if it maches 0, LRU is tag 1
      if (dc.ccwait) begin next_state = SNOOP_0; end
      else if (dc.halt) begin if (halt_count < 16) next_state  = HALT_0; else next_state = FLUSHED; end
      else if (read_tag_miss_clean) next_state = LOAD_0;
      else if (read_tag_miss_dirty) next_state = WRITEBACK_0; 
      else if (write_atomic_fail) begin  atomic_val = 0;  atomic_hit = 1; end // SC RETURNS 0 on write_atomic_fail!
      else if (writehit) begin 
        if(!sets[index][match1].dirty) begin
          dc.cctrans=1;
          if(!dc.dwait) begin // NEED COHERENCE TO INVALIDATE THE OTHER GUY!
            write_wait = 0; 
            if(write_atomic) begin atomic_val = 1; atomic_hit=1; end // SC RETURNS 1
            if (match0) begin next_set[0].data[blkoff] = dc.dmemstore; next_set[0].dirty = 1; end
            if (match1) begin next_set[1].data[blkoff] = dc.dmemstore; next_set[1].dirty = 1; end
            next_LRU = match0;
            if (link_match) next_link_valid = 0; 
          end
        end
        else begin //dirty on dirty
          if(write_atomic) begin atomic_val = 1; atomic_hit=1;end // SC RETURNS 1
          write_wait = 0; // ALL GOOD TO GIVE A DHIT SINCE memory will be updated!
          if (match0) begin next_set[0].data[blkoff] = dc.dmemstore; next_set[0].dirty = 1; end
          if (match1) begin next_set[1].data[blkoff] = dc.dmemstore; next_set[1].dirty = 1; end
          next_LRU = match0;
          if (link_match) next_link_valid = 0; 
        end        
      end
      else if (write_tag_miss_clean) begin next_state = WRITE_MISS_CLEAN; end
      else if (write_tag_miss_dirty) next_state = WRITEBACK_0;
    end // end IDLE
    LOAD_0: begin
      dc.dREN = 1; dc.daddr = dc.dmemaddr - (blkoff ? 4 : 0);
      if (!dc.dwait) begin
        next_state = LOAD_1;
        next_set[lru].data[0] = dc.dload;
        next_set[lru].valid = 0; next_set[lru].dirty = 0;
      end
    if (dc.ccwait) begin next_state = SNOOP_0; end
    end
    LOAD_1: begin
      dc.dREN = 1; dc.daddr = dc.dmemaddr + (blkoff ? 0 : 4);
      if (!dc.dwait) begin
        next_state            = IDLE;
        next_set[lru].data[1] = dc.dload;
        next_set[lru].valid   = 1;
        next_set[lru].dirty   = 0;
        next_set[lru].tag     = daddr_in.tag;
        next_LRU = !lru;
      end
    end
    WRITEBACK_0: begin
      dc.dWEN = 1; dc.daddr = lru_addr;    dc.dstore = lru_frame.data[0];
      if (!dc.dwait) next_state = WRITEBACK_1;
      if (dc.ccwait) begin next_state = SNOOP_0; end
    end
    WRITEBACK_1: begin
      dc.dWEN = 1; dc.daddr = lru_addr + 4; dc.dstore = lru_frame.data[1];
      if (!dc.dwait) begin
        next_state = LOAD_0;
        next_set[lru].dirty = 0;
        if (write_tag_miss_dirty) begin
          next_state = WRITE_MISS_CLEAN;
        end
      end
    end
    WRITE_MISS_CLEAN: begin
      dc.cctrans = 1;
      dc.dREN = 1; dc.daddr = dc.dmemaddr + (blkoff ? -4 : 4);
      if (!dc.dwait) begin
        next_set[lru].data[blkoff]  = dc.dmemstore; // write to word from DP
        next_set[lru].data[!blkoff] = dc.dload;  // write to other word from Mem
        next_set[lru].valid         = 1;
        next_set[lru].dirty         = 1;
        next_set[lru].tag           = daddr_in.tag;
        next_state                  = IDLE;
        next_LRU = !lru;
        if(write_atomic) begin atomic_hit =1; atomic_val = 1; end // SC returns 1
        if (link_match) next_link_valid = 0; // invalidates on Store to link_addr
      end
      if (dc.ccwait) begin next_state = SNOOP_0; end
    end
    HALT_0: begin
      if (halt_count == 16) next_state = FLUSHED;
      else if (halt_frame.dirty) begin 
        dc.dWEN = 1; dc.daddr = halt_addr; dc.dstore = halt_frame.data[0]; 
        if (!dc.dwait) next_state = HALT_1;
      end
      else begin
        next_state = HALT_0; next_set[halt_count[0]].valid =0; next_set[halt_count[0]].dirty=0;
        next_halt_count = halt_count + 1;
      end
      if (dc.ccwait) begin next_state = SNOOP_0; end
    end
    HALT_1: begin
        dc.dWEN = 1; dc.daddr = halt_addr+4; dc.dstore = halt_frame.data[1]; 
        if (!dc.dwait) begin next_state = HALT_0; next_halt_count = halt_count + 1;  
          next_set[halt_count[0]].valid=0; next_set[halt_count[0]].dirty = 0; 
        end
    end
    FLUSHED: begin next_count_written = 1; end
    SNOOP_0: begin
      dc.dstore = snoop_frame.data[0];
      dc.daddr  = snoop_frame.data[1];
      if(snoop_match) begin 
        if(dc.ccinv) begin 
          next_set[snoop_match1].valid = 0; next_set[snoop_match1].dirty=0;
          next_state=IDLE;

          if(snoop_link_match) next_link_valid = 0; // LINK INVALIDATE 
        end
        if(!dc.dwait) begin next_state = SNOOP_1; end;
      end
      else begin next_state = IDLE; end
      if(!dc.ccwait) begin next_state = IDLE; end;  
    end
    SNOOP_1: begin
      dc.dstore = snoop_frame.data[1];
      dc.daddr  = snoop_frame.data[0];
      if(!dc.dwait) begin
        if (dc.ccinv) begin  next_set[snoop_match1].valid=0;   if(snoop_link_match) next_link_valid=0; end
        next_set[snoop_match1].dirty = 0;
        next_state = IDLE;
      end
    end

    default: begin end 
  endcase 
end // end_always_comb




endmodule
