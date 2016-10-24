/*
  Eric Villasenor
  evillase@gmail.com

  holds datapath and cache interface signals
*/
`ifndef DCACHE_IF_VH
`define DCACHE_IF_VH

// types
`include "cpu_types_pkg.vh"

interface dcache_if;
  // import types
  import cpu_types_pkg::*;

// datapath signals
  // stop processing

// Icache signals
  // hit and enable
  logic               dhit, dwait, flushed, halt;
  // instruction addr
  word_t             dmemload, dload, daddr, dmemstore, dmemaddr, dstore;

// Dcache signals
  // hit, atomic and enables
  logic               dmemREN, dmemWEN, dREN, dWEN;
  // data and address

  // datapath ports
  modport ic (
    input   dmemREN, dmemWEN,  dload, dwait, dmemaddr, dmemstore, halt, 
    output  dmemload, dREN, dWEN, daddr, dhit, flushed, dstore
  );

endinterface

`endif //DATAPATH_CACHE_IF_VH
