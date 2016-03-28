import lc3b_types::*;

module id_ex_flipflop
(
    input clk,
    input lc3b_word pc_plus2_in_ff,
	 input lc3b_word sr1_in_ff,
	 input lc3b_word sr2_in_ff,
	 input lc3b_reg dest_in_ff,
	 input lc3b_word adj5_in_ff,
	 input lc3b_word adj6_in_ff,
	 input lc3b_word adj9_in_ff, 
	 input lc3b_word mem_wdata_in_ff,
	 input lc3b_control_word control_id_ex_in_ff,
	 input lc3b_reg dest_id_ex_in_ff,
	 output lc3b_word pc_plus2_out_ff,
	 output lc3b_word sr1_out_ff,
	 output lc3b_word sr2_out_ff,
	 output lc3b_reg dest_out_ff,
	 output lc3b_word adj5_out_ff,
	 output lc3b_word adj6_out_ff,
	 output lc3b_word adj9_out_ff,
	 output lc3b_control_word control_id_ex_out_ff,
	 output lc3b_word mem_wdata_out_ff,
	 output logic aluothermux_sel,
	 output lc3b_reg dest_id_ex_out_ff
);


always_ff @(posedge clk)
	begin
	  pc_plus2_out_ff = pc_plus2_in_ff;
	  sr1_out_ff = sr1_in_ff;
	  sr2_out_ff = sr2_in_ff;
	  dest_out_ff = dest_in_ff;
	  adj5_out_ff = adj5_in_ff;
	  adj6_out_ff = adj6_in_ff;
	  adj9_out_ff = adj9_in_ff;
	  control_id_ex_out_ff = control_id_ex_in_ff;
	  mem_wdata_out_ff = mem_wdata_in_ff;
	  aluothermux_sel = mem_wdata_in_ff[5];
	  dest_id_ex_out_ff = dest_id_ex_in_ff;
	  

	end
	 
 endmodule : id_ex_flipflop