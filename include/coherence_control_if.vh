`ifndef COHERENCE_CONTROL_IF_VH
`define COHERENCE_CONTROL_IF_VH

`include "cpu_types_pkg.vh"


word_t ramaddr, ramstore;

logic wait_in, ramWEN, ramREN;



modport coc (

input wait_in,
output ramaddr, ramstore, ramWEN, ramREN

);



`endif