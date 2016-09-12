/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);

dpif
 //   input   ihit, imemload, dhit, dmemload,
 //   output  halt, imemREN, imemaddr, dmemREN, dmemWEN, datomic,
 //            dmemstore, dmemaddr

  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

 // interfaces
 alu_if al();
 register_file_if rfif();

// Main

alu ALU (al); // still need to assign the values 


endmodule
