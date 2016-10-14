// types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// request unit interface

`include "request_unit_if.vh"


module request_unit(input CLK, nRST, request_unit_if.ru ruif);

always_ff @(posedge CLK, negedge nRST) begin
  if (nRST == 0) begin ruif.dmemREN <=0; ruif.dmemWEN<=0; end // deAssert data signals
  else if (ruif.ihit) begin
    ruif.dmemREN <= ruif.dREN;
    ruif.dmemWEN <= ruif.dWEN;
  end
  else if (ruif.dhit) begin
    ruif.dmemREN <= 0;
    ruif.dmemWEN <= 0;
  end 
end //end always_ff

assign ruif.imemREN = 1'b1; //always reading instructions!

endmodule
