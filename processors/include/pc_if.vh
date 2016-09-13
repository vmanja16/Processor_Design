/*
  Vikram Manja
  vmanja@purdue.edu

  pc interface
*/
`ifndef PC_IF_VH
`define PC_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface pc_if;
  // import types
  import cpu_types_pkg::*;
  
  pcselect_t     pc_select;
  word_t    rtn_addr, imem_addr, jump_data, init;
  logic pc_halt;
  // pc ports
  modport pc (
    input   pc_select, jump_data, init, pc_halt,
    output imem_addr, rtn_addr
  );
  // pc tb
  modport tb (
    input   rtn_addr, imem_addr,
    output pc_select, jump_data, init, pc_halt
  );
endinterface

`endif // PC_IF_VH