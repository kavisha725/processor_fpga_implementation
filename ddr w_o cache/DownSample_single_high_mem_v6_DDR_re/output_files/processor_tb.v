`timescale 1ns/10ps
module processor_tb();

wire [2:0] ALU_OP;
wire [2:0] AMUX_sel;
wire [2:0] BMUX_sel;
wire [8:0] LOAD_VECT;
wire [5:0] CLEAR_VECT;
wire PASS_AC;
wire z;
wire z1;

wire RD_M_INS;
wire RD_MI;
wire WR_MO;
wire END_FLAG;

reg clk = 1'b0;
reg rst = 0;

reg [7:0] M_INS_DATA = 8'd37;
wire [7:0] M_INS_ADD;

reg START_FLAG = 0;
wire [7:0] state;

always begin
		#10 clk <= ~clk;
	end 

initial begin
	#10
	START_FLAG <= 1;
	#20
	START_FLAG <= 0;
	#600
	$finish;
end

control_unit CU1( clk,
					rst,
					START_FLAG,
					z,
					z1,
					RD_M_INS,
					RD_MI,
					WR_MO,
					LOAD_VECT,
					CLEAR_VECT,
					AMUX_sel,
					BMUX_sel,
					ALU_OP,
					PASS_AC,
					END_FLAG,
					M_INS_DATA,
					M_INS_ADD,
					state);
endmodule