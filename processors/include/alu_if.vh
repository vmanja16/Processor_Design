/*
  Vikram Manja
	vmanja@purdue.edu

  alu interface
*/
`ifndef ALU_IF_VH
`define ALU_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface alu_if;
  // import types
  import cpu_types_pkg::*;
  
  aluop_t   alu_op;
  logic     z_fl, n_fl, o_fl ; // the zero , neg, out flags
  word_t    port_a, port_b, port_o;

  // register file ports
  modport al (
    input   alu_op, port_a, port_b,
    output  z_fl, n_fl, o_fl, port_o
  );
  // register file tb
  modport tb (
    input   alu_op, port_a, port_b,
    output  z_fl, n_fl, o_fl, port_o
  );
endinterface

`endif // ALU_IF_VH