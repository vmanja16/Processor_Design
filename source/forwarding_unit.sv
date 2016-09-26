`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`include "forwarding_unit_if.vh"
/*
// hazard ports
  modport haz (
    input   exmem_WEN, memwb_WEN, ihit, dhit, rdat1_in, 
            rdat2_in, imemload, rfif_wdat, exmem_wsel, 
            memwb_wsel, exmem_port_o, 
    output  hazard, rdat1_in, rdat2_out
  );
*/
module forwarding_unit (input CLK, nRST, forwarding_unit_if.fu fuif);

r_t instr;
assign instr = fuif.imemload;


// rdat 1 forwarding
always_comb begin
  if      (fuif.exmem_WEN && (fuif.exmem_wsel != 0) && (instr.rs == fuif.exmem_wsel) )
    fuif.rdat1_out = fuif.exmem_port_o;
  else if (fuif.memwb_WEN && (fuif.memwb_wsel != 0) && (instr.rs == fuif.memwb_wsel) )
    fuif.rdat1_out = fuif.rfif_wdat;
  else fuif.rdat1_out = fuif.rdat1_in;
end // end_always

// rdat 2 forwarding
always_comb begin
  if      (fuif.exmem_WEN && (fuif.exmem_wsel != 0) && (instr.rt == fuif.exmem_wsel) )
       fuif.rdat2_out = fuif.exmem_port_o;
  else if (fuif.memwb_WEN && (fuif.memwb_wsel != 0) && (instr.rt == fuif.memwb_wsel) )
       fuif.rdat2_out = fuif.rfif_wdat;
  else fuif.rdat2_out = fuif.rdat2_in;
end // end always




endmodule