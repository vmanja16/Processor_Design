/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"
`include "coherence_control_if.vh"
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

typedef enum logic [3:0] {IDLE, LOAD_0, LOAD_1, 
                          WRITE_BACK_0, WRITE_BACK_1,
                          INVALIDATE_0, INVALIDATE_1,
                          SNOOP} coherence_state_t;

coherence_state_t state, next_state;

logic select; // selects which cache's arbitration signals to send

logic requestor, next_requestor, receiever, writer, next_writer;
logic snoop_hit;
logic int_wait;

/****************************************************************************************************************************
//                                            COHERENCE
/***************************************************************************************************************************/

always_ff @ (posedge CLK, negedge nRST) begin
  if (!nRST) begin state <= IDLE; requestor <= 0; end
  else       begin 
    state     <= next_state; 
    requestor <= next_requestor; 
    writer    <= next_writer;
  end

end // end always_ff

// Internals
assign receiever = !requestor;
assign snoop_hit  = ccif.ccwrite[receiever];
assign int_wait = ~((ccif.ramstate == ACCESS) && (ccif.dREN[requestor]||ccif.dWEN[writer]));

// Coherence combinational logic
assign ccif.ccsnoopaddr[0] = ccif.daddr[1];
assign ccif.ccsnoopaddr[1] = ccif.daddr[0];

always_comb begin
  next_state     = state;
  next_requestor = ccif.cctrans[0]; // requestor

end
endmodule
/****************************************************************************************************************************
//                                            COHERENCE
/***************************************************************************************************************************/

/****************************************************************************************************************************
//                                            ARBITER
/***************************************************************************************************************************/
// CACHE outputs

/*
assign ccif.dload = ccif.ramload;
assign ccif.iload = ccif.ramload;
assign ccif.iwait = ~((ccif.ramstate == ACCESS) && !(ccif.dWEN||ccif.dREN));
assign ccif.dwait = ~((ccif.ramstate == ACCESS) && (ccif.dREN||ccif.dWEN));


// RAM outputs
assign ccif.ramWEN   = ccif.dWEN;
assign ccif.ramREN   = (ccif.dWEN) ? 1'b0 : (ccif.iREN|ccif.dREN);
assign ccif.ramstore = ccif.dstore;
assign ccif.ramaddr  = (ccif.dREN||ccif.dWEN) ? ccif.daddr : ccif.iaddr;

*/

