`include "cache_control_if.vh"
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
`timescale 1 ns / 1ns

module dcache_tb;

parameter PERIOD = 20;

logic CLK = 0; logic RAMCLK = 0;
logic nRST;
always #(PERIOD/2) RAMCLK++;
always #(PERIOD)   CLK++;

caches_if cif0(); // the cache
caches_if cif1(); // useless for single core
cache_control_if #(.CPUS(1)) ccif (cif0, cif1); // instansiate controller interface w/ cache
datapath_cache_if dcif(); // datapath to cache interface
cpu_ram_if ramif(); // ram

/*                   DUT: ccif->cif0->icache()                             */

// signals from datapath
assign dcif.imemREN = 0; // ONLY TESTING DCACHE

// signals to Memory controller
assign ccif.ramload   = ramif.ramload;
assign ccif.ramstate  = ramif.ramstate;
// signals to RAM
assign ramif.ramREN   = ccif.ramREN;
assign ramif.ramWEN   = ccif.ramWEN;
assign ramif.ramaddr  = ccif.ramaddr;
assign ramif.ramstore = ccif.ramstore;
// signals to Cache
  

test PROG(CLK, nRST, dcif, cif0); // CALLS the programming block using cif0 as a caches obj

`ifndef MAPPED
  caches         C(CLK, nRST, dcif, cif0);
  memory_control M(CLK, nRST, ccif);
  ram            R(RAMCLK, nRST, ramif);
`else
`endif
endmodule

program test(input logic CLK, output logic nRST, 
            datapath_cache_if dcif, caches_if cif);

parameter PERIOD = 20;

static int v1 = 32'h10000;
static int v2 = 32'h1234;

task test_load_from_cache_hit();
  @(posedge CLK);
  if (dcif.dhit == 1)
    $display("PASSED: immediate dhit from cache\n");
  else $display("FAILED: no immediate dhit from cache\n");
  if (dcif.dmemload == dcif.dmemaddr)
    $display("PASSED: loaded data from cache\n");
  else $display("FAILED did not load data from cache\n");
  #(PERIOD);
endtask

task test_write_miss_clean();
	while (dcif.dhit == 0) begin @ (posedge CLK); end
		dcif.dmemWEN = 0; dcif.dmemREN = 1; 
	@ (posedge CLK);
	if (dcif.dmemload == 32'hFF)
    $display("PASSED: loaded data from cache after writing\n");
  else $display("FAILED did not load data from cache after writing\n");
  #(PERIOD);
endtask

task test_load_from_memory();
while (dcif.dhit == 0) begin @ (posedge CLK); end
if (dcif.dmemload == dcif.dmemaddr)
  $display("PASSED: loaded instr from memory\n");
else $display("FAILED did not load instr from memory\n");
#(PERIOD);
endtask 

task test_write_hit();
	@ (posedge CLK);
	if (dcif.dhit == 1) $display("PASS: Immediate dhit on writehit");
	else $display("FAILED: no immediate dhit on writehit");
	dcif.dmemWEN = 0; dcif.dmemREN = 1; 
	@ (posedge CLK);
	if (dcif.dmemload == 32'hAA)
	$display("PASSED: loaded data from cache after writing\n");
	else $display("FAILED did not load data from cache after writing\n");
	#(PERIOD);
endtask

task test_dirty_read_miss();
	while (dcif.dhit == 0) begin @ (posedge CLK); end // Written to 80 and 84
		@ (posedge CLK);
		dcif.dmemWEN = 0; dcif.dmemREN = 1; dcif.dmemaddr = 32'd208;
		@ (posedge CLK);
		if ((cif.dWEN ==1) && (cif.dstore == 32'hFF))$display("PASS: Correctly wrote lru first word to memory on read dirty miss");
	while (dcif.dhit == 0) begin 
	@ (posedge CLK); end // WENT through replacement
		// MANUALLY CHECK LRU CHANGE FROM 0 to 1 because we had just written to 1 and now replacing 0

endtask


initial begin

// need to give cache from dpif:(imemREN, dmemREN, dmemWEN, imemaddr) in program block
// need to check values of cif.imemload and cif.ihit and cif.iREN

dcif.dmemREN  = 0;
dcif.dmemWEN  = 0;
dcif.dmemaddr = 0;
# (PERIOD);
nRST = 0;
# (PERIOD);
nRST = 1;
# (PERIOD);
$display("\tTESTING READ CLEAN MISS\n");
dcif.dmemREN = 1; dcif.dmemaddr = 32'h8;
test_load_from_memory();
$display("\tTESTING READ HIT\n");
dcif.dmemREN = 1; dcif.dmemaddr = 32'd12;
test_load_from_cache_hit();
dcif.dmemREN = 0; dcif.dmemWEN = 1; dcif.dmemstore = 32'hFF; dcif.dmemaddr = 32'd16; //dirty addr
@(posedge CLK);
$display("\tTESTING WRITE MISS CLEAN");
test_write_miss_clean();
$display("\tTESTING WRITE HIT");
dcif.dmemREN = 0; dcif.dmemWEN = 1; dcif.dmemstore = 32'hAA; dcif.dmemaddr = 32'd20;
@ (posedge CLK);
test_write_hit();
$display("\tTESTING DIRTY READ");
dcif.dmemREN = 0; dcif.dmemWEN = 1;  dcif.dmemstore = 32'hBB; dcif.dmemaddr = 32'd80; 
@ (posedge CLK);
test_dirty_read_miss();

$finish;
end
endprogram
