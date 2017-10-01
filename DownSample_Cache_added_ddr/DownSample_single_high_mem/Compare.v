module Compare#(
parameter     TAG_LENGTH                =9
)
(
input         [(TAG_LENGTH-1):0]        CashTag,
input         [(TAG_LENGTH-1):0]        MemTag,
output reg                              Match
);
	 always @*
	 begin
		if (CashTag==MemTag)begin
			Match									=1'b1;
		end else begin
			Match									=1'b0;
		end
	 end
endmodule
