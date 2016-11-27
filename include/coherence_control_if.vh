`ifndef COHERENCE_CONTROL_IF_VH
`define COHERENCE_CONTROL_IF_VH

`include "cpu_types_pkg.vh"

interface coherence_control_if;
  // import types
import cpu_types_pkg::*;
word_t ramaddr, ramstore;

logic wait_in, ramWEN, ramREN;



modport coc (

input wait_in,
output ramaddr, ramstore, ramWEN, ramREN

);

endinterface

`endif