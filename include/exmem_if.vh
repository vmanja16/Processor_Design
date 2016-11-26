/*
  Vikram Manja
	vmanja@purdue.edu

  EXMEM interface
*/
`ifndef EXMEM_IF_VH
`define EXMEM_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface exmem_if;
  // import types
  import cpu_types_pkg::*;

// enables 
  logic enable, flush;
  
// from idex latch
  word_t imemload_in, npc_in, rdat1_in, rdat2_in, lui_word_in;
  wdatselect_t wdatsel_in; 
  regbits_t wsel_in; 
  pcselect_t pc_select_in; 
  logic  dREN_in, dWEN_in, halt_in, WEN_in, datomic_in;
  
  word_t imemload_out, npc_out, rdat1_out, rdat2_out, lui_word_out;
  wdatselect_t wdatsel_out; 
  regbits_t wsel_out; 
  pcselect_t pc_select_out;
  logic  dREN_out, dWEN_out, halt_out, WEN_out, datomic_out; 

// from ALU
  word_t port_o_in;
  logic z_fl_in;
  word_t port_o_out;
  logic z_fl_out;


  // exmem ports
  modport ex (
    input     enable, flush, imemload_in, npc_in, rdat1_in, rdat2_in, lui_word_in, wdatsel_in, wsel_in, pc_select_in, 
              dREN_in, dWEN_in, halt_in, WEN_in, port_o_in, z_fl_in, datomic_in,
    output    imemload_out, npc_out, rdat1_out, rdat2_out, lui_word_out, wdatsel_out, wsel_out, pc_select_out, 
              dREN_out, dWEN_out, halt_out, WEN_out, port_o_out, z_fl_out, datomic_out
  );
  //  tb
  modport tb (
    input     imemload_out, npc_out, rdat1_out, rdat2_out, lui_word_out, wdatsel_out, wsel_out, pc_select_out, 
              dREN_out, dWEN_out, halt_out, WEN_out, port_o_out, z_fl_out,
    output    enable, flush, imemload_in, npc_in, rdat1_in, rdat2_in, lui_word_in, wdatsel_in, wsel_in, pc_select_in, 
              dREN_in, dWEN_in, halt_in, WEN_in, port_o_in, z_fl_in
  );
endinterface

`endif // EXMEM_IF_VH
