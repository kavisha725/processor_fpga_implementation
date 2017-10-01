module processor(	input wire clk,
						input wire rst,
						input wire START_FLAG,
						output wire END_FLAG,
						// instruction memory
						input wire [7:0] M_INS_DATA,
						output wire [7:0] M_INS_ADD,
						output wire RD_M_INS,
						// input image memory
						input wire [7:0] MI_data,
						output wire [18:0] MI_add,
						output wire RD_MI,
						// output image memory
						output wire [7:0] MO_data,
						output wire [18:0] MO_add,
						output wire WR_MO);


wire [2:0] ALU_OP;
wire [2:0] AMUX_sel;
wire [2:0] BMUX_sel;
wire [8:0] LOAD_VECT;
wire [5:0] CLEAR_VECT;
wire PASS_AC;
wire z;
wire z1;
						
datapath DP1(ALU_OP, 
						AMUX_sel, 
						BMUX_sel,
						LOAD_VECT,
						CLEAR_VECT,
						PASS_AC,
						MO_data,
						MO_add,
						MI_data,
						MI_add,
						clk, 
						z,
						z1
						);
					
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
					M_INS_ADD);
endmodule