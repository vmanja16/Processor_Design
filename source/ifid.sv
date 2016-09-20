`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`include "ifid_if.vh"


module ifid (input CLK, nRST, ifid_if.ifid ifidif);
/*ifid ports
    modport ifid (
      input   imemload_in, npc_in, enable, flush
      output  imemload_out, npc_out
  );
*/

  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST==0) begin
      ifidif.imemload_out <= 0; // 0 on nRST
      ifidif.npc_out      <= 0; // 0 on nRST
    end
    else if (ifidif.flush) begin
      ifidif.imemload_out <= 0; // 0 on flush
      ifidif.npc_out      <= 0; // 0 on flush
    end
    else if (ifidif.ifid_enable) begin
      ifidif.imemload_out <= ifidif.imemload_in; // update instruction
      ifidif.npc_out      <= ifidif.npc_in; // update next_pc
    end

  end // end always_ff

endmodule
