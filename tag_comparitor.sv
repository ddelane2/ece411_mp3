	import lc3b_types::*;
	
	module tag_comparitor #(parameter width = 10)
	(
		input lc3b_tag tag_cpu,
		input lc3b_tag tag_cache,
		output logic  tag_comp_out
	);
	
	always_comb
	begin
		if(tag_cpu == tag_cache) //AND TAG_CACHE != 0?
			tag_comp_out = 1;
		else
			tag_comp_out = 0;
	end
endmodule : tag_comparitor
	