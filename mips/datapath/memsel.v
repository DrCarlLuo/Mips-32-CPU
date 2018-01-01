`include "defines.vh"
module memsel(
	input  [7:0]  alucontrolM,
	input  [31:0] aluoutM,
	input  [31:0] writedataM,
	input		  memwriteM,
	input  [31:0] readdata,
	output [3:0]  wea,
	output [31:0] readdataM,
	output [31:0] writedata
	);

	wire [7:0] readbyte;
	wire [15:0] readhword;

	assign wea={4{memwriteM}}&(   
                     (alucontrolM==`EXE_SB_OP)?(
                     	(aluoutM[1:0]==2'b00)? 4'b0001:
                     	(aluoutM[1:0]==2'b01)? 4'b0010:
                     	(aluoutM[1:0]==2'b10)? 4'b0100:
                     	(aluoutM[1:0]==2'b11)? 4'b1000:
                     	4'b0000):
                     (alucontrolM==`EXE_SH_OP)?((aluoutM[1])?4'b1100:4'b0011):
                     (alucontrolM==`EXE_SW_OP)?    4'b1111:
                     4'b0000);

	assign writedata=(alucontrolM==`EXE_SB_OP)?(
                     	(aluoutM[1:0]==2'b00)? {24'h000000,writedataM[7:0]}:
                     	(aluoutM[1:0]==2'b01)? {16'h0000,writedataM[7:0],8'h0000}:
                     	(aluoutM[1:0]==2'b10)? {8'h0000,writedataM[7:0],16'h0000}:
                     						   {writedataM[7:0],24'h000000}):
                     (alucontrolM==`EXE_SH_OP)?((aluoutM[1])?{writedataM[15:0],16'h0000}:{16'h0000,writedataM[15:0]}):
                     						   writedataM;

	assign readbyte=        
				(aluoutM[1:0]==2'b00)? readdata[7:0]:
             	(aluoutM[1:0]==2'b01)? readdata[15:8]:
             	(aluoutM[1:0]==2'b10)? readdata[23:16]:
             						   readdata[31:24];

    assign readhword=(aluoutM[1])?readdata[31:16]:readdata[15:0];

	assign readdataM=
	                 (alucontrolM==`EXE_LB_OP)?    {{24{readbyte[7]}},readbyte}:
                     (alucontrolM==`EXE_LBU_OP)?   {24'h000000,readbyte}:
                     (alucontrolM==`EXE_LH_OP)?    {{16{readhword[15]}},readhword}:
                     (alucontrolM==`EXE_LHU_OP)?   {16'h0000,readhword}:
                     (alucontrolM==`EXE_LW_OP)?    readdata:
                     32'h00000000;

endmodule