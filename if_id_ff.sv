import lc3b_types::*;

	 
module if_id_flipflop
(
    input clk,
    input lc3b_word pc_plus2_in_ff,
	 input lc3b_control_word control_if_id_in_ff,	//comes from control
	 input lc3b_word mem_rdata_in_ff,
	 output lc3b_word pc_plus2_out_ff,
	 output lc3b_control_word control_if_id_out_ff,
	 output lc3b_word mem_rdata_out_ff,
	 
	 output logic A, D,
    output lc3b_opcode opcode,
    output lc3b_reg dest, src1, src2,
    output lc3b_offset6 offset6,
    output lc3b_offset9 offset9,
	 output lc3b_word instruction
);


always_ff @(posedge clk)
	begin
	  pc_plus2_out_ff = pc_plus2_in_ff;
	  control_if_id_out_ff = control_if_id_in_ff;
	  mem_rdata_out_ff = mem_rdata_in_ff;
	  
	 opcode = lc3b_opcode'(mem_rdata_in_ff[15:12]);
    dest = mem_rdata_in_ff[11:9];
    src1 = mem_rdata_in_ff[8:6];
    src2 = mem_rdata_in_ff[2:0];
    offset6 = mem_rdata_in_ff[5:0];
    offset9 = mem_rdata_in_ff[8:0];
	 instruction = mem_rdata_in_ff;
	 A = mem_rdata_in_ff[5];
	 D = mem_rdata_in_ff[4];
	 
	 end
 
 endmodule : if_id_flipflop