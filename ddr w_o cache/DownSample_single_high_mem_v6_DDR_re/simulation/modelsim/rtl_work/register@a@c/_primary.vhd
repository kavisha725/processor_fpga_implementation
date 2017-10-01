library verilog;
use verilog.vl_types.all;
entity registerAC is
    port(
        clk             : in     vl_logic;
        LD_ALU_AC       : in     vl_logic;
        LD_MI_AC        : in     vl_logic;
        clear           : in     vl_logic;
        pass            : in     vl_logic;
        data_in_ALU     : in     vl_logic_vector(18 downto 0);
        data_in_MI      : in     vl_logic_vector(7 downto 0);
        data_out        : out    vl_logic_vector(18 downto 0);
        z               : out    vl_logic;
        z1              : out    vl_logic
    );
end registerAC;
