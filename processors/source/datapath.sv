/*
  Vikram Manja
  vmanja@purdue.edu

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"

// other interfaces
`include "register_file_if.vh"
`include "alu_if.vh"
`include "pc_if.vh"
`include "control_unit_if.vh"
`include "request_unit_if.vh"



// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
//dpif IO
 //   input   ihit, imemload, dhit, dmemload,
 //   output  halt, imemREN, imemaddr, dmemREN, dmemWEN, datomic,
 //            dmemstore, dmemaddr

  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;
  
 // interfaces
alu_if al();
register_file_if rfif();
pc_if pcif();
request_unit_if ruif();
control_unit_if cuif();
// Map ALU
alu ALU (al); // still need to assign the values 
// Map registers
register_file RF (rfif); // still need to assign values
// Map Request Unit
request_unit RU (ruif);
// Map Control Unit
control_unit CF (cuif);
// Map PC
pc PROGRAM_COUNTER (CLK, nRST, pcif);

// DATHAPATH OUTPUTS
assign dpif.halt      = ruif.halt;
assign dpif.imemREN   = ruif.imemREN;
assign dpif.dmemREN   = ruif.imemREN;
assign dpif.dmemWEN   = ruif.imemWEN;
assign dpif.imemaddr  = pcif.imemaddr;
assign dpif.datomic   = cuif.datomic;
assign dpif.dmemstore = cuif.dmemstore;
assign dpif.dmemaddr  = cuif.dmemaddr;

// PC inputs
assign pcif.pc_select   = cuif.pc_select;
assign pcif.jump_data   = cuif.jump_data;
assign pcif.init        = cuif.init;

// REQUEST_UNIT inputs
assign ruif.cpu_halt = cuif.cpu_halt;
assign ruif.dREN     = cuif.dREN;
assign ruif.dWEN     = cuif.dWEN;
assign ruif.ihit     = dpif.ihit;
assign ruif.dhit     = dpif.dhit;

// ALU inputs
assign al.aluop  = cuif.aluop;
assign al.port_a = rfif.rdat1;
assign al.port_b = (cuif.alusrc) ? cuif.immediate : rfif.rdat2;

// REGISTER_FILE inputs
assign rfif.rsel1 = cuif.rsel1;
assign rfif.rsel2 = cuif.rsel2;
assign rfif.WEN   = cuif.WEN;
assign rfif.wsel  = cuif.wsel;
always_comb begin
  casez(cuif.wdatsel)
    DMEMLOAD: rfif.wdat = dpif.dmemload;
    LUI_WORD: rfif.wdat = cuif.lui_word;
    RTN_ADDR: rfif.wdat = pcif.rtn_addr;
    PORT_O:   rfif.wdat = alu.port_o;
    default:  rfif.wdat = 32'h0;
end //end always_comb 

// CONTROL_UNIT inputs
assign cuif.port_o   = al.port_o;
assign cuif.z_fl     = al.z_fl;
assign cuif.rdat2    = rfif.wsel;
assign cuif.imemload = dpif.imemload;

endmodule