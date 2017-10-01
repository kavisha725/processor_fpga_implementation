module register19(clk, load, clear, data_in, data_out);	//RX, RK
	input clk;
	input load;
	input clear;
	input [18:0] data_in;
	output reg [18:0] data_out = 0;
	 
	always @(negedge clk)
		begin
			if (load) data_out = data_in;
			else if (clear)data_out = 19'd0;
	   end
endmodule


module registerAC(clk, LD_ALU_AC, LD_MI_AC, clear, pass, data_in_ALU, data_in_MI, data_out, z, z1);
	input clk;
	input LD_ALU_AC;
	input LD_MI_AC;
	input clear;
	input pass;
	input [18:0] data_in_ALU;
	input [7:0] data_in_MI;
	output reg [18:0] data_out = 0;
	
	reg [18:0] data_out2 = 0;
	//reg [18:0] data_out = 0;
	output reg z = 1'b0;
	output reg z1 = 1'b1;
	
	always@(data_out) begin
		z = (data_out == 19'b0) ? 1'b1 : 1'b0;
		z1 = ((data_out == 19'b0) || (data_out == 19'b1)) ? 1'b0 : 1'b1;
	end
	 
	always @(negedge clk)
		begin
			if (LD_ALU_AC) data_out2 = data_in_ALU;
			else if (LD_MI_AC) data_out2 = {11'b0, data_in_MI};
			else if (clear)data_out2 = 19'd0;
	   end
	
	always @(*)
		begin
			if (pass) data_out <= data_in_ALU;
			else data_out <= data_out2;
		end
endmodule