/*
  Vikram Manja
  vmanja@purdue.edu
*/


// interfaces
`include "datapath_cache_if.vh"
`include "caches_if.vh"

// cpu types
`include "cpu_types_pkg.vh"
import cpu_types_pkg::*;

// Need to output IREN IHIT ILOAD

/*
  modport cache (
    input   halt, imemREN, dmemREN, dmemWEN, datomic,
            dmemstore, dmemaddr, imemaddr,
    output  ihit, dhit, imemload, dmemload, flushed
  );
*/

/*
  modport icache (
    input   iwait, iload,
    output  iREN, iaddr
  );

*/

/*
  typedef struct packed {
    logic [ITAG_W-1:0]  tag;
    logic [IIDX_W-1:0]  idx;
    logic [IBYT_W-1:0]  bytoff;
  } icachef_t;

  typedef struct packed {
    logic               valid;
    logic [ITAG_W-1:0]  tag;
    logic [IIDX_W-1:0]  idx;
    logic [IBYT_W-1:0]  bytoff;
    word_t              data;
  } icacheframe_t
*/
module icache(input logic CLK, nRST, datapath_cache_if.cache dcif, caches_if icif
);

	typedef enum logic [1:0]{
		IDLE,
		LOAD
	} istate_t;


	icacheframe_t frames [15:0], next_frame;
	icachef_t     iaddr_in;
	istate_t      state, next_state;
	logic         miss, index[15:0];
// OUTPUTS
	assign icif.hit      = (frames[index].valid) && (iaddr_in.tag == frames[index].tag);
	assign icif.imemload = frame[index].data; 

//  Internals
	assign iaddr_in = icif.iaddr;
	assign miss     = !icif.ihit;
	assign index    = iaddr_in.idx;

//  UPDATE REGISTERS
	always_ff @ (posedge CLK negedge nRST) begin 
		if(!nRST) begin
			frames <= '{default:'0};
			state  <= IDLE;
		end
		else begin 
			frame[index] <= next_frame;
			state <= next_state;
		end
	end // end always_ff

//  NEXT_STATE_LOGIC
	always_comb begin
		next_state = state;
		next_frame = frame[index];
		icif.iREN = 0;
		casez(state)
			IDLE: begin
				icif.iREN = 0;
				if (miss) begin
					next_state = LOAD;
					next_frame.valid = 0;
					icif.iREN = 1;
				end
			end
			LOAD: begin
				icif.iREN = 1;
				if (!icif.iwait) begin
					next_state = IDLE;
					next_frame.tag  = iaddr_in.tag;
					next_frame.data = icif.iload;
					next_frame.valid = 1;
				end

			end
		endcase
	end // end always_comb
endmodule // icache