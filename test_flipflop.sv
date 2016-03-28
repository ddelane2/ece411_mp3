import lc3b_types::*;

module test_flipflop
(
    input clk,
	 input lc3b_control_word test_in,	//comes from if/id
	 output lc3b_control_word test_out

);


always_ff @(posedge clk)
	begin
	  test_out = test_in;
	 end
 
 endmodule : test_flipflop