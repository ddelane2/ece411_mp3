import lc3b_types::*;

module mem_wb_flipflop
(
    input clk,
    input lc3b_word mem_address_in_ff,
	 input lc3b_word mem_wdata_in_ff,
	 input lc3b_control_word control_mem_wb_in_ff,
	 input lc3b_reg dest_mem_wb_in_ff,
	 output lc3b_word mem_address_mem_wb_ff,
	 output lc3b_word mem_wdata_mem_wb_ff,
	 output lc3b_control_word control_mem_wb_out_ff,
	 output lc3b_reg dest_mem_wb_out_ff
);


always_ff @(posedge clk)
	begin
		mem_address_mem_wb_ff = mem_address_in_ff;
		mem_wdata_mem_wb_ff = mem_wdata_in_ff;
		control_mem_wb_out_ff = control_mem_wb_in_ff;
		dest_mem_wb_out_ff = dest_mem_wb_in_ff;
	  
	end
	 
 endmodule : mem_wb_flipflop