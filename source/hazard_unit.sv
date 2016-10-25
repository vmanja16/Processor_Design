`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`include "hazard_unit_if.vh"

module hazard_unit (input CLK, nRST, hazard_unit_if.hu huif);

logic jump_flush;
logic load_hazard, jump_hazard;
logic any_hit;
r_t ifid_instr, idex_instr;
assign ifid_instr = huif.ifid_imemload;
assign idex_instr = huif.idex_imemload;
assign any_hit = huif.ihit || huif.dhit;

//================== LOAD HAZARDS ===============//

assign load_hazard =   (huif.idex_dREN_out) && 
   ( 
      (ifid_instr.rs == idex_instr.rt) || 
      (ifid_instr.rt == idex_instr.rt)  
   );

//================== JUMPING/BRANCH HAZARDS ===============//
assign jump_hazard = (huif.pc_select == JUMP) || 
                     (huif.pc_select == JUMPREGISTER) ||
                     ( (huif.pc_select == BRANCH_IF_EQUAL) && (huif.z_fl) ) ||
                     ( (huif.pc_select == BRANCH_IF_NOT_EQUAL) && (!huif.z_fl) );

assign jump_flush = jump_hazard && huif.ihit;
//================== OUTPUTS ===============//

  // enables
assign huif.pc_enable    = huif.ihit && (!load_hazard) || (jump_flush);
assign huif.ifid_enable  = huif.ihit && (!load_hazard);
assign huif.idex_enable  = any_hit;
assign huif.exmem_enable = any_hit;
assign huif.memwb_enable = any_hit;


  // flushes
assign huif.ifid_flush   = (huif.dhit && (!load_hazard) ) || jump_flush;
assign huif.idex_flush   = (load_hazard && (huif.ihit||huif.dhit))       || jump_flush;
assign huif.exmem_flush  = jump_flush;
assign huif.memwb_flush  = 0; // NEVER	


endmodule
