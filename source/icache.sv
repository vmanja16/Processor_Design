/*
  Vikram Manja
  vmanja@purdue.edu
*/


// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"
`include "icache_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// Need to output IREN IHIT ILOAD

//module icache(input logic CLK, nRST, datapath_cache_if icif, caches_if icif);
module icache(input logic CLK, nRST, icache_if icif);
	typedef enum logic [1:0]{
		IDLE,
		LOAD
	} istate_t;

	typedef struct packed {
    word_t              data;
    logic               valid;
    logic [ITAG_W-1:0]  tag;
    logic [IIDX_W-1:0]  idx;
    logic [IBYT_W-1:0]  bytoff;
    } icacheframe_t;

	icacheframe_t frames [15:0], next_frame;
	icachef_t     iaddr_in;
	istate_t      state, next_state;
	logic         miss;
	logic [15:0] index;
	logic accessing;
// OUTPUTS
	assign icif.ihit      = (frames[index].valid) && (iaddr_in.tag == frames[index].tag)
	                        && (!accessing);
	assign icif.imemload  = frames[index].data; 
	assign icif.iaddr      = icif.imemaddr;
//  Internals
	assign accessing = icif.dmemREN || icif.dmemWEN;
	assign iaddr_in = icif.iaddr;
	assign miss     = (!icif.ihit) && (!accessing);
	assign index    = iaddr_in.idx;

//  UPDATE REGISTERS
	always_ff @ (posedge CLK, negedge nRST) begin 
		if(!nRST) begin
			frames <= '{default:'0};
			state  <= IDLE;
		end
		else begin 
			frames[index] <= next_frame;
			state         <= next_state;
		end
	end // end always_ff

//  NEXT_STATE_LOGIC
	always_comb begin
		next_state = state;
		next_frame = frames[index];
		icif.iREN = 0;
		casez(state)
			IDLE: begin
				if (miss && icif.imemREN) next_state = LOAD;
			end
			LOAD: begin
				icif.iREN = icif.imemREN;
				if (!icif.iwait) begin
					next_state       = IDLE;
					next_frame.tag   = iaddr_in.tag;
					next_frame.data  = icif.iload;
					next_frame.valid = 1;
				end
			end
		endcase
	end // end always_comb
endmodule // icache
