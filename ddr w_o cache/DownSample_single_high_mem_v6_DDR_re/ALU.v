module ALU(A_bus, B_bus, op, C_bus/*, z, z1*/);
	input [11:0] A_bus;
	input [18:0] B_bus;
	input [2:0] op;
	output reg [18:0] C_bus;
	//output reg z = 1'b0;
	//output reg z1 = 1'b1;
	
	parameter ADD = 3'd0,
				 DIV16 = 3'd1,
	          SUB = 3'd2,
	          INC2 = 3'd3,
	          INC1 = 3'd4,
	          DEC1 = 3'd5,
	          MUL2 = 3'd6,
	          MUL4 = 3'd7;
	
	/*always@(C_bus) begin
		z = (C_bus == 19'b0) ? 1'b1 : 1'b0;
		z1 = ((C_bus == 19'b0) || (C_bus == 19'b1)) ? 1'b0 : 1'b1;
	end*/
	
	always@(op or A_bus or B_bus)
		begin
			case(op)
				 ADD: 
					begin
						C_bus = {7'b0, A_bus} + B_bus;
					end
						
				 DIV16:
					begin
						C_bus = {7'b0, A_bus} >> 4;
					end
					
				 SUB: 
					begin
						C_bus = B_bus - {7'b0, A_bus};
					end
						
				 INC2:
					begin
						C_bus = {7'b0, A_bus} + 19'd2;
					end
					
				 INC1:
					begin
						C_bus = B_bus + 19'd1;
					end
				 
				 DEC1: 
					begin
						C_bus = B_bus - 19'd1;
					end
					
				 MUL2:
					begin
						C_bus = B_bus << 1;
					end
				 
				 MUL4:
					begin
						C_bus = B_bus << 2;
					end			
				endcase
			end		
endmodule
				 
