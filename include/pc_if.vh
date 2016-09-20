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
  word_t    rtn_addr, imemaddr, jump_data;
  logic ihit; logic dhit;

  

  // pc ports
  modport pc (
    input   pc_select, jump_data, ihit, dhit,
    output imemaddr, rtn_addr
  );
  // pc tb
  modport tb (
    input   rtn_addr, imemaddr, 
    output pc_select, jump_data, ihit, dhit
  );
endinterface

`endif // PC_IF_VH