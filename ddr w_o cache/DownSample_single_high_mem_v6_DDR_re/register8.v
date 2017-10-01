module registerIR(clk, load, clear,/* inc, jump,*/ pass, data_in, data_out); // IR and PC
	input clk;
	input load;
	input clear;
	//input inc;
	/*input jump;*/
	input pass;
	input [7:0] data_in;
	output [7:0] data_out = 8'b0;
	
	reg [7:0] data_out = 8'b0;
	reg [7:0] data_out2 = 8'b0;
	
	
	always @(negedge clk)
		begin
			if (load) data_out2 <= data_in;
			else if (clear) data_out2 <= 8'd0;
			//else if (inc)  data_out2 <= data_out2 + 8'd1;
			//else if (jump) data_out2 <= data_in;
			else data_out2 <= data_out2;
	   end
		
	always @(*)
		begin
			if (pass) data_out <= data_in;
			else data_out <= data_out2;
		end
endmodule

module registerPC(clk, load, clear, inc, /*jump, pass,*/ data_in, data_out); // IR and PC
	input clk;
	input load;
	input clear;
	input inc;
	/*input jump;*/
	//input pass;
	input [7:0] data_in;
	output [7:0] data_out = 8'b0;
	
	reg [7:0] data_out = 8'b0;
	//reg [7:0] data_out2 = 0;
	
	
	always @(negedge clk)
		begin
			if (load) data_out <= data_in;
			else if (clear) data_out <= 8'd0;
			else if (inc)  data_out <= data_out + 8'd1;
			//else if (jump) data_out2 <= data_in;
			else data_out <= data_out;
	   end
		
	/*always @(*)
		begin
			if (pass) data_out <= data_in;
			else data_out <= data_out2;
		end*/
endmodule
/*`timescale 1ns/10ps

module register8_tb();
	reg clk = 0;	
	reg load;
	reg clear;
	reg pass;
	reg jump;
	reg inc;
	reg [7:0] data_in;
	wire [7:0] data_out;
	
	register8 regtb(
	.clk(clk),
	.load(load),
	.clear(clear),
	.jump(jump),
	.inc(inc),
	.pass(pass),
	.data_in(data_in),
	.data_out(data_out)
	);
	
always begin
   #40 clk <= ~clk;
end 
	
initial begin
		clear <= 0;
		load <= 0;	
		pass <= 0;
		inc <= 0;
		jump <= 0;
		data_in <= 8'b11110000;
		#200
		clear <= 0;
		load <= 0;
		pass <= 1;
		inc <= 0;
		jump <= 0;
		#100
		clear <= 0;
		load <= 0;
		pass <= 0;
		inc <= 0;
		jump <= 0;
		#2000
		clear <= 1;
		load <= 0;
		pass <= 0;
		inc <= 0;
		jump <= 0;
		#100
		clear <= 0;
		load <= 0;
		pass <= 1;
		inc <= 0;
		jump <= 0;
		#200
		load <= 1;
		clear <= 0;
		jump <= 0;
		pass <= 1;
		data_in <= 8'b10100101;
		#100
		pass <= 0;
      load <= 0;
      #200
		jump <= 1;
		pass <= 0;
		clear <= 0;
 
		#1000;
		$finish;
	end
endmodule*/