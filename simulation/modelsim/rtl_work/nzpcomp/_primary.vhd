library verilog;
use verilog.vl_types.all;
entity nzpcomp is
    generic(
        width           : integer := 16
    );
    port(
        nzp             : in     vl_logic_vector(2 downto 0);
        nzp_other       : in     vl_logic_vector(2 downto 0);
        br_en           : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of width : constant is 1;
end nzpcomp;
