/*
  Eric Villasenor
  evillase@gmail.com

  this block is the coherence protocol
  and artibtration for ram
*/

// interface include
`include "cache_control_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module coherence_control (
  input CLK, nRST,
  cache_control_if ccif
);
  // type import
  import cpu_types_pkg::*;

  // number of cpus for cc
  parameter CPUS = 2;

/*
  modport cc (
            // cache inputs
    input   iREN, dREN, dWEN, dstore, iaddr, daddr,
            // ram inputs
            ramload, ramstate,
            // coherence inputs from cache
            ccwrite, cctrans, ccwrite = writing, cctrans = miss
            // cache outputs
    output  iwait, dwait, iload, dload,
            // ram outputs
            ramstore, ramaddr, ramWEN, ramREN,
            // coherence outputs to cache
            ccwait, ccinv, ccccsnoopaddr
  );
*/

/*
The coherence control must run through the following operations:

First, it decides on a memory request to work on from one of the two caches. 
Then, it will take the memory request and send the snoop address to the other cache. 
Once the other cache does the coherence operation, either write back or invalidate, 
the coherence control lets the requesting cache block continue with the original memory request.


write: 0 , trans: 0 --> Do nothing
write: 0,  trans: 1 --> BusRd
write: 1,  trans: 0 --> Do nothing
write: 1,  trans: 1 --> BusRdx

// write: Implies that the ccsnoopaddr is available in the requestee cache

*/

typedef enum logic [3:0] {IDLE, LOAD_0, LOAD_1, 
                          WRITE_BACK_0, WRITE_BACK_1,
                          INVALIDATE_0, INVALIDATE_1,
                          SNOOP} coherence_state_t;

coherence_state_t state, next_state;

logic select; // selects which cache's arbitration signals to send

logic requestor, next_requestor, receiever, writer, next_writer;
logic snoop_hit;
logic int_wait;

/****************************************************************************************************************************
//                                            COHERENCE
/***************************************************************************************************************************/

always_ff @ (posedge CLK, negedge nRST) begin
  if (!nRST) begin state <= IDLE; requestor <= 0; end
  else       begin 
    state     <= next_state; 
    requestor <= next_requestor; 
    writer    <= next_writer;
  end

end // end always_ff

// Internals
assign receiever = !requestor;
assign snoop_hit  = ccif.ccwrite[receiever];
assign int_wait = ~((ccif.ramstate == ACCESS) && (ccif.dREN[requestor]||ccif.dWEN[writer]));

// Coherence combinational logic
assign ccif.ccsnoopaddr[0] = ccif.daddr[1];
assign ccif.ccsnoopaddr[1] = ccif.daddr[0];

always_comb begin
  next_state     = state;
  next_requestor = requestor;
  next_writer    = writer;
  ccif.dwait[0]  = 1;
  ccif.dwait[1]  = 1;
  ccif.ccwait[0]   = 0;
  ccif.ccwait[1]   = 0;
  ccif.ccinv[0]    = 0;
  ccif.ccinv[1]    = 0;
  casez(state)
    IDLE: begin // NEED TO ARBITRATE!      
      if      (ccif.dREN[0] && ccif.cctrans[0]) begin next_state = SNOOP;        next_requestor = 0; end
      else if (ccif.dREN[1] && ccif.cctrans[1]) begin next_state = SNOOP;        next_requestor = 1; end
      else if (ccif.dWEN[0] && ccif.cctrans[0]) begin next_state = WRITE_BACK_0; next_requestor = 0; end
      else if (ccif.dWEN[1] && ccif.cctrans[1]) begin next_state = WRITE_BACK_0; next_requestor = 1; end
      else if (ccif.cctrans[0])              begin next_state = INVALIDATE_0; next_requestor = 0; end// clean hit on cache 0
      else if (ccif.cctrans[1])              begin next_state = INVALIDATE_0; next_requestor = 1; end// clean hit on cache 1
      next_writer = next_requestor;
    end
    SNOOP: begin
           ccif.ccwait[receiever] =  1;
           next_state           = LOAD_0;
    end
    LOAD_0: begin

      if(snoop_hit) begin 
        ccif.ccwait[receiever] = 1;
        ccif.dwait[requestor] = 0; 
        ccif.dload[requestor] = ccif.dstore[receiever];
        next_state = LOAD_1;
      end
      else begin
        ccif.ramREN = 1; ccif.ramaddr = ccif.daddr[requestor]; ccif.dload[requestor]=ccif.ramload;
        ccif.dwait[requestor] = int_wait;
        if (!ccif.dwait[requestor]) next_state = LOAD_1;            
      end
    end
    LOAD_1: begin
      if(snoop_hit) begin 
        ccif.ccwait[receiever] = 1;
        ccif.dwait[requestor] = 0; 
        ccif.dload[requestor] = ccif.dstore[receiever];
        next_state = WRITE_BACK_0; next_writer = receiever;
      end
      else begin          
        ccif.ramREN = 1; ccif.ramaddr = ccif.daddr[requestor]; ccif.dload[requestor]=ccif.ramload;
        ccif.dwait[requestor] = int_wait;       
        if (!ccif.dwait[requestor]) next_state = IDLE;
      end
    end
    WRITE_BACK_0: begin
      ccif.ccwait[writer] = 1;
      ccif.ramWEN = 1; ccif.ramaddr = {ccif.daddr[writer]}; ccif.ramstore[writer]=ccif.ramload;
      ccif.dwait[writer] = int_wait;
      if (!ccif.dwait[writer]) next_state = WRITE_BACK_1;
    end
    WRITE_BACK_1: begin
      ccif.ccwait[writer] = 1;
      ccif.ramWEN = 1; ccif.ramaddr = {ccif.daddr[writer]}; ccif.ramstore[writer]=ccif.ramload;
      ccif.dwait[writer] = int_wait;   
      if (!ccif.dwait[writer]) next_state = IDLE;     
    end
    INVALIDATE_0: begin // This state is literally just to snoop lol
      ccif.ccinv[receiever] = 1;
      ccif.ccwait[receiever] = 1;
      next_state = INVALIDATE_1;
    end
    INVALIDATE_1: begin 
      ccif.ccwait[receiever] = 1;
      ccif.ccinv[receiever] = 1;
      next_state = IDLE; 
      if (ccif.ccwrite[receiever]) begin
        next_state = WRITE_BACK_0; next_writer = receiever; 
      end
    end
  endcase
end //
endmodule
