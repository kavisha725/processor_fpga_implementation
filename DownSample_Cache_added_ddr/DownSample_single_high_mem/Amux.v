module Amux(RS, RI, RJ, RH, RW, A_bus, sel);
	input [11:0] RS, RI, RJ, RH, RW;
	input [2:0] sel;
	output reg [11:0] A_bus = 0;
	
	always @(*)
	begin
		case(sel)
			3'b000: A_bus = RS;
			3'b001: A_bus = RI;
			3'b010: A_bus = RJ;
			3'b011: A_bus = RH;
			3'b100: A_bus = RW;
			default: A_bus = 0;
		endcase
	end
endmodule

