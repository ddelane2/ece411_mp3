	import lc3b_types::*;
	
	module decoder #(parameter width = 16)
	(
		input lc3b_word address, 
		output lc3b_tag tag,
		output lc3b_index index,
		output lc3b_offset offset
	);
	
		assign	tag = address[15:7];
		assign index = address[6:4];
		assign offset = address[3:1];

endmodule : decoder

