`include "cpu_types_pkg.vh"
`include "alu_if.vh"
import cpu_types_pkg::*;

module alu (
alu_if.al al // ALU interface, see includes/alu_if.vh 
);

always_comb begin
  al.o_fl = 0; al.port_o = 0;
  casez(al.alu_op)
    ALU_SLL: al.port_o = al.port_a << al.port_b;    
    ALU_SRL: al.port_o = al.port_a >> al.port_b;
    ALU_ADD: begin
      al.port_o = $signed(al.port_a) + $signed(al.port_b);
      if (al.port_a[31]==al.port_b[31]) 
        if (al.port_a[31] != al.port_o[31]) al.o_fl = 1; 
    end
    ALU_SUB: begin
      al.port_o = $signed(al.port_a) - $signed(al.port_b);
      if (al.port_a[31] != al.port_b[31])   
        if (al.port_o[31] != al.port_a[31]) al.o_fl = 1;
    end
    ALU_AND: al.port_o = al.port_a & al.port_b;
    ALU_OR:  al.port_o = al.port_a | al.port_b;
    ALU_XOR: al.port_o = al.port_a ^ al.port_b;
    ALU_NOR: al.port_o = ~(al.port_a | al.port_b);
    ALU_SLT: al.port_o = ($signed(al.port_a) < $signed(al.port_b)) ? 1:0;
    ALU_SLTU: al.port_o = (al.port_a < al.port_b) ? 1:0;
    default: al.port_o = 0;
  endcase
end // end always

assign al.z_fl = (al.port_o == 0) ? 1:0;
assign al.n_fl = al.port_o[31];


endmodule
