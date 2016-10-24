/*
  Eric Villasenor
  evillase@gmail.com

  this block holds the i and d cache
*/


// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "icache_if.vh"
`include "dcache_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module caches (
  input logic CLK, nRST,
  datapath_cache_if.cache dcif,
  caches_if cif
);


icache_if ic();

icache ICACHE(CLK, nRST, ic);

dcache_if dc();
dcache DCACHE(CLK, nRST, dc);

assign ic.imemaddr = dcif.imemaddr;
assign ic.imemREN  = dcif.imemREN;
assign ic.iload    = cif.iload;
assign ic.dmemREN  = dcif.dmemREN;
assign ic.dmemWEN  = dcif.dmemWEN;
assign ic.iwait     = cif.iwait;

assign cif.iaddr     = ic.iaddr;
assign dcif.imemload = ic.imemload;
assign cif.iREN      = ic.iREN;
assign dcif.ihit     = ic.ihit;




assign dc.dmemaddr = dcif.dmemaddr;
assign dc.dload    = cif.dload;
assign dc.dmemREN  = dcif.dmemREN;
assign dc.dmemWEN  = dcif.dmemWEN;
assign dc.dmemstore= dcif.dmemstore;
assign dc.dwait    = cif.dwait;
assign dc.halt     = dcif.halt;

assign cif.daddr     = dc.daddr;
assign cif.dREN      = dc.dREN;
assign cif.dWEN      = dc.dWEN;
assign dcif.dhit     = dc.dhit;
assign cif.dstore    = dc.dstore;
assign dcif.flushed  = dc.flushed;
assign dcif.dmemload = dc.dmemload;


// time to do nonsense


  // icache
//  icache  ICACHE(CLK, nRST, dcif, cif); // needs imemREN, dmemREN, dmemWEN, out: ihit imemload
  // dcache
 // dcache  DCACHE(CLK, nRST, dcif, cif); // needs dmemREN, dmemWEN, dstore, daddr; out: dhit, dmemload, flushed, cif:



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
