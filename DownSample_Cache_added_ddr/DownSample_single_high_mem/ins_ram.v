//module ins_ram		// 8 bit addressing 256 bytes - 256 instructions max
//(
//	input [7:0] data,
//	input [7:0] addr,
//	input we, clk,
//	output [7:0] q
//);
//
//	// Declare the RAM variable
//	reg [7:0] ram[255:0];//'{default:'0};
//
//	// Variable to hold the registered read address
//	reg [7:0] addr_reg;
//	
//	// Specify the initial contents.  You can also use the $readmemb
//	// system task to initialize the RAM variable from a text file.
//	// See the $readmemb template page for details.
//	initial 
//	begin : INIT
//		integer i;
//		for(i = 0; i < 256; i = i + 1)
//			ram[i] = {8{1'b1}};
//	end 
//
//	always @ (posedge clk)				// CHANGE TO NEGEDGE FROM POS EDGE IF NOT ENOUGH TIME
//	begin
//		// Write
//		if (we)
//			ram[addr] <= data;
//
//		addr_reg <= addr;
//	end
//
//	// Continuous assignment implies read returns NEW data.
//	// This is the natural behavior of the TriMatrix memory
//	// blocks in Single Port mode.  
//	assign q = ram[addr_reg];
//
//endmodule

module ins_ram//_single_clock
//#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [7:0] /*data_a,*/ data_b,
	input [7:0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [7:0] q_a, q_b
);

	// Declare the RAM variable
	reg [7:0] ram[255:0];

	// Port A 
	always @ (posedge clk)
	begin
		if (we_a) 
		begin
			//ram[addr_a] <= data_a;
			//q_a <= data_a;
			q_a <= ram[addr_a];
		end
		else 
		begin
			q_a <= ram[addr_a];
		end 
	end 

	// Port B 
	always @ (posedge clk)
	begin
		if (we_b) 
		begin
			ram[addr_b] <= data_b;
			q_b <= data_b;
		end
		else 
		begin
			q_b <= ram[addr_b];
		end 
	end

endmodule

`timescale 1ns/10ps

module ins_ram_tb();
//	reg [7:0] data_a, data_b;
//	reg [18:0] addr_a, addr_b;
//	reg we_a, we_b;
//	reg clk = 0;
//	wire [7:0] q_a, q_b;
//	wire d_ready = 1'b0;
//	wire [2:0] test;//
//	wire [7:0] delay_temp = 8'b0;//
//	wire [18:0] prev_addr_a = 19'b0;//
	
	reg [7:0] /*data_a,*/ data_b;
	reg [7:0] addr_a;
	reg [7:0] addr_b;
	reg we_a;
	reg we_b; 
	reg clk = 0;
	wire[7:0] q_a;
   wire [7:0] q_b;
	
	ins_ram ins_ram_tb1(
	//.data_a(data_a),
	.addr_a(addr_a),
	.addr_b(addr_b),
	.data_b(data_b),
	.we_a(we_a),
	.we_b(we_b),
	.clk(clk),
	.q_a(q_a),
	.q_b(q_b)
	//.d_ready(d_ready),
	//.test(test),
	//.delay_temp(delay_temp),
	//.prev_addr_a(prev_addr_a)
	);
	
	always begin
   #10 clk <= ~clk;
	end
	
	initial begin
	//data_a <= 8'b1010_0000;
	#10
	we_a <= 0;
	we_b <= 0;
	data_b <= 8'b1111_1111;
	addr_a <= 19'b000_0000_0000_0011_0000;
	addr_b <= 19'b000_0000_0000_0011_0000;
	#20
	we_b <= 1;
	#20
	we_b <= 0;
	#60
	data_b <= 8'b1110_0000;
	addr_b <= 19'b000_0000_0000_0000_0100;
	#20
	we_b <= 1;
	#20
	we_b <= 0;
	#60
	data_b <= 8'b1010_0000;
	addr_b <= 19'b000_0000_0000_0001_000;
	#20
	we_b <= 1;
	we_a <= 0;
	#20
	we_b <= 0;
	#60
	addr_a <= 19'b000_0000_0000_0000_0100;
	//addr_b <= 19'b000_0000_0000_0011_0000;
	#40
	we_a <= 1;
	#40
	we_a <= 0;
	#20
	$finish;
	end
endmodule
	