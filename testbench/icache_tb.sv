`include "cache_control_if.vh"
`include "datapath_cache_if.vh"
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;
`timescale 1 ns / 1ns

module icache_tb;

parameter PERIOD = 20;

logic CLK = 0;
logic nRST;
always #(PERIOD/2) CLK++;

caches_if cif0(); // the cache
caches_if cif1(); // useless for single core
cache_control_if #(.CPUS(1)) ccif (cif0, cif1); // instansiate controller interface w/ cache
datapath_cache_if dcif(); // datapath to cache interface
cpu_ram_if ramif(); // ram

/*                   DUT: ccif->cif0->icache()                             */

// signals to datapath

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
  ram            R(CLK, nRST, ramif);
`else
`endif
endmodule

program test(input logic CLK, output logic nRST, 
            datapath_cache_if dcif, caches_if cif);

parameter PERIOD = 20;

static int v1 = 32'h10000;
static int v2 = 32'h1234;

task test_load_from_memory();
while (dcif.ihit == 0) begin @ (posedge CLK); end
if (dcif.imemload == dcif.imemaddr)
  $display("PASSED: loaded instr from memory\n");
else $display("FAILED did not load instr from memory\n");
#(PERIOD);
endtask initial begin

// need to give cache from dpif:(imemREN, dmemREN, dmemWEN, imemaddr) in program block
// need to check values of cif.imemload and cif.ihit and cif.iREN

dcif.imemREN  = 0;
dcif.imemaddr = 0;
dcif.dmemREN  = 0;
dcif.dmemWEN  = 0;
dcif.dmemaddr = 0;
# (PERIOD);
nRST = 0;
# (PERIOD);
nRST = 1;
# (PERIOD);


dcif.imemREN = 1; dcif.imemaddr = 32'h4;
test_load_from_memory();




// TEST 1: Standard instruction read from memory:







  $finish;
end
endprogram
