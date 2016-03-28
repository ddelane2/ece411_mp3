library verilog;
use verilog.vl_types.all;
library work;
entity ex_mem_flipflop is
    port(
        clk             : in     vl_logic;
        adder_in_ff     : in     vl_logic_vector(15 downto 0);
        alu_in_ff       : in     vl_logic_vector(15 downto 0);
        control_ex_mem_in_ff: in     work.lc3b_types.lc3b_control_word;
        dest_ex_mem_in_ff: in     vl_logic_vector(2 downto 0);
        branch_enable   : in     vl_logic;
        adder_out_ff    : out    vl_logic_vector(15 downto 0);
        alu_out_ff      : out    vl_logic_vector(15 downto 0);
        control_ex_mem_out_ff: out    work.lc3b_types.lc3b_control_word;
        mem_read_ex_mem : out    vl_logic;
        mem_write_ex_mem: out    vl_logic;
        dest_ex_mem_out_ff: out    vl_logic_vector(2 downto 0)
    );
end ex_mem_flipflop;
