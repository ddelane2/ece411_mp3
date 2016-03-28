library verilog;
use verilog.vl_types.all;
library work;
entity datapath is
    port(
        clk             : in     vl_logic;
        control_word_ctrl: in     work.lc3b_types.lc3b_control_word;
        pcmux_sel       : in     vl_logic;
        load_pc         : in     vl_logic;
        load_ir         : in     vl_logic;
        load_regfile    : in     vl_logic;
        load_mar        : in     vl_logic;
        load_mdr        : in     vl_logic;
        load_cc         : in     vl_logic;
        alumux_sel      : in     vl_logic;
        regfilemux_sel  : in     vl_logic;
        mdrmux_sel      : in     vl_logic;
        storemux_sel    : in     vl_logic;
        leamux_sel      : in     vl_logic;
        destmux_sel     : in     vl_logic;
        offsetmux_sel   : in     vl_logic;
        adj6mux_sel     : in     vl_logic;
        aluop           : in     work.lc3b_types.lc3b_aluop;
        opcode          : out    work.lc3b_types.lc3b_opcode;
        branch_enable   : out    vl_logic;
        A               : out    vl_logic;
        D               : out    vl_logic;
        mem_rdata_a     : in     vl_logic_vector(15 downto 0);
        mem_address_a   : out    vl_logic_vector(15 downto 0);
        mem_wdata_a     : out    vl_logic_vector(15 downto 0);
        mem_rdata_b     : in     vl_logic_vector(15 downto 0);
        mem_address_b   : out    vl_logic_vector(15 downto 0);
        mem_wdata_b     : out    vl_logic_vector(15 downto 0);
        instruction     : out    vl_logic_vector(15 downto 0)
    );
end datapath;
