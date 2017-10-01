library verilog;
use verilog.vl_types.all;
entity processor is
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        START_FLAG      : in     vl_logic;
        END_FLAG        : out    vl_logic;
        M_INS_DATA      : in     vl_logic_vector(7 downto 0);
        M_INS_ADD       : out    vl_logic_vector(7 downto 0);
        RD_M_INS        : out    vl_logic;
        MI_data         : in     vl_logic_vector(7 downto 0);
        MI_add          : out    vl_logic_vector(18 downto 0);
        RD_MI           : out    vl_logic;
        d_ready_re      : in     vl_logic;
        MO_data         : out    vl_logic_vector(7 downto 0);
        MO_add          : out    vl_logic_vector(18 downto 0);
        WR_MO           : out    vl_logic;
        d_ready_we      : in     vl_logic
    );
end processor;
