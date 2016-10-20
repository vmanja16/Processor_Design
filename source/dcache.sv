/*
  Vikram Manja
  vmanja@purdue.edu
*/


// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

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

module dcache(input logic CLK, nRST, datapath_cache_if.cache dcif, caches_if cif);

typedef enum logic[3:0] {
  IDLE,
  LOAD_0,
  LOAD_1,
  WRITEBACK_0,
  WRITEBACK_1,
  WRITE_MISS_CLEAN,
  WRITE_MISS_WB_0,
  WRITE_MISS_WB_1
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

logic [7:0] index;
logic [7:0] LRU, next_LRU;
dcachef_t daddr_in;
dcacheframe_t  next_set [1:0];
dstate_t state, next_state;
dcacheframe_t sets[7:0][1:0];
dcacheframe_t lru_frame, frame0, frame1;
logic blkoff, match0, match1, match, lru;
word_t lru_addr;

logic readhit, read_tag_miss_clean, read_tag_miss_dirty, writehit, write_tag_miss_clean, write_tag_miss_dirty;

// NOTE: on a load_WRITEBACK, can load first(give a dhit) and then writeback (from WB registers)
// QUESTION: SHOULD DWEN/DREN come out of latches!?

/*
  readhit: read and data is in cache
  read_tag_miss_clean: (LRU is clean) so load data 0,1 from memory into LRU, set nLRU = ~LRU, valid =1 dirty =0, dREN = 1;
  read_tag_miss_dirty: (LRU is dirty) so write(dWEN=1) LRU data 0,1 into memory from cache, move to read_tag_miss_clean
  writehit: Write dmemstore to specified block, set dirty = 1; valid = 1; LRU = nonwritten frame;
  write_tag_miss_clean: (LRU clean)1st cycle: replace LRU tag, write dmemstore to LRU block[offset], set dirty=1; set valid = 0;
                                   2nd cycle: Load other word from memory, set dirty=1, set valid = 1, LRU = ~LRU;
  write_tag_miss_dirty: (LRU dirty) Writeback LRU 0,1, move to write_tag_miss_clean

*/
// OUTPUTS
 // dcif.dhit cif.dREN cif.dWEN cif.daddr cif.dstore dcif.dmemload
 assign dcif.dhit = (readhit || writehit);
 assign dcif.dmemload  = sets[index][match1].data[blkoff];
 // cif signals assigned in combinational block


// Internals
  assign daddr_in  = dcif.daddr;
  assign index     = daddr_in.idx;
  assign blkoff    = daddr_in.blkoff;
  assign frame0    = sets[index][0];
  assign frame1    = sets[index][1];
  assign lru_frame = sets[index][LRU[index]];
  assign match0    = (daddr_in.tag == frame0.tag) && (frame0.valid); // checks match and valid
  assign match1    = (daddr_in.tag == frame1.tag) && (frame1.valid); // checks match and valid
  assign match     = (match0 || match1);
  assign lru       = LRU[index];
  assign lru_addr  = {lru_frame.tag, index, 3'b00}; 

  assign readhit             = dcif.dmemREN &&  match;
  assign read_tag_miss_clean  = dcif.dmemREN &&  !match &&  !lru_frame.dirty;
  assign read_tag_miss_dirty  = dcif.dmemREN &&  !match &&  lru_frame.dirty;
  assign writehit             = dcif.dmemWEN &&  match;  
  assign write_tag_miss_clean = dcif.dmemWEN &&  !match && !lru_frame.dirty;
  assign write_tag_miss_dirty = dcif.dmemWEN &&  !match && lru_frame.dirty;

// UPDATE REGISTERS
always_ff @(posedge CLK, negedge nRST) begin 
  if(!nRST) begin 
      sets <= '{default:'0};
      LRU    <= '0;
      state  <= IDLE;
  end 
  else begin
    sets[index] <= next_set;
    LRU[index]  <= next_LRU;
    state       <= next_state;
  end
end // end always_ff

always_comb begin
  next_set   = sets[index];
  next_LRU   = LRU[index];
  next_state = state;
  cif.dREN   = 0;
  cif.dWEN   = 0;
  cif.daddr  = dcif.dmemaddr;
  cif.dstore = dcif.dmemstore;
  casez (state)
    IDLE: begin
      if (readhit) begin
        next_LRU = match0; // if it maches 0, LRU is tag 1
      end
      else 
      if (read_tag_miss_clean) begin
        cif.dREN = 1; cif.daddr = dcif.daddr; // maybe don't need
        next_state = LOAD_0;
      end
      else
      if (read_tag_miss_dirty) begin
        cif.dREN = 0; cif.dWEN = 1; cif.daddr = lru_addr; // maybe don't need this.
        next_state = WRITEBACK_0; 
      end
      else 
      if (writehit) begin
        if (match0) next_set[0].data[blkoff] = dcif.dmemstore;
        if (match1) next_set[1].data[blkoff] = dcif.dmemstore;
        next_LRU = match0;
      end
      else 
      if (write_tag_miss_clean) begin
        cif.dREN = 1; cif.dWEN = 0; cif.daddr = dcif.daddr - (blkoff ? 4 : 0); // maybe don't need this
        next_state = WRITE_MISS_CLEAN;
      end
      else 
      if (write_tag_miss_dirty) begin
        cif.dWEN = 1; cif.daddr = lru_addr; // maybe don't need this
        next_state = WRITEBACK_0;
      end
    end // end IDLE

    LOAD_0: begin
      cif.dREN = 1; cif.dWEN = 0; cif.daddr = dcif.daddr;
      if (!cif.dwait) begin
        next_state = LOAD_1;
        next_set[lru].tag     = daddr_in.tag;
        next_set[lru].data[0] = cif.dload;
        next_set[lru].valid   = 0;
        next_set[lru].dirty   = 0;
        cif.daddr = dcif.daddr + 4; // maybe don't need this
      end
    end
    LOAD_1: begin
      cif.dREN = 1; cif.dWEN = 0; cif.daddr = dcif.daddr + 4;
      if (!cif.dwait) begin
        next_state = IDLE;
        next_set[lru].data[1] = cif.dload;
        next_set[lru].valid = 1;
        cif.dREN = 0;
        next_LRU = !lru;
      end
    end
    WRITEBACK_0: begin
      cif.dWEN = 1; cif.dREN = 0; cif.daddr = lru_addr;
      if (!cif.dwait) begin
        next_state = WRITEBACK_1;
        cif.daddr = lru_addr + 4;
      end
    end
    WRITEBACK_1: begin
      cif.dWEN = 1; cif.dREN = 0; cif.daddr = lru_addr + 4;
      if (!cif.dwait) begin
        next_state = LOAD_0;
        cif.daddr = dcif.daddr0; // maybe don't need this
        cif.dWEN = 0; cif.dREN = 1; // maybe don't need this
        if (write_tag_miss_dirty) begin
          next_state = WRITE_MISS_CLEAN;
          cif.dREN = 1; cif.dWEN = 0; cif.daddr = dcif.daddr - (blkoff ? 4 : 0); // maybe don't need this     
        end
      end
    end
    WRITE_MISS_CLEAN: begin
      cif.dREN = 1; cif.dWEN = 0; cif.daddr = dcif.daddr - (blkoff ? 4 : 0);
      if (!dcif.dwait) begin
        next_set[lru].data[blkoff]  = dcif.dmemstore; // write to word from DP
        next_set[lru].data[!blkoff] = cif.dload;  // write to other word from Mem
        next_set[lru].valid = 1;
        next_set[lru].dirty = 1;
        next_state = IDLE;
        next_LRU = !lru;
        cif.dREN = 0; cif.dWEN = 0; // maybe don't need this (might even be bad)
      end
    end
    default : /* default */;
  endcase

end // end_always_comb
endmodule
