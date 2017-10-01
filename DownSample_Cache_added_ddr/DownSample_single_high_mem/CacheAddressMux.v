module CacheAddressMux#(
parameter     ADDRESS_WIDTH                =10
)
(
input                                   Select,
input         [(ADDRESS_WIDTH-1):0]        FSMAddress,
input         [(ADDRESS_WIDTH-1):0]        ProcessorAddress,
output reg    [(ADDRESS_WIDTH-1):0]        Address
    );
	 
	 /*reg [1:0] memory_data_sel=0;
	 always begin
		memory_data_sel=memory_data_select;
	 end*/
	 
	 always @* 
	 begin
		case (Select)
			1'b1: begin
						Address=FSMAddress;
						//$display($time,"*****Data is selected from memory  : 00 ****");
					end
			1'b0: begin 
						Address=ProcessorAddress;
						//$display($time,"*****Data is selected from cache*****");
					end
		endcase
	end
endmodule