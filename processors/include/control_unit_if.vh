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
  logic cpu_halt, datomic, dREN, dWEN;
  word_t dmemaddr, dmemstore;
  word_t imemload;

// Muxes  
  logic alusrc; // lower mux
  logic [1:0] wdatsel; // wdat mux

// register
  logic WEN;
  regbits_t wsel, rsel1, rsel2;
  word_t rdat2; // for stores


// pc
  pcselect_t pc_select;
  word_t jump_data;

// alu
  aluop_t aluop;
  word_t port_o;  
  logic z_fl;
// immediates  
  word_t immediate; // sign-extended imm
  word_t lui_word; // non-sign extended imm

  // control_unit ports
  modport cu (
    input   imemload, rdat2, port_o, z_fl,
    output  cpu_halt, datomic, dREN, dWEN, dmemaddr, dmemstore, alusrc, wdatsel, WEN, wsel, rsel1, rsel2, pc_select, jump_data, immediate, lui_word, aluop
  );
  // control_unit tb
  modport tb (
    input  cpu_halt, datomic, dREN, dWEN, dmemaddr, dmemstore, alusrc, wdatsel, WEN, wsel, rsel1, rsel2, lui_word, pc_select, jump_data, immediate, aluop,
    output imemload, rdat2, port_o, z_fl
  );
  
endinterface

`endif // CONTROL_UNIT_IF_VH