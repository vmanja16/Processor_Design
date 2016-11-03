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
`include "hazard_unit_if.vh"
`include "forwarding_unit_if.vh"
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

  hazard_unit_if huif();
  forwarding_unit_if fuif();
// Map Modules

  // Map ALU
  alu ALU (al); 
  // Map registers
  register_file RF (CLK, nRST, rfif); 
  // Map Control Unit
  control_unit CF (CLK, nRST, cuif);
  // Map PC
  pc  #(.PC_INIT(PC_INIT)) PROGRAM_COUNTER(CLK, nRST, pcif);
  // Map IFID
  ifid IFID (CLK, nRST, ifidif);
  // Map IDEX
  idex IDEX (CLK, nRST, idexif);
  // Map EXMEM
  exmem EXMEM (CLK, nRST, exmemif);
  // Map MEMWB 
  memwb MEMWB (CLK, nRST, memwbif);
  // Map Hazard
  hazard_unit HU (CLK, nRST, huif);
  // Map Forwarding Unit
  forwarding_unit FU (CLK, nRST, fuif);

//dpif IO
 //   input   ihit, imemload, dhit, dmemload,
 //   output  halt, imemREN, imemaddr, dmemREN, dmemWEN, datomic,
 //            dmemstore, dmemaddr

// internals
  r_t instr; word_t next_pc, current_pc, pc4;
  assign instr = ifidif.imemload_out; 
  assign pc4   = pcif.rtn_addr; // =is currPC + 4
  assign current_pc = pcif.imemaddr;

always_ff @ (posedge CLK, negedge nRST) begin
  if (nRST == 0) dpif.halt <= 0;
  else if(memwbif.halt_out) dpif.halt <=1;
end // end always_ff

// =============== PC =================== //
assign pcif.enable    = huif.pc_enable;
assign pcif.pc_select = exmemif.pc_select_out; 
assign pcif.jump_data = exmemif.imemload_out;
assign pcif.z_fl      = exmemif.z_fl_out;
assign pcif.npc       = exmemif.npc_out;
assign pcif.rdat1     = exmemif.rdat1_out;

// ================HAZARDS!=============== //
assign huif.ihit          = dpif.ihit;
assign huif.dhit          = dpif.dhit;
assign huif.ifid_imemload = ifidif.imemload_out;
assign huif.idex_imemload = idexif.imemload_out;
assign huif.idex_dREN_out = idexif.dREN_out;
assign huif.pc_select     = exmemif.pc_select_out;
assign huif.z_fl          = exmemif.z_fl_out; 

// ================FORWARDING!=============== //
assign fuif.exmem_WEN    = exmemif.WEN_out;
assign fuif.exmem_wsel   = exmemif.wsel_out;
assign fuif.exmem_port_o = exmemif.port_o_out;
assign fuif.memwb_WEN    = memwbif.WEN_out;
assign fuif.memwb_wsel   = memwbif.wsel_out;
assign fuif.rfif_wdat    = rfif.wdat;
assign fuif.imemload     = idexif.imemload_out;
assign fuif.rdat1_in     = idexif.rdat1_out;
assign fuif.rdat2_in     = idexif.rdat2_out;

// ======== FETCH ================= //
assign dpif.imemaddr = pcif.imemaddr;


  // IFID inputs
assign ifidif.enable            = huif.ifid_enable;
assign ifidif.imemload_in       = dpif.imemload;
assign ifidif.npc_in            = pc4;
assign ifidif.flush             = huif.ifid_flush;


// ======== DECODE ================= //
 
  // Register file read inputs
assign rfif.rsel1 = instr.rs;
assign rfif.rsel2 = instr.rt;

  // control_unit inputs    
assign cuif.imemload = ifidif.imemload_out;

// IDEX inputs
assign idexif.enable = huif.idex_enable;
assign idexif.flush        = huif.idex_flush; 

assign idexif.rdat1_in     = rfif.rdat1;
assign idexif.rdat2_in     = rfif.rdat2;
assign idexif.aluop_in     = cuif.aluop;
assign idexif.alusrc_in    = cuif.alusrc;
assign idexif.immediate_in = cuif.immediate;
assign idexif.dREN_in      = cuif.dREN;
assign idexif.dWEN_in      = cuif.dWEN;
assign idexif.halt_in      = cuif.cpu_halt;
assign idexif.wdatsel_in   = cuif.wdatsel;
assign idexif.wsel_in      = cuif.wsel;
assign idexif.WEN_in       = cuif.WEN;
assign idexif.lui_word_in  = cuif.lui_word;
assign idexif.pc_select_in = cuif.pc_select;


//Passed from IFID latch
assign idexif.npc_in      =       ifidif.npc_out;
assign idexif.imemload_in =  ifidif.imemload_out;


// ======== EXECUTE ================= //
   // ALU inputs
assign al.alu_op = idexif.aluop_out;
assign al.port_a = fuif.rdat1_out;
assign al.port_b = (idexif.alusrc_out) ? idexif.immediate_out : fuif.rdat2_out;

// EXMEM inputs
assign exmemif.enable    = huif.exmem_enable;
assign exmemif.flush     = huif.exmem_flush;
assign exmemif.port_o_in = al.port_o; 
assign exmemif.z_fl_in   = al.z_fl;

//Passed from IDEX latch
assign exmemif.dREN_in      = idexif.dREN_out;
assign exmemif.dWEN_in      = idexif.dWEN_out;
assign exmemif.halt_in      = idexif.halt_out;
assign exmemif.wdatsel_in   = idexif.wdatsel_out;
assign exmemif.wsel_in      = idexif.wsel_out;
assign exmemif.WEN_in       = idexif.WEN_out;
assign exmemif.lui_word_in  = idexif.lui_word_out;
assign exmemif.pc_select_in = idexif.pc_select_out;
assign exmemif.npc_in       = idexif.npc_out;
assign exmemif.imemload_in  = idexif.imemload_out;
assign exmemif.rdat1_in     = fuif.rdat1_out;
assign exmemif.rdat2_in     = fuif.rdat2_out;



// ======== MEMORY =================== //
  // MEMWB inputs
assign memwbif.enable      = huif.memwb_enable;
assign memwbif.flush       = huif.memwb_flush;
assign memwbif.dmemload_in = dpif.dmemload;

//Passed from EXMEM latch
assign memwbif.halt_in     = exmemif.halt_out;
assign memwbif.wdatsel_in  = exmemif.wdatsel_out;
assign memwbif.wsel_in     = exmemif.wsel_out;
assign memwbif.WEN_in      = exmemif.WEN_out;
assign memwbif.lui_word_in = exmemif.lui_word_out;
assign memwbif.port_o_in   = exmemif.port_o_out;
assign memwbif.npc_in      = exmemif.npc_out;

// Dcache assignments
assign dpif.imemREN   = !(dpif.halt||dpif.dmemREN||dpif.dmemWEN);
assign dpif.dmemREN   = exmemif.dREN_out && (!dpif.halt);
assign dpif.dmemWEN   = exmemif.dWEN_out && (!dpif.halt);
assign dpif.datomic   = 0; // what is this?
assign dpif.dmemstore = exmemif.rdat2_out;
assign dpif.dmemaddr  = exmemif.port_o_out;

// ======== WRITEBACK ================ //

  // Register File Writes
assign rfif.WEN   = memwbif.WEN_out;
assign rfif.wsel  = memwbif.wsel_out;

always_comb begin
  casez(memwbif.wdatsel_out)
    DMEMLOAD: rfif.wdat = memwbif.dmemload_out;
    LUI_WORD: rfif.wdat = memwbif.lui_word_out;
    RTN_ADDR: rfif.wdat = memwbif.npc_out;
    PORT_O:   rfif.wdat = memwbif.port_o_out;
    default:  rfif.wdat = 32'h0;
  endcase
end //end always_comb   

endmodule
