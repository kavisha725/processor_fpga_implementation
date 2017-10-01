module DoutMux#(
parameter     DATA_WIDTH                =8
)
(
input                                   Select,
input         [(DATA_WIDTH-1):0]        CashData,
input         [(DATA_WIDTH-1):0]        MemData,
output reg    [(DATA_WIDTH-1):0]        DataOut
    );
	 
	 /*reg [1:0] memory_data_sel=0;
	 always begin
		memory_data_sel=memory_data_select;
	 end*/
	 
	 always @* 
	 begin
		case (Select)
			1'b1: begin
						DataOut=MemData;
						//$display($time,"*****Data is selected from memory  : 00 ****");
					end
			1'b0: begin 
						DataOut=CashData;
						//$display($time,"*****Data is selected from cache*****");
					end
		endcase
	end
endmodule