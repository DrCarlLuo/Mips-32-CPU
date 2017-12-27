`include "defines.vh"
module maindec(
	input  wire [5:0] 	op,
	input  wire [5:0] 	funct,
	input  wire [4:0] 	rt,
	output wire 		memtoreg,memen,memwrite,
	output wire 		branch,alusrc,
	output wire 		regdst,regwrite,hilowrite,
	output wire 		jump,jal,jr,bal 
	);

	assign {memtoreg,memen,memwrite,branch,alusrc,regdst,regwrite,hilowrite,jump,jal,jr,bal}=
			/*-----I_Type-----*/
			(op==`EXE_ADDI)?  12'b00001010000:
			(op==`EXE_XORI)?  12'b00001010000:
			(op==`EXE_LUI)?   12'b00001010000:
			(op==`EXE_ORI)?   12'b00001010000:
			(op==`EXE_ADDI)?  12'b00001010000:
			(op==`EXE_ADDIU)? 12'b00001010000:
			(op==`EXE_SLTI)?  12'b00001010000:
			(op==`EXE_SLTIU)? 12'b00001010000:
			/*-----R_Type-----*/
				//Null instruction
				(funct==`EXE_NOP)?   12'b00000000000:
				//Logic instructions
				(funct==`EXE_AND)?   12'b00000110000:
				(funct==`EXE_OR)?    12'b00000110000:
				(funct==`EXE_XOR)?   12'b00000110000:
				(funct==`EXE_NOR)?   12'b00000110000:
				//Shift instructions
				(funct==`EXE_SLL)?   12'b00000110000:
				(funct==`EXE_SRL)?   12'b00000110000:
				(funct==`EXE_SRA)?   12'b00000110000:
				(funct==`EXE_SLLV)?  12'b00000110000:
				(funct==`EXE_SRLV)?  12'b00000110000:
				(funct==`EXE_SRAV)?  12'b00000110000:
				//Move instructions
				(funct==`EXE_MFHI)?  12'b00000110000:
				(funct==`EXE_MFLO)?  12'b00000110000:
				(funct==`EXE_MTHI)?  12'b00000101000:
				(funct==`EXE_MTLO)?  12'b00000101000:
				//Arithmetic instructions
				(funct==`EXE_ADD)?   12'b00000110000:
				(funct==`EXE_ADDU)?  12'b00000110000:
				(funct==`EXE_SUB)?   12'b00000110000:
				(funct==`EXE_SUBU)?  12'b00000110000:
				(funct==`EXE_SLT)?   12'b00000110000:
				(funct==`EXE_SLTU)?  12'b00000110000:
				(funct==`EXE_MULT)?  12'b00000101000:
				(funct==`EXE_MULTU)? 12'b00000101000:
				12'b000000000000;


endmodule