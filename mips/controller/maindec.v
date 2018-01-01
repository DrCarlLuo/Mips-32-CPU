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
            (op==`EXE_ADDI)?  12'b000010100000:
            (op==`EXE_XORI)?  12'b000010100000:
            (op==`EXE_LUI)?   12'b000010100000:
            (op==`EXE_ORI)?   12'b000010100000:
            (op==`EXE_ADDI)?  12'b000010100000:
            (op==`EXE_ADDIU)? 12'b000010100000:
            (op==`EXE_SLTI)?  12'b000010100000:
            (op==`EXE_SLTIU)? 12'b000010100000:
            /*-----J_Type-----*/
            (op==`EXE_J)?     12'b000000001000:
            (op==`EXE_JAL)?   12'b000000101100:
            (op==`EXE_BEQ)?   12'b000100000000:
            (op==`EXE_BGTZ)?  12'b000100000000:
            (op==`EXE_BLEZ)?  12'b000100000000:
            (op==`EXE_BNE)?   12'b000100000000:
            (op==`EXE_REGIMM_INST)?(
                (rt==`EXE_BLTZ)?  12'b000100000000:
                (rt==`EXE_BLTZAL)?12'b000100100001:
                (rt==`EXE_BGEZ)?  12'b000100000000:
                (rt==`EXE_BGEZAL)?12'b000100100001:
                12'b000000000000):
            
            (op==`EXE_LB)?    12'b110010100000:
            (op==`EXE_LBU)?   12'b110010100000:
            (op==`EXE_LH)?    12'b110010100000:
            (op==`EXE_LHU)?   12'b110010100000:
            (op==`EXE_LW)?    12'b110010100000:
            (op==`EXE_SB)?    12'b011010000000:
            (op==`EXE_SH)?    12'b011010000000:
            (op==`EXE_SW)?    12'b011010000000:
			/*-----R_Type-----*/
				//Null instruction
				//(funct==`EXE_NOP)?   12'b000000000000:
				//Logic instructions
                (funct==`EXE_AND)?   12'b000001100000:
                (funct==`EXE_OR)?    12'b000001100000:
                (funct==`EXE_XOR)?   12'b000001100000:
                (funct==`EXE_NOR)?   12'b000001100000:
				//Shift instructions
                (funct==`EXE_SLL)?   12'b000001100000:
                (funct==`EXE_SRL)?   12'b000001100000:
                (funct==`EXE_SRA)?   12'b000001100000:
                (funct==`EXE_SLLV)?  12'b000001100000:
                (funct==`EXE_SRLV)?  12'b000001100000:
                (funct==`EXE_SRAV)?  12'b000001100000:
				//Move instructions
                (funct==`EXE_MFHI)?  12'b000001100000:
                (funct==`EXE_MFLO)?  12'b000001100000:
                (funct==`EXE_MTHI)?  12'b000001010000:
                (funct==`EXE_MTLO)?  12'b000001010000:
				//Arithmetic instructions
                (funct==`EXE_ADD)?   12'b000001100000:
                (funct==`EXE_ADDU)?  12'b000001100000:
                (funct==`EXE_SUB)?   12'b000001100000:
                (funct==`EXE_SUBU)?  12'b000001100000:
                (funct==`EXE_SLT)?   12'b000001100000:
                (funct==`EXE_SLTU)?  12'b000001100000:
                (funct==`EXE_MULT)?  12'b000001010000:
                (funct==`EXE_MULTU)? 12'b000001010000:
                //jr instructions
                (funct==`EXE_JALR)?  12'b000001101010:
                (funct==`EXE_JR)?    12'b000000001000:
				12'b000000000000;

endmodule