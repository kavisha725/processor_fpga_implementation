library verilog;
use verilog.vl_types.all;
entity uart is
    port(
        din             : in     vl_logic_vector(7 downto 0);
        wr_en           : in     vl_logic;
        clk_50m         : in     vl_logic;
        tx              : out    vl_logic;
        tx_busy         : out    vl_logic;
        rx              : in     vl_logic;
        rdy             : out    vl_logic;
        rdy_clr         : in     vl_logic;
        dout            : out    vl_logic_vector(7 downto 0)
    );
end uart;
