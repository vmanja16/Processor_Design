/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module coherence_control (
  input CLK, nRST,
  cache_control_if ccif,
  coherence_control_if cocif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

/*
  modport cc (
            // cache inputs
    input   iREN, dREN, dWEN, dstore, iaddr, daddr,
            // ram inputs
            ramload, ramstate,
            // coherence inputs from cache
            ccwrite, cctrans, ccwrite = writing, cctrans = miss
            // cache outputs
    output  iwait, dwait, iload, dload,
            // ram outputs
            ramstore, ramaddr, cocif.ramWEN, cocif.ramREN,
            // coherence outputs to cache
            ccwait, ccinv, ccsnoopaddr
  );
*/

/*
The coherence control must run through the following operations:

First, it decides on a memory request to work on from one of the two caches. 
Then, it will take the memory request and send the snoop address to the other cache. 
Once the other cache does the coherence operation, either write back or invalidate, 


General workflow for READING:

Cycle 1:
  Cache 1: Makes request and goes to : LOAD0/WMC looking to read 
  Controller -> Goes to Snoop state to assert ccwait on cache2
  Cache 2: Gets the ccwait from controller
Cycle 2:
  Cache 1: Receives data from either cache2::SNOOP0 or from memory
  Controller: Grabs data from either memory or cache2::SNOOP0
              if from cache2: Writes back the data at the same time
  Cache 2: Sends data from SNOOP0 if snoophit // may also have already flushed(won't send)
Cycle 3: if snoophit, cache2::SNOOP1 gives the data for word2

Replacement/Halt writebacks are snoop independent.

// write: Implies that the ccsnoopaddr is available in the requestee cache

*/

typedef enum logic [3:0] {IDLE, LOAD_0, LOAD_1, 
                          WRITE_BACK_0, WRITE_BACK_1,
                          INVALIDATE_0, INVALIDATE_1,
                          SNOOP, WRITE_MISS_CLEAN_0, WRITE_MISS_CLEAN_1,
                          CACHECACHE0, CACHECACHE1,
                          LOAD_SNOOP} coherence_state_t;

coherence_state_t state, next_state;

logic select; // selects which cache's arbitration signals to send

logic requestor, next_requestor, rec;
logic snoop_hit;

word_t word_0, next_word_0;
/****************************************************************************************************************************
//                                            COHERENCE
/***************************************************************************************************************************/

always_ff @ (posedge CLK, negedge nRST) begin
  if (!nRST) begin state <= IDLE; requestor <= 0; word_0<=0; end
  else       begin 
    state     <= next_state; 
    requestor <= next_requestor; 
    word_0    <= next_word_0;
  end

end // end always_ff

// Internals
assign rec = !requestor;
assign snoop_hit  = ccif.ccwrite[rec];

// Coherence combinational logic


always_comb begin
  next_state     = state;
  next_requestor = requestor; // requestor
  ccif.ccsnoopaddr[0] = ccif.daddr[1];
  ccif.ccsnoopaddr[1] = ccif.daddr[0];
  ccif.dwait[0]  = 1;
  ccif.dwait[1]  = 1;
  ccif.dload[0]  = 0;
  ccif.dload[1]  = 0;
  ccif.ccwait[0] = 0;
  ccif.ccwait[1] = 0;
  ccif.ccinv[0]  = 0;
  ccif.ccinv[1]  = 0;
  cocif.ramREN = 0;
  cocif.ramWEN = 0;
  cocif.ramaddr = 32'hBAD1BAD1;
  cocif.ramstore = 32'hBAD1BAD1;
  next_word_0 = word_0;


  // DREN & !cctrans = READ_MISS
  // DREN & cctrans  = WRITE_MISS_CLEAN
  // DWEN            = WB
  // !DREN && !DWEN && cctrans = Write_hit_clean // need to inv


// CC outputs to mem_arbiter = dREN dWEN  


  casez(state)
    IDLE: begin // NEED TO ARBITRATE!  
      if      (ccif.dREN[requestor])    next_state = SNOOP; // read_miss or write_miss
      else if (ccif.dWEN[requestor])    next_state = WRITE_BACK_0; // writing back 
      else if (ccif.cctrans[requestor]) next_state = INVALIDATE_0; // clean hit on cache 
      else begin
        next_requestor = !requestor;
      end                        
    end
    SNOOP: begin
      ccif.ccwait[rec] =  1;
      next_state           = LOAD_SNOOP;
      if(ccif.cctrans[requestor]) next_state = WRITE_MISS_CLEAN_0;
    end
   
// LOAD_0-1 states take care of 1. requestor Read_miss 2. the rec's response to BusRD
    LOAD_SNOOP: begin
      if(snoop_hit) begin next_state=CACHECACHE0; end
      else begin next_state = LOAD_0; end;            
    end
    CACHECACHE0: begin
      ccif.dload[requestor]  = ccif.dstore[rec]; // CACHE -> CACHE transfer
      cocif.ramWEN = 1; cocif.ramstore = ccif.dstore[rec]; cocif.ramaddr = ccif.daddr[requestor];
      ccif.dwait[rec] = cocif.wait_in; // To transition dcache::rec to SNOOP_1 state
      ccif.dwait[requestor] = cocif.wait_in;
      if (!cocif.wait_in) next_state = CACHECACHE1;
    end
    CACHECACHE1: begin
        ccif.dload[requestor] = ccif.dstore[rec]; // CACHE -> CACHE transfer
        cocif.ramWEN=1; cocif.ramstore = ccif.dstore[rec]; cocif.ramaddr = ccif.daddr[requestor]; 
        ccif.dwait[rec] = cocif.wait_in; // To transition dcache::rec out to SNOOP_1 state
        ccif.dwait[requestor] = cocif.wait_in;   
      if (!cocif.wait_in) begin next_state = IDLE; next_requestor = !requestor; end
    end
    LOAD_0: begin
      cocif.ramREN = 1; cocif.ramaddr = ccif.daddr[requestor]; ccif.dload[requestor]=ccif.ramload; 
      ccif.dwait[requestor] = cocif.wait_in;
      if (!cocif.wait_in) next_state = LOAD_1;
    end
    LOAD_1: begin
      cocif.ramREN = 1; cocif.ramaddr = ccif.daddr[requestor]; ccif.dload[requestor]=ccif.ramload;
      ccif.dwait[requestor] = cocif.wait_in;   
      if (!cocif.wait_in) begin next_state = IDLE; next_requestor = !requestor; end
    end
    WRITE_MISS_CLEAN_0: begin
      ccif.ccsnoopaddr[rec] = {ccif.daddr[requestor][31:3], !ccif.daddr[requestor][2], 2'b00}; // FOR LINK MATCHING
      
      if(snoop_hit) begin
        cocif.ramWEN = 1; cocif.ramstore = ccif.dstore[rec]; cocif.ramaddr = {ccif.daddr[requestor][31:3],3'b000};
        ccif.dwait[rec] = cocif.wait_in; // -> rec::SNOOP_1
        next_word_0 = ccif.dstore[rec];
        
        if(!cocif.wait_in) begin next_state = WRITE_MISS_CLEAN_1; end
      end
      else begin
        ccif.ccinv[rec] = 1; 
        cocif.ramREN = 1; cocif.ramaddr = ccif.daddr[requestor]; ccif.dload[requestor]=ccif.ramload;
        ccif.dwait[requestor] = cocif.wait_in;   
        if (!cocif.wait_in) begin next_state = IDLE; next_requestor = !requestor; end
      end
    end

    WRITE_MISS_CLEAN_1: begin
      ccif.ccinv[rec]  = 1;
      ccif.ccsnoopaddr[rec] = {ccif.daddr[requestor][31:3], !ccif.daddr[requestor][2], 2'b00}; // FOR LINK MATCHING
      
      cocif.ramWEN = 1; cocif.ramstore = ccif.dstore[rec]; cocif.ramaddr = {ccif.daddr[requestor][31:3],3'b100};
      
      ccif.dload[requestor] = ccif.daddr[requestor][2] ? ccif.dstore[rec] : word_0; //ccif.daddr[rec];

      ccif.dwait[requestor] = cocif.wait_in; ccif.dwait[rec] = cocif.wait_in;
      if(!cocif.wait_in) begin
        next_state = IDLE; next_requestor = !requestor;
      end

    end

// WRITE_BACK_0-1 take care of Requestor writebacks

    WRITE_BACK_0: begin 
      cocif.ramWEN = 1; cocif.ramaddr = ccif.daddr[requestor]; cocif.ramstore=ccif.dstore[requestor];
      ccif.dwait[requestor] = cocif.wait_in;
      if (!cocif.wait_in) next_state = WRITE_BACK_1;
    end
    WRITE_BACK_1: begin
      cocif.ramWEN = 1; cocif.ramaddr = ccif.daddr[requestor]; cocif.ramstore=ccif.dstore[requestor];
      ccif.dwait[requestor] = cocif.wait_in;   
      if (!cocif.wait_in) begin next_state = IDLE;   next_requestor = !requestor; end 
    end


//  INVALIDATE_0-1 take care of Requestor Writehit_clean->rec invalidation

    INVALIDATE_0: begin // This state is literally just to snoop
      //ccif.ccinv[rec] = 1;
      ccif.ccwait[rec] = 1;
      next_state = INVALIDATE_1;
    end
    INVALIDATE_1: begin 
      ccif.ccinv[rec] = 1;
      next_state = IDLE;  next_requestor = !requestor; 
      ccif.dwait[requestor] = 0; // Go ahead with req::S->M transition!
    end
  endcase
  
end //
endmodule
