		import lc3b_types::*;
		
	module word_inserter #(parameter width = 128)
	(
		input lc3b_offset sel,	//3 bits, 8 options
		input [width-1:0] data,
		input lc3b_word new_word,
		output logic [127:0] f
	);
	
	always_comb
	begin
		if (sel == 3'b000) 		  //0
			f = {data[127:16], new_word};
		else if(sel == 3'b001) //1
			f = {data[127:32], new_word, data[15:0]};
		else if(sel == 3'b010) //2
			f ={data[127:48], new_word, data[31:0]};
		else if (sel == 3'b011) //3
			f = {data[127:64], new_word, data[47:0]};
		else if (sel == 3'b100) //4
			f = {data[127:80], new_word, data[63:0]};
		else if (sel == 3'b101) //5
			f = {data[127:96], new_word, data[79:0]};
		else if (sel == 3'b110) //6
			f = {data[127:112], new_word, data[95:0]};
		else 											//7
			f = {new_word, data[111:0]};
	end
	endmodule : word_inserter