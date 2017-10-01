library verilog;
use verilog.vl_types.all;
entity top_mod is
    generic(
        INS_ADDR_WIDTH  : integer := 8;
        IMG_IN_ADDR_WIDTH: integer := 15
    );
    port(
        clk             : in     vl_logic;
        rx              : in     vl_logic;
        tx              : out    vl_logic;
        rst             : in     vl_logic;
        led_rx          : out    vl_logic;
        led_tx          : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INS_ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of IMG_IN_ADDR_WIDTH : constant is 1;
end top_mod;
