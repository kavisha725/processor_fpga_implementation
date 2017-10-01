library verilog;
use verilog.vl_types.all;
entity memory_unit is
    port(
        clk             : in     vl_logic;
        M_I_addr_CPU    : in     vl_logic_vector(7 downto 0);
        M_I_re_CPU      : in     vl_logic;
        M_I_q_CPU       : out    vl_logic_vector(7 downto 0);
        MI_IMG_data_CPU : in     vl_logic_vector(7 downto 0);
        MI_IMG_addr_CPU_read: in     vl_logic_vector(18 downto 0);
        MI_IMG_addr_CPU_write: in     vl_logic_vector(18 downto 0);
        MI_IMG_re_CPU   : in     vl_logic;
        MI_IMG_we_CPU   : in     vl_logic;
        MI_IMG_q_CPU    : out    vl_logic_vector(7 downto 0);
        d_ready_re      : out    vl_logic;
        d_ready_we      : out    vl_logic;
        M_I_data_UART   : in     vl_logic_vector(7 downto 0);
        M_I_addr_UART   : in     vl_logic_vector(7 downto 0);
        M_I_we_UART     : in     vl_logic;
        M_I_q_UART      : out    vl_logic_vector(7 downto 0);
        MI_IMG_data_UART: in     vl_logic_vector(7 downto 0);
        MI_IMG_addr_UART: in     vl_logic_vector(18 downto 0);
        MI_IMG_we_UART  : in     vl_logic;
        MI_IMG_q_UART   : out    vl_logic_vector(7 downto 0)
    );
end memory_unit;
