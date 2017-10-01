library verilog;
use verilog.vl_types.all;
entity UART_FSM is
    generic(
        INS_ADDR_WIDTH  : integer := 8;
        IMG_IN_ADDR_WIDTH: integer := 19
    );
    port(
        clk             : in     vl_logic;
        rx              : in     vl_logic;
        tx              : out    vl_logic;
        rst             : in     vl_logic;
        led_rx          : out    vl_logic;
        led_tx          : out    vl_logic;
        RK_val          : in     vl_logic_vector(18 downto 0);
        ram_ins_out     : in     vl_logic_vector(7 downto 0);
        ram_ins_we      : out    vl_logic;
        ram_ins_addr    : out    vl_logic_vector;
        ram_ins_in      : out    vl_logic_vector(7 downto 0);
        ram_data_out_img_in: in     vl_logic_vector(7 downto 0);
        ram_we_img_in   : out    vl_logic;
        ram_addr_img_in : out    vl_logic_vector;
        ram_data_in_img_in: out    vl_logic_vector(7 downto 0);
        start_flag      : out    vl_logic;
        end_flag        : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of INS_ADDR_WIDTH : constant is 1;
    attribute mti_svvh_generic_type of IMG_IN_ADDR_WIDTH : constant is 1;
end UART_FSM;
