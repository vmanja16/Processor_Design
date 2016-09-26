/*
  Vikram Manja
	vmanja@purdue.edu

  FORWARDING_UNIT interface
*/
`ifndef FORWARDING_UNIT_IF_VH
`define FORWARDING_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface forwarding_unit_if;
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


// outputs
word_t rdat1_out, rdat2_out;

  // hazard ports
  modport fu (
    input   exmem_WEN, memwb_WEN, rdat1_in, 
            rdat2_in, imemload, rfif_wdat, exmem_wsel, 
            memwb_wsel, exmem_port_o, 
    output  rdat1_out, rdat2_out
  );

  //  tb
  modport tb (
    input   rdat1_out, rdat2_out,
    output  exmem_WEN, memwb_WEN, rdat1_in, 
            rdat2_in, imemload, rfif_wdat, exmem_wsel, 
            memwb_wsel, exmem_port_o 
  );

endinterface

`endif // FORWARDING_UNIT_IF_VH