	import lc3b_types::*;
	
	module nzpcomp #(parameter width = 16)
	(
		input lc3b_nzp nzp,
		input lc3b_reg nzp_other,
		output logic  br_en
	);
	
	always_comb
	begin
		//if (((nzp & 3'b001) && (comp_num & 3'b001)) || ((nzp & 3'b010) && (comp_num & 3'b010)) || ((nzp & 3'1b00) && (comp_num & 3'b100))) 
		//if (((nzp & 1) && (comp_num & 1)) || ((nzp & 2) && (comp_num & 2)) || ((nzp & 4) && (comp_num & 4))) 
		if((nzp[2] && nzp_other[2]) || (nzp[1] && nzp_other[1]) || (nzp[0] && nzp_other[0]))
			br_en = 1;
		else
			br_en = 0;
	end
endmodule : nzpcomp
	
	
	
			