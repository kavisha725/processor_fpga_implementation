module UART_FSM
#(parameter INS_ADDR_WIDTH=8, parameter IMG_IN_ADDR_WIDTH=19)
(		input wire clk,
		input wire rx,
		output wire tx,
		input wire rst,
		output reg led_rx = 1'b1,
		output reg led_tx = 1'b1,
		input wire [18:0] RK_val,
		// instruction memory
		input wire [7:0] ram_ins_out,
		output reg ram_ins_we = 0,
		output reg [INS_ADDR_WIDTH-1:0] ram_ins_addr= 0,
		output reg [7:0] ram_ins_in = 0,
		// input image memory
		input wire [7:0] ram_data_out_img_in,
		output reg ram_we_img_in = 0,
		output reg [IMG_IN_ADDR_WIDTH-1:0] ram_addr_img_in = 0,
		output reg [7:0] ram_data_in_img_in = 0,
		// output image memory
		/*input wire [7:0] ram_data_out_img_out,
		output reg ram_we_img_out = 0,
		output reg [IMG_OUT_ADDR_WIDTH-1:0] ram_addr_img_out = 0,
		output reg [7:0] ram_data_in_img_out = 0,*/
		
		output reg start_flag = 1'b0,
		input wire end_flag);

// main states
parameter STATE_CHECK_RX= 5'd0;

parameter STATE_RX1 = 5'd1;
parameter STATE_RX2 = 5'd2;
parameter STATE_RX3 = 5'd3;

parameter STATE_RX_DATA1= 5'd4;
parameter STATE_RX_DATA2= 5'd5;
parameter STATE_RX_DATA3= 5'd6;
parameter STATE_RX_DATA4= 5'd7;
parameter STATE_RX_DATA5= 5'd8;

parameter STATE_TX1 = 5'd9;

parameter STATE_TX_DATA1 = 5'd10;
parameter STATE_TX_DATA2 = 5'd11;
parameter STATE_TX_DATA3 = 5'd12;
parameter STATE_TX_DATA4 = 5'd13;

parameter STATE_TX_BUSY = 5'd14;

parameter STATE_START1 = 5'd15;
parameter STATE_START2 = 5'd16;

parameter STATE_END1 = 5'd17;
parameter STATE_END2 = 5'd18;
parameter STATE_END3 = 5'd19;

//commands
//parameter CMD_RX_IMG = 8'd255;
//parameter CMD_TX_IMG = 8'd254;

// next_state register with initial next_state
reg [4:0] curr_state = STATE_CHECK_RX;
reg [4:0] next_state = STATE_CHECK_RX;

// connectors for serial interface
wire tx_busy_flag;
wire rx_rdy_flag;
wire [7:0] ser_data_out;

reg [7:0] ser_data_in;
reg rx_rdy_clr = 0;	// MAKE THESE 1'b0
reg ser_wr_en = 0;

// ram selection values
parameter IMG_IN_RAM = 2'b0;
parameter INS_RAM = 2'b10;

reg [1:0] ram_sel = IMG_IN_RAM;

// connectors for instruction ram
//wire [7:0] ram_ins_out;
//
//reg ram_ins_we = 0;
//reg [INS_ADDR_WIDTH-1:0] ram_ins_addr= 0;
//reg [7:0] ram_ins_in = 0;

// connectors for image input ram
//wire [7:0] ram_data_out_img_in;
//
//reg ram_we_img_in = 0;
//reg [IMG_IN_ADDR_WIDTH-1:0] ram_addr_img_in = 0;
//reg [7:0] ram_data_in_img_in = 0;

// connectors for image output ram
//wire [7:0] ram_data_out_img_out;
//
//reg ram_we_img_out = 0;
//reg [IMG_OUT_ADDR_WIDTH-1:0] ram_addr_img_out = 0;
//reg [7:0] ram_data_in_img_out = 0;

//other
reg [23:0] len_cnt = 0;

reg [23:0] ins_len = 0;
//reg [23:0] ins_len_cnt = 0;

reg [23:0] input_img_len = 0;
//reg [23:0] input_img_len_cnt = 0;

reg [23:0] output_read_img_len = 0; // from processor
//reg [23:0] output_img_len_cnt = 0;
reg imgo_cnt_sel = 0; // zero for normal , 1 - for processed out

parameter CMD_DEC = 2'd0;
parameter CMD_RX = 2'd1;
parameter CMD_TX = 2'd2;

reg [1:0] mode = CMD_DEC;

parameter BYTE_RX_INS = 8'd255;
parameter BYTE_TX_INS = 8'd254;

parameter BYTE_RX_IMG_I = 8'd253;
parameter BYTE_TX_IMG_I = 8'd252;

parameter BYTE_READ_IMG_O = 8'd249;

parameter BYTE_START = 8'd240;
parameter BYTE_END = 8'd239;


//initial begin
//	led <= 1'b0;
//end
//assign led_rx = ~rx_rdy_flag;
//assign led_tx = ~tx_busy_flag;

always @(posedge clk) begin
	if (rst == 0) begin			// check
		curr_state <= STATE_CHECK_RX;
		next_state <= STATE_CHECK_RX;
		mode <= CMD_DEC;
		rx_rdy_clr <= 1'b0;
		ser_wr_en <= 1'b0;
		
		led_rx <= 1'b1;
		led_tx <= 1'b1;
		//led <= 1'b0;
	end
	
	case(curr_state)
		STATE_CHECK_RX: begin
			if(rx_rdy_flag && !rx_rdy_clr) begin
				led_rx <= 1'b0;
				case(mode)		// select mode
					CMD_DEC: begin
						case(ser_data_out)
							BYTE_RX_IMG_I: begin		// receive image to processor
								next_state <= STATE_RX1;
								curr_state <= STATE_CHECK_RX;
								mode <= CMD_RX;
								//led <= 1'b1;
								
								ram_sel <= IMG_IN_RAM;
							end
							BYTE_TX_IMG_I: begin		// transmit image from processor
								//next_state <= STATE_TX1;
								curr_state <= STATE_TX1;
								mode <= CMD_TX;
								//led <= 1'b1;
								
								ram_sel <= IMG_IN_RAM;
								imgo_cnt_sel <= 1'b0;
							end
	
							BYTE_READ_IMG_O: begin		// transmit image from processor
								//next_state <= STATE_TX1;
								curr_state <= STATE_TX1;
								mode <= CMD_TX;
								//led <= 1'b1;
								
								ram_sel <= IMG_IN_RAM;
								imgo_cnt_sel <= 1'b1;
								
							end
							BYTE_RX_INS: begin
								next_state <= STATE_RX1;
								curr_state <= STATE_CHECK_RX;
								mode <= CMD_RX;
								//led <= 1'b1;
								
								ram_sel <= INS_RAM;
							end
							BYTE_TX_INS: begin		// transmit image from processor
								//next_state <= STATE_TX1;
								curr_state <= STATE_TX1;
								mode <= CMD_TX;
								//led <= 1'b1;
								
								ram_sel <= INS_RAM;
							end
							
							BYTE_START: begin		// start processing
								//next_state <= STATE_TX1;
								curr_state <= STATE_START1;
								//led <= 1'b1;
								start_flag <= 1'b1;
							end
							
							default: begin
								curr_state <= STATE_CHECK_RX;
							end
						endcase
					end
					CMD_RX: begin
						curr_state <= next_state;
					end
					CMD_TX: begin
						curr_state <= next_state;
					end
					default: begin
						curr_state <= STATE_CHECK_RX;
					end
				endcase
				
				rx_rdy_clr <= 1'b1;
			end
			else if(end_flag) begin
				curr_state <= STATE_END1;
				
				output_read_img_len <= {5'b0, RK_val} + 24'b1;  // assuming RK goes from zero to last address
			end
			else begin
				rx_rdy_clr <= 1'b0;
				curr_state <= STATE_CHECK_RX;
				led_rx <= 1'b1;
			end
		end
		
		STATE_RX1: begin		// MSB1
			rx_rdy_clr <= 1'b0;
			next_state <= STATE_RX2;
			curr_state <= STATE_CHECK_RX;
			
			if (ram_sel == INS_RAM) begin
				ins_len[23:16] <= ser_data_out;
			end
			else begin
				input_img_len[23:16] <= ser_data_out;
			end
			
			//led <= 1'b0;
		end
		
		STATE_RX2: begin		// MSB2
			next_state <= STATE_RX3;
			curr_state <= STATE_CHECK_RX;
			
			if (ram_sel == INS_RAM) begin
				ins_len[15:8] <= ser_data_out;
			end
			else begin
				input_img_len[15:8] <= ser_data_out;
			end
			
			//input_img_len[15:8] <= ser_data_out;
			//led <= 1'b1;
		end
		
		STATE_RX3: begin		// MSB3
			next_state <= STATE_RX_DATA1;
			curr_state <= STATE_CHECK_RX;
			
			//input_img_len[7:0] <= ser_data_out;
			//input_img_len_cnt <= 24'b0;
			if (ram_sel == INS_RAM) begin
				ins_len[7:0] <= ser_data_out;
				//ins_len_cnt <= 24'b0;
			end
			else begin
				input_img_len[7:0] <= ser_data_out;
				//input_img_len_cnt <= 24'b0;
			end
			len_cnt <= 24'b0;
			//led <= 1'b0;
		end
		
		STATE_RX_DATA1: begin		// write data to ram
			curr_state <= STATE_RX_DATA2;
			
			if (ram_sel == INS_RAM) begin
				ram_ins_addr <= len_cnt[INS_ADDR_WIDTH-1:0];
				ram_ins_in <= ser_data_out;
				ram_ins_we <= 1'b1;
			end
			else begin
				ram_addr_img_in <= len_cnt[IMG_IN_ADDR_WIDTH-1:0];
				ram_data_in_img_in <= ser_data_out;
				ram_we_img_in <= 1'b1;
			end
			//led <= 1'b1;
		end
		
		STATE_RX_DATA2: begin		// idle cycle
			curr_state <= STATE_RX_DATA3;			
		end
		
		STATE_RX_DATA3: begin		// write data to ram
			curr_state <= STATE_RX_DATA4;
			
			if (ram_sel == IMG_IN_RAM) begin
				ram_we_img_in <= 1'b0;
			end
			else begin
				ram_ins_we <= 1'b0;
			end
		end
		
		STATE_RX_DATA4: begin		// 
			curr_state <= STATE_RX_DATA5;
			//input_img_len_cnt <= input_img_len_cnt + 24'b1;
			len_cnt <= len_cnt + 24'b1;
			/*if (ram_sel == IMG_IN_RAM) begin
				input_img_len_cnt <= input_img_len_cnt + 24'b1;
			end
			else if (ram_sel == INS_RAM) begin
				ins_len_cnt <= ins_len_cnt + 24'b1;
			end
			else begin
				output_img_len_cnt <= output_img_len_cnt + 24'b1;
			end*/
		end
		
		STATE_RX_DATA5: begin		// 
		
			if(((len_cnt == input_img_len)&&(ram_sel == IMG_IN_RAM)) || 
				((len_cnt == ins_len)&&(ram_sel == INS_RAM)) ) begin
				
				curr_state <= STATE_CHECK_RX;
				mode <= CMD_DEC;
				//led <= 1'b0;
			end
			else begin
				next_state <= STATE_RX_DATA1;
				curr_state <= STATE_CHECK_RX;
			end
			
		end
//***********************************************************************		
		
		STATE_TX1: begin		// Minitialise
			rx_rdy_clr <= 1'b0;
			//next_state <= STATE_RX2;
			curr_state <= STATE_TX_DATA1;
			
			//input_img_len_cnt <= 24'b0;
			len_cnt <= 24'b0;
			/*if (ram_sel == IMG_IN_RAM) begin
				input_img_len_cnt <= 24'b0;
			end
			else if (ram_sel == INS_RAM) begin
				ins_len_cnt <= 24'b0;
			end
			else begin
				output_img_len_cnt <= 24'b0;
			end*/
			//led <= 1'b0;
		end
		
		STATE_TX_DATA1: begin		// Minitialise
			//next_state <= STATE_RX2;
			led_tx <= 1'b0;
			curr_state <= STATE_TX_BUSY;
			
			if (ram_sel == IMG_IN_RAM) begin
				ram_addr_img_in <= len_cnt[IMG_IN_ADDR_WIDTH-1:0];
			end
			else begin
				ram_ins_addr <= len_cnt[INS_ADDR_WIDTH-1:0];
			end
			//led <= 1'b0;
		end
		
		STATE_TX_BUSY: begin		// Minitialise
			//next_state <= STATE_RX2;

			if(tx_busy_flag) begin
				curr_state <= STATE_TX_BUSY;
			end
			else begin
				curr_state <= STATE_TX_DATA2;
			end
			//led <= 1'b0;
		end
		
		STATE_TX_DATA2: begin		// Minitialise
			//next_state <= STATE_RX2;
			curr_state <= STATE_TX_DATA3;
			
			if (ram_sel == IMG_IN_RAM) begin
				ser_data_in <= ram_data_out_img_in;
			end
			else begin
				ser_data_in <= ram_ins_out;
			end
			ser_wr_en <= 1'b1;
			//led <= 1'b0;
		end
		
		STATE_TX_DATA3: begin		// Minitialise
			//next_state <= STATE_RX2;
			curr_state <= STATE_TX_DATA4;
			
			ser_wr_en <= 1'b0;
			len_cnt <= len_cnt + 24'b1;
			//led <= 1'b0;
		end
		
		STATE_TX_DATA4: begin		// Minitialise
			//next_state <= STATE_RX2;
			
			if (((len_cnt == input_img_len)&&(ram_sel == IMG_IN_RAM)&&(imgo_cnt_sel == 1'b0)) || 
				((len_cnt == ins_len)&&(ram_sel == INS_RAM)) || 
				((len_cnt == output_read_img_len)&&(ram_sel == IMG_IN_RAM)&&(imgo_cnt_sel == 1'b1))) begin
				
				curr_state <= STATE_CHECK_RX;
				mode <= CMD_DEC;
				//led <= 1'b0;
			end
			else begin
				curr_state <= STATE_TX_DATA1;
			end
			//led <= 1'b0;
			led_tx <= 1'b1;
		end
		
		STATE_START1: begin
			rx_rdy_clr <= 1'b0;
			curr_state <= STATE_START2;
		end
		
		STATE_START2: begin
			curr_state <= STATE_CHECK_RX;
			start_flag <= 1'b0;
		end
		
		STATE_END1: begin	
			rx_rdy_clr <= 1'b0;
			
			if(tx_busy_flag) begin
				curr_state <= STATE_END1;
			end
			else begin
				curr_state <= STATE_END2;
				ser_data_in <= 8'd239;
				ser_wr_en <= 1'b1;
			end		
		end
		
		STATE_END2: begin		
			curr_state <= STATE_END3;
			//ser_wr_en <= 1'b0;
		end
		
		STATE_END3: begin		// additional delay to avoid sending two flags
			curr_state <= STATE_CHECK_RX;
			ser_wr_en <= 1'b0;
		end
		
		default: begin
			curr_state <= STATE_CHECK_RX;
		end
	endcase
end

	uart uart1(ser_data_in,
		ser_wr_en,
		clk,
		tx,
		tx_busy_flag,
		rx,
		rx_rdy_flag,
		rx_rdy_clr,
		ser_data_out);
	 
	/*single_port_ram ram_img_in(ram_data_in_img_in,
		ram_addr_img_in,
		ram_we_img_in,
		clk,
		ram_data_out_img_in);
	
	single_port_ram ram_INS(ram_ins_in,
		ram_ins_addr,
		ram_ins_we,
		clk,
		ram_ins_out);*/

endmodule