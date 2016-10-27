/*
  Eric Villasenor
  evillase@gmail.com

  holds datapath and cache interface signals
*/
`ifndef ICACHE_IF_VH
`define ICACHE_IF_VH

// types
`include "cpu_types_pkg.vh"

interface icache_if;
  // import types
  import cpu_types_pkg::*;

// datapath signals
  // stop processing

// Icache signals
  // hit and enable
  logic               ihit, imemREN, iwait;
  // instruction addr
  word_t             imemload, imemaddr, iload, iaddr;

// Dcache signals
  // hit, atomic and enables
  logic               dmemREN, dmemWEN, iREN;
  // data and address

  // datapath ports
  modport ic (
    input   dmemREN, dmemWEN, imemREN, iload, iwait, imemaddr,
    output  imemload, iREN, iaddr, ihit
  );

endinterface

`endif //DATAPATH_CACHE_IF_VH
