`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`include "exmem_if.vh"


module exmem (input CLK, nRST, exmem_if.ex exmemif);
/*
   // exmem ports
  modport ex (
    input     enable, flush, imemload_in, npc_in, rdat1_in, rdat2_in, lui_word_in, wdatsel_in, wsel_in, pc_select_in, 
              dREN_in, dWEN_in, halt_in, WEN_in, port_o_in, z_fl_in,
    output    imemload_out, npc_out, rdat1_out, rdat2_out, lui_word_out, wdatsel_out, wsel_out, pc_select_out, 
              dREN_out, dWEN_out, halt_out, WEN_out, wdatsel_out, port_o_out, z_fl_out, dmemaddr, dmemstore
  );
 */
  
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST==0 || exmemif.flush) begin
       exmemif.imemload_out  <= 0; 
       exmemif.npc_out       <= 0;
       exmemif.rdat1_out     <= 0;
       exmemif.rdat2_out     <= 0;
       exmemif.wdatsel_out   <= PORT_O;
       exmemif.wsel_out      <= 0;
       exmemif.WEN_out       <= 0;
       exmemif.dREN_out      <= 0;
       exmemif.dWEN_out      <= 0;
       exmemif.halt_out      <= 0;
       exmemif.port_o_out    <= 0;
       exmemif.z_fl_out      <= 0;
       exmemif.lui_word_out  <= 0;
       exmemif.pc_select_out <= NEXT;
       
    end // if (nRST==0)
    
    else if (exmemif.enable) begin
       exmemif.imemload_out  <= exmemif.imemload_in;
       exmemif.npc_out       <= exmemif.npc_in; 
       exmemif.rdat1_out     <= exmemif.rdat1_in;
       exmemif.rdat2_out     <= exmemif.rdat2_in;
       exmemif.wdatsel_out   <= exmemif.wdatsel_in;
       exmemif.wsel_out      <= exmemif.wsel_in;
       exmemif.WEN_out       <= exmemif.WEN_in;
       exmemif.dREN_out      <= exmemif.dREN_in;
       exmemif.dWEN_out      <= exmemif.dWEN_in;
       exmemif.halt_out      <= exmemif.halt_in;
       exmemif.port_o_out    <= exmemif.port_o_in;
       exmemif.z_fl_out      <= exmemif.z_fl_in;
       exmemif.lui_word_out  <= exmemif.lui_word_in;
       exmemif.pc_select_out <= exmemif.pc_select_in;
    end
     

  end // end always_ff

endmodule
