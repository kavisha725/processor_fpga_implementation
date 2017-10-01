library verilog;
use verilog.vl_types.all;
entity Amux is
    port(
        RS              : in     vl_logic_vector(11 downto 0);
        RI              : in     vl_logic_vector(11 downto 0);
        RJ              : in     vl_logic_vector(11 downto 0);
        RH              : in     vl_logic_vector(11 downto 0);
        RW              : in     vl_logic_vector(11 downto 0);
        A_bus           : out    vl_logic_vector(11 downto 0);
        sel             : in     vl_logic_vector(2 downto 0)
    );
end Amux;
