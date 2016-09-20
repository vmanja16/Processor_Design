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
`include "ifid_if.vh"
`include "idex_if.vh"
`include "exmem_if.vh"
`include "memwb_if.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  // import types
  import cpu_types_pkg::*;

  // pc init
  parameter PC_INIT = 0;

// interfaces
  alu_if al();
  register_file_if rfif();
  control_unit_if cuif();
  pc_if pcif();

  ifid_if ifidif();
  idex_if idexif();
  exmem_if exmemif();
  memwb_if memwbif();

// Map Modules

  // Map ALU
  alu ALU (al); 
  // Map registers
  register_file RF (CLK, nRST, rfif); 
  // Map Control Unit
  control_unit CF (CLK, nRST, cuif);
  // Map PC
  pc PROGRAM_COUNTER (CLK, nRST, pcif);
  // Map IFID
  ifid IFID (CLK, nRST, ifidif);
  // Map IDEX
  idex IDEX (CLK, nRST, idexif);
  // Map EXMEM
  exmem EXMEM (CLK, nRST, exmemif);
  // Map MEMWB 
  memwb MEMWB (CLK, nRST, memwbif);

//dpif IO
 //   input   ihit, imemload, dhit, dmemload,
 //   output  halt, imemREN, imemaddr, dmemREN, dmemWEN, datomic,
 //            dmemstore, dmemaddr

// internals
  r_t instr;
  assign instr = ifidif.imemload; 
  assign pc4   = pcif.rtn_addr; // ret_addr is currPC + 4
// DATHAPATH OUTPUTS

// didn't make sense because it's the metastable cpu_halt!
//always_ff @ (posedge CLK, negedge nRST) begin
//  if (nRST == 0) dpif.halt <= 0;
//  else if(cuif.cpu_halt) dpif.halt <=1;
//end // end always_ff

//assign dpif.halt      = cuif.cpu_halt; // not sure here
assign dpif.imemREN   = 1;
assign dpif.dmemREN   = exmemif.dmemREN;
assign dpif.dmemWEN   = exmemif.dmemWEN;
assign dpif.imemaddr  = pcif.imemaddr;
assign dpif.datomic   = 0; // what is this?
assign dpif.dmemstore = exmemif.rdat2;
assign dpif.dmemaddr  = exmemif.port_o;

// PC inputs

// REQUEST_UNIT inputs

// ALU inputs
assign al.alu_op = idexif.aluop;
assign al.port_a = idexif.rdat1;
assign al.port_b = (idexif.alusrc) ? idexif.immediate : idexif.rdat2;

/* REGISTER_FILE inputs   */
 // reads
assign rfif.rsel1 = instr.rs;
assign rfif.rsel2 = cuif.rsel2;
 // writes
assign rfif.WEN   = memwbif.WEN;
  // rfif.wsel (MUX);
always_comb begin
  casez(memwbif.wdatsel)
    DMEMLOAD: rfif.wdat = memwbif.dmemload;
    LUI_WORD: rfif.wdat = memwbif.lui_word;
    RTN_ADDR: rfif.wdat = memwbif.rtn_addr;
    PORT_O:   rfif.wdat = memwbif.al.port_o;
    default:  rfif.wdat = 32'h0;
  endcase
end //end always_comb   

/*   CONTROL_UNIT inputs    */
assign cuif.imemload = ifidif.imemload;

// IFID inputs
assign ifidif.ifid_enable = dpif.ihit;
assign ifidif.iload       = dpif.imemload;
  // flush
assign npc_in             = pc4;

// IDEX inputs
assign idexif.idex_enable = (dpif.dhit || dpif.ihit); 

// EXMEM inputs
assign idexif.exmem_enable = (dpif.dhit || dpif.ihit); // halt?
assign exmemif.port_o_in = al.port_o;

// MEMWB inputs
assign idexif.memwb_enable = (dpif.dhit || dpif.ihit); // halt?




endmodule
