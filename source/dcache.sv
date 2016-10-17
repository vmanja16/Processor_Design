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

module dcache(
	      // ds[1:0][7:0] #struct
	      [1:0] represents the frames
	      [7:0] represents the indices AKA sets
	      
	      // LRU [7:0] : 0 is Left (lru), 1 is Right(lru)
);
/*
ds = valid, dirty, tag, word_t data[1:0] 

 Initialiaze all valids to 0!
 
 // FROM DADDR
 assign index_in    = daddr[3:1];
 assign offset_in   = daddr[0];
 
 
assign Readmiss  = dREN_in && !dhit
assign dhit      = (tag_in == ds[0][index_in].tag || tag_in == ds[1][index_in].tag) && (ds[0][index_in].valid || ds[1][index_in].valid);
assign LRU_addr  =  {ds[LRU[index_in]][index_in].tag,ds[LRU[index_in]][index_in].index, 0}
assign LRU_word1 = ds[LRU[index_in]][index_in].data[0];
assign LRU_word2 = ds[LRU[index_in]][index_in].data[1];  
 
always_comb begin
 next_state = state; 
 
 IDLE:
  if Read_hit{LRU[index_in] = (tag.in == ds[0][index_in].tag )} // matches
  if Write_hit{next_dirty=1; next_block[offset_in] = dmemstore;} 
 
  if Readmiss & !ds[LRU[index_in]][index_in].dirty  -> LOAD_0
  if Readmiss & !ds[LRU[index_in]][index_in].dirty  -> LOAD_WB_1 
 
  if Write_Miss & LRU[Index] is clean ->
  
 LOAD_WB_1:
     Giving mem addr=LRU_addr, store=LRU_word1, dWEN
     if (!dwait){
       next_state = LOAD_WB_2
 } 
  LOAD_WB_2:
     Giving mem addr=LRU_addr+4, store=LRU_word2, dWEN
     if (!dwait){
      next_state = LOAD_0;
 } 
 
 LOAD_0:
     Giving mem daddr, a dREN
     if (!dwait){
       next_block0 = dmemload;
       next_state -> LOAD_2
     }
 LOAD_1:
     Giving mem daddr+4, a dREN
     if (!dwait){
        next_block1 = ram.load;
        next_state = IDLE:
        next_dirty = 0;
     }
 
 WRITE:
   next_block[offset_in] = dmemstore;
   next_dirty = 1;
   next_state = IDLE;
 
end // end always_comb 
 
 */ 

endmodule
