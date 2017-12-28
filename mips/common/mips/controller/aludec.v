`include "defines.vh"
module aludec(
	input  [5:0] op,
	input  [5:0] funct,
	output [7:0] alucontrol
	);

	assign alucontrol=
		/*-----I_Type-----*/
		(op==`EXE_ANDI)?   `EXE_ANDI_OP:
		(op==`EXE_XORI)?   `EXE_XORI_OP:
		(op==`EXE_LUI)?    `EXE_LUI_OP:
		(op==`EXE_ORI)?    `EXE_ORI_OP:
		(op==`EXE_ADDI)?   `EXE_ADDI_OP:
		(op==`EXE_ADDIU)?  `EXE_ADDIU_OP:
		(op==`EXE_SLTI)?   `EXE_SLTI_OP:
		(op==`EXE_SLTIU)?  `EXE_SLTIU_OP:
		/*-----J_Type-----*/

		/*-----R_Type-----*/
			//Null instruction
			//(funct==`EXE_NOP)?    `EXE_NOP_OP:
			//Logic instructions
			(funct==`EXE_AND)?    `EXE_AND_OP:
			(funct==`EXE_OR)?     `EXE_OR_OP:
			(funct==`EXE_XOR)?    `EXE_XOR_OP:
			(funct==`EXE_NOR)?    `EXE_NOR_OP:
			//Shift instructions
			(funct==`EXE_SLL)?    `EXE_SLL_OP:
			(funct==`EXE_SRL)?    `EXE_SRL_OP:
			(funct==`EXE_SRA)?    `EXE_SRA_OP:
			(funct==`EXE_SLLV)?   `EXE_SLLV_OP:
			(funct==`EXE_SRLV)?   `EXE_SRLV_OP:
			(funct==`EXE_SRAV)?   `EXE_SRAV_OP:
			//Move instructions
			(funct==`EXE_MFHI)?   `EXE_MFHI_OP:
			(funct==`EXE_MFLO)?   `EXE_MFLO_OP:
			(funct==`EXE_MTHI)?   `EXE_MTHI_OP:
			(funct==`EXE_MTLO)?   `EXE_MTLO_OP:
			//Arithmetic instructions
			(funct==`EXE_ADD)?    `EXE_ADD_OP:
			(funct==`EXE_ADDU)?   `EXE_ADDU_OP:
			(funct==`EXE_SUB)?    `EXE_SUB_OP:
			(funct==`EXE_SUBU)?   `EXE_SUBU_OP:
			(funct==`EXE_SLT)?    `EXE_SLT_OP:
			(funct==`EXE_SLTU)?   `EXE_SLTU_OP:
			(funct==`EXE_MULT)?   `EXE_MULT_OP:
			(funct==`EXE_MULTU)?  `EXE_MULTU_OP:
			(funct==`EXE_DIV)?    `EXE_DIV_OP:
			(funct==`EXE_DIVU)?   `EXE_DIVU_OP:
			//Branch instructions
			(funct==`EXE_JR)?     `EXE_JR_OP:
			(funct==`EXE_JALR)?   `EXE_JALR_OP:
			//Trap instructions
			(funct==`EXE_BREAK)?  `EXE_BREAK_OP:
			(funct==`EXE_SYSCALL)?`EXE_SYSCALL_OP:
			`FUNCT_INVALID;

endmodule