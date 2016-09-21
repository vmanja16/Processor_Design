/*
  Vikram Manja
	vmanja@purdue.edu

  MEMWB interface
*/
`ifndef MEMWB_IF_VH
`define MEMWB_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface memwb_if;
  // import types
  import cpu_types_pkg::*;

// enables 
  logic enable, flush;
  
// from exmem latch
  word_t npc_in,lui_word_in, port_o_in;
  wdatselect_t wdatsel_in; 
  regbits_t wsel_in; 
  logic  halt_in, WEN_in;
  
  word_t npc_out, lui_word_out, port_o_out;
  wdatselect_t wdatsel_out; 
  regbits_t wsel_out; 
  logic  halt_out, WEN_out; 

// from DCACHE
  word_t dmemload_in, dmemload_out;

  // memwb ports
  modport mem (
    input     enable, flush, npc_in,lui_word_in, wdatsel_in, wsel_in, halt_in, WEN_in, port_o_in, dmemload_in,
    output    npc_out, lui_word_out, wsel_out, halt_out, WEN_out, wdatsel_out, port_o_out, dmemload_out
  );
  //  tb
  modport tb (
    input     npc_out, lui_word_out, wsel_out, halt_out, WEN_out, wdatsel_out, port_o_out, dmemload_out,
    output    enable, flush, npc_in,lui_word_in, wdatsel_in, wsel_in, halt_in, WEN_in, port_o_in, dmemload_in 
  );
endinterface

`endif // MEMWB_IF_VH
