library verilog;
use verilog.vl_types.all;
entity datapath is
    port(
        ALU_OP          : in     vl_logic_vector(2 downto 0);
        AMUX_sel        : in     vl_logic_vector(2 downto 0);
        BMUX_sel        : in     vl_logic_vector(2 downto 0);
        LOAD_VECT       : in     vl_logic_vector(8 downto 0);
        CLEAR_VECT      : in     vl_logic_vector(5 downto 0);
        PASS_AC         : in     vl_logic;
        MO_data         : out    vl_logic_vector(7 downto 0);
        MO_add          : out    vl_logic_vector(18 downto 0);
        MI_data         : in     vl_logic_vector(7 downto 0);
        MI_add          : out    vl_logic_vector(18 downto 0);
        clk             : in     vl_logic;
        z               : out    vl_logic;
        z1              : out    vl_logic
    );
end datapath;
