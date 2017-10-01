module Bmux(RH, RW, RK, RX, AC, B_bus, sel); // H,W,K,X,AC
	input [18:0] RK, RX, AC;
	input [11:0]	RH, RW;
	input [2:0] sel;
	output reg [18:0] B_bus = 0;
	
	always @(*)
	begin
		case(sel)
			3'b000: B_bus = {7'b0, RH};
			3'b001: B_bus = {7'b0, RW};
			3'b010: B_bus = RK;
			3'b011: B_bus = RX;
			3'b100: B_bus = AC;
			default: B_bus = 0;
		endcase
	end
endmodule