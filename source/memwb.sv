`include "cpu_types_pkg"
import cpu_types_pkg::*;

`include "memwb_if.vh"


module memwb (input CLK, negedge nRST, memwbif);
  
  always_ff @ (posedge CLK, negedge nRST) begin
    if (nRST==0) begin
      
    end
  end // end always_ff

endmodule
