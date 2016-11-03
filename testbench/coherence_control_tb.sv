`include "cache_control_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
`timescale 1 ns / 1ns

module coherence_control_tb;

parameter PERIOD = 10;

logic CLK = 0;
logic nRST;
always #(PERIOD/2) CLK++;

caches_if cif0();
caches_if cif1();
cache_control_if #(.CPUS(2)) ccif (cif0, cif1);
//cpu_ram_if ramif();


//assign ccif.ramload = ramif.ramload;
//assign ccif.ramstate = ramif.ramstate;
/*
assign ramif.ramREN = ccif.ramREN;
assign ramif.ramWEN = ccif.ramWEN;
assign ramif.ramaddr = ccif.ramaddr;
assign ramif.ramstore = ccif.ramstore;
*/

test PROG(CLK, nRST, ccif, cif0, cif1);

`ifndef MAPPED
  coherence_control M(CLK, nRST, ccif );
  //ram RAM(CLK, nRST, ramif);
`else  
`endif
endmodule

program test(input logic CLK, output logic nRST, cache_control_if ccif, caches_if cif0, caches_if cif1);
parameter PERIOD = 20;

static int v1 = 32'h10000;
static int v2 = 32'h1234;
initial begin
nRST = 0;
cif0.dWEN = 1'h0;cif1.dWEN = 1'h0;
cif0.dREN = 1'h0;cif1.dREN = 1'h0;
cif0.cctrans = 1'b0; cif1.cctrans = 1'b0;
cif0.daddr = 32'h0; cif1.daddr = 32'h0;
cif0.dstore = 32'h0; cif1.dstore = 32'h0;
# ( 2 * PERIOD);
nRST = 1;
cif0.dREN = 1; cif0.cctrans = 1; cif0.daddr = 32'hAA;
@ (posedge CLK);

if (ccif.ccwait[1] == 1) $display ("Test 1 Snoop state Worked!");
else $display ("Test 1 Snoop state Failed");
if (ccif.ccsnoopaddr[1] == 32'hAA) $display ("Test 1 Snoop addresss Worked!");
else $display ("Test 1 Snoop address Failed");

cif1.ccwrite = 1; cif1.dstore = 32'hFF; // SNOOPHIT!
// LOAD 0 STATE
@ (posedge CLK);
if (ccif.ccwait[1] == 1) $display ("Test 2 Snoop LOAD0 Worked!");
else $display ("Test 2 Snoop state Failed");
if (ccif.dload[0] == 32'hFF) $display ("Test 2  LOAD0 Worked!");
else $display ("Test 2 LOAD0 state Failed");
if (ccif.dwait[0] == 0) $display ("Test 2  Dwait LOAD0 Worked!");
else $display ("Test 2 Dwait LOAD0 state Failed");
cif1.dstore = 32'hFF -4;

@ (posedge CLK );
if (ccif.ccwait[1] == 1) $display ("Test 2 Snoop LOAD1 Worked!");
else $display ("Test 2 Load1 state Failed");
if (ccif.dload[0] == 32'hFF-4) $display ("Test 2  LOAD1 Worked!");
else $display ("Test 2 LOAD1 state Failed");
if (ccif.dwait[0] == 0) $display ("Test 2  Dwait LOAD1 Worked!");
else $display ("Test 2 Dwait LOAD1 state Failed");
// WRITEBACK_0 snoophit
cif1.daddr = 32'hFF-4;
@ (posedge CLK);
if (ccif.ccwait[1] == 1) $display ("Test 3 Snoop WRITEBACK0 Worked!");
else $display ("Test 3 Snoop WRITEBACK0 Failed");

if (ccif.ramWEN == 1) $display ("Test 3 RamWEN WRITEBACK0 Worked!");
else $display ("Test 3 RAMWEN WRITEBACK0 Failed");

if (ccif.ramaddr == 32'hFF-4) $display ("Test 3 Ramaddr WRITEBACK0 Worked!");
else $display ("Test 3 RAMaddr WRITEBACK0 Failed");
// WRITEBACK 1
cif1.daddr = 32'hFF;
@ (posedge CLK);
if (ccif.ccwait[1] == 1) $display ("Test 4 Snoop WRITEBACK1 Worked!");
else $display ("Test 3 Snoop WRITEBACK1 Failed");

if (ccif.ramWEN == 1) $display ("Test 4 RamWEN WRITEBACK1 Worked!");
else $display ("Test 3 RAMWEN WRITEBACK0 Failed");

if (ccif.ramaddr == 32'hFF) $display ("Test 4 Ramaddr WRITEBACK0 Worked!");
else $display ("Test 3 RAMaddr WRITEBACK1 Failed");


reset();
cif0.dREN = 1; cif0.cctrans = 1; cif0.daddr = 32'hAA;
// Snoop STATE
@ (posedge CLK);
if (ccif.ccwait[1] == 1) $display ("Test 5 Snoop  Worked!");
else $display ("Test 5 Snoop state Failed");
// LOAD_0
@ (posedge CLK);
if (ccif.ccwait[1] == 0) $display ("Test 5 Snoop  disable Worked!");
else $display ("Test 5 Snoop disable Failed");

if (ccif.ramREN == 1) $display ("Test 5 RamREN LOAD0 Worked!");
else $display ("Test 3 RAMREN LOAD00 Failed");

if (ccif.ramaddr == cif0.daddr) $display ("Test 5 Ramaddr LOAD0 Worked!");
else $display ("Test 3 RAMaddr 5 Failed");

// LOAD1
@ (posedge CLK);
if (ccif.ccwait[1] == 0) $display ("Test 6 LOAD1 Snoop  disable Worked!");
else $display ("Test 5 Snoop disable Failed");

if (ccif.ramREN == 1) $display ("Test 6 RamREN LOAD1 Worked!");
else $display ("Test 3 RAMREN LOAD00 Failed");

if (ccif.ramaddr == cif0.daddr) $display ("Test 6 Ramaddr LOAD1 Worked!");
else $display ("Test 3 RAMaddr 5 Failed");

reset();
@(posedge CLK);
cif0.dWEN = 1; cif0.cctrans = 1; cif0.daddr = 32'hCC;

// WRITEBACK_0
@ (posedge CLK);
if (ccif.ccwait[1] == 1) $display ("Test 7 Snoop state wait Worked!");
else $display ("Test 7 Snoop state Failed");

if (ccif.ccsnoopaddr[1] == 32'hCC) $display ("Test 7 Snoop addresss Worked!");
else $display ("Test 7 Snoop address Failed");

if (ccif.ramWEN == 1) $display ("Test 7 RamWEN WRITEBACK0 Worked!");
else $display ("Test 7 RAMWEN WB0 Failed");

if (ccif.ramaddr == cif0.daddr) $display ("Test 7 Ramaddr WRITEBACK0 Worked!");
else $display ("Test 7 RAMaddr WRITEBACK0 Failed");

if (ccif.dwait[0] == 1) $display ("Test 7 dwait WRITEBACK0 Worked!");
else $display ("Test 7 dwait WRITEBACK0 Failed");

ccif.ramstate = ACCESS;

@ (posedge CLK)
if (ccif.dwait[0] == 0) $display ("Test 7 dwait set WRITEBACK0 Worked!");
else $display ("Test 7 dwait set WRITEBACK0 Failed");

// WRITEBACK_1

ccif.ramstate = BUSY;
@ (posedge CLK);



if (ccif.ramWEN == 1) $display ("Test 8 RamWEN WRITEBACK1 Worked!");
else $display ("Test 8 RAMWEN WB1 Failed");

if (ccif.ramaddr == cif0.daddr) $display ("Test 8 Ramaddr WRITEBACK1 Worked!");
else $display ("Test 8 RAMaddr WRITEBACK1 Failed");

if (ccif.dwait[0] == 1) $display ("Test 8 dwait WRITEBACK1 Worked!");
else $display ("Test 8 dwait WRITEBACK1 Failed");

ccif.ramstate = ACCESS;

@ (posedge CLK);
@ (posedge CLK);

if (ccif.dwait[0] == 0) $display ("Test 8 dwait set WRITEBACK1 Worked!");
else $display ("Test 8 dwait set WRITEBACK1 Failed");


reset();

cif1.cctrans = 1; cif1.daddr = 32'hBB;
@ (posedge CLK);

// INVALIDATE 0 STATE!!!!!!
if (ccif.ccwait[0] == 1) $display ("Test 9 Snoop state wait INV0 Worked!");
else $display ("Test 9 Snoop state Failed");

if (ccif.ccsnoopaddr[0] == 32'hBB) $display ("Test 9 Snoop addresss  INV0 Worked!");
else $display ("Test 9 Snoop address Failed");


@ (posedge CLK);
@ (posedge CLK);

if ((ccif.ccwait[0] == 0) && (ccif.ccwait[1] == 0)) $display ("Test 10 Goes back to Idle on Write without invalidation worked!");
else $display ("Test 9 Snoop state Failed");

@ (posedge CLK);

// INVALIDATE 0 STATE!!!!!!
if (ccif.ccwait[0] == 1) $display ("Test 11 Snoop state wait INV0 Worked!");
else $display ("Test 11 Snoop state Failed");

if (ccif.ccsnoopaddr[0] == 32'hBB) $display ("Test 11 Snoop addresss  INV0 Worked!");
else $display ("Test 11 Snoop address Failed");

@ (posedge CLK);

cif0.ccwrite = 1; // FORCE INVALIDATION! goes to WRITEBACK!

@ (posedge CLK);
@ (posedge CLK);

if (ccif.ramaddr == cif0.daddr) $display ("Test 12 Ramaddr  Invalidation WRITEBACK0 Worked!");
else $display ("Test 12 RAMaddr Invalidation WRITEBACK0 Failed");




//dump_memory();

$finish;
end
task reset();
  nRST = 0;
  cif0.dWEN = 1'h0;cif1.dWEN = 1'h0;
  cif0.dREN = 1'h0;cif1.dREN = 1'h0;
  cif0.ccwrite = 1'h0; cif1.ccwrite = 1'h0;
  cif0.cctrans = 1'b0; cif1.cctrans = 1'b0;
  cif0.daddr = 32'h0; cif1.daddr = 32'h0;
  cif0.dstore = 32'h0; cif1.dstore = 32'h0;
  ccif.ramstate = BUSY;
  # ( 2 * PERIOD);
  nRST = 1;
  @ (posedge CLK);
endtask
/*task automatic dump_memory();
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
  endtask */
endprogram
