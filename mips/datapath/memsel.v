module memsel(
	input  [7:0]  alucontrolM,
	input		  memwriteM,
	input  [31:0] readdata,
	output [3:0]  wea,
	output [31:0] readdataM
	);

	assign wea={4{memwriteM}}&(   
                     (alucontrolM==`EXE_SB_OP)?    4'b0001:
                     (alucontrolM==`EXE_SH_OP)?    4'b0011:
                     (alucontrolM==`EXE_SW_OP)?    4'b1111:
                     4'b0000);

	assign readdataM=
	                 (alucontrol==`EXE_LB_OP)?    {{24{readdata[7]}},readdata[7:0]}:
                     (alucontrol==`EXE_LBU_OP)?   {24'h000000,readdata[7:0]}:
                     (alucontrol==`EXE_LH_OP)?    {{16{readdata[15]}},readdata[15:0]}:
                     (alucontrol==`EXE_LHU_OP)?   {16'h0000,readdata[15:0]}:
                     (alucontrol==`EXE_LW_OP)?    readdata:
                     32'h00000000;

endmodule