`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

`include "ifid_if.vh"


module exmem (input CLK, nRST, exmem_if.ex exmemif)

  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST==0) begin
      ifidif.imemload <= 0; // 0 on nRST
      ifidif.npc_out  <= 0; // 0 on nRST
    end

  end // end always_ff

endmodule
