// types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
// inteface
`include "pc_if.vh"

/*modport pc (
    input   pc_select jump_data,
    output  rtn_addr, imem_addr
  );
*/
module pc(input CLK, nRST, pc_if.pc pcif);

word_t next_pc, current_pc;

// TODO: FIGURE OUT IF BRANCH NEEDS TO SPECIFY $SIGNED!

assign pcif.rtn_addr  = current_pc + 4;
assign pcif.imem_addr = current_pc;

always_ff @ (posedge CLK, negedge nRST) begin
	if (nRST == 0) current_pc <= pcif.init;
	else           current_pc <= next_pc;
end // end always_ff

always_comb begin
    casez (pcif.pc_select)
	  JUMP:	        next_pc = {current_pc[31:28], pcif.jump_data[25:0], 2'b00}; // normal J or JAL ops
	  JUMPREGISTER: next_pc = pcif.jump_data; // jump_data holds reg contents
	  BRANCH:       next_pc = $signed(current_pc) + $signed({ {14{pcif.jump_data[15]}}, pcif.jump_data[15:0], 2'b00}) + $signed(32'h4); // sign extended? 
	  default: 		next_pc = current_pc + 32'h4; // standard case
	endcase
    if (pcif.pc_halt) next_pc = current_pc;
end // end always_comb

endmodule