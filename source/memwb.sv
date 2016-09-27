`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`include "memwb_if.vh"


module memwb (input CLK, nRST, memwb_if.mem memwbif);
  
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST==0 || memwbif.flush) begin
      memwbif.port_o_out <= 0;
      memwbif.dmemload_out <= 0;
      memwbif.halt_out <= 0;
      memwbif.wdatsel_out <= PORT_O;
      memwbif.wsel_out <= 0;
      memwbif.WEN_out <= 0;
      memwbif.lui_word_out <= 0;
      memwbif.npc_out     <= 0;
    end
    else if (memwbif.enable) begin
      memwbif.port_o_out <= memwbif.port_o_in;
      memwbif.dmemload_out <= memwbif.dmemload_in;
      memwbif.halt_out <= memwbif.halt_in;
      memwbif.wdatsel_out <= memwbif.wdatsel_in;
      memwbif.wsel_out <= memwbif.wsel_in;
      memwbif.WEN_out <= memwbif.WEN_in;
      memwbif.lui_word_out <= memwbif.lui_word_in;
      memwbif.npc_out      <= memwbif.npc_in;      
    end
  end // end always_ff

endmodule
