`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`include "hazard_unit_if.vh"
/*
// hazard unit ports
  modport hu (
    input   ihit, dhit, idif_imemload, idex_imemload,
            idex_dREN_out, pc_enable,
    output  idif_enable, idif_flush, idex_enable, idex_flush
            exmem_enable, exmem_flush, memwb_enable, memwb_flush
  );

*/
module hazard_unit (input CLK, nRST, hazard_unit_if.hu huif);

logic load_hazard;
r_t ifid_instr, idex_instr;
assign ifid_instr = huif.ifid_imemload;
assign idex_instr = huif.idex_imemload;

//================== LOAD HAZARDS ===============//

assign load_hazard =   (huif.idex_dREN_out) && 
   ( 
      (ifid_instr.rs == idex_instr.rt) || 
      (ifid_instr.rt == idex_instr.rt)  
   );
//================== OUTPUTS ===============//

// enables
assign huif.pc_enable    = huif.ihit && (!load_hazard);
assign huif.ifid_enable  = huif.ihit && (!load_hazard);
assign huif.idex_enable  = (huif.ihit || huif.dhit);
assign huif.exmem_enable = (huif.ihit || huif.dhit);
assign huif.memwb_enable = (huif.ihit || huif.dhit);

// flushes
assign huif.ifid_flush   = huif.dhit && (!load_hazard);
assign huif.idex_flush   = load_hazard & huif.dhit;
assign huif.exmem_flush  = 0; // TEMP
assign huif.memwb_flush  = 0; // TEMP


endmodule
