/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/


// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module caches (
  input logic CLK, nRST,
  datapath_cache_if.cache dcif,
  caches_if cif
);

  word_t instr;
  word_t daddr;

  // icache
  icache  ICACHE(CLK, nRST, dcif, cif); // needs imemREN, dmemREN, dmemWEN, out: ihit imemload
  // dcache
  dcache  DCACHE(CLK, nRST, dcif, cif); // needs dmemREN, dmemWEN, dstore, daddr; out: dhit, dmemload, flushed, cif:
  //assign cif.dREN   = dcif.dmemREN;
  //assign cif.dWEN   = dcif.dmemWEN;
  //assign cif.dstore = dcif.dmemstore;
  //assign cif.daddr  = dcif.dmemaddr;
  //assign dcif.dhit = (dcif.dmemREN|dcif.dmemWEN) ? ~cif.dwait : 0;
  //assign dcif.dmemload = cif.dload;
  //assign dcif.flushed = dcif.halt;

//assign dcif.ihit = (dcif.imemREN) ? ~cif.iwait : 0;  
//assign dcif.imemload = cif.iload;
//assign cif.iREN = dcif.imemREN;
//assign cif.iaddr  = dcif.imemaddr;



endmodule
