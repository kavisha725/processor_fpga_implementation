library verilog;
use verilog.vl_types.all;
entity ALU is
    generic(
        ADD             : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi0);
        DIV16           : vl_logic_vector(0 to 2) := (Hi0, Hi0, Hi1);
        SUB             : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi0);
        INC2            : vl_logic_vector(0 to 2) := (Hi0, Hi1, Hi1);
        INC1            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi0);
        DEC1            : vl_logic_vector(0 to 2) := (Hi1, Hi0, Hi1);
        MUL2            : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi0);
        MUL4            : vl_logic_vector(0 to 2) := (Hi1, Hi1, Hi1)
    );
    port(
        A_bus           : in     vl_logic_vector(11 downto 0);
        B_bus           : in     vl_logic_vector(18 downto 0);
        op              : in     vl_logic_vector(2 downto 0);
        C_bus           : out    vl_logic_vector(18 downto 0)
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of ADD : constant is 1;
    attribute mti_svvh_generic_type of DIV16 : constant is 1;
    attribute mti_svvh_generic_type of SUB : constant is 1;
    attribute mti_svvh_generic_type of INC2 : constant is 1;
    attribute mti_svvh_generic_type of INC1 : constant is 1;
    attribute mti_svvh_generic_type of DEC1 : constant is 1;
    attribute mti_svvh_generic_type of MUL2 : constant is 1;
    attribute mti_svvh_generic_type of MUL4 : constant is 1;
end ALU;
