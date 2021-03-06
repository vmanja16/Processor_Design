/*
  Vikram Manja
  vmanja@purdue.edu

Hazard Test bench
*/

// mapped needs this
`include "alu_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module hazard_unit_tb;

  parameter PERIOD = 20;

  logic CLK = 0;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  hazard_unit_if huif ();
  // test program
  test PROG (CLK, huif);
  // DUT
`ifndef MAPPED
  hazard_unit DUT(CLK, 32'h1, huif);
`endif
endmodule

program test(input logic CLK, hazard_unit_if.tb huif);

// MAIN TESTING!

task test_non_hazard; begin
if (!huif.ifid_flush && !huif.idex_flush && !huif.exmem_flush) $display("Non Hazard Flushes passed");
else $display("Non Hazard Flush failed!");

end
endtask

task test_jump_hazard; begin
if (huif.ifid_flush && huif.idex_flush && huif.exmem_flush) $display("Non Hazard Flushes passed");
else $display("Non Hazard Flush failed!");
end
endtask

//
initial begin
$display("START TESTING!");
// Initializations!

huif.dhit = 0;
huif.ihit = 0;
huif.ifid_imemload = 0;
huif.idex_imemload = 0;

@CLK;
@CLK;

 // STart actual testing

 // rtype
huif.ifid_imemload = {6'h0, 5'd6, 5'd0, 5'd6, 5'd2, 6'd0}; // SLL reg[6]  
huif.idex_imemload = {6'b1000, 5'd5, 5'd6, 16'hFFFF}; // LW to reg[6]
huif.idex_dREN_out = 1;
huif.pc_select = NEXT;
@CLK;
huif.dhit = 1;
huif.ihit = 0;
@CLK;
@CLK;
if (huif.idex_flush == (1)) $display("Test Load Hazard (idex flush) Pass!");
  else $display("Test Load hazard (idex flush) Fail!");
if (huif.ifid_enable == (0)) $display("Test Load Hazard (ifid enable)Pass!");
  else $display("Test Load hazard (ifid_enable) Fail!");
@CLK;
huif.idex_dREN_out = 0;
huif.dhit = 0;
@CLK;
@CLK;
// Test Jump Hazards

//TEST JUMP/JAL
huif.ihit = 0;
$display("Test JUMP/JAL");
huif.pc_select = JUMP;
@CLK;
@CLK;
test_non_hazard;
@CLK;
@CLK;
huif.ihit = 1;
@CLK;
@CLK;
test_jump_hazard;
@CLK;
@CLK;

// TEST JR
$display("Test JUMPREGISTER");
huif.ihit = 0;
huif.pc_select = JUMPREGISTER;
@CLK;
@CLK;
test_non_hazard;
@CLK;
@CLK;
huif.ihit = 1;
@CLK;
@CLK;
test_jump_hazard;
@CLK;
@CLK;

// TEST BEQ
$display("Test Branch if not equal");
huif.ihit = 1;
huif.z_fl = 1;
huif.pc_select = BRANCH_IF_NOT_EQUAL;
@CLK;
@CLK;
test_non_hazard;
@CLK;
@CLK;
huif.ihit = 1;
huif.z_fl = 0;
@CLK;
@CLK;
test_jump_hazard;
@CLK;
@CLK;
// TEST BNE
$display("Test Branch if equal");
huif.ihit = 1;
huif.pc_select = BRANCH_IF_EQUAL;
huif.z_fl = 0;
@CLK;
@CLK;
test_non_hazard;
@CLK;
@CLK;
huif.ihit = 1;
huif.z_fl = 1;
@CLK;
@CLK;
test_jump_hazard;
@CLK;
@CLK;

$finish;
end // end initial block
endprogram