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
assign ic.iwait    = cif.iwait;

assign cif.iaddr     = ic.iaddr;
assign dcif.imemload = ic.imemload;
assign cif.iREN      = ic.iREN;
assign dcif.ihit     = ic.ihit;


assign dc.dmemaddr    = dcif.dmemaddr;
assign dc.dload       = cif.dload;
assign dc.dmemREN     = dcif.dmemREN;
assign dc.dmemWEN     = dcif.dmemWEN;
assign dc.dmemstore   = dcif.dmemstore;
assign dc.dwait       = cif.dwait;
assign dc.halt        = dcif.halt;
assign dc.ccsnoopaddr = cif.ccsnoopaddr;
assign dc.ccinv       = cif.ccinv;
assign dc.ccwait      = cif.ccwait;
assign dc.datomic     = dcif.datomic;

assign cif.daddr     = dc.daddr;
assign cif.dREN      = dc.dREN;
assign cif.dWEN      = dc.dWEN;
assign dcif.dhit     = dc.dhit;
assign cif.dstore    = dc.dstore;
assign dcif.flushed  = dc.flushed;
assign dcif.dmemload = dc.dmemload;


// Replaceable code
assign cif.cctrans = dc.cctrans;
assign cif.ccwrite = dc.ccwrite;

endmodule
