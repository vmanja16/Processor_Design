// types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
// interface
`include "pc_if.vh"

/* modport pc (
    input   pc_select, jump_data, ihit, z_fl, next_pc, rdat1,
    output imemaddr, rtn_addr
  );
*/
module pc(input CLK, nRST, pc_if.pc pcif);

parameter PC_INIT = 0;

word_t  current_pc;
word_t next_pc; word_t branch_address, jump_address;

// internals
assign branch_address =  pcif.npc + ({ {14{pcif.jump_data[15]}}, pcif.jump_data[15:0], 2'b00});
assign jump_address   = {pcif.npc[31:28], pcif.jump_data[25:0], 2'b00};

// outputs
assign pcif.rtn_addr = current_pc + 32'h4;
assign pcif.imemaddr = current_pc;

// pc reg
always_ff @ (posedge CLK, negedge nRST) begin
  if (nRST == 0)        current_pc <= PC_INIT;
  else if (pcif.enable) current_pc <= next_pc;
end // end always_ff

// next_pc LOGIC
always_comb begin
  next_pc = current_pc + 4;
  casez (pcif.pc_select)
    JUMP:                                next_pc = jump_address;
    JUMPREGISTER:                        next_pc = pcif.rdat1; 
    BRANCH_IF_EQUAL:     if (pcif.z_fl)  next_pc = branch_address;
    BRANCH_IF_NOT_EQUAL: if (!pcif.z_fl) next_pc = branch_address;
    PC_HALT:                             next_pc = current_pc;
    NEXT:                                next_pc = current_pc + 32'h4;
    default:                             next_pc = current_pc + 32'h4; 
  endcase
end // end always_comb

endmodule