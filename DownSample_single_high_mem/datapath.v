module datapath(input [2:0] ALU_OP, 
					input [2:0] AMUX_sel, 
					input [2:0] BMUX_sel,
					input [8:0] LOAD_VECT,
					input [5:0] CLEAR_VECT,
					input PASS_AC,
					output reg [7:0] MO_data = 0,
					output reg [18:0] MO_add = 0,
					input [7:0] MI_data,
					output reg [18:0] MI_add = 0,
					input clk, 
					output z,
					output z1
					);
					
reg CLR_RH = 0;
reg CLR_RW = 0;
wire [18:0] AC_out;
wire [11:0] RS_out;
wire [11:0] RI_out;
wire [11:0] RJ_out;
wire [11:0] RH_out;
wire [11:0] RW_out;
wire [18:0] RK_out;
wire [18:0] RX_out;
wire [18:0] C_bus;
wire [18:0] B_bus;
wire [11:0] A_bus;


register12 RS(.clk(clk), .load(LOAD_VECT[4]), .clear(CLEAR_VECT[1]), .data_in(AC_out[11:0]), .data_out(RS_out)); //check if new name in bracket.
register12 RI(.clk(clk), .load(LOAD_VECT[6]), .clear(CLEAR_VECT[3]), .data_in(AC_out[11:0]), .data_out(RI_out));
register12 RJ(.clk(clk), .load(LOAD_VECT[7]), .clear(CLEAR_VECT[4]), .data_in(AC_out[11:0]), .data_out(RJ_out));
register12 RH(.clk(clk), .load(LOAD_VECT[2]), .clear(CLR_RH), .data_in(AC_out[11:0]), .data_out(RH_out));
register12 RW(.clk(clk), .load(LOAD_VECT[3]), .clear(CLR_RW), .data_in(AC_out[11:0]), .data_out(RW_out));

register19 RK(.clk(clk), .load(LOAD_VECT[8]), .clear(CLEAR_VECT[5]), .data_in(AC_out), .data_out(RK_out));
register19 RX(.clk(clk), .load(LOAD_VECT[5]), .clear(CLEAR_VECT[2]), .data_in(AC_out), .data_out(RX_out));

registerAC AC(.clk(clk), .LD_ALU_AC(LOAD_VECT[1]), .LD_MI_AC(LOAD_VECT[0]), .clear(CLEAR_VECT[0]), .pass(PASS_AC), .data_in_ALU(C_bus), .data_in_MI(MI_data), .data_out(AC_out), .z(z), .z1(z1));

ALU ALU(.A_bus(A_bus), .B_bus(B_bus), .op(ALU_OP), .C_bus(C_bus)/*, .z(z), .z1(z1)*/);

Amux AMUX(.RS(RS_out), .RI(RI_out), .RJ(RJ_out), .RH(RH_out), .RW(RW_out), .A_bus(A_bus), .sel(AMUX_sel));
Bmux bmuxtb(.RH(RH_out), .RW(RW_out), .RK(RK_out), .RX(RX_out), .AC(AC_out), .B_bus(B_bus), .sel(BMUX_sel));

always @(*) begin						// check this part.
	MO_data <= RS_out[7:0];//[7:0];	
	MO_add <= RK_out;//[15:0]; // removed [15:0] to support 512x512
	MI_add <= RX_out;			
						
end

endmodule
