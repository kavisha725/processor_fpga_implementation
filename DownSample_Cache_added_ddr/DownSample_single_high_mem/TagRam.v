module TagRam #(
parameter     TAG_ADDR_WIDTH            =8, 
parameter     TAG_LENGTH                =9
)


(
input        [(TAG_ADDR_WIDTH-1):0]      Address,    //only 8 bits from the total 10 TAG = 10-2*
input        [(TAG_LENGTH-1):0]          TagIn,
input                                    Write,
input                                    Clk,
output  reg  [(TAG_LENGTH-1):0]          TagOut
);

reg          [TAG_LENGTH-1:0]            TagRam[0:(2**TAG_ADDR_WIDTH-1)];

always @ (negedge Clk)          // Write
   if (Write) begin
//      $display($time, " TagRam> store addr %d  tag %d", Address, TagIn);
      TagRam[Address]  					= TagIn;
   end

always @ (negedge Clk) begin    // Read
   TagOut 								= TagRam[Address];
//   $display($time, " TagRam> tag of %d = %d", Address, TagOut);
end
endmodule 