`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
`timescale 1 ns / 1ns

module memory_control_tb;

parameter PERIOD = 10;

logic CLK = 0;
logic nRST;
always #(PERIOD/2) CLK++;

caches_if cif0();
caches_if cif1();
cache_control_if #(.CPUS(1)) ccif (cif0, cif1);
cpu_ram_if ramif();


assign ccif.ramload = ramif.ramload;
assign ccif.ramstate = ramif.ramstate;
assign ramif.ramREN = ccif.ramREN;
assign ramif.ramWEN = ccif.ramWEN;
assign ramif.ramaddr = ccif.ramaddr;
assign ramif.ramstore = ccif.ramstore;


test PROG(CLK, nRST, cif0);

`ifndef MAPPED
  memory_control M(CLK, nRST, ccif);
  ram RAM(CLK, nRST, ramif);
`else  
`endif
endmodule

program test(input logic CLK, output logic nRST, caches_if.caches cif);
parameter PERIOD = 20;

static int v1 = 32'h10000;
static int v2 = 32'h1234;
initial begin
nRST = 1;
cif.dWEN = 1'b0;
cif.dREN = 1'b0;
cif.iREN = 0;
cif.iaddr = 32'h0;
cif.daddr = 32'h0;
# (2*PERIOD);

// TEST 1 DATA WRITE AND READ

cif.dstore = v1;
cif.daddr = v1;
cif.dWEN = 1'b1;
cif.dREN = 1'b0;
cif.iREN = 0;
# (PERIOD);
cif.dWEN =0; cif.dREN = 1;
# (PERIOD);
if (cif.dload == v1) $display ("Test 1 Write/Read Worked!");
else $display ("Test 1 Write/Read Failed");
if (cif.dwait ==0) $display ("Test 1 dwait worked!");
else $display ("Test 1 dwait failed!");
#(2*PERIOD)
// TEST 2 DATA WRITE Instruction READ
cif.daddr = v2;
cif.dstore = v2;
cif.dWEN = 1'b1;
cif.dREN = 1'b0;
cif.iREN = 0;
# (PERIOD);
cif.dWEN =0; cif.dREN = 1;
# (PERIOD);
if (cif.dload == v2) $display ("Test 2 Write/Read Worked!");
else $display ("Test 2 Write/Read Failed");
if (cif.dwait ==0) $display ("Test 2 dwait worked!");
else $display ("Test 2 dwait failed!");
# (PERIOD);
cif.dWEN=0; cif.dREN =0; cif.iREN = 1; cif.iaddr = v1;
# (PERIOD);
if (cif.iload == v1) $display ("Test 2 Instr Read Worked!");
else $display ("Test 2 Instr Write/Read Failed");
if (cif.iwait ==0) $display ("Test 2 iwait worked!");
else $display ("Test 2 dwait failed!");
if (cif.dwait ==1) $display ("Test 2 second dwait worked!");
else $display ("Test 2 dwait failed!");
dump_memory();
$finish;
end
task automatic dump_memory();
    string filename = "memcpu.hex";
    int memfd;

    cif.daddr = 0;
    cif.dWEN = 0;
    cif.dREN = 0;

    memfd = $fopen(filename,"w");
    if (memfd)
      $display("Starting memory dump.");
    else
      begin $display("Failed to open %s.",filename); $finish; end

    for (int unsigned i = 0; memfd && i < 16384; i++)
    begin
      int chksum = 0;
      bit [7:0][7:0] values;
      string ihex;

      cif.daddr = i << 2;
      cif.dREN = 1;
      repeat (4) @(posedge CLK);
      if (cif.dload === 0)
        continue;
      values = {8'h04,16'(i),8'h00,cif.dload};
      foreach (values[j])
        chksum += values[j];
      chksum = 16'h100 - chksum;
      ihex = $sformatf(":04%h00%h%h",16'(i),cif.dload,8'(chksum));
      $fdisplay(memfd,"%s",ihex.toupper());
    end //for
    if (memfd)
    begin
      cif.dREN = 0;
      $fdisplay(memfd,":00000001FF");
      $fclose(memfd);
      $display("Finished memory dump.");
    end
  endtask
endprogram
