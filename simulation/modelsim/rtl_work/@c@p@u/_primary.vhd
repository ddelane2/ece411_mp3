library verilog;
use verilog.vl_types.all;
entity CPU is
    port(
        clk             : in     vl_logic;
        mem_resp_a      : in     vl_logic;
        mem_rdata_a     : in     vl_logic_vector(15 downto 0);
        mem_read_a      : out    vl_logic;
        mem_write_a     : out    vl_logic;
        mem_byte_enable_a: out    vl_logic_vector(1 downto 0);
        mem_address_a   : out    vl_logic_vector(15 downto 0);
        mem_wdata_a     : out    vl_logic_vector(15 downto 0);
        mem_resp_b      : in     vl_logic;
        mem_rdata_b     : in     vl_logic_vector(15 downto 0);
        mem_read_b      : out    vl_logic;
        mem_write_b     : out    vl_logic;
        mem_byte_enable_b: out    vl_logic_vector(1 downto 0);
        mem_address_b   : out    vl_logic_vector(15 downto 0);
        mem_wdata_b     : out    vl_logic_vector(15 downto 0)
    );
end CPU;
