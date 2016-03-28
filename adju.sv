import lc3b_types::*;

/*
 * SEXT[offset-n]  (doesn't shift by 1 bit)
 */
module adj_u #(parameter width = 8)
(
    input [width-1:0] in,
    output lc3b_word out
);

assign out = $signed(in);

endmodule : adj_u
