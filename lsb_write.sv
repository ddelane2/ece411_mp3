	import lc3b_types::*;
	
	module lsb_write #(parameter width = 16)
	(
		input lsb,
		input lc3b_word in, 
		output lc3b_word out
	);
	
	always_comb
		begin
	
		if(lsb == 1'b0)
			out = {8'b0, in[15:8]};
		else	
			out = {8'b0, in[7:0]};
			
	end
	
endmodule : lsb_write