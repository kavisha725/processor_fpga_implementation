library verilog;
use verilog.vl_types.all;
entity img_in_ddr is
    generic(
        DELAY           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1)
    );
    port(
        data_a          : in     vl_logic_vector(7 downto 0);
        data_b          : in     vl_logic_vector(7 downto 0);
        addr_a          : in     vl_logic_vector(18 downto 0);
        addr_b          : in     vl_logic_vector(18 downto 0);
        we_a            : in     vl_logic;
        we_b            : in     vl_logic;
        re_a            : in     vl_logic;
        clk             : in     vl_logic;
        q_a             : out    vl_logic_vector(7 downto 0);
        q_b             : out    vl_logic_vector(7 downto 0);
        d_ready_we      : out    vl_logic;
        d_ready_re      : out    vl_logic;
        test            : out    vl_logic_vector(4 downto 0);
        delay_temp_re   : out    vl_logic_vector(7 downto 0);
        delay_temp_we   : out    vl_logic_vector(7 downto 0);
        prev_addr_a1    : out    vl_logic_vector(18 downto 0);
        prev_addr_a2    : out    vl_logic_vector(18 downto 0);
        we_flag         : out    vl_logic;
        re_flag         : out    vl_logic;
        addrs_change_flag_we: out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of DELAY : constant is 1;
end img_in_ddr;
