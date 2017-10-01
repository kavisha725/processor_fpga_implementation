module top_mod
#(parameter INS_ADDR_WIDTH=8, parameter IMG_IN_ADDR_WIDTH=15)
(		input wire clk,
		input wire rx,
		output wire tx,
		input wire rst,
		output wire led_rx,
		output wire led_tx
);

// processor side port a
wire START_FLAG,END_FLAG;

wire [7:0] M_I_addr_CPU;
wire M_I_re_CPU;
wire [7:0] M_I_q_CPU;

wire [18:0] MI_IMG_addr_CPU;
//wire [18:0] MI_IMG_addr_CPU_2;
wire MI_IMG_re_CPU;
wire [7:0] MI_IMG_q_CPU;

wire [7:0] MO_IMG_data_CPU;
wire [18:0] MO_IMG_addr_CPU;
//wire [15:0] MO_IMG_addr_CPU2;
wire MO_IMG_we_CPU;

// UART side port b
wire [7:0] M_I_data_UART;
wire [INS_ADDR_WIDTH-1:0] M_I_addr_UART;
wire M_I_we_UART;
wire [7:0] M_I_q_UART;

wire [7:0] MI_IMG_data_UART;
wire [18:0] MI_IMG_addr_UART;
wire MI_IMG_we_UART;
wire [7:0] MI_IMG_q_UART;
wire d_ready_re;
wire d_ready_we;
					
//wire [23:0] rk_val_2_cnt ;

//assign MI_IMG_addr_CPU_2 = {4'b0,MI_IMG_addr_CPU};
//assign MO_IMG_addr_CPU2 = {3'b0,MO_IMG_addr_CPU};
//assign rk_val_2_cnt = {8'b0,MO_IMG_addr_CPU};

processor cpu1(	clk,
						rst,
						START_FLAG,
						END_FLAG,
						// instruction memory
						M_I_q_CPU,
						M_I_addr_CPU,
						M_I_re_CPU,
						// input image memory
						MI_IMG_q_CPU,
						MI_IMG_addr_CPU,
						MI_IMG_re_CPU,
						
						d_ready_re,
						// output image memory
						MO_IMG_data_CPU,
						MO_IMG_addr_CPU,
						MO_IMG_we_CPU,
						d_ready_we);

memory_unit mu1(	clk,
						// CPU side port a
						M_I_addr_CPU[INS_ADDR_WIDTH-1:0],
						M_I_re_CPU,
						M_I_q_CPU,
						
						MO_IMG_data_CPU,
						MI_IMG_addr_CPU,//[IMG_IN_ADDR_WIDTH-1:0],
						MO_IMG_addr_CPU,//[IMG_IN_ADDR_WIDTH-1:0],
						MI_IMG_re_CPU, 
						MO_IMG_we_CPU,
						MI_IMG_q_CPU,
						
						d_ready_re,
						d_ready_we,
						
						// UART side port b
						M_I_data_UART,
						M_I_addr_UART,
						M_I_we_UART,
						M_I_q_UART,
						
						MI_IMG_data_UART,
						MI_IMG_addr_UART,
						MI_IMG_we_UART, 
						MI_IMG_q_UART);

UART_FSM uart_fsm1(clk,
						rx,
						tx,
						rst,
						led_rx,
						led_tx,
						MO_IMG_addr_CPU, // RK value
						
						// instruction memory						
						M_I_q_UART,
						M_I_we_UART,
						M_I_addr_UART,
						M_I_data_UART,
						
						// input image memory						
						MI_IMG_q_UART,
						MI_IMG_we_UART,
						MI_IMG_addr_UART,
						MI_IMG_data_UART,

						START_FLAG,
						END_FLAG);
endmodule