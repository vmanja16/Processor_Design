// types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// request unit interface

`include "request_unit_if.vh"


module request(input logic CLK, nRST, request_unit_if.ru ruif);

always_ff @(posedge CLK, negedge nRST)begin
  ruif.halt <= ruif.cpu_halt;
  if (nRST == 0) begin ruif.dmemREN <=0; ruif.dmemWEN<=0; ruif.halt<=0; end // deAssert data signals
  else
    begin
      ruif.dmemREN <= (ruif.dhit) ? 0 : ( (ruif.ihit) ? ruif.dREN : 0 );
      ruif.dmemWEN <= (ruif.dhit) ? 0 : ( (ruif.ihit) ? ruif.dWEN : 0 );
    end 
end //end always_ff


assign ruif.imemREN = 1'b1; //always reading instructions!

endmodule
