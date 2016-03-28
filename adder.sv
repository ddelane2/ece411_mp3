	import lc3b_types::*;
	
	module adder #(parameter width = 16)
	(
		input lc3b_word sr1, sr2, 
		output lc3b_word sum
	);
	
		assign	sum = sr1 + sr2;

	endmodule : adder