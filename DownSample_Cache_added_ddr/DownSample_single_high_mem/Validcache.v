module Validcache #( 
parameter     TAG_ADDR_WIDTH            =8
)

(
input         [(TAG_ADDR_WIDTH-1):0]           Address,
input                                          ValidIn,
input                                          Write,
input                                          Reset,
input                                          Clk,
output         reg                             ValidOut
);

reg            [(2**TAG_ADDR_WIDTH-1):0]       ValidBits;

integer i;

always @ (negedge Clk)          // Write or Reset
   if (Write && !Reset) begin           // Write
//      $display($time, " ValidRam> write valid bit (%b) of %d", ValidIn, Address);
      ValidBits[Address]       				  = ValidIn;
   end
   else if (Reset)                      // Reset
      for (i=0; i<(2**TAG_ADDR_WIDTH-1); i=i+1)
         ValidBits[i]                         = 0;

always @ (negedge Clk) begin    // Read
   ValidOut                                   = ValidBits[Address];
//   $display($time, " ValidRam> valid bit of %d = %d", Address, ValidOut);
end

endmodule 