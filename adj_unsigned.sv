import lc3b_types::*;

/*
 * SEXT[offset-n]  (doesn't shift by 1 bit)
 */
module adj_unsigned#(parameter width = 8)
(
    input [width-1:0] in,
    output lc3b_word out
);

assign out = ({in, 1'b0});

endmodule : adj_unsigned