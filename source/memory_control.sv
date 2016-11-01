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

module memory_control (
  input CLK, nRST,
  cache_control_if.cc ccif
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
            ramstore, ramaddr, ramWEN, ramREN,
            // coherence outputs to cache
            ccwait, ccinv, ccsnoopaddr
  );
*/

/*
The coherence control must run through the following operations:

First, it decides on a memory request to work on from one of the two caches. 
Then, it will take the memory request and send the snoop address to the other cache. 
Once the other cache does the coherence operation, either write back or invalidate, 
the coherence control lets the requesting cache block continue with the original memory request.


write: 0 , trans: 0 --> Do nothing
write: 0,  trans: 1 --> BusRd
write: 1,  trans: 0 --> Do nothing
write: 1,  trans: 1 --> BusRdx

// write: Implies that the snoop_address is available in the requestee cache

*/

typedef enum logic [3:0] {IDLE, READ_MISS_0, READ_MISS_1, } coherence_state_t;

coherence_state_t state, next_state;

logic select; // selects which cache's arbitration signals to send

logic requestor, next_requestor;

always_ff @ (posedge CLK, negedge nRST) begin
  if (!nRST) begin state <= IDLE; requestor <= 0;
  else       begin state <= next_state; requestor <= next_requestor; end

end // end always_ff


always_comb begin
  next_state = state;
  casez(state)
    IDLE: begin
      if      (dREN[0] && ccif.cctrans[0]) begin next_state = SNOOP; next_requestor = 0; end
      else if (dREN[1] && ccif.cctrans[1]) begin next_state = SNOOP; next_requestor = 1; end
      else if (dWEN[0] && ccif.cctrans[0]) begin next_state = WRITE_BACK_0; next_requestor = 0; end
      else if (dWEN[1] && ccif.cctrans[1]) begin next_state = WRITE_BACK_0; next_requestor = 1; end
      else if (ccif.trans[0])              next_state = INVALIDATE_0; next_requestor = 0;// clean hit on cache 0
      else if (ccif.trans[1])              next_state =INVALIDATE_0; next_requestor = 1;// clean hit on cache 1
    end
    SNOOP: begin
           // send a snoop_addr, wait to receiever
           next_state = READ_MISS_0;
    end
    READ_MISS_0: begin
      // send a snoop_addr, wait to receiever
      // if snoop_hit: requestor_dwait = 0; requestor_dload = receiver_dstore; next_state = READ_MISS_1;
      // if !snoop_hit: ASSERT dREN, 
          //if (~(ccif.ramstate == ACCESS) set dwait low, then next_state = READ_MISS_1;
    end
    READ_MISS_1: begin
      // if snoop_hit: requestor_dwait = 0; requestor_dload = receiver_dstore; next_state = IDLE;
            // if !snoop_hit: ASSERT dREN, daddr
          //if (~(ccif.ramstate == ACCESS), set dwait low then next_state = IDLE;
    end
    WRITE_BACK_0: begin
    // ASSERT dWEN, daddr
          //if (~(ccif.ramstate == ACCESS) then set dwait loww, next_state = WRITE_BACK_1;
    end
    WRITE_BACK_1: begin
     // ASSERT dWEN, daddr
          //if (~(ccif.ramstate == ACCESS) then set dwait loww, next_state = IDLE;
    end
    INVALIDATE_0: begin
      // send snoop_address; cc.invalid, cc.wait, next_state = WRITE_HIT_1:
    end
    INVALIDATE_1: begin next_state = IDLE; end
end //



/****************************************************************************************************************************
//                                            ARBITER
/***************************************************************************************************************************/
// CACHE outputs
assign ccif.dload = ccif.ramload;
assign ccif.iload = ccif.ramload;
assign ccif.iwait = ~((ccif.ramstate == ACCESS) && !(ccif.dWEN||ccif.dREN));
assign ccif.dwait = ~((ccif.ramstate == ACCESS) && (ccif.dREN||ccif.dWEN));


// RAM outputs
assign ccif.ramWEN   = ccif.dWEN;
assign ccif.ramREN   = (ccif.dWEN) ? 1'b0 : (ccif.iREN|ccif.dREN);
assign ccif.ramstore = ccif.dstore;
assign ccif.ramaddr  = (ccif.dREN||ccif.dWEN) ? ccif.daddr : ccif.iaddr;


endmodule
