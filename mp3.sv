import lc3b_types::*;

module mp3
(
    input clk,

    /* Memory signals */
    input pmem_resp_a,
    //input [127:0] pmem_rdata_a,
	 input [15:0] pmem_rdata_a,
    output pmem_read_a,
    output pmem_write_a,
    output lc3b_word pmem_address_a,
    //output [127:0] pmem_wdata_a,
	 output [15:0] pmem_wdata_a,
	 output [1:0] pmem_mask_a,		//***
	 
	 input pmem_resp_b,
    //input [127:0] pmem_rdata_b,
	 input [15:0] pmem_rdata_b,
    output pmem_read_b,
    output pmem_write_b,
    output lc3b_word pmem_address_b,
    //output [127:0] pmem_wdata_b,
	 output [15:0] pmem_wdata_b,
	 output [1:0] pmem_mask_b
	 
);
//**********************************************
/* Internal Signals */
lc3b_mem_wmask mem_byte_enable_a, mem_byte_enable_b;
logic mem_read, mem_write;
lc3b_word mem_address, mem_wdata, mem_rdata;
logic mem_resp;

/* Top Level Blocks */

//cache cache_unit
//(
//   .clk,
//
//    //Signals between CPU and Cache
//   .mem_read(mem_read), 
//	.mem_write(mem_write),								//read/write signals
//	.mem_byte_enable(mem_byte_enable), 				//mask saying which byte(s) to write to
//	.mem_address(mem_address),			//address from cpu
//   .mem_wdata(mem_wdata),  				//data from data bus to cache
//	.mem_rdata(mem_rdata),				//data from cache to data bus
//	.mem_resp(mem_resp),
//	
//	//Signals between Cache and Main Memory
//	.pmem_resp(pmem_resp),										//signal indicating physical memory has finished operation
//	.pmem_rdata(pmem_rdata),									//data read from memory
//	.pmem_wdata(pmem_wdata),									//data to be written to memory
//	.pmem_read(pmem_read),										//read signal (to memory)
//	.pmem_write(pmem_write),						 			//write signal (to memory)
//	.pmem_address(pmem_address)								//address for memory
//
//);

CPU CPU_unit
(
    .clk,
    /* Memory signals */
    .mem_resp_a(pmem_resp_a),
    .mem_rdata_a(pmem_rdata_a),
    .mem_read_a(pmem_read_a),
    .mem_write_a(pmem_write_a),
    .mem_byte_enable_a(mem_byte_enable_a),
    .mem_address_a(pmem_address_a),
    .mem_wdata_a(pmem_wdata_a),
	 
	 .mem_resp_b(pmem_resp_b),
    .mem_rdata_b(pmem_rdata_b),
    .mem_read_b(pmem_read_b),
    .mem_write_b(pmem_write_b),
    .mem_byte_enable_b(mem_byte_enable_b),
    .mem_address_b(pmem_address_b),
    .mem_wdata_b(pmem_wdata_b)

);

//
//CPU CPU_unit
//(
//    .clk,
//    /* Memory signals */
//    .mem_resp(mem_resp),
//    .mem_rdata(mem_rdata),
//    .mem_read(mem_read),
//    .mem_write(mem_write),
//    .mem_byte_enable(mem_byte_enable),
//    .mem_address(mem_address),
//    .mem_wdata(mem_wdata)
//
//);


endmodule : mp3
