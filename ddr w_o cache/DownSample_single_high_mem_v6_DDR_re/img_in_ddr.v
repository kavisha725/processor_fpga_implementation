module img_in_ddr//_single_clock
//#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [7:0] data_a, data_b,
	input [18:0] addr_a, addr_b,
	input we_a, we_b, re_a, clk,
	output reg [7:0] q_a, q_b,
	output reg d_ready_we = 1'b0,
	output reg d_ready_re = 1'b0
);

	// Declare the RAM variable
	reg [7:0] ram[263168:0]; // 25800 160x160  32768 262144
	parameter DELAY = 8'd250;
	reg [18:0] prev_addr;
	reg [18:0] prev_addr_a;
	reg [18:0] prev_addr_a1 = 19'b0;
	reg [18:0] prev_addr_a2 = 19'b0;
	reg addrs_change_flag_re = 1'b0;
	reg addrs_change_flag_we = 1'b0;
	reg [7:0] delay_temp_re = 8'b0;
	reg [7:0] delay_temp_we = 8'b0;
	reg we_flag = 1'b0;
	reg re_flag = 1'b0;
	
	
	

	always @ (posedge clk)
	begin	
	
	if (addrs_change_flag_re == 1'b1 && re_flag == 1 ) begin	
		if (addr_a == prev_addr_a2+ 19'd1)begin
				d_ready_re <= 1'b1;
		end
		else 
		begin
			delay_temp_re <= delay_temp_re + 8'b1;
			if (DELAY == delay_temp_re) begin
				d_ready_re <= 1'b1;
				delay_temp_re <= 8'b0;
			end
		end
	end
			
	if (addrs_change_flag_we == 1'b1 && we_flag == 1) begin
		if (addr_a == prev_addr_a2 + 19'd1)begin
				d_ready_we <= 1'b1;	
		end
			
		else 
		begin
			delay_temp_we <= delay_temp_we + 8'b1;
			if (DELAY == delay_temp_we) begin
				d_ready_we <= 1'b1;
				delay_temp_we <= 8'b0;
			end
		end
	end
	
	if ((we_flag == 1'b1 ) && addrs_change_flag_we== 1'b0) begin
			d_ready_we <= 1'b1;
			d_ready_re <= 1'b0;
	end
	
	if ((re_flag == 1'b1 ) && addrs_change_flag_re== 1'b0) begin
			d_ready_we <= 1'b0;
			d_ready_re <= 1'b1;
	end
	
	
	if (we_a == 1'b1) begin
			we_flag <= 1'b1;
	end
	
	if (re_a == 1'b1) begin
			re_flag <= 1'b1;
	end
	
	prev_addr_a <= addr_a;
	prev_addr_a1 <= prev_addr_a;
		
	if (addr_a != prev_addr_a1)begin
		addrs_change_flag_re <= 1'b1;
		addrs_change_flag_we <= 1'b1;
	end
	
	if (d_ready_we == 1'b1)
		begin
			d_ready_we <= 1'b0;
			we_flag <= 1'b0;	
			addrs_change_flag_we <= 1'b0;
			delay_temp_we <= 8'b0;
		end
		
	if (d_ready_re == 1'b1)
		begin	
			addrs_change_flag_re <= 1'b0;
			delay_temp_re <= 8'b0;
			d_ready_re <= 1'b0;
			re_flag <= 1'b0;
		end
		end
		// PORT A 
//**********************
	
	always @ (posedge clk)
	begin	
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
//**********************
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

//`timescale 1ns/10ps
//
//module img_in_ddr_tb();
//	reg [7:0] data_a, data_b;
//	reg [18:0] addr_a, addr_b;
//	reg we_a, we_b, re_a;
//	reg clk = 0;
//	wire [7:0] q_a, q_b;
//	wire d_ready_we ;
//	wire d_ready_re;

	
//	
//	img_in_ddr img_in_ddr_tb1(
//	.data_a(data_a),
//	.data_b(data_b),
//	.addr_a(addr_a),
//	.addr_b(addr_b),
//	.we_a(we_a),
//	.re_a(re_a),
//	.we_b(we_b),
//	.clk(clk),
//	.q_a(q_a),
//	.q_b(q_b),
//	.d_ready_we(d_ready_we),
//	.d_ready_re(d_ready_re)

//	);
//	
//	always begin
//   #10 clk <= ~clk;
//	end
//	
//	initial begin
//	#10
//	data_a <= 8'b1010_0000;
//	data_b <= 8'b1111_0000;
//	addr_a <= 19'b000_0000_0000_0000_0011;
//	addr_b <= 19'b000_0000_0000_0011_0000;
//	#40
//	we_a <= 1;
//	#20
//	we_a <= 0;
//	
//	re_a <= 1;
//	#20
//	re_a <= 0;
//	#200
//	we_a <= 1;
//	#20
//	we_a <= 0;
//	#60
//	data_a <= 8'b1110_0000;
//	addr_a <= 19'b000_0000_0000_0000_0100;
//	#60
//	we_a <= 1;
//	re_a <= 1;
//	#20
//	we_a <= 0;
//	re_a <= 0;
//	#40
//	data_a <= 8'b1010_0000;
//	addr_a <= 19'b000_0000_0000_0001_0000;
//	re_a <= 1;
//	#20
//	re_a <= 0;
//	#100
//	#100
//	data_a <= 8'b1010_0000;
//	addr_a <= 19'b000_0000_0000_0001_0001;
//	#20
//	we_a <= 1;
//	we_b <= 0;
//	#20
//	we_a <= 0;
//	#40
//	we_a <= 1;
//	we_b <= 0;
//	#20
//	we_a <= 0;
//	#40
//	addr_b <= 19'b000_0000_0000_0011_0000;
//	#40
//	we_b <= 1;
//	#20
//	we_b <= 0;
//	data_a <= 8'b1010_0000;
//	addr_a <= 19'b000_0000_0000_0001_0100;
//	we_a <= 1;
//	we_b <= 0;
//	#20
//	we_a <= 0;
//	#200
//	addr_a <= 19'b000_0000_0000_0001_1000;
//	#60
//	we_a <= 1;
//	#20
//	we_a <= 0;
//	#200
//	
//
//
//
//
//
//	data_a <= 8'b1010_0000;
////	data_b <= 8'b1111_0000;
//	addr_a <= 19'b000_0000_0000_0000_0011;
////	addr_b <= 19'b000_0000_0000_0011_0000;
//	#40
//	we_a <= 1;
//	#20
//	we_a <= 0;
//	#200
////	we_a <= 1;
////	#20
////	we_a <= 0;
////	#60
//	data_a <= 8'b1110_0000;
//	addr_a <= 19'b000_0000_0000_0000_0100;
////	#60
//	we_a <= 1;
//	#20
//	we_a <= 0;
////	#40
////	data_a <= 8'b1010_0000;
////	addr_a <= 19'b000_0000_0000_0001_000;
//	#100
////	#100
//	data_a <= 8'b1010_0000;
//	addr_a <= 19'b000_0000_0000_0001_0001;
////	#20
//	we_a <= 1;
////	we_b <= 0;
//	#20
//	we_a <= 0;
//	#200
//	addr_a <= 19'b000_0000_0000_0000_0011;
////	addr_b <= 19'b000_0000_0000_0011_0000;
//	#200
////	we_a <= 1;
////	#20
////	we_a <= 0;
////	#60
//	data_a <= 8'b1110_0000;
//	addr_a <= 19'b000_0000_0000_0000_0100;
////	#40
////	data_a <= 8'b1010_0000;
////	addr_a <= 19'b000_0000_0000_0001_000;
//	#200
////	#100
//	data_a <= 8'b1010_0000;
//	addr_a <= 19'b000_0000_0000_0000_1001;
////	#20
//	#200
//	
//	$finish;
//	end
//endmodule
	
	
	
	
