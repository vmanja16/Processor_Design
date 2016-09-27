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
  
  pcselect_t  pc_select;
  word_t  rtn_addr, imemaddr, jump_data, npc, rdat1;
  logic enable, z_fl;

  // pc ports
  modport pc (
    input   pc_select, jump_data, enable, z_fl, npc, rdat1,
    output imemaddr, rtn_addr
  );

 endinterface

`endif // PC_IF_VH