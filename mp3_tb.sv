module mp3_tb;

timeunit 1ns;
timeprecision 1ns;

logic clk;

//memory A
logic pmem_resp_a;
logic pmem_read_a;
logic pmem_write_a;
logic [15:0] pmem_address_a;
logic [15:0] pmem_rdata_a;
logic [15:0] pmem_wdata_a;
logic [1:0] pmem_mask_a;

//memory B
logic pmem_resp_b;
logic pmem_read_b;
logic pmem_write_b;
logic [15:0] pmem_address_b;
logic [15:0] pmem_rdata_b;
logic [15:0] pmem_wdata_b;
logic [1:0] pmem_mask_b;

/* Clock generator */
initial clk = 0;
always #5 clk = ~clk;

mp3 dut
(
    .clk,
	 //memory A
    .pmem_resp_a,
    .pmem_rdata_a,
    .pmem_read_a,
    .pmem_write_a,
    .pmem_address_a,
    .pmem_wdata_a,
	 .pmem_mask_a,
	 
	 //memory B
	 .pmem_resp_b,
    .pmem_rdata_b,
    .pmem_read_b,
    .pmem_write_b,
    .pmem_address_b,
    .pmem_wdata_b,
	 .pmem_mask_b
);

magic_memory_dp magic_memory_dp
(
     .clk,

    /* Port A */
    .read_a(pmem_resp_a),
    .write_a(pmem_write_a),
    .wmask_a(pmem_mask_a),
    .address_a(pmem_address_a),
    .wdata_a(pmem_wdata_a),
    .resp_a(pmem_resp_a),
    .rdata_a(pmem_rdata_a),

    /* Port B */
    .read_b(pmem_resp_b),
    .write_b(pmem_write_b),
    .wmask_b(pmem_mask_b),
    .address_b(pmem_address_b),
    .wdata_b(pmem_wdata_b),
    .resp_b(pmem_resp_b),
    .rdata_b(pmem_rdata_b)
);

//	physical_memory memory
//	(
//		 .clk,
//		 .read(pmem_read),
//		 .write(pmem_write),
//		 .address(pmem_address),
//		 .wdata(pmem_wdata),
//		 .resp(pmem_resp),
//		 .rdata(pmem_rdata)
//	);

endmodule : mp3_tb
