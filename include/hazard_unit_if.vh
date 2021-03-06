/*
  Vikram Manja
	vmanja@purdue.edu

  HAZARD interface
*/
`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface hazard_unit_if;
  // import types
  import cpu_types_pkg::*;

// from idif
word_t ifid_imemload;

// from idex
word_t idex_imemload;
logic idex_dREN_out, idex_datomic_out;

// from exmem
logic z_fl;
pcselect_t pc_select;

// from datapath
logic  ihit, dhit;

// outputs
//logic hazard;
logic ifid_enable, ifid_flush, idex_enable, idex_flush, pc_enable;
logic exmem_enable, exmem_flush, memwb_enable, memwb_flush;


  // hazard unit ports
  modport hu (
    input   ihit, dhit, ifid_imemload, idex_imemload,
            idex_dREN_out, z_fl, pc_select, idex_datomic_out,
    output  ifid_enable, ifid_flush, idex_enable, idex_flush, 
            pc_enable, exmem_enable, exmem_flush, memwb_enable, 
            memwb_flush
  );

  //  tb
  modport tb (
    input   ifid_enable, ifid_flush, idex_enable, idex_flush, 
            pc_enable, exmem_enable, exmem_flush, memwb_enable, 
            memwb_flush,
    output  ihit, dhit, ifid_imemload, idex_imemload,idex_dREN_out, z_fl, pc_select
  );

endinterface

`endif // HAZARD_IF_VH