import lc3b_types::*;

module cache_datapath
(
	input clk,
	
	//Signals between CPU and Cache
	input mem_read,											//read signal
	input mem_write,											//write signal
	input [1:0] mem_byte_enable, 				//mask saying which byte(s) to write to
	input lc3b_word mem_address,			//address from cpu
   input lc3b_word mem_wdata,  				//data from data bus to cache
	//output lc3b_word mem_rdata,				//data from cache to data bus - using word_sel_out instead (control)

	//Signals between Cache and Main Memory
	input [127:0] pmem_rdata,				//data read from memory
	//output [127:0] pmem_wdata,			//data to be written to memory
	output lc3b_word pmem_address,		//address for memory
	
	//Signals to/from Control
	input DA_mux_out_sel, DA_mux_in_sel0, DA_mux_in_sel1, writemux_sel,	//mux selects
	input validbit_write0, validbit_write1, dirtybit_write0, dirtybit_write1, LRU_write, DA_write0, DA_write1, tag_write0, tag_write1,
	input validbit_in0, validbit_in1, dirtybit_in0, dirtybit_in1, LRU_in,
	input [1:0] address_mux_sel,
	output logic hit, tag_comp_out0, tag_comp_out1,	LRU_out, validbit_out0, validbit_out1, dirtybit_out0, dirtybit_out1,
	output lc3b_word word_sel_out,
	output [127:0] dataarray_muxout

);

//internal signals
lc3b_tag tag, tag_out0, tag_out1;
lc3b_index index;
lc3b_offset offset;	
lc3b_word word_inserter_in, mem_byte_in;		//word input to word_inserter module
logic [127:0] data_array0_out, data_array1_out; //data arrays and data mux
logic [127:0] DA_muxin_out0, DA_muxin_out1;	//input for data arrays
logic [127:0] written_data, writemux_out; //updated line from cache with written word from mem_wdata
//logic validbit_write0, validbit_write1, dirtybit_write0, dirtybit_write1, LRU_write;	//writes
//logic validbit_in0, validbit_in1, dirtybit_in0, dirtybit_in1, LRU_in;					//inputs
//logic LRU_in;
logic hit_select_DAmux;
//logic tag_comp_out0, tag_comp_out1;		//tag comparitor


//decoder
decoder decoder_unit
	(
	.address(mem_address), 
	.tag(tag),
	.index(index),
	.offset(offset)
	);

//data arrays
data_array data_array0	//create mux (size 8) to handle offset from output of data array (first 8 bits ar output 0 on mux, second 8 bits are output 1 on mux, mux select is offset, etc.)
(
    .clk,
    .write(DA_write0),	//coming from control?
    .index(index),
    .datain(DA_muxin_out0),	//ADD MUX TO DATA ARRAYS FOR INPUT. MUX INPUTS ARE DATA FROM CPU AND DATA FROM MEMORY 
    .dataout(data_array0_out)
);

data_array data_array1
(
    .clk,
    .write(DA_write1),	//coming from control?
    .index(index),
    .datain(DA_muxin_out1),	//ADD MUX TO DATA ARRAYS FOR INPUT. MUX INPUTS ARE DATA FROM CPU AND DATA FROM MEMORY 
    .dataout(data_array1_out)
);

//muxes that choose what data input into data arrays
mux2 #(.width(128)) DA_mux_in0	
(
	.sel(DA_mux_in_sel0),	
	.a(pmem_rdata),	//data from physical memory
	.b(written_data),
	.f(DA_muxin_out0)
);

mux2 #(.width(128)) DA_mux_in1	
(
	.sel(DA_mux_in_sel1),	
	.a(pmem_rdata),	//data from physical memory
	.b(written_data),
	.f(DA_muxin_out1)
);

//mux that chooses which output from the data arrays to use
mux2 #(.width(128)) dataarray_mux_out
(
	//.sel(DA_mux_out_sel),
	.sel(hit_select_DAmux),
	.a(data_array0_out),
	.b(data_array1_out),
	.f(dataarray_muxout)
);


//Word Selector - chooses a word from data array output based on offset
word_selector word_selector_unit
(
	.sel(offset),
	.in(dataarray_muxout),
	//.f(mem_rdata)
	.f(word_sel_out)
);

//valid bit arrays
bit_array validbit_array0
(
    .clk,
    .write(validbit_write0),	
    .index(index),
    .datain(validbit_in0),	
    .dataout(validbit_out0)
);

bit_array validbit_array1
(
    .clk,
    .write(validbit_write1),	
    .index(index),
    .datain(validbit_in1),	
    .dataout(validbit_out1)
);

//dirty bit arrays
bit_array dirtybit_array0
(
    .clk,
    .write(dirtybit_write0),	
    .index(index),
    .datain(dirtybit_in0),	
    .dataout(dirtybit_out0)
);

bit_array dirtybit_array1
(
    .clk,
    .write(dirtybit_write1),	
    .index(index),
    .datain(dirtybit_in1),	
    .dataout(dirtybit_out1)
);

//tag arrays
tag_array tag_array0
(
    .clk,
    .write(tag_write0),	
    .index(index),
    .datain(tag),	
    .dataout(tag_out0)
);

tag_array tag_array1
(
    .clk,
    .write(tag_write1),	
    .index(index),
    .datain(tag),	
    .dataout(tag_out1)
);

//LRU array
bit_array LRU_array
(
    .clk,
    .write(LRU_write),	
    .index(index),
    .datain(LRU_in),	
    .dataout(LRU_out)
);

////LRU mux - logic for input of the LRU array
//mux2 LRU_mux
//(
//	.sel(hit),
//	.a(LRU_out),
//	.b(tag_comp_out0),
//	.f(LRU_in)
//);

//tag comparitors
tag_comparitor  tag_comp0
	(
		.tag_cpu(tag),
		.tag_cache(tag_out0),
		.tag_comp_out(tag_comp_out0)
	);

tag_comparitor  tag_comp1
	(
		.tag_cpu(tag),
		.tag_cache(tag_out1),
		.tag_comp_out(tag_comp_out1)
	);

//hit module
hit_module hit_unit
(
	.valid_bit0(validbit_out0),
	.valid_bit1(validbit_out1),
	.tag_comp0(tag_comp_out0),
	.tag_comp1(tag_comp_out1),
	.LRU_bit(LRU_out),
	.hit(hit),
	.hit_select_DAmux(hit_select_DAmux)
);

//address mux - chooses address for main memory
mux4 address_mux
(
	.sel(address_mux_sel),
	.a({mem_address[15:4], 4'b0}),	//used for cache miss
	.b({tag_out0, mem_address[6:4], 4'b0}),								//used for writes into main memory CHANGE TO SPECIFIC TAG AND LAST BITS OF ADDRESS***
	.c({tag_out1, mem_address[6:4], 4'b0}),
	.d(16'b0),
	.f(pmem_address)								//pass this output to memory
);

mux4 byte_enable_mux
(
	.sel(mem_byte_enable),
	.a(16'b0),
	//.b({mem_byte_in[15:8], mem_wdata[7:0]}),
	.b({mem_byte_in[15:8], mem_wdata[7:0]}),
	.c({mem_wdata[15:8], mem_byte_in[7:0]}),
	.d(mem_wdata),
	.f(word_inserter_in)
);

word_inserter word_inserter_unit
	(
		.sel(offset),	
		.data(writemux_out),
		.new_word(word_inserter_in),
		.f(written_data)
	);

	mux2 #(.width(128)) writemux
(
	.sel(writemux_sel),
	.a(dataarray_muxout),
	.b(pmem_rdata),
	.f(writemux_out)
);

//chooses word to overwrite with mem_byte_enable
word_selector byte_selector_unit
(
	.sel(offset),
	.in(pmem_rdata),
	.f(mem_byte_in)
);
endmodule : cache_datapath