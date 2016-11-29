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
  cache_control_if ccif
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


// write: Implies that the snoop_address is available in the requestee cache

*/

/****************************************************************************************************************************
//                                            COHERENCE
/***************************************************************************************************************************/

coherence_control_if cocif();
coherence_control COHERENCE(CLK, nRST,ccif,cocif);

assign cocif.wait_in = ~((ccif.ramstate == ACCESS) && (cocif.ramREN||cocif.ramWEN));

/****************************************************************************************************************************
//                                            ARBITER
/***************************************************************************************************************************/
// CACHE outputs

//TODO : NEED TO CHOOSE BETWEEN ICACHES;
logic requestor, next_requestor, instruction_wait;

assign instruction_wait = ~((ccif.ramstate == ACCESS) && !(cocif.ramWEN||cocif.ramREN));

always_ff @(posedge CLK, negedge nRST) begin
  if(!nRST) requestor = 0;
  else begin
    requestor <=next_requestor;
  end
end

assign ccif.iwait[0] = requestor  ? 1 : instruction_wait;
assign ccif.iwait[1] = requestor  ? instruction_wait : 1;

always_comb begin
 // ccif.iwait[!requestor] = 1;  
 // ccif.iwait[requestor] = instruction_wait;
  next_requestor = requestor;
  if(!(instruction_wait||ccif.iREN[requestor])) next_requestor = !requestor; // change requestor!
  if(!ccif.iREN[requestor]) next_requestor = !requestor;
end



// Iload
assign ccif.iload[0] = ccif.ramload; 
assign ccif.iload[1] = ccif.ramload; 


// RAM outputs
assign ccif.ramWEN   = cocif.ramWEN;
assign ccif.ramREN   = (cocif.ramWEN) ? 1'b0 : (ccif.iREN[requestor]||cocif.ramREN);
assign ccif.ramstore = cocif.ramstore;
assign ccif.ramaddr  = (cocif.ramREN||cocif.ramWEN) ? cocif.ramaddr : ccif.iaddr[requestor];



endmodule