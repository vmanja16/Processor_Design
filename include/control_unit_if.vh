/*
  Vikram Manja
  vmanja@purdue.edu

  control_unit interface
*/
`ifndef CONTROL_UNIT_IF_VH
`define CONTROL_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface control_unit_if;
  // import types
  import cpu_types_pkg::*;
  
//  RU/caches
  logic cpu_halt, dREN, dWEN;
  word_t imemload;

// Muxes  
  logic alusrc; // lower mux
  wdatselect_t wdatsel; // wdat mux

// register
  logic WEN;
  regbits_t wsel;
  word_t rdat2; // for stores


// pc
  pcselect_t pc_select;
  word_t jump_data;

// alu
  aluop_t aluop;
//  word_t port_o;  
 // logic z_fl;
// immediates  
  word_t immediate; // sign-extended imm
  word_t lui_word; // non-sign extended imm

  // control_unit ports
  modport cu (
    input   imemload,
    output  cpu_halt, dREN, dWEN, alusrc, wdatsel, WEN, wsel, pc_select, jump_data, immediate, lui_word, aluop
  );
  // control_unit tb
  modport tb (
    input  cpu_halt, dREN, dWEN, alusrc, wdatsel, WEN, wsel, lui_word, pc_select, jump_data, immediate, aluop,
    output imemload
  );
  
endinterface

`endif // CONTROL_UNIT_IF_VH
