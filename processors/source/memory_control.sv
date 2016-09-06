/*
Vikram Manja
vmanja@purdue.edu

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

  // number offor cc
  parameter CPUS = 2;

// CACHE outputs
assign ccif.dload = ccif.ramload;
assign ccif.iload = ccif.ramload;
assign ccif.iwait = ~((ccif.ramstate == ACCESS) && (ccif.iREN));
assign ccif.dwait = ~((ccif.ramstate == ACCESS) && (ccif.dREN||ccif.dWEN));

// RAM outputs
assign ccif.ramWEN   = ccif.dWEN;
assign ccif.ramREN   = (ccif.dWEN) ? 0 : (ccif.iREN|ccif.dREN);
assign ccif.ramstore = ccif.dstore;
assign ccif.ramaddr  = (ccif.dREN||ccif.dWEN) ? ccif.daddr : ccif.iaddr;

endmodule
