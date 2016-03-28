import lc3b_types::*;

module cache
(
    input clk,

    //Signals between CPU and Cache
   input mem_read, mem_write,								//read/write signals
	input [1:0] mem_byte_enable, 				//mask saying which byte(s) to write to
	input lc3b_word mem_address,			//address from cpu
   input lc3b_word mem_wdata,  				//data from data bus to cache
	output lc3b_word mem_rdata,				//data from cache to data bus
	output logic mem_resp,
	
	//Signals between Cache and Main Memory
	input pmem_resp,										//signal indicating physical memory has finished operation
	input [127:0] pmem_rdata,				//data read from memory
	output [127:0] pmem_wdata,			//data to be written to memory
	output logic pmem_read,										//read signal (to memory)
	output logic pmem_write,						 			//write signal (to memory)
	output lc3b_word pmem_address		//address for memory
);
//**********************************************
/* Internal Signals */
logic hit, tag_comp_out0, tag_comp_out1, LRU_out, validbit_out0, validbit_out1, dirtybit_out0, dirtybit_out1;
logic DA_mux_out_sel, DA_mux_in_sel0, DA_mux_in_sel1, writemux_sel;	 //mux selects
logic [1:0] address_mux_sel;
logic validbit_write0, validbit_write1, dirtybit_write0, dirtybit_write1, LRU_write, DA_write0, DA_write1, tag_write0, tag_write1;
logic validbit_in0, validbit_in1, dirtybit_in0, dirtybit_in1, LRU_in;
logic [127:0] dataarray_muxout;
lc3b_word word_sel_out;
	
	
cache_datapath cache_unit
(
	.clk,
	
	//Signals between CPU and Cache
	.mem_read(mem_read),											//read signal
	.mem_write(mem_write),										//write signal
	.mem_byte_enable(mem_byte_enable), 			//mask saying which byte(s) to write to
	.mem_address(mem_address),							//address from cpu
   .mem_wdata(mem_wdata),  									//data from data bus to cache
	//.mem_rdata(mem_rdata),										//data from cache to data bus

	//Signals between Cache and Main Memory
	.pmem_rdata(pmem_rdata),									//data read from memory
	//.pmem_wdata(pmem_wdata),								//data to be written to memory
	.pmem_address(pmem_address),						//address for memory
	
	//Signals to/from Control
	.DA_mux_out_sel(DA_mux_out_sel), 
	.DA_mux_in_sel0(DA_mux_in_sel0), 
	.DA_mux_in_sel1(DA_mux_in_sel1), 
	.address_mux_sel(address_mux_sel), 	
	.writemux_sel(writemux_sel),
	.validbit_write0(validbit_write0), 
	.validbit_write1(validbit_write1), 
	.dirtybit_write0(dirtybit_write0), 
	.dirtybit_write1(dirtybit_write1), 
	.LRU_write(LRU_write), 
	.DA_write0(DA_write0), 
	.DA_write1(DA_write1), 
	.tag_write0(tag_write0), 
	.tag_write1(tag_write1),
	.validbit_in0(validbit_in0), 
	.validbit_in1(validbit_in1), 
	.dirtybit_in0(dirtybit_in0), 
	.dirtybit_in1(dirtybit_in1),
	.LRU_in(LRU_in),
	.hit(hit), 
	.tag_comp_out0(tag_comp_out0), 
	.tag_comp_out1(tag_comp_out1),	
	.LRU_out(LRU_out),
	.validbit_out0(validbit_out0),
	.validbit_out1(validbit_out1),
	.dirtybit_out0(dirtybit_out0),
	.dirtybit_out1(dirtybit_out1),
	.word_sel_out(word_sel_out),
	.dataarray_muxout(dataarray_muxout)
);

cache_control control_unit
( 
	.clk,
	
	//Memory Signals
	.pmem_resp(pmem_resp),
	.pmem_read(pmem_read), 
	.pmem_write(pmem_write), 		
	.pmem_wdata(pmem_wdata),	
	
	
	//CPU signals
	.mem_read(mem_read), 
	.mem_write(mem_write),
	
	//Datapath signals
	.hit(hit), 
	.tag_comp_out0(tag_comp_out0), 
	.tag_comp_out1(tag_comp_out1), 
	.validbit_out0(validbit_out0),
	.validbit_out1(validbit_out1),
	.dirtybit_out0(dirtybit_out0),
	.dirtybit_out1(dirtybit_out1),
	.LRU_out(LRU_out), 
	.DA_mux_out_sel(DA_mux_out_sel), 
	.DA_mux_in_sel0(DA_mux_in_sel0), 
	.DA_mux_in_sel1(DA_mux_in_sel1), 
	.address_mux_sel(address_mux_sel),
	.writemux_sel(writemux_sel),
	.validbit_write0(validbit_write0), 
	.validbit_write1(validbit_write1), 
	.dirtybit_write0(dirtybit_write0), 
	.dirtybit_write1(dirtybit_write1), 
	.LRU_write(LRU_write), 
	.DA_write0(DA_write0), 
	.DA_write1(DA_write1), 
	.tag_write0(tag_write0), 
	.tag_write1(tag_write1),
	.validbit_in0(validbit_in0), 
	.validbit_in1(validbit_in1), 
	.dirtybit_in0(dirtybit_in0), 
	.dirtybit_in1(dirtybit_in1), 
	.LRU_in(LRU_in),
	.mem_resp(mem_resp),
	.mem_rdata(mem_rdata),
	.word_sel_out(word_sel_out),
	.mem_byte_enable(mem_byte_enable),
	.dataarray_muxout(dataarray_muxout)
);
endmodule : cache



