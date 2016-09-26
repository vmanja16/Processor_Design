/*
  Vikram Manja
	vmanja@purdue.edu

  HAZARD interface
*/
`ifndef HAZARD_IF_VH
`define HAZARD_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface hazard_if;
  // import types
  import cpu_types_pkg::*;

// from idex
word_t rdat1_in, rdat2_in, imemload;

// from exmem  
logic exmem_WEN;
regbits_t exmem_wsel;
word_t exmem_port_o;

// from memwb
logic memwb_WEN;
regbits_t memwb_wsel;
word_t rfif_wdat;

// from datapath
logic  ihit, dhit;

// outputs
logic hazard;
word_t rdat1_out, rdat2_out;

  // hazard ports
  modport haz (
    input   exmem_WEN, memwb_WEN, ihit, dhit, rdat1_in, 
            rdat2_in, imemload, rfif_wdat, exmem_wsel, 
            memwb_wsel, exmem_port_o, 
    output  hazard, rdat1_out, rdat2_out
  );

  //  tb
  modport tb (
    input   hazard, rdat1_out, rdat2_out,
    output  exmem_WEN, memwb_WEN, ihit, dhit, rdat1_in, 
            rdat2_in, imemload, rfif_wdat, exmem_wsel, 
            memwb_wsel, exmem_port_o 
  );

endinterface

`endif // HAZARD_IF_VH