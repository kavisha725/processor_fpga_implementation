//module img_in_ram			// 15 bit address 25800 bytes (160 x 160 image max)(25600 bytes)
//(
//	input [7:0] data,
//	input [14:0] addr,
//	input we, clk,
//	output [7:0] q
//);
//
//	// Declare the RAM variable
//	reg [7:0] ram[25799:0];//'{default:'0};
//
//	// Variable to hold the registered read address
//	reg [14:0] addr_reg;
//	
//	// Specify the initial contents.  You can also use the $readmemb
//	// system task to initialize the RAM variable from a text file.
//	// See the $readmemb template page for details.
//	
//	// ***************** could not initiate max iterations was reached
//	
//	/*initial 
//	begin : INIT
//		integer i;
//		for(i = 0; i < 25800; i = i + 1)
//			ram[i] = {8{1'b1}};
//	end */
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

module img_in_ram//_single_clock
//#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [7:0] data_a, data_b,
	input [18:0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [7:0] q_a, q_b
);

	// Declare the RAM variable
	reg [7:0] ram[263168:0]; // 25800 160x160  32768 262144 263168

	// Port A 
	always @ (posedge clk)
	begin
		if (we_a) 
		begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
			//q_a <= ram[addr_a];
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