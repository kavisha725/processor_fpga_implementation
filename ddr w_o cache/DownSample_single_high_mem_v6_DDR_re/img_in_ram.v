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
	output reg [7:0] q_a, q_b,
	output reg d_ready_we = 1'b0,
	output reg d_ready_re = 1'b0,
	output reg [4:0] test ,//
	output reg [7:0] delay_temp = 8'b0,//
	output reg [18:0] prev_addr_a1 = 19'b0,
	output reg [18:0] prev_addr_a2 = 19'b0,
	output reg we_flag = 1'b0,
	output reg addrs_change_flag = 1'b0,
	output reg strt_count = 1'b0
	
);

	// Declare the RAM variable
	reg [7:0] ram[263168:0]; // 25800 160x160  32768 262144
	parameter DELAY = 8'd7;
	reg [18:0] prev_addr;
	reg [18:0] prev_addr_a;
	//reg delay = 1'b0;
		
	always @ (posedge clk)
	begin	
//**************************************************************	
		case(1) 
		((we_flag == 1'b1 || we_a == 1'b1 ) && (addrs_change_flag == 1 || addr_a != prev_addr_a1)): begin  // adress change and then write enable;write ready given out
			  
			  //here it makes sure that if a write enable comes aftr a clock cycle to a neighbour address change, write ready is gven insted of read ready
			 if (addr_a == prev_addr_a2 + 19'd1)begin
			 test <= 5'b10000;
				//repeat (1)  
				//delay <= 1'b1;
				//if (delay == 1'b1)begin
					d_ready_we <= 1'b1;
					//delay <= 1'b0;
				//end		
			end	
			else 
			begin
				test <= 5'b10001;
				strt_count <= 1'b1;
				delay_temp <= delay_temp + 8'b1;
				if (DELAY == delay_temp) begin
					test <= 5'b10010;
					strt_count <= 1'b0;
					d_ready_we <= 1'b1;
					delay_temp <= 8'b0;
				end
			end
		end
		
		((we_flag == 1'b0) && (addrs_change_flag == 1'b1 || addr_a != prev_addr_a1)):begin // no write enable aftr address change, read ready comes
			if (addr_a == prev_addr_a2 + 19'd1)begin
				test <= 5'b00000;
				d_ready_re <= 1'b1;						
			end
			else 
			begin
				test <= 5'b00001;
				strt_count <= 1'b1;
				if (strt_count == 1'b1)begin
					delay_temp <= delay_temp + 8'b1;
					if (DELAY == delay_temp) begin
						test <= 5'b00010;
						strt_count <= 1'b0;
						d_ready_re <= 1'b1;
						delay_temp <= 8'b0;
					end
				end
			end
		end
		
		((we_flag == 1'b1|| we_a == 1) && addrs_change_flag == 1'b0): begin // no adress change just write enable, special case after data being 		available for a  read or a write beforehand
			test <= 5'b11000;
			d_ready_we <= 1'b1;
			d_ready_re <= 1'b0;
		end
		default:begin
			//test <= 5'bxxxxx;
			d_ready_we <= 1'b0;
			d_ready_re <= 1'b0;
		end
endcase
//*************************************************************************		
		prev_addr_a <= addr_a;
		prev_addr_a1 <= prev_addr_a;
		
		if (addr_a != prev_addr_a1)
			addrs_change_flag <= 1'b1;
		if (we_a == 1'b1) begin
			//test <= 5'bxxxxx;
			we_flag <= 1'b1;
			delay_temp <= 8'b0;
			strt_count <= 1'b0;
		end
		
		case(1)
		(d_ready_we == 1'b1): begin
			//test <= 5'bxxxxx;
			d_ready_we <= 1'b0;
			//d_ready_re <= 1'b0;
			we_flag <= 1'b0;	
			addrs_change_flag <= 1'b0;
			delay_temp <= 8'b0;
			strt_count <= 1'b0;
		end
		(d_ready_re == 1'b1 && addr_a != prev_addr_a1):begin
			//d_ready_we <= 1'b0;
			d_ready_re <= 1'b0;
			we_flag <= 1'b0;	
			//addrs_change_flag <= 1'b0;
			delay_temp <= 8'b0;
			strt_count <= 1'b0;
		end
		(d_ready_re == 1'b1):begin
			//d_ready_we <= 1'b0;
			d_ready_re <= 1'b0;
			we_flag <= 1'b0;	
			addrs_change_flag <= 1'b0;
			delay_temp <= 8'b0;
			strt_count <= 1'b0;
		end
		endcase
	// Port A
		if (we_a) begin
			ram[addr_a] <= data_a;
			q_a <= data_a;
			
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
	 
always @(addr_a)begin 
	 prev_addr <= addr_a;
	 prev_addr_a2 <= prev_addr;
end


endmodule




`timescale 1ns/10ps

module img_in_ram_tb();
	reg [7:0] data_a, data_b;
	reg [18:0] addr_a, addr_b;
	reg we_a, we_b;
	reg clk = 0;
	wire [7:0] q_a, q_b;
	wire d_ready_we ;
	wire d_ready_re;
	wire [4:0] test;
	wire [7:0] delay_temp; 
	wire [18:0] prev_addr_a1; 
	wire [18:0] prev_addr_a2;
	wire we_flag;
	wire addrs_change_flag;
	wire strt_count;

	
	
	
	img_in_ram img_in_ram_tb1(
	.data_a(data_a),
	.data_b(data_b),
	.addr_a(addr_a),
	.addr_b(addr_b),
	.we_a(we_a),
	.we_b(we_b),
	.clk(clk),
	.q_a(q_a),
	.q_b(q_b),
	.d_ready_we(d_ready_we),
	.d_ready_re(d_ready_re),
	.test(test),
	.delay_temp(delay_temp),
	.prev_addr_a1(prev_addr_a1),
	.prev_addr_a2(prev_addr_a2),
	.we_flag(we_flag),
	.addrs_change_flag(addrs_change_flag),
	.strt_count(strt_count)
	);
	
	always begin
   #10 clk <= ~clk;
	end
	
	initial begin
	#10
	data_a <= 8'b1010_0000;
	data_b <= 8'b1111_0000;
	addr_a <= 19'b000_0000_0000_0000_0011;
	addr_b <= 19'b000_0000_0000_0011_0000;
	#40
	we_a <= 1;
	#20
	we_a <= 0;
	#200
	we_a <= 1;
	#20
	we_a <= 0;
	#60
	data_a <= 8'b1110_0000;
	addr_a <= 19'b000_0000_0000_0000_0100;
	#60
	we_a <= 1;
	#20
	we_a <= 0;
	#40
	data_a <= 8'b1010_0000;
	addr_a <= 19'b000_0000_0000_0001_000;
	#100
	#100
	data_a <= 8'b1010_0000;
	addr_a <= 19'b000_0000_0000_0001_001;
	#20
	we_a <= 1;
	we_b <= 0;
	#20
	we_a <= 0;
	#40
	we_a <= 1;
	we_b <= 0;
	#20
	we_a <= 0;
	#40
	addr_b <= 19'b000_0000_0000_0011_0000;
	#40
	we_b <= 1;
	#20
	we_b <= 0;
	data_a <= 8'b1010_0000;
	addr_a <= 19'b000_0000_0000_0001_010;
	we_a <= 1;
	we_b <= 0;
	#20
	we_a <= 0;
	#100
	addr_a <= 19'b000_0000_0000_0001_100;
	#60
	we_a <= 1;
	#20
	we_a <= 0;
	#60
	
	
	$finish;
	end
endmodule
	
	
	
	