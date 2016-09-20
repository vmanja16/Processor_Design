`include "register_file_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

module register_file (
  input CLK, nRST,
  register_file_if.rf rfif

);

word_t next_register [31:0], register [31:0];

always_ff @ (negedge CLK, negedge nRST) begin
	if (nRST==0)        register <= '{default:'0}; // all 0 on nRST
	else		    register <= next_register; // update reg
	register[0] <= 32'b0; // set reg 0 to 0
end
always_comb begin
next_register = register;
if (rfif.WEN) next_register[rfif.wsel] = rfif.wdat;
end

assign rfif.rdat1 = register[rfif.rsel1];
assign rfif.rdat2 = register[rfif.rsel2];


endmodule
