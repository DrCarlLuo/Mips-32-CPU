`include "defines.vh"
module eqcmp(
	input  [31:0] a,b,
	input  [5:0]  op,
	input  [4:0]  rt,
	output		  y
	);

	assign y = (op==`EXE_BEQ)?(a==b):
			   (op==`EXE_BNE)?(a!=b):
			   (op==`EXE_BGTZ)?((a[31]==1'b0)&&(a!=`ZeroWord)):
			   (op==`EXE_BLEZ)?((a[31]==1'b1)||(a==`ZeroWord)):
			   (op==`EXE_REGIMM_INST)?(
			   		(rt==`EXE_BGEZ)?(a[31]==1'b0):
			   		(rt==`EXE_BGEZAL)?(a[31]==1'b0):
			   		(rt==`EXE_BLTZ)?(a[31]==1'b1):
			   		(rt==`EXE_BLTZAL)?(a[31]==1'b1):
			   		1'b0
			   	):
			   1'b0;
endmodule