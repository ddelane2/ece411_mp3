library verilog;
use verilog.vl_types.all;
entity mp3 is
    port(
        clk             : in     vl_logic;
        pmem_resp_a     : in     vl_logic;
        pmem_rdata_a    : in     vl_logic_vector(15 downto 0);
        pmem_read_a     : out    vl_logic;
        pmem_write_a    : out    vl_logic;
        pmem_address_a  : out    vl_logic_vector(15 downto 0);
        pmem_wdata_a    : out    vl_logic_vector(15 downto 0);
        pmem_mask_a     : out    vl_logic_vector(1 downto 0);
        pmem_resp_b     : in     vl_logic;
        pmem_rdata_b    : in     vl_logic_vector(15 downto 0);
        pmem_read_b     : out    vl_logic;
        pmem_write_b    : out    vl_logic;
        pmem_address_b  : out    vl_logic_vector(15 downto 0);
        pmem_wdata_b    : out    vl_logic_vector(15 downto 0);
        pmem_mask_b     : out    vl_logic_vector(1 downto 0)
    );
end mp3;
