// ************************ too much logic units in this implementation
//module memory_unit(input wire clk,
//							// CPU side
//							/*input wire [7:0] M_I_data_CPU,*/
//							input wire [7:0] M_I_addr_CPU,
//							input wire M_I_re_CPU,
//							output reg [7:0] M_I_q_CPU,
//							
//							/*input wire [7:0] MI_IMG_data_CPU,*/
//							input wire [14:0] MI_IMG_addr_CPU,
//							input wire MI_IMG_re_CPU, 
//							output reg [7:0] MI_IMG_q_CPU,
//							
//							input wire [7:0] MO_IMG_data_CPU,
//							input wire [12:0] MO_IMG_addr_CPU,
//							input wire MO_IMG_we_CPU,
//							/*output wire [7:0] MO_IMG_q_CPU,*/
//							
//							// UART side
//							input wire [7:0] M_I_data_UART,
//							input wire [7:0] M_I_addr_UART,
//							input wire M_I_we_UART,
//							output reg [7:0] M_I_q_UART,
//							
//							input wire [7:0] MI_IMG_data_UART,
//							input wire [14:0] MI_IMG_addr_UART,
//							input wire MI_IMG_we_UART, 
//							output reg [7:0] MI_IMG_q_UART,
//							
//							input wire [7:0] MO_IMG_data_UART,
//							input wire [12:0] MO_IMG_addr_UART,
//							input wire MO_IMG_we_UART,
//							output reg [7:0] MO_IMG_q_UART);
//	
//	reg [7:0] M_I_data;
//	reg [7:0] M_I_addr;
//	reg M_I_we;
//	wire [7:0] M_I_q;
//	
//	reg [7:0] MI_IMG_data;
//	reg [14:0] MI_IMG_addr;
//	reg MI_IMG_we;
//	wire [7:0] MI_IMG_q;
//	
//	reg [7:0] MO_IMG_data;
//	reg [12:0] MO_IMG_addr;
//	reg MO_IMG_we;
//	wire [7:0] MO_IMG_q;
//	
//	always @(*) begin
//		if (M_I_re_CPU) begin
//			M_I_data = 8'b0;
//			M_I_addr = M_I_addr_CPU;
//			M_I_we = 1'b0;
//			M_I_q_CPU = M_I_q;
//		end
//		else begin
//			M_I_data = M_I_data_UART;
//			M_I_addr = M_I_addr_UART;
//			M_I_we = M_I_we_UART;
//			M_I_q_UART = M_I_q;
//		end
//	end
//	
//	always @(*) begin
//		if (MI_IMG_re_CPU) begin
//			MI_IMG_data = 8'b0;
//			MI_IMG_addr = MI_IMG_addr_CPU;
//			MI_IMG_we = 1'b0;
//			MI_IMG_q_CPU = MI_IMG_q;
//		end
//		else begin
//			MI_IMG_data = MI_IMG_data_UART;
//			MI_IMG_addr = MI_IMG_addr_UART;
//			MI_IMG_we = MI_IMG_we_UART;
//			MI_IMG_q_UART = MI_IMG_q;
//		end
//	end
//	
//	always @(*) begin
//		if (MO_IMG_we_CPU) begin
//			MO_IMG_data = MO_IMG_data_CPU;
//			MO_IMG_addr = MO_IMG_addr_CPU;
//			MO_IMG_we = MO_IMG_we_CPU;
//			MO_IMG_q_UART = MO_IMG_q;  // connected to uart (to stop floating)
//		end
//		else begin
//			MO_IMG_data = MO_IMG_data_UART;
//			MO_IMG_addr = MO_IMG_addr_UART;
//			MO_IMG_we = MO_IMG_we_UART;
//			MO_IMG_q_UART = MO_IMG_q;
//		end
//	end
//	
//ins_ram M_INS(M_I_data,
//					M_I_addr,
//					M_I_we, 
//					clk,
//					M_I_q);
//							
//img_in_ram MI_IMG(MI_IMG_data,
//						MI_IMG_addr,
//						MI_IMG_we, 
//						clk,
//						MI_IMG_q);
//							
//img_out_ram MO_IMG(MO_IMG_data,
//						MO_IMG_addr,
//						MO_IMG_we, 
//						clk,
//						MO_IMG_q);
//endmodule

module memory_unit(input wire clk,
							// CPU side port a
							/*input wire [7:0] M_I_data_CPU,*/
							input wire [7:0] M_I_addr_CPU,
							input wire M_I_re_CPU,
							output wire [7:0] M_I_q_CPU,
							
							input wire [7:0] MI_IMG_data_CPU,
							input wire [18:0] MI_IMG_addr_CPU_read,
							input wire [18:0] MI_IMG_addr_CPU_write,
							input wire MI_IMG_re_CPU,
							input wire MI_IMG_we_CPU,
							output wire [7:0] MI_IMG_q_CPU,
							
							// UART side port b
							input wire [7:0] M_I_data_UART,
							input wire [7:0] M_I_addr_UART,
							input wire M_I_we_UART,
							output wire [7:0] M_I_q_UART,
							
							input wire [7:0] MI_IMG_data_UART,
							input wire [18:0] MI_IMG_addr_UART,
							input wire MI_IMG_we_UART, 
							output wire [7:0] MI_IMG_q_UART);
	
	//supply0 [7:0] M_I_data_CPU;
	//supply0 [7:0] MI_IMG_data_CPU;
	//input wire M_I_re_CPU
//parameter addr_width = 19;
wire [18:0] MI_IMG_addr_CPU;

assign MI_IMG_addr_CPU = (MI_IMG_we_CPU == 1'b1) ? MI_IMG_addr_CPU_write : MI_IMG_addr_CPU_read;
	
ins_ram M_INS(M_I_data_UART,
					M_I_addr_CPU,M_I_addr_UART,
					M_I_re_CPU, M_I_we_UART,
					clk,
					M_I_q_CPU,M_I_q_UART);
							
img_in_ram MI_IMG(MI_IMG_data_CPU,MI_IMG_data_UART,
						MI_IMG_addr_CPU,MI_IMG_addr_UART,
						MI_IMG_we_CPU, MI_IMG_we_UART,
						clk,
						MI_IMG_q_CPU,MI_IMG_q_UART);

endmodule