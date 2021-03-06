library verilog;
use verilog.vl_types.all;
entity control_unit is
    generic(
        START           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0);
        CLAC            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1);
        DIVRS1          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi1);
        DECRX_W         : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0, Hi0);
        FETCH1          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1);
        CLRX            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0);
        SUBRHRJ         : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi0);
        SHFT1           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0, Hi1);
        FETCH2          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0);
        CLRS            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1);
        SUBRWRI         : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi0, Hi1);
        SHFT2           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi0);
        LDACRX1         : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1);
        CLRI            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0);
        INRI1           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi0);
        JUMP1           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1, Hi1);
        LDACRX2         : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0);
        CLRJ            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1);
        INRJ1           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi1, Hi1, Hi1);
        JUMP2           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi0);
        MVACRH1         : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi1);
        CLRK            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi0);
        INRK            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi0);
        JMPZ1           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0, Hi1);
        MVACRW1         : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi0);
        ADDRXAC1        : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1, Hi1);
        INRX            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi0, Hi1);
        JMPZ2           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1, Hi0);
        STRSRK1         : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi0, Hi1, Hi1, Hi1);
        ADDRXAC2        : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi0);
        DECRX           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi0);
        JMPSP1          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1, Hi1);
        STRSRK2         : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0);
        ADDSUM1         : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi0, Hi1);
        INRX_W          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi1, Hi0, Hi1, Hi1);
        JMPSP2          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi0);
        ADDSUM2         : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0);
        \END\           : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi0, Hi1);
        END2            : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi1, Hi0);
        SEL_OP          : vl_logic_vector(0 to 7) := (Hi0, Hi0, Hi1, Hi0, Hi0, Hi1, Hi1, Hi1)
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        START_FLAG      : in     vl_logic;
        Z               : in     vl_logic;
        Z1              : in     vl_logic;
        RD_M_INS        : out    vl_logic;
        RD_MI           : out    vl_logic;
        WR_MO           : out    vl_logic;
        LOAD_VECT       : out    vl_logic_vector(8 downto 0);
        CLEAR_VECT      : out    vl_logic_vector(5 downto 0);
        AMUX            : out    vl_logic_vector(2 downto 0);
        BMUX            : out    vl_logic_vector(2 downto 0);
        ALU_OP          : out    vl_logic_vector(2 downto 0);
        PASS_AC         : out    vl_logic;
        END_FLAG        : out    vl_logic;
        M_INS_DATA      : in     vl_logic_vector(7 downto 0);
        M_INS_ADD       : out    vl_logic_vector(7 downto 0);
        d_ready_re      : in     vl_logic;
        d_ready_we      : in     vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of START : constant is 1;
    attribute mti_svvh_generic_type of CLAC : constant is 1;
    attribute mti_svvh_generic_type of DIVRS1 : constant is 1;
    attribute mti_svvh_generic_type of DECRX_W : constant is 1;
    attribute mti_svvh_generic_type of FETCH1 : constant is 1;
    attribute mti_svvh_generic_type of CLRX : constant is 1;
    attribute mti_svvh_generic_type of SUBRHRJ : constant is 1;
    attribute mti_svvh_generic_type of SHFT1 : constant is 1;
    attribute mti_svvh_generic_type of FETCH2 : constant is 1;
    attribute mti_svvh_generic_type of CLRS : constant is 1;
    attribute mti_svvh_generic_type of SUBRWRI : constant is 1;
    attribute mti_svvh_generic_type of SHFT2 : constant is 1;
    attribute mti_svvh_generic_type of LDACRX1 : constant is 1;
    attribute mti_svvh_generic_type of CLRI : constant is 1;
    attribute mti_svvh_generic_type of INRI1 : constant is 1;
    attribute mti_svvh_generic_type of JUMP1 : constant is 1;
    attribute mti_svvh_generic_type of LDACRX2 : constant is 1;
    attribute mti_svvh_generic_type of CLRJ : constant is 1;
    attribute mti_svvh_generic_type of INRJ1 : constant is 1;
    attribute mti_svvh_generic_type of JUMP2 : constant is 1;
    attribute mti_svvh_generic_type of MVACRH1 : constant is 1;
    attribute mti_svvh_generic_type of CLRK : constant is 1;
    attribute mti_svvh_generic_type of INRK : constant is 1;
    attribute mti_svvh_generic_type of JMPZ1 : constant is 1;
    attribute mti_svvh_generic_type of MVACRW1 : constant is 1;
    attribute mti_svvh_generic_type of ADDRXAC1 : constant is 1;
    attribute mti_svvh_generic_type of INRX : constant is 1;
    attribute mti_svvh_generic_type of JMPZ2 : constant is 1;
    attribute mti_svvh_generic_type of STRSRK1 : constant is 1;
    attribute mti_svvh_generic_type of ADDRXAC2 : constant is 1;
    attribute mti_svvh_generic_type of DECRX : constant is 1;
    attribute mti_svvh_generic_type of JMPSP1 : constant is 1;
    attribute mti_svvh_generic_type of STRSRK2 : constant is 1;
    attribute mti_svvh_generic_type of ADDSUM1 : constant is 1;
    attribute mti_svvh_generic_type of INRX_W : constant is 1;
    attribute mti_svvh_generic_type of JMPSP2 : constant is 1;
    attribute mti_svvh_generic_type of ADDSUM2 : constant is 1;
    attribute mti_svvh_generic_type of \END\ : constant is 1;
    attribute mti_svvh_generic_type of END2 : constant is 1;
    attribute mti_svvh_generic_type of SEL_OP : constant is 1;
end control_unit;
