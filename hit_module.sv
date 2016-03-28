	module hit_module #(parameter width = 1)
	(
		input valid_bit0, valid_bit1, tag_comp0, tag_comp1, LRU_bit,
		output logic hit, hit_select_DAmux
	);

	always_comb
	begin
		//set datamux out select
		if(valid_bit0 && tag_comp0)		//hits
			hit_select_DAmux = 1'b0;
		else if(valid_bit1 && tag_comp1)
			hit_select_DAmux = 1'b1;
		else if(LRU_bit == 1'b0)				//misses
			hit_select_DAmux = 1'b0;
		else 
			hit_select_DAmux = 1'b1;
		
		//check for hit
		if (valid_bit0 && tag_comp0 || valid_bit1 && tag_comp1) 
			hit = 1'b1;
		else
			hit = 1'b0;
	end
	endmodule : hit_module