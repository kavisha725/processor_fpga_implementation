library verilog;
use verilog.vl_types.all;
entity Bmux is
    port(
        RH              : in     vl_logic_vector(11 downto 0);
        RW              : in     vl_logic_vector(11 downto 0);
        RK              : in     vl_logic_vector(18 downto 0);
        RX              : in     vl_logic_vector(18 downto 0);
        AC              : in     vl_logic_vector(18 downto 0);
        B_bus           : out    vl_logic_vector(18 downto 0);
        sel             : in     vl_logic_vector(2 downto 0)
    );
end Bmux;
