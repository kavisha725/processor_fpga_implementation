module CacheTop#(
parameter     DATA_WIDTH                =8,
parameter     ADDRESS_LENGTH            =19,
parameter     TAG_LENGTH           		 =9,
parameter     CASHE_ADDRESS_LENGTH      =10,
parameter     CASHE_BIT_DEPTH           =2

)
(
input                                   Clk,//dfsdf
input                                   ResetFlag,

input                                   ProcessorWriteEnIn,
input                                   ProcessorReadEnIn,
input 		[(DATA_WIDTH-1):0]          ProcessorDataIn,
input 		[(ADDRESS_LENGTH-1):0]      ProcessorAddressIn,

output                                	 ProcessorWriteReadyOut,
output                               	 ProcessorReadReadyOut,
output 		[(DATA_WIDTH-1):0]          ProcessorDataOut,


input                             	    DdrWriteReadyIn,
input                             		 DdrReadReadyIn,
input			[(DATA_WIDTH-1):0]          DdrDataIn,

output                                  DdrWriteEnOut,
output                                  DdrReadEnOut,
output 	 	[(DATA_WIDTH-1):0]          DdrDataOut,
output 	   [(ADDRESS_LENGTH-1):0]      DdrAddressOut
);


wire  [(ADDRESS_LENGTH-CASHE_ADDRESS_LENGTH-1):0]   Tag_Compare_AddressBUS;
wire  											Compare_Fsm_WIRE;
wire  											Valid_Fsm_WIRE;
wire  											Fsm_CacheMem_WriteEn_Wire;
wire  											Fsm_DataOutMux_Select_Wire;
wire  											Fsm_CacheAddressMux_Select_Wire;
wire  											Fsm_TagMem_WriteEn_Wire;
wire  											Fsm_ValidMem_WriteEn_Wire;
wire  											Fsm_ValidMem_DataBit_Wire;
wire  [(CASHE_ADDRESS_LENGTH-1):0]     Fsm_CacheAddressMux_AddressBUS;
wire  [(CASHE_ADDRESS_LENGTH-1):0]     CacheAddressMux_CacheMem_AddressBUS;
wire  [(DATA_WIDTH-1):0]     				CacheMem_CacheAddressMux_DataBUS;
wire 												InterConnect;

assign DdrDataOut=ProcessorDataIn;

//control Element FSM
FSMControl FSMControl(
	.WriteIn 						(ProcessorWriteEnIn),
	.ReadIn 							(ProcessorReadEnIn),
	.Match 							(Compare_Fsm_WIRE),
	.Valid 							(Valid_Fsm_WIRE),
	.Clk 								(Clk),
	.ResetFlag 						(ResetFlag),
	.Memory_Cache_Read_Ready 	(DdrReadReadyIn),
	.Memory_Cache_Write_Ready 	(DdrWriteReadyIn),
	.Processor_Cache_Address 	(ProcessorAddressIn),

	.Cache_Write_Enable 			(Fsm_CacheMem_WriteEn_Wire),              // 1= write to cashs
	.Select_DataOut_Memory_cache(Fsm_DataOutMux_Select_Wire),        // 1 = memory
	.Select_CacheAddrss_FSM_Address(Fsm_CacheAddressMux_Select_Wire),    // 0 = processor 1= fsm address
	.Ram_Write 						(DdrWriteEnOut),    // 0 = memory 1= fsm addres
	.Ram_Read 						(DdrReadEnOut),
	.Tag_Write 						(Fsm_TagMem_WriteEn_Wire),               
	.Valid_Write 					(Fsm_ValidMem_WriteEn_Wire),
	.Valid_Bit 						(Fsm_ValidMem_DataBit_Wire),
	.Cache_Processor_Read_Ready (ProcessorReadReadyOut),
	.Cache_Processor_Write_Ready(ProcessorWriteReadyOut),
	.Cache_RAMportB_Address		(DdrAddressOut),
	.Cache_DataCache_Address 	(Fsm_CacheAddressMux_AddressBUS)            //10 bits

);



//RAMS VAlid CacheMen and Tag
TagRam TagRam (
	.Address 					(ProcessorAddressIn[9:2]),    //only 8 bits from the total 10 TAG = 10-2*
	.TagIn 						(ProcessorAddressIn[(ADDRESS_LENGTH-1):CASHE_ADDRESS_LENGTH]),
	.Write 						(Fsm_TagMem_WriteEn_Wire),
	.Clk 							(Clk),

	.TagOut 						(Tag_Compare_AddressBUS)
);

Validcache Validcache( 
	.Address 					(ProcessorAddressIn[9:2]),
	.ValidIn 					(Fsm_ValidMem_DataBit_Wire),
	.Write 						(Fsm_ValidMem_WriteEn_Wire),
	.Reset 						(ResetFlag),
	.Clk 							(Clk),

	.ValidOut 					(Valid_Fsm_WIRE)
);

CacheDataRam CacheDataRam1(
	.Address 					(CacheAddressMux_CacheMem_AddressBUS),
	.DataIn 						(DdrDataIn),
	.Write 						(Fsm_CacheMem_WriteEn_Wire),
	.Clk							(Clk),
	
	.DataOut 					(CacheMem_CacheAddressMux_DataBUS)
);

//Muxes  CacheAddressMux and DoutMux
CacheAddressMux CacheAddressMux(
	.Select 						(Fsm_CacheAddressMux_Select_Wire),
	.FSMAddress 				(Fsm_CacheAddressMux_AddressBUS),
	.ProcessorAddress 		(ProcessorAddressIn[(CASHE_ADDRESS_LENGTH-1):0]),

	.Address 					(CacheAddressMux_CacheMem_AddressBUS)
);

DoutMux DoutMux(
	.Select 						(Fsm_DataOutMux_Select_Wire),
	.CashData 					(CacheMem_CacheAddressMux_DataBUS),
	.MemData 					(DdrDataIn),

	.DataOut 					(ProcessorDataOut)
);

//other
Compare Compare(
	.CashTag 					(Tag_Compare_AddressBUS),
	.MemTag 						(ProcessorAddressIn[(ADDRESS_LENGTH-1):CASHE_ADDRESS_LENGTH]),

	.Match 						(Compare_Fsm_WIRE)
);


endmodule