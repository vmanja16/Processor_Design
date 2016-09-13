// types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
// request unit interface

`include "control_unit_if.vh"

module request(input logic CLK, nRST, control_unit_if.cu cuif);
 
/*modport cu (
    input   imemload, rdat2, port_o, z_fl,
    output  cpu_halt, datomic, dREN, dWEN, dmemaddr, dmemstore, alusrc, wdatsel, WEN, wsel, rsel1, rsel2, pc_select, jump_data, init, immediate, lui_word
  );
*/
// internals
opcode_t opcode;
assign opcode = cuif.imemload[31:26];

// keep in mind that immediate can be shamt!
//assign cuif.immediate = { {16{cuif.imemload[15]}}, cuif.imemload[15:0] }; // sign-extended
assign cuif.lui_word  = { cuif.imemload[15:0], 16'h0 }; // shifted word
assign cuif.dWEN      = (opcode == SW) ? 1 : 0;
assign cuif.datomic   = 1'b0; //what is this?

endmodule