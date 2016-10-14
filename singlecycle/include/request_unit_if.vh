/*
  Vikram Manja
	vmanja@purdue.edu

  request_unit interface
*/
`ifndef REQUEST_UNIT_IF_VH
`define REQUEST_UNIT_IF_VH

// all types
`include "cpu_types_pkg.vh"

interface request_unit_if;
  // import types
  import cpu_types_pkg::*;
  
  logic halt, cpu_halt;  
  logic dhit, ihit; 
  logic imemREN, dmemREN, dmemWEN;
  logic dREN, dWEN; 

  // request_unit ports
  modport ru (
    input   dhit, ihit, dREN, dWEN, cpu_halt,
    output  imemREN, dmemREN, dmemWEN, halt
  );
  
  // request_unit ports
  modport tb (
    input  imemREN, dmemREN, dmemWEN, halt, 
    output   dhit, ihit, dREN, dWEN, cpu_halt
  );
endinterface

`endif // REQUEST_UNIT_IF_VH