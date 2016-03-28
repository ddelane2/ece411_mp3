import lc3b_types::*;

module dirtybit_array #(parameter width = 1)
(
    input clk,
    input write,
    input lc3b_index index,
    input datain,
    output logic dataout
);

logic data [7:0]; // Initialize array (1 bit per line, 8 lines)

initial
begin
    for (int i = 0; i < $size(data); i++)
    begin
        data[i] = 1'b0;
    end
end

always_ff @(posedge clk)
begin
    if (write == 1)
    begin
        data[index] = datain;
    end
end

assign dataout = data[index];

endmodule : dirtybit_array