library verilog;
use verilog.vl_types.all;
entity ins_ram is
    port(
        data_b          : in     vl_logic_vector(7 downto 0);
        addr_a          : in     vl_logic_vector(7 downto 0);
        addr_b          : in     vl_logic_vector(7 downto 0);
        we_a            : in     vl_logic;
        we_b            : in     vl_logic;
        clk             : in     vl_logic;
        q_a             : out    vl_logic_vector(7 downto 0);
        q_b             : out    vl_logic_vector(7 downto 0)
    );
end ins_ram;
