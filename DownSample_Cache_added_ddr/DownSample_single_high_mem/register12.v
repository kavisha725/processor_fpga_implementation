module register12(clk, load, clear, data_in, data_out); // RS,RI,RJ,RH,RW
	input clk;
	input load;
	input clear;
	input [11:0] data_in;
	output reg [11:0] data_out = 0;
	
	always @(negedge clk)
		begin
			if (load) data_out <= data_in;
			else if (clear) data_out <= 12'd0;
	   end
endmodule