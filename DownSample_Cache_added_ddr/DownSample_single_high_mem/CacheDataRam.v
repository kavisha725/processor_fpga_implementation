module CacheDataRam#(
parameter     DATA_WIDTH                =8, 
parameter     CACHE_ADDR_SIZE           =10

)
(
input         [(CACHE_ADDR_SIZE-1):0]   Address,
input         [(DATA_WIDTH-1):0]        DataIn,
input                                   Write,
input                                   Clk,

output reg    [(DATA_WIDTH-1):0]        DataOut
);

reg           [(DATA_WIDTH-1):0]        DataRam[0:(2**(CACHE_ADDR_SIZE)-1)];

//always @ (Write) begin
//   $display($time, " DataRam>   Write %b", Write);
//end

always @ (negedge Clk) begin
   if (Write) begin             // Write
//      $display($time, " DataRam> write %d to %d", DataIn, Address);
      DataRam[Address]      				=DataIn;
   end
end

always @ (negedge Clk) begin        // Read
   DataOut   									=DataRam[Address];
end
endmodule 