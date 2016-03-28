import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module cache_control
(

	input clk,
	
	//Memory Signals
	input pmem_resp,
	input [1:0] mem_byte_enable,
	output logic pmem_read, pmem_write, 		
	output logic [127:0] pmem_wdata,
	output lc3b_word mem_rdata,
	
	//CPU signals
	input mem_read, mem_write,
	
	//Datapath signals
	input hit, tag_comp_out0, tag_comp_out1, LRU_out, validbit_out0, validbit_out1, dirtybit_out0, dirtybit_out1,
	input lc3b_word word_sel_out,
	input [127:0] dataarray_muxout,
	output logic DA_mux_out_sel, DA_mux_in_sel0, DA_mux_in_sel1, writemux_sel,	 //mux selects
	output logic [1:0] address_mux_sel,
	output logic validbit_write0, validbit_write1, dirtybit_write0, dirtybit_write1, LRU_write, DA_write0, DA_write1, tag_write0, tag_write1,
	output logic validbit_in0, validbit_in1, dirtybit_in0, dirtybit_in1, LRU_in, mem_resp
	
);

enum int unsigned {
	/*List of States*/
	idle_hit,
	read_miss1,
	read_miss2,
	write_miss1,
	write_miss2
} state, next_state;

always_comb
	begin : state_actions
		/* Default assignments */
		pmem_read = 1'b0;
		pmem_write = 1'b0;
		validbit_write0 = 1'b0;
		validbit_write1 = 1'b0;
		dirtybit_write0 = 1'b0;
		dirtybit_write1 = 1'b0;
		tag_write0 = 1'b0;
		tag_write1 = 1'b0;
		DA_write0 = 1'b0;
		DA_write1 = 1'b0;
		validbit_in0 = 1'b1;
		validbit_in1 = 1'b1;
		dirtybit_in0 = 1'b1;
		dirtybit_in1 = 1'b1;
		LRU_in = 1'b0;
		LRU_write = 1'b0;
		DA_mux_out_sel = 1'b0;
		DA_mux_in_sel0 = 1'b0;
		DA_mux_in_sel1 = 1'b0;
		writemux_sel = 1'b0;
		address_mux_sel = 2'b00;
		mem_resp =  1'b0;
		mem_rdata = 16'b0;
		pmem_wdata = 128'b0;
		
		
		case(state)
		
			idle_hit: begin
			if(hit && mem_read)	//HIT READ
					begin
					if(tag_comp_out0 == 1'b1 && validbit_out0 == 1'b1)			//hit at array 0 
						LRU_in = 1'b1;
						
					else if(tag_comp_out1 == 1'b1 && validbit_out1 == 1'b1)	//hit at array 1 
						LRU_in = 1'b0;
						
					LRU_write = 1'b1;						//update LRU array
					mem_rdata = word_sel_out;
					mem_resp = 1'b1;
					end
					
			else if(hit && mem_write && (mem_byte_enable != 2'b0))  //HIT WRITE
					begin
					if(tag_comp_out0 == 1'b1 && validbit_out0 == 1'b1)			//hit at array 0 
						begin
						LRU_in = 1'b1;						//update LRU 
						dirtybit_write0 = 1'b1;			//update dirty bit array
						DA_mux_in_sel0 = 1'b1;
						DA_write0 = 1'b1;				//write new 128 bits into array
						end
						
					else if(tag_comp_out1 == 1'b1 && validbit_out1 == 1'b1)	//hit at array 1
						begin	
						LRU_in = 1'b0;						
						dirtybit_write1 = 1'b1;
						DA_mux_in_sel1 = 1'b1;
						DA_write1 = 1'b1;				
						end
							
					LRU_write = 1'b1;						//update LRU array
					mem_resp = 1'b1;
					end
					
			else
				DA_mux_out_sel = 1'b0;		//do nothing if no hit
				
		end
		
			read_miss1: begin	//read from memory into cache
				pmem_read = 1'b1;
				if(LRU_out == 1'b0)
					begin
					if(mem_read)
						DA_write0 = 1'b1;
					validbit_write0 = 1'b1;
					tag_write0 = 1'b1;
					DA_mux_out_sel = 1'b0;		//not used
					end
				else
					begin
					if(mem_read)
						DA_write1 = 1'b1;
					validbit_write1 = 1'b1;
					tag_write1 = 1'b1;
					DA_mux_out_sel = 1'b1;		//not used
					end
			end
			
			read_miss2: begin		//update data, tag, valid bit arrays
					if(LRU_out == 1'b0)
						begin
						LRU_in = 1'b1;
						dirtybit_in0 = 1'b0;
						dirtybit_write0 = 1'b1;
						end
					else if(LRU_out == 1'b1)
						begin
						dirtybit_in1 = 1'b0;
						dirtybit_write1 = 1'b1;
						end
					LRU_write = 1'b1;
					mem_rdata = word_sel_out;
					mem_resp = 1'b1;
			end
			
			write_miss1: begin	//write to memory
				if(LRU_out == 1'b0 && dirtybit_out0 == 1'b1)					//evict cache 0
						begin
						address_mux_sel = 2'b01;
						pmem_wdata = dataarray_muxout;
						pmem_write = 1'b1;
						end
				else if(LRU_out == 1'b1 && dirtybit_out1 == 1'b1)		//evict cache 1
						begin
						address_mux_sel = 2'b10;
						pmem_wdata = dataarray_muxout;
						pmem_write = 1'b1;
						end	
			end
			
//			write_miss2: begin	//take word data from pmemory, insert word, and put into cache
//				pmem_read = 1'b1;	
//				if(LRU_out == 1'b0)
//					begin
//					LRU_in = 1'b1;
//					validbit_write0 = 1'b1;
//					dirtybit_write0 = 1'b1;
//					tag_write0 = 1'b1;
//					DA_mux_in_sel0 = 1'b1;	//choose array input to updated 128 bits
//					DA_write0 = 1'b1;
//					end
//				else if(LRU_out == 1'b1)
//					begin
//					validbit_write1 = 1'b1;
//					dirtybit_write1 = 1'b1;
//					tag_write1 = 1'b1;
//					DA_mux_in_sel1 = 1'b1;	//choose array input to updated 128 bits
//					DA_write1 = 1'b1;
//					end
//				LRU_write = 1'b1;
//				writemux_sel = 1'b1;
//				mem_resp = 1'b1;
//			end
			
			write_miss2: begin	//take word data from pmemory, insert word, and put into cache
			if(LRU_out == 1'b0)
				begin
				LRU_in = 1'b1;
				DA_mux_in_sel0 = 1'b1;
				DA_write0 = 1'b1;	
				dirtybit_write0 = 1'b1;
				validbit_write0 = 1'b1;
				tag_write0 = 1'b1;
				end
			else
				begin
				LRU_in = 1'b0;
				DA_mux_in_sel1 = 1'b1;
				DA_write1 = 1'b1;	
				dirtybit_write1 = 1'b1;
				validbit_write1 = 1'b1;
				tag_write1 = 1'b1;
				end
				
			LRU_write = 1'b1;
			writemux_sel = 1'b1;
			mem_resp = 1'b1;
			end
			
			default: ;
			
		endcase
	end
	
	
always_comb												 /* Next state information and conditions (if any) for transitioning between states */

	begin : next_state_logic
		
		  case(state)
		  
			idle_hit: begin
				if(mem_read && hit == 1'b0)
					next_state = read_miss1;
				else if(mem_write && hit == 1'b0 && mem_byte_enable != 2'b0)
					next_state = write_miss1;
				else
					next_state = idle_hit;
			end
			
			read_miss1: begin
				if(pmem_resp == 1'b1 && mem_read == 1'b1)			//wait for mem_resp signal
					next_state = read_miss2;
				else if(pmem_resp == 1'b1 && mem_write == 1'b1)
					next_state = write_miss2;
				else
					next_state = read_miss1;
			end
			
			read_miss2: begin
				next_state = idle_hit;
			end
		
			write_miss1: begin
				if((LRU_out == 1'b0 && dirtybit_out0 == 1'b1) || (LRU_out == 1'b1 && dirtybit_out1 == 1'b1))	//if we are writing to physical memory
					begin
					if(pmem_resp == 1'b1)
						next_state = read_miss1;
					else
						next_state = write_miss1;
					end
				else																//not writing to physical memory
					next_state = read_miss1;
			end
		
			write_miss2: begin
					next_state = idle_hit;
			end
		
		
	default: next_state = idle_hit;	//do nothing
				
		endcase
end	
		
		
		
		
always_ff @(posedge clk)
	begin: next_state_assignment
		 state <= next_state;
	end

		
endmodule : cache_control
		