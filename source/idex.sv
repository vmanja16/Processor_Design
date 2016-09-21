`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`include "idex_if.vh"


module idex (input CLK, nRST, idex_if.id idexif);
/*
  // idex ports
  modport id (
    input     imemload_in, npc_in, rdat1_in, rdat2_in immediate_in, alusrc_in, aluop_in, 
              dREN_in, dWEN_in, halt_in, wdatsel_in, wsel_in, WEN_in, lui_word_in, 
              pc_select_in, enable, flush
    output    imemload_out, npc_out, rdat1_out, rdat2_out, immediate_out, alusrc_out, aluop_out, 
              dREN_out, dWEN_out,halt_out, wdatsel_out, wsel_out, WEN_out, lui_word_out,
              pc_select_out,
  );
*/
  always_ff @ (posedge CLK, negedge nRST) begin
    if (( nRST==0) || idexif.flush) begin
      idexif.imemload_out <= 0; // 0 on nRST
      idexif.npc_out      <= 0; // 0 on nRST
      idexif.rdat1_out    <= 0;
      idexif.rdat2_out    <= 0;
       idexif.immediate_out <= 0;
       idexif.alusrc_out    <=0;
       idexif.aluop_out      <= ALU_ADD;
       idexif.dREN_out         <=0;
       idexif.dWEN_out        <=0;
       idexif.halt_out         <=0;
       idexif.wdatsel_out    <= PORT_O;
       idexif.wsel_out       <= 0;
       idexif.WEN_out       <= 0;
       idexif.lui_word_out <= 0;
       idexif.pc_select_out <= NEXT;
    end
    else if (idexif.enable) begin
      idexif.imemload_out  <= idexif.imemload_in;
      idexif.npc_out       <= idexif.npc_in;
      idexif.rdat1_out     <= idexif.rdat1_in;
      idexif.rdat2_out     <= idexif.rdat2_in;
      idexif.immediate_out <= idexif.immediate_in;
      idexif.alusrc_out    <= idexif.alusrc_in;
      idexif.aluop_out     <= idexif.aluop_in;
      idexif.dREN_out      <= idexif.dREN_in;
      idexif.dWEN_out      <= idexif.dWEN_in;
      idexif.halt_out      <= idexif.halt_in;
      idexif.wdatsel_out   <= idexif.wdatsel_in;
      idexif.wsel_out      <= idexif.wsel_in;
      idexif.WEN_out       <= idexif.WEN_in;
      idexif.lui_word_out  <=  idexif.lui_word_in;
      idexif.pc_select_out <= idexif.pc_select_in;
    end

  end // end always_ff

endmodule
