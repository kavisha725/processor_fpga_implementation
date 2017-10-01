module FSMControl#(
parameter     ADDRESS_LENGTH            =19
)
(
input                                   WriteIn,
input 											 ReadIn,
input                                   Match,
input                                   Valid,
input                                   Clk,
input                                   ResetFlag,
input                                   Memory_Cache_Read_Ready,
input                                   Memory_Cache_Write_Ready,
input 		[18:0]                      Processor_Cache_Address,



output reg 		                         Cache_Write_Enable,              // 1= write to cashs
output reg 		                         Select_DataOut_Memory_cache,        // 1 = memory
output reg                              Select_CacheAddrss_FSM_Address,    // 0 = processor 1= fsm address
output reg                              Ram_Write,    // 0 = memory 1= fsm addres
output reg                              Ram_Read,
output reg                              Tag_Write,               
output reg                              Valid_Write,
output reg                              Valid_Bit,
output reg                              Cache_Processor_Read_Ready,
output reg                              Cache_Processor_Write_Ready,
output reg [18:0]                       Cache_RAMportB_Address,
output reg [9:	0]                       Cache_DataCache_Address            //10 bits

);
	 
	 
	 
	 reg Write_Sample                    		=0;
	 reg MReady_Read_sample              		=0;
	 reg MReady_Write_sample             		=0;
	 reg Read_Sample                     		=0;
	 reg [18:0] Address_sample           		=19'd0;
	 reg [16:0] Address_temp             		=19'd0;
	 reg [1:0]  temp                     		=2'd0;
	 localparam [2:0] idle=3'd0, Write_Wait=3'd1, Read_Wait=3'd2, Data_Load_1st=3'd3,Data_Load_2nd=3'd4,Data_Load_3rd=3'd5,Reset_State=3'd6;
	 reg [2:0] state                     		=3'd0;
	 
	 always @(negedge Clk)
	 begin 
		Write_Sample 							<= WriteIn;
		Read_Sample 							<= ReadIn;
		MReady_Read_sample 					<= Memory_Cache_Read_Ready;
		MReady_Write_sample 					<= Memory_Cache_Write_Ready;
		Address_sample 						<=Processor_Cache_Address;
		if(ResetFlag) begin
		end
	 end
	 
	 always @(posedge Clk)
	 begin
		case (state)
			idle: if(Read_Sample) begin
						if (Match && Valid) begin
							$display($time, " [FSM] Read - Matched and Valid ");
							Cache_Processor_Read_Ready			<=1'd1;
							state 									<=Reset_State;
						end
						else begin
							$display($time, " [FSM] Read - Not valid or matched ");
							Select_CacheAddrss_FSM_Address   <=1'd1;      //1 = to cache address from fsm
							Cache_RAMportB_Address				<=Address_sample;    // first address to memory
							Ram_Read									<=1'd1;
							Cache_Write_Enable					<=1'd1;
							Cache_DataCache_Address				<=Address_sample[9:0];
							Address_temp							<=Address_sample[18:2];
							temp[1:0] 								<=Address_sample[1:0]+1;
							$display("[FSM] address temp %b temp %b",Address_sample[18:2],Address_sample[1:0]);
							Select_DataOut_Memory_cache 		<=1'd1;       // first data from memory
							Valid_Bit								<=1'd1;
							Valid_Write								<=1'd1;
							Tag_Write								<=1'd1;
							state 									<=Read_Wait;							
						end
					end
					else if (Write_Sample) begin
						if (Match && Valid) begin
							$display($time, "[FSM] Write - Matched And VAlid");
							Valid_Bit								<=1'd0;
							Valid_Write								<=1'd1;
							Cache_RAMportB_Address				<=Address_sample;
							Ram_Write								<=1'd1;
							state 									<= Write_Wait;
						end
						else begin
							$display($time, "[FSM] Write - Not Valid Or marched");
							state										<= Write_Wait;
							Cache_RAMportB_Address				<=Address_sample;
							Ram_Write								<=1'd1;
						end
					end
					else begin
						state											<=idle;
					end
			Reset_State: begin
								$display($time, "[FSM] Reset");
								Cache_Processor_Read_Ready		<=1'd0;
								Cache_Processor_Write_Ready	<=1'd0;
								Valid_Write							<=1'd0;
								Valid_Bit							<=1'd1;
								Ram_Write							<=1'd0;
								Tag_Write							<=1'd0;
								Select_CacheAddrss_FSM_Address<=1'd0;
								Select_DataOut_Memory_cache	<=1'd0;
								Cache_Write_Enable				<=1'd0;
								state 								<=idle;
							end
			
			Write_Wait: if(MReady_Write_sample) begin
								$display($time, "[FSM] Write Wait Ready Received");
								Cache_Processor_Write_Ready 	<=1'd1;
								Ram_Write							<=1'd0;
								state 								<=Reset_State;
							end
							else begin
								$display($time, "[FSM] Write Wait ******");
								Valid_Write							<=1'd0;
								Ram_Write 							<=1'd0;     //only for 1 clock cycle 
								state 								<=Write_Wait;
							end
			Read_Wait:  if(MReady_Read_sample) begin                              //1st data in the cache
								$display($time, "[FSM] Read Wait 1 Ready Received  1 data in cache");
								Ram_Read 							<=1'd1;
								$display("[FSM] read wait address temp %b temp %b",Address_temp,temp);
								Cache_RAMportB_Address 			<={Address_temp,(temp[1:0])};    //addresing 2nd data 
								Cache_DataCache_Address 		<={Address_temp[7:0],temp[1:0]};  //geting ready for  2nd Data input
 								Cache_Processor_Read_Ready 	<=1'd1;
								temp[1:0] 							<=temp+1;
								state 								<=Data_Load_1st;
								
							end
							else begin
								$display($time, "[FSM] Read Wait 1 *****");
								Ram_Read 							<=1'd0;                                       //fist clock after addressing 
								Tag_Write 							<=1'd0;
								Valid_Write 						<=1'd0;
								state 								<=Read_Wait;
							end
			Data_Load_1st:if(MReady_Read_sample) begin                            //2nd data in the cache
								$display($time, "[FSM] Read Wait 2 Ready Received  2 data in cache");
								Cache_Processor_Read_Ready 	<=1'd0;
								Ram_Read 							<=1'd1;
								Cache_RAMportB_Address 			<={Address_temp,temp[1:0]};    //addresing 3rd data 
								Cache_DataCache_Address 		<={Address_temp[7:0],temp[1:0]};  //geting ready for  3rd Data input
								temp[1:0] 							<=temp+1;
								state 								<=Data_Load_2nd;
								
							end
							else begin
								$display($time, "[FSM] Read Wait 2 *****");
								Cache_Processor_Read_Ready 	<=1'd0;
								Ram_Read 							<=1'd0;
								state 								<=Data_Load_1st;
							end
			
			Data_Load_2nd:if(MReady_Read_sample) begin                            //3rd data in the cache
								$display($time, "[FSM] Read Wait 3 Ready Received  3 data in cache");
								Ram_Read 							<=1'd1;
								Cache_RAMportB_Address 			<={Address_temp,temp[1:0]};    //addresing 4th data 
								Cache_DataCache_Address 		<={Address_temp[7:0],temp[1:0]};  //geting ready for  4th Data input
								temp[1:0] 							<=temp+1;
								state 								<=Data_Load_3rd;
								
							end
							else begin
								$display($time, "[FSM] Read Wait 3 *****");
								Ram_Read 							<=1'd0;
								state 								<=Data_Load_2nd;
							end

			Data_Load_3rd:if(MReady_Read_sample) begin                            //4th data in the cache
								$display($time, "[FSM] Read Wait 4 Ready Received  4 data in cache");

								temp 									<=2'd0;
								state 								<=Reset_State;
								
							end
							else begin
								$display($time, "[FSM] Read Wait 4 *****");
								Ram_Read 							<=1'd0;
								state 								<=Data_Load_3rd;
							end
			default: state 										<=idle;	
		endcase
	 end
endmodule


