// types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
// inteface
`include "pc_if.vh"

/*modport pc (
    input   pc_select, jump_data, init, pc_halt,
    output imem_addr, rtn_addr
  );
*/
module pc(input CLK, nRST, pc_if.pc pcif);

parameter PC_INIT = 0;

word_t next_pc, current_pc;

// TODO: FIGURE OUT IF BRANCH NEEDS TO SPECIFY $SIGNED!

assign pcif.rtn_addr  = current_pc + 4;
assign pcif.imem_addr = current_pc;

always_ff @ (posedge CLK, negedge nRST) begin
	if (nRST == 0) current_pc <= PC_INIT;
	else           current_pc <= next_pc;
end // end always_ff

always_comb begin
    casez (pcif.pc_select)
	  JUMP:	        next_pc = {current_pc[31:28], pcif.jump_data[25:0], 2'b00}; // normal J or JAL ops
	  JUMPREGISTER: next_pc = pcif.jump_data; // jump_data holds reg contents
	  BRANCH:       next_pc = $signed(current_pc) + $signed({ {14{pcif.jump_data[15]}}, pcif.jump_data[15:0], 2'b00}) + $signed(32'h4); // sign extended? 
	  HALT:         next_pc = current_pc;
	  NEXT:         next_pc = current_pc + 32'h4; // standard
	  default: 		next_pc = current_pc + 32'h4; // standard case
	endcase
end // end always_comb

endmodule