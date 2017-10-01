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

module ddr_sim//_single_clock
//#(parameter DATA_WIDTH=8, parameter ADDR_WIDTH=8)
(
	input [7:0] data_a, data_b,
	input [18:0] addr_a, addr_b,
	input we_a, we_b, clk,
	output reg [7:0] q_a, q_b,
	output reg d_ready_we = 1'b0,
	output reg d_ready_re = 1'b0
);

	// Declare the RAM variable
	reg [7:0] ram[263168:0]; // 25800 160x160  32768 262144
	parameter DELAY = 8'd7;
	reg [18:0] prev_addr;
	reg [7:0] delay_temp = 8'b0;//
	reg [18:0] prev_addr_a1 = 19'b0;
	reg [18:0] prev_addr_a2 = 19'b0;
	reg [18:0] prev_addr_a;
	reg we_flag = 1'b0;
	reg addrs_change_flag = 1'b0;
	reg strt_count = 1'b0;
	reg delay = 1'b0;
	reg [7:0] counter = 8'b0;
	
		
	always @ (posedge clk)
	begin	
//**************************************************************	
		 case(1)
		((we_flag == 1'b1 || we_a == 1'b1 ) && addrs_change_flag == 1): begin  // adress change and then write enable;write ready given out
			  
//here it makes sure that if a write enable comes aftr a clock cycle to a neighbour address change, write ready is   given  insted of read ready
			 if (addr_a == prev_addr_a2 + 19'd1)begin
				case(1)
				(counter > 8'd2):begin
					delay <= 1'b1;
				end
				(delay == 1'b1):begin
					d_ready_we <= 1'b1;
					delay <=  1'b0;
				end
				(counter <= 8'd2):begin
					d_ready_we <= 1'b1;
				end
				endcase
			end	
			
			else 
			begin
				strt_count <= 1'b1;
				delay_temp <= delay_temp + 8'b1;
				if (DELAY == delay_temp) begin
					strt_count <= 1'b0;
					d_ready_we <= 1'b1;
					delay_temp <= 8'b0;
				end
			end
		end
		
		((we_flag == 1'b0) && addrs_change_flag == 1'b1):begin // no write enable aftr address change, read ready comes
			if (addr_a == prev_addr_a2 + 19'd1)begin
				d_ready_re <= 1'b1;						
			end
			else 
			begin
				strt_count <= 1'b1;
				delay_temp <= delay_temp + 8'b1;
				if (DELAY == delay_temp) begin
					strt_count <= 1'b0;
					d_ready_re <= 1'b1;
					delay_temp <= 8'b0;
				end
			end
		end
		
		((we_flag == 1'b1 ) && addrs_change_flag == 1'b0): begin // no adress change just write enable, special case after data being 		available for a  read or a write beforehand
			d_ready_we <= 1'b1;
			d_ready_re <= 1'b0;
		end
		default:begin
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
			we_flag <= 1'b1;
			delay_temp <= 8'b0;
			strt_count <= 1'b0;
		end
		
		if (d_ready_we == 1'b1 || d_ready_re == 1'b1)
		begin
			d_ready_we <= 1'b0;
			d_ready_re <= 1'b0;
			we_flag <= 1'b0;	
			addrs_change_flag <= 1'b0;
			delay_temp <= 8'b0;
			strt_count <= 1'b0;
			delay <= 1'b0;
			
		end
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

always @(clk) begin
	if (addrs_change_flag == 1'b1)
			counter <= counter + 8'b1;
	if (we_a == 1'b1)
		counter <= 8'b0;
	end

endmodule

