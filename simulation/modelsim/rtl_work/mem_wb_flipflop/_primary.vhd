library verilog;
use verilog.vl_types.all;
library work;
entity mem_wb_flipflop is
    port(
        clk             : in     vl_logic;
        mem_address_in_ff: in     vl_logic_vector(15 downto 0);
        mem_wdata_in_ff : in     vl_logic_vector(15 downto 0);
        control_mem_wb_in_ff: in     work.lc3b_types.lc3b_control_word;
        dest_mem_wb_in_ff: in     vl_logic_vector(2 downto 0);
        mem_address_mem_wb_ff: out    vl_logic_vector(15 downto 0);
        mem_wdata_mem_wb_ff: out    vl_logic_vector(15 downto 0);
        control_mem_wb_out_ff: out    work.lc3b_types.lc3b_control_word;
        dest_mem_wb_out_ff: out    vl_logic_vector(2 downto 0)
    );
end mem_wb_flipflop;
