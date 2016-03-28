library verilog;
use verilog.vl_types.all;
library work;
entity if_id_flipflop is
    port(
        clk             : in     vl_logic;
        pc_plus2_in_ff  : in     vl_logic_vector(15 downto 0);
        control_if_id_in_ff: in     work.lc3b_types.lc3b_control_word;
        mem_rdata_in_ff : in     vl_logic_vector(15 downto 0);
        pc_plus2_out_ff : out    vl_logic_vector(15 downto 0);
        control_if_id_out_ff: out    work.lc3b_types.lc3b_control_word;
        mem_rdata_out_ff: out    vl_logic_vector(15 downto 0);
        A               : out    vl_logic;
        D               : out    vl_logic;
        opcode          : out    work.lc3b_types.lc3b_opcode;
        dest            : out    vl_logic_vector(2 downto 0);
        src1            : out    vl_logic_vector(2 downto 0);
        src2            : out    vl_logic_vector(2 downto 0);
        offset6         : out    vl_logic_vector(5 downto 0);
        offset9         : out    vl_logic_vector(8 downto 0);
        instruction     : out    vl_logic_vector(15 downto 0)
    );
end if_id_flipflop;
