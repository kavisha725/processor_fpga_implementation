library verilog;
use verilog.vl_types.all;
entity transmitter is
    generic(
        STATE_IDLE      : vl_logic_vector(0 to 1) := (Hi0, Hi0);
        STATE_START     : vl_logic_vector(0 to 1) := (Hi0, Hi1);
        STATE_DATA      : vl_logic_vector(0 to 1) := (Hi1, Hi0);
        STATE_STOP      : vl_logic_vector(0 to 1) := (Hi1, Hi1)
    );
    port(
        din             : in     vl_logic_vector(7 downto 0);
        wr_en           : in     vl_logic;
        clk_50m         : in     vl_logic;
        clken           : in     vl_logic;
        tx              : out    vl_logic;
        tx_busy         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of STATE_IDLE : constant is 1;
    attribute mti_svvh_generic_type of STATE_START : constant is 1;
    attribute mti_svvh_generic_type of STATE_DATA : constant is 1;
    attribute mti_svvh_generic_type of STATE_STOP : constant is 1;
end transmitter;
