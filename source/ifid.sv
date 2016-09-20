`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`include "ifid_if.vh"


module ifid (input CLK, nRST, ifid_if.ifid ifidif);
/*ifid ports
    modport ifid (
      input   iload, npc_in, ifid_enable,
      output  imemload, npc
  );
*/

  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST==0) begin
      ifidif.imemload <= 0; // 0 on nRST
      ifidif.npc_out  <= 0; // 0 on nRST
    end
    else if (ifidif.flush) begin
      ifidif.imemload <= 0; // 0 on flush
      ifidif.npc_out  <= 0; // 0 on flush
    end
    else if (ifidif.ifid_enable) begin
      ifidif.imemload <= ifidif.iload; // update instruction
      ifidif.npc_out  <= ifidif.npc_in; // update next_pc
    end

  end // end always_ff

endmodule
