`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`include "hazard_if.vh"
/*
// hazard ports
  modport haz (
    input   exmem_WEN, memwb_WEN, ihit, dhit, rdat1_in, 
            rdat2_in, imemload, rfif_wdat, exmem_wsel, 
            memwb_wsel, exmem_port_o, 
    output  hazard, rdat1_in, rdat2_out
  );
*/
module hazard (input CLK, nRST, hazard_if.haz hazif);

r_t instr;
assign instr = hazif.imemload;

// TODO: Route LUI through ALU port_o!

// rdat 1 forwarding
always_comb begin
  if      (hazif.exmem_WEN && (instr.rs == hazif.exmem_wsel) )
    hazif.rdat1_out = hazif.exmem_port_o;
  else if (hazif.memwb_WEN &&  (instr.rs == hazif.memwb_wsel) )
    hazif.rdat1_out = hazif.rfif_wdat;
  else hazif.rdat1_out = hazif.rdat1_in;
end // end_always

// rdat 2 forwarding
always_comb begin
  if      (hazif.exmem_WEN && (instr.rt == hazif.exmem_wsel) )
       hazif.rdat2_out = hazif.exmem_port_o;
  else if (hazif.memwb_WEN && (instr.rt == hazif.memwb_wsel) )
       hazif.rdat2_out = hazif.rfif_wdat;
  else hazif.rdat2_out = hazif.rdat2_in;
end // end always

// Load Hazards


endmodule