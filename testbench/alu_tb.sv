/*
  Vikram Manja
  vmanja@purdue.edu

  alu test bench
*/

// mapped needs this
`include "alu_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
// mapped timing needs this. 1ns is too fast
`timescale 1 ns / 1 ns

module alu_tb;

  parameter PERIOD = 10;

  logic CLK = 0;

  // clock
  always #(PERIOD/2) CLK++;

  // interface
  alu_if al ();
  // test program
  test PROG (CLK, al);
  // DUT
`ifndef MAPPED
  alu DUT(al);
`else
  alu DUT(
    .\al.alu_op (al.alu_op),
    .\al.port_a (al.port_a),
    .\al.port_b (al.port_b),
    .\al.port_o (al.port_o),
    .\al.n_fl (al.n_fl),
    .\al.z_fl (al.z_fl),
    .\al.o_fl (al.o_fl)
  );
`endif
endmodule

program test(input logic CLK, alu_if.tb al);
int i = 0;
logic [31:0] tb_op_1, tb_op_2, tb_res; 
task test_add;
  input logic [31:0] a, b, sum;
  input logic v; 
  begin
    #(10);
    al.port_a = a; al.port_b = b;
    al.alu_op = ALU_ADD;
    #(10);
    if(al.port_o == sum) $display("Test Addition Pass!");
    else $display("Test Addition Fail!");
    if (al.o_fl == v) $display("Test Overflow Pass!");
    else $display("Test Overflow Fail!");
  end
  test_neg();
  test_zero();
 endtask
task test_sub;
  input logic [31:0] a, b, diff;
  input logic v; 
  begin
    #(10);
    al.port_a = a; al.port_b = b;
    al.alu_op = ALU_SUB;
    #(10);
    if(al.port_o == diff) $display("Test Subtraction Pass!");
    else $display("Test Subtraction Fail!");
    if (al.o_fl == v) $display("Test Overflow Pass!");
    else $display("Test Overflow Fail!");
  end
  test_neg();
  test_zero();
 endtask
task test_neg; 
  begin
  if (al.n_fl == ($signed(al.port_o) < 0)) $display("Test Negative Pass!");
  else $display("Test Negative Fail!");
  end 
 endtask
task test_zero; 
  begin
  if (al.z_fl == (al.port_o == 0)) $display("Test Zero Pass!");
  else $display("Test Zero Fail!");
  end 
 endtask
task start; 
  input logic num; begin
  $display("\tTest ", num);
  end
 endtask
//
// MAIN TESTING!
//
initial begin
$display("START TESTING!");
// Signed Addition
i = i + 1; $display("\tTest ", i);
test_add(32'h7, 32'h8, 32'h0F, 1'b0);
i = i + 1; $display("\tTest ", i);
test_add(32'h7FFFFFFF, 32'h7FFFFFFF, 32'h7FFFFFFF, 1'b1);

// Test 2: Signed Subtraction
i = i + 1; $display("\tTest ", i);
test_sub(32'h8, 32'h7, 32'h1, 1'b0);
i = i + 1; $display("\tTest ", i);
test_sub(32'h7, 32'h8, 32'hFFFFFFFF, 1'b0);
i = i + 1; $display("\tTest ", i);
test_sub(32'h7FFFFFFF, 32'hFFFFFFFF, 32'h80000000, 1'b1);

// Test 3: Logical Left
i = i + 1; $display("\tTest ", i);
#(10);
al.alu_op = ALU_SLL; 
al.port_a = 32'hFFFFFFFF; al.port_b = 32'hC;
#(10);
if (al.port_o == 32'hFFFFF000)$display("Left Shift Pass!");
else $display("Left Shift FAIL!");
test_neg(); test_zero();

// Test 4: Logical Right
i = i + 1; $display("\tTest ", i);
#(10);
al.alu_op = ALU_SRL;
al.port_a = 32'h777; al.port_b = 32'h777;
#(10);
if (al.port_o == 32'h0) $display("Right Shift Pass!");
else $display("Right Shift FAIL!");
test_neg; test_zero;

// Test 5: Bitwise AND
i = i + 1; $display("\tTest ", i);
#(10);
al.alu_op = ALU_AND;
al.port_a = 32'hEEEEEEEE; al.port_b = 32'h11111111;
#(10);
if (al.port_o == 32'h0) $display("Bitwise AND Pass!");
else $display("Bitwise AND FAIL!");
test_neg; test_zero;

// Test 6: Bitwise OR
i = i + 1; $display("\tTest ", i);
#(10);
al.alu_op = ALU_OR;
al.port_a = 32'hEEEEEEEE; al.port_b = 32'h11111111;
#(10);
if (al.port_o == 32'hFFFFFFFF) $display("Bitwise OR Pass!");
else $display("Bitwise OR FAIL!");
test_neg; test_zero;

// Test 7: Bitwise XOR
i = i + 1; $display("\tTest ", i);
#(10);
al.alu_op = ALU_XOR;
al.port_a = 32'hEEEEEEEE; al.port_b = 32'hffffffff;
#(10);
if (al.port_o == 32'h11111111) $display("Bitwise XOR Pass!");
else $display("Bitwise XOR FAIL!");
test_neg; test_zero;

// Test 8: Bitwise NOR
i = i + 1; $display("\tTest ", i);
#(10);
al.alu_op = ALU_NOR;
al.port_a = 32'h11111111; al.port_b = 32'h22222222;
#(10);
if (al.port_o == 32'hCCCCCCCC) $display("Bitwise NOR Pass!");
else $display("Bitwise NOR FAIL!");
test_neg; test_zero;

// Test 9: Set Less Than
i = i + 1; $display("\tTest ", i);
#(10);
al.alu_op = ALU_SLT; 
al.port_a = 32'hFFFFFFFF; al.port_b = 32'h2;
#(10);
if (al.port_o == 1) $display("Set Less Than Pass!");
else $display("Set Less Than FAIL!");
test_zero();

// Test 10: Set Less Than Unsigned
i = i + 1; $display("\tTest ", i);
#(10);
al.alu_op = ALU_SLTU; 
al.port_a = 32'hFFFFFFFF; al.port_b = 32'h2;
#(10);
if (al.port_o == 0) $display("Unsigned Set Less Than Pass!");
else $display("Unsigned Set Less Than FAIL!");
test_zero();
$finish;
end // end initial block
endprogram
