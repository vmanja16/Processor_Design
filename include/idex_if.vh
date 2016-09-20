/*
  Vikram Manja
	vmanja@purdue.edu

  EXMEM interface
*/
`ifndef IDEX_IF_VH
`define IDEX_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface idex_if;
  // import types
  import cpu_types_pkg::*;

// enables 
  logic enable, flush;
  
// from ifid latch
  word_t     imemload_in, npc_in;
  word_t     imemload_out, npc_out;
  
// from Register_File
  word_t rdat1_in, rdat2_in;
  word_t rdat1_out, rdat2_out;

// from Control Unit
  word_t immediate_in,lui_word_in; 
  logic alusrc_in,  dWEN_in, dREN_in, halt_in, WEN_in;
  aluop_t aluop_in;
  regbits_t wsel_in;
  wdatselect_t wdatsel_in; 
  pcselect_t  pc_select_in;

  word_t immediate_out, lui_word_out;
  logic alusrc_out,  dWEN_out, dREN_out, halt_out, WEN_out;
  aluop_t aluop_out;
  regbits_t wsel_out;
  wdatselect_t wdatsel_out; 
  pcselect_t  pc_select_out;




  // idex ports
  modport id (
    input     imemload_in, npc_in, rdat1_in, rdat2_in, immediate_in, alusrc_in, aluop_in, 
               dWEN_in, dREN_in, halt_in, wdatsel_in, wsel_in, WEN_in, lui_word_in, 
              pc_select_in, enable, flush,
    output    imemload_out, npc_out, rdat1_out, rdat2_out, immediate_out, alusrc_out, aluop_out, 
              dWEN_out, dREN_out, halt_out, wdatsel_out, wsel_out, WEN_out, lui_word_out,
              pc_select_out
  );
  //  tb
  modport tb (
    input     imemload_out, npc_out, rdat1_out, rdat2_out, immediate_out, alusrc_out, aluop_out, 
               dWEN_out, dREN_out, halt_out, wdatsel_out, wsel_out, WEN_out, lui_word_out,
              pc_select_out,
    output     imemload_in, npc_in, rdat1_in, rdat2_in, immediate_in, alusrc_in, aluop_in, 
              dREN_in, dWEN_in, halt_in, wdatsel_in, wsel_in, WEN_in, lui_word_in, 
              pc_select_in, enable, flush
  );
endinterface

`endif // IDEX_IF_VH
