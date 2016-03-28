library verilog;
use verilog.vl_types.all;
library work;
entity id_ex_flipflop is
    port(
        clk             : in     vl_logic;
        pc_plus2_in_ff  : in     vl_logic_vector(15 downto 0);
        sr1_in_ff       : in     vl_logic_vector(15 downto 0);
        sr2_in_ff       : in     vl_logic_vector(15 downto 0);
        dest_in_ff      : in     vl_logic_vector(2 downto 0);
        adj5_in_ff      : in     vl_logic_vector(15 downto 0);
        adj6_in_ff      : in     vl_logic_vector(15 downto 0);
        adj9_in_ff      : in     vl_logic_vector(15 downto 0);
        mem_wdata_in_ff : in     vl_logic_vector(15 downto 0);
        control_id_ex_in_ff: in     work.lc3b_types.lc3b_control_word;
        dest_id_ex_in_ff: in     vl_logic_vector(2 downto 0);
        pc_plus2_out_ff : out    vl_logic_vector(15 downto 0);
        sr1_out_ff      : out    vl_logic_vector(15 downto 0);
        sr2_out_ff      : out    vl_logic_vector(15 downto 0);
        dest_out_ff     : out    vl_logic_vector(2 downto 0);
        adj5_out_ff     : out    vl_logic_vector(15 downto 0);
        adj6_out_ff     : out    vl_logic_vector(15 downto 0);
        adj9_out_ff     : out    vl_logic_vector(15 downto 0);
        control_id_ex_out_ff: out    work.lc3b_types.lc3b_control_word;
        mem_wdata_out_ff: out    vl_logic_vector(15 downto 0);
        aluothermux_sel : out    vl_logic;
        dest_id_ex_out_ff: out    vl_logic_vector(2 downto 0)
    );
end id_ex_flipflop;
