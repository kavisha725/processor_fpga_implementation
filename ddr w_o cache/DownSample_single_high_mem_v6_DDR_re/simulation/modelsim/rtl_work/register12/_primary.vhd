library verilog;
use verilog.vl_types.all;
entity register12 is
    port(
        clk             : in     vl_logic;
        load            : in     vl_logic;
        clear           : in     vl_logic;
        data_in         : in     vl_logic_vector(11 downto 0);
        data_out        : out    vl_logic_vector(11 downto 0)
    );
end register12;
