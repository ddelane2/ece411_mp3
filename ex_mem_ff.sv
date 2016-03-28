import lc3b_types::*;

module ex_mem_flipflop
(
    input clk,
    input lc3b_word adder_in_ff,
	 input lc3b_word alu_in_ff,
	 input lc3b_control_word control_ex_mem_in_ff,
	 input lc3b_reg dest_ex_mem_in_ff,
	 input branch_enable,
	 output lc3b_word adder_out_ff,
	 output lc3b_word alu_out_ff,
	 output lc3b_control_word control_ex_mem_out_ff,
	 output logic mem_read_ex_mem,
	 output logic mem_write_ex_mem,
	 output lc3b_reg dest_ex_mem_out_ff

);


always_ff @(posedge clk)
	begin
	  adder_out_ff = adder_in_ff;
	  alu_out_ff = alu_in_ff;
	  control_ex_mem_out_ff = control_ex_mem_in_ff;
	  mem_read_ex_mem = control_ex_mem_in_ff.mem_read;
	  mem_write_ex_mem = control_ex_mem_in_ff.mem_write;
	  dest_ex_mem_out_ff = dest_ex_mem_in_ff;
//	  if(branch_enable && control_ex_mem_in_ff.opcode == op_br)
//			control_ex_mem_out_ff.pcmux_sel = 1'b1;
//		else
//			control_ex_mem_out_ff.pcmux_sel = 1'b0;
			

		
	end
	 
 endmodule : ex_mem_flipflop