import lc3b_types::*;

/*
 * SEXT[offset-n]  (doesn't shift by 1 bit)
 */
module adj_8_zext#(parameter width = 8)
(
    input [width-1:0] in,
    output lc3b_word out
);

assign out = ({7'b0,in, 1'b0}); //zero extend trap 8 vector after shifting it to the left

endmodule : adj_8_zext