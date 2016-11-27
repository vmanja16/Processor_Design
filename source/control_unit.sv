// types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
// request unit interface

`include "control_unit_if.vh"

module control_unit(input CLK, nRST, control_unit_if.cu cuif);
 
/*modport cu (
  input   imemload
  output  
  cpu_halt, dREN, dWEN,  
  wdatsel, WEN, wsel, 
  pc_select, lui_word, 
  aluop, immediate, alusrc, datomic
  ); 
*/

// op    rs rt ---immediate-- 
// op    ----jump_address----
// op=0  rs rt rd shamt funct

// internals
r_t instr; r_t r_instr; i_t i_instr; word_t zero_extended_immediate, sign_extended_immediate, extended_shamt;

assign r_instr = cuif.imemload; assign i_instr = cuif.imemload;
assign instr = cuif.imemload;
assign zero_extended_immediate = {16'h0, cuif.imemload[15:0]};
assign sign_extended_immediate = { {16{cuif.imemload[15]}}, cuif.imemload[15:0] };
assign extended_shamt = {27'h0, r_instr.shamt};


// Begin Ouputs
assign cuif.lui_word  = { cuif.imemload[15:0], 16'h0 }; // left shifted word
assign cuif.dWEN      = ((instr.opcode == SW)||(instr.opcode == SC)) ? 1 : 0; // assert DWEN on SW only
assign cuif.dREN      = ((instr.opcode == LW)||(instr.opcode == LL)) ? 1 : 0; // assert dREN on LW only
assign cuif.cpu_halt  = (instr.opcode == HALT) ? 1 : 0;

always_comb begin

// DEFAULTS
cuif.pc_select = NEXT; // overwritten on BNE BEQ J JAL JR HALT
cuif.jump_data = cuif.imemload; // overwritten for JR 
cuif.immediate = sign_extended_immediate; // overwritten on XORI ORI ANDI SLL SRL
cuif.aluop = ALU_ADD; // not overwritten on J, JAL, JR, LUI
cuif.wdatsel = PORT_O; // overwritten on LUI, JAL, LW
cuif.WEN  = 0; // not overwritten JR, branches, SW 
cuif.wsel = i_instr.rt; // overwritten on JAL, RTYPE
cuif.alusrc = 0; // 1 for immediates, 0 for rdat2
cuif.datomic = 0;
// OPCODES
casez(instr.opcode)
//================= J-TYPE!============================= 
  
  J: begin 
    cuif.pc_select = JUMP;
    // No aluop
  end 
  JAL: begin 
    cuif.pc_select = JUMP;
    cuif.wdatsel   = RTN_ADDR;
    cuif.WEN       = 1; 
    cuif.wsel      = 5'd31;
    // No aluop
  end
//================ I-TYPE!===============================
  BEQ: begin 
    cuif.pc_select = BRANCH_IF_EQUAL;
    cuif.aluop     = ALU_SUB;
    cuif.alusrc    = 0;
  end
  BNE: begin
    cuif.pc_select = BRANCH_IF_NOT_EQUAL; 
    cuif.aluop     = ALU_SUB;
    cuif.alusrc    = 0;
  end
  ADDI: begin
    cuif.aluop  = ALU_ADD; 
    cuif.alusrc = 1;
    cuif.WEN    = 1;
  end
  ADDIU: begin 
    cuif.aluop  = ALU_ADD;
    cuif.alusrc = 1;
    cuif.WEN    = 1;
  end
  SLTI: begin 
    cuif.aluop  = ALU_SLT;
    cuif.alusrc = 1;
    cuif.WEN    = 1;
  end
  SLTIU: begin 
    cuif.aluop = ALU_SLTU;
    cuif.alusrc = 1;
    cuif.WEN = 1;
  end
  ANDI: begin 
    cuif.immediate = zero_extended_immediate;
    cuif.aluop     = ALU_AND;
    cuif.alusrc    = 1;
    cuif.WEN       = 1;
  end
  
  ORI: begin 
    cuif.immediate = zero_extended_immediate;
    cuif.aluop     = ALU_OR;
    cuif.alusrc    = 1;
    cuif.WEN       = 1;
  end 
  XORI: begin   
    cuif.immediate = zero_extended_immediate;
    cuif.aluop     = ALU_XOR;
    cuif.alusrc    = 1;
    cuif.WEN       = 1;
  end  
  LUI:  begin 
    cuif.WEN     = 1;
    cuif.wdatsel = LUI_WORD;
    cuif.aluop   = ALU_ADD;
    cuif.alusrc  = 1;
    cuif.immediate = cuif.lui_word;
    // No aluop
  end
  LW: begin 
    cuif.aluop   = ALU_ADD;
    cuif.alusrc  = 1;
    cuif.wdatsel = DMEMLOAD;
    cuif.WEN     = 1;
  end
  LL: begin
    cuif.aluop = ALU_ADD;
    cuif.alusrc = 1;
    cuif.wdatsel = DMEMLOAD;
    cuif.WEN = 1;
    cuif.datomic = 1;
  end
  SW: begin 
    cuif.aluop  = ALU_ADD;
    cuif.alusrc = 1;
  end
  SC: begin
    cuif.aluop = ALU_ADD;
    cuif.alusrc = 1;
    cuif.wdatsel = DMEMLOAD;
    cuif.WEN = 1;
    cuif.datomic = 1;
  end
  HALT: begin 
    cuif.pc_select = PC_HALT;
    // No aluop
    end
//================= R-TYPE! =================================

  RTYPE: begin
    cuif.wsel = r_instr.rd;
    cuif.WEN = 1; // NOT for JR!
    casez(r_instr.funct)
      SLL: begin
        cuif.immediate = extended_shamt;
        cuif.aluop     = ALU_SLL;
        cuif.alusrc    = 1;
      end
      SRL: begin
        cuif.immediate = extended_shamt;
        cuif.aluop     = ALU_SRL;
        cuif.alusrc    = 1;
      end
      JR: begin
        cuif.pc_select = JUMPREGISTER;
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
  default: begin
    cuif.WEN=0;
  end
  endcase  // end opcode case
end //end always_comb

endmodule
