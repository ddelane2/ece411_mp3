	module mux8 #(parameter width = 128)
	(
		input lc3b_offset sel,	//3 bits, 8 options
		input [width-1:0] in,
		output logic lc3b_word f
	);
	
	always_comb
	begin
		if (sel == 2'b000) //0
			f = in[15:0];
		else if(sel == 2'b001) //1
			f = in[31:16];
		else if(sel == 2'b010) //2
			f = in[47:32];
		else if (sel == 2'b011) //3
			f = in[63:48];
		else if (sel == 2'b100) //4
			f = in[79:64];
		else if (sel == 2'b101) //5
			f = in[95:80];
		else if (sel == 2'b110) //6
			f = in[111:96];
		else 										//7
			f = in[127:112];
	end
	endmodule : mux8