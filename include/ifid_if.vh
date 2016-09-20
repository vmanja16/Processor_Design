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
  
  word_t    iload, imemload, npc_in, npc_out;
  logic ifid_enable, ifid_flush;

  // ifid ports
  modport ifid (
    input   iload, npc_in, ifid_enable, ifid_flush,
    output  imemload, npc_out
  );
  //  tb
  modport tb (
    input   imemload, npc_out,
    output  iload, npc_in, ifid_enable, ifid_flush,
  );
endinterface

`endif // IFID_IF_VH