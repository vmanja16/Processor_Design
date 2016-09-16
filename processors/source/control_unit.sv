// types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
// request unit interface

`include "control_unit_if.vh"

module control_unit(input CLK, nRST, control_unit_if.cu cuif);
 
/*modport cu (
	input   imemload, rdat2, port_o, z_fl,
	output  cpu_halt, datomic, dREN, dWEN, dmemaddr, 
	dmemstore, alusrc, wdatsel, WEN, wsel, rsel1, rsel2, 
	pc_select, jump_data, immediate, lui_word, aluop
  ); 
*/
/*modport cu (
 DONE: dREN, dWEN, dmemaddr, dmemstore,cpu_halt, lui_word,
      jump_data, immediate, pc_select,
      aluop, wdatsel, WEN, wsel, alusrc 

 TODO:   rsel1, rsel2,  
	 datomic, 
  ); 
*/
// op    rs rt ---immediate-- 
// op    ----jump_address----
// op=0  rs rt rd shamt funct
// internals
r_t instr; r_t r_instr; j_t j_instr; i_t i_instr; word_t zero_extended_immediate, sign_extended_immediate, extended_shamt;

assign r_instr = cuif.imemload; assign j_instr = cuif.imemload; assign i_instr = cuif.imemload;
assign instr = cuif.imemload;
assign zero_extended_immediate = {16'h0, cuif.imemload[15:0]};
assign sign_extended_immediate = { {16{cuif.imemload[15]}}, cuif.imemload[15:0] };
assign extended_shamt = {27'h0, r_instr.shamt};


// Begin Ouputs
assign cuif.lui_word  = { cuif.imemload[15:0], 16'h0 }; // left shifted word
assign cuif.dWEN      = (instr.opcode == SW) ? 1 : 0; // assert DWEN on SW only
assign cuif.dREN      = (instr.opcode == LW) ? 1 : 0; // assert dREN on LW only
assign cuif.dmemaddr  = cuif.port_o; // addr is an ALU sum for SW/LW
assign cuif.dmemstore = cuif.rdat2; // for SW, dmemstore is a register value
assign cuif.cpu_halt  = (instr.opcode == HALT) ? 1 : 0;
assign cuif.datomic   = 1'b0; // WHAT IS DATOMIC!?!?!?!?!?!?!??!!!?!?!
always_comb begin
// DEFAULTS
cuif.pc_select = NEXT; // overwritten on BNE BEQ J JAL JR HALT
cuif.jump_data = cuif.imemload; // overwritten for JR 
cuif.immediate = sign_extended_immediate; // overwritten on XORI ORI ANDI SLL SRL
cuif.aluop = ALU_ADD; // not overwritten on J, JAL, JR, LUI
cuif.wdatsel = PORT_O; // overwritten on LUI, JAL, LW
cuif.WEN  = 0; // not overwritten JR, bNeq, SW 

cuif.wsel = i_instr.rt; // overwritten on JAL, RTYPE

cuif.rsel1 = i_instr.rs; // rs for i/r, 
cuif.rsel2 = i_instr.rt; // rt for i/r
cuif.alusrc = 0; // 1 for immediates, 0 for rdat2
// OPCODES
casez(instr.opcode)
//================= J-TYPE!============================= 
///*	
	J: begin 
	  cuif.pc_select = JUMP;
    // No aluop
	end 
	JAL: begin 
	  cuif.pc_select = JUMP;
	  cuif.wdatsel = RTN_ADDR;
	  cuif.WEN  = 1; cuif.wsel = 5'd31;
    // No aluop
	end
//================ I-TYPE!===============================
	BEQ: begin 
	  if (cuif.z_fl) cuif.pc_select = BRANCH;
	  cuif.aluop = ALU_SUB;
	  cuif.alusrc = 0;
	end
	BNE: begin
	  if (!cuif.z_fl) cuif.pc_select = BRANCH; 
	  cuif.aluop = ALU_SUB;
	  cuif.alusrc = 0;
	end
	ADDI: begin
	  cuif.aluop = ALU_ADD; 
    cuif.alusrc = 1;
    cuif.WEN = 1;

	end
	ADDIU: begin 
    cuif.aluop = ALU_ADD;
    cuif.alusrc = 1;
    cuif.WEN = 1;
	end
	SLTI: begin 
    cuif.aluop = ALU_SLT;
    cuif.alusrc = 1;
    cuif.WEN = 1;

	end
	SLTIU: begin 
    cuif.aluop = ALU_SLTU;
    cuif.alusrc = 1;
    cuif.WEN = 1;
	end
	ANDI: begin 
	  cuif.immediate = zero_extended_immediate;
	  cuif.aluop     = ALU_AND;
	  cuif.alusrc = 1;
	  cuif.WEN       = 1;
	end
//*/	
	ORI: begin 
	  cuif.immediate = zero_extended_immediate;
	  cuif.aluop     = ALU_OR;
	  cuif.alusrc =1;
	  cuif.WEN = 1;
	end
///*	
	XORI: begin   
	  cuif.immediate = zero_extended_immediate;
	  cuif.aluop     = ALU_XOR;
	  cuif.alusrc = 1;
	  cuif.WEN = 1;
	end
//*/	
	LUI:  begin 
    cuif.WEN = 1;
    cuif.wdatsel = LUI_WORD;
    // No aluop
	end
	LW: begin 
    cuif.aluop = ALU_ADD;
    cuif.alusrc = 1;
    cuif.wdatsel = DMEMLOAD;
    cuif.WEN = 1;
	end
	SW: begin 
    cuif.aluop = ALU_ADD;
    cuif.alusrc = 1;
	end
	HALT: begin 
	  cuif.pc_select = PC_HALT;
	  // No aluop
	  end
//================= R-TYPE! =================================
///*
	RTYPE: begin
	  cuif.rsel1 = r_instr.rs;
	  cuif.rsel2 = r_instr.rt;
	  cuif.wsel = r_instr.rd;
	  cuif.WEN = 1; // NOT for JR!
	  casez(r_instr.funct)
			SLL: begin
	      cuif.immediate = extended_shamt;
	      cuif.aluop     = ALU_SLL;
	      cuif.alusrc = 1;
			end
			SRL: begin
	      cuif.immediate = extended_shamt;
	      cuif.aluop     = ALU_SRL;
	      cuif.alusrc = 1;
			end
			JR: begin
	      cuif.pc_select = JUMPREGISTER;
	      cuif.jump_data = cuif.rdat2;
        // No aluop
	      cuif.WEN = 0; 
			end
			ADD: begin
        cuif.aluop = ALU_ADD;
        cuif.alusrc = 0;
			end
			ADDU: begin
			  cuif.aluop = ALU_ADD;
			  cuif.alusrc = 0;
			end
			SUB: begin
			  cuif.aluop = ALU_SUB;
			  cuif.alusrc = 0;
			end
			SUBU: begin
			  cuif.aluop = ALU_SUB;
			  cuif.alusrc = 0;
			end
			AND: begin
        cuif.aluop = ALU_AND;
        cuif.alusrc = 0;
			end
			OR: begin
        cuif.aluop = ALU_OR;
        cuif.alusrc = 0;     
			end
			XOR: begin
        cuif.aluop = ALU_XOR;
        cuif.alusrc = 0;
			end
			NOR: begin
        cuif.aluop = ALU_NOR;
        cuif.alusrc = 0;
			end
			SLT: begin
        cuif.aluop = ALU_SLT;
        cuif.alusrc = 0;
			end
			SLTU: begin
        cuif.aluop = ALU_SLTU;
        cuif.alusrc = 0;
			end
			default: begin
	      // Noop
	      cuif.WEN = 0;
	      // No aluop
			end
	  endcase // end funct case
	end // end R-type struct
//*/	
	default: begin
	  cuif.WEN=0;
	end
  endcase  // end opcode case
end //end always_comb

endmodule