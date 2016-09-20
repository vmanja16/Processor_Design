/*
  Vikram Manja
	vmanja@purdue.edu

  IFID interface
*/
`ifndef IFID_IF_VH
`define IFID_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface ifid_if;
  // import types
  import cpu_types_pkg::*;
  
  word_t  imemload_in,imemload_out;
  word_t  npc_in, npc_out;
  logic enable, flush;

  // ifid ports
  modport ifid (
    input   imemload_in, npc_in, enable, flush,
    output  imemload_out, npc_out
  );
  //  tb
  modport tb (
    input   imemload_out, npc_out,
    output  imemload_in, npc_in, enable, flush
  );
endinterface

`endif // IFID_IF_VH