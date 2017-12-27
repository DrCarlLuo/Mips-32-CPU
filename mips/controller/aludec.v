`include "defines.vh"
module aludec(
	input  wire [5:0] op,
	input  wire [5:0] funct,
	output reg  [7:0] alucontrol,
	);

	always @(*) begin
		case (op)
		/*-----I_Type-----*/
		`EXE_ANDI  : alucontrol <= `EXE_ANDI_OP;
		`EXE_XORI  : alucontrol <= `EXE_XORI_OP;
		`EXE_LUI   : alucontrol <= `EXE_LUI_OP;
		`EXE_ORI   : alucontrol <= `EXE_ORI_OP;
		`EXE_ADDI  : alucontrol <= `EXE_ADDI_OP;
		`EXE_ADDIU : alucontrol <= `EXE_ADDIU_OP;
		`EXE_SLTI  : alucontrol <= `EXE_SLTI_OP;
		`EXE_SLTIU : alucontrol <= `EXE_SLTIU_OP;
		/*-----J_Type-----*/
		
		/*-----R_Type-----*/
		default: case(funct)
			//Null instruction
			`EXE_NOP  : alucontrol <= `EXE_NOP_OP;
			//Logic instructions
			`EXE_AND  : alucontrol <= `EXE_AND_OP;
			`EXE_OR   : alucontrol <= `EXE_OR_OP;
			`EXE_XOR  : alucontrol <= `EXE_XOR_OP;
			`EXE_NOR  : alucontrol <= `EXE_NOR_OP;
			//Shift instructions
			`EXE_SLL  : alucontrol <= `EXE_SLL_OP;
			`EXE_SRL  : alucontrol <= `EXE_SRL_OP;
			`EXE_SRA  : alucontrol <= `EXE_SRA_OP;
			`EXE_SLLV : alucontrol <= `EXE_SLLV_OP;
			`EXE_SRLV : alucontrol <= `EXE_SRLV_OP;
			`EXE_SRAV : alucontrol <= `EXE_SRAV_OP;
			//Move instructions
			`EXE_MFHI : alucontrol <= `EXE_MFHI_OP;
			`EXE_MFLO : alucontrol <= `EXE_MFLO_OP;
			`EXE_MTHI : alucontrol <= `EXE_MTHI_OP;
			`EXE_MTLO : alucontrol <= `EXE_MTLO_OP;
			//Arithmetic instructions
			`EXE_ADD  : alucontrol <= `EXE_ADD_OP;
			`EXE_ADDU : alucontrol <= `EXE_ADDU_OP;
			`EXE_SUB  : alucontrol <= `EXE_SUB_OP;
			`EXE_SUBU : alucontrol <= `EXE_SUBU_OP;
			`EXE_SLT  : alucontrol <= `EXE_SLT_OP;
			`EXE_SLTU : alucontrol <= `EXE_SLTU_OP;
			`EXE_MULT : alucontrol <= `EXE_MULT_OP;
			`EXE_MULTU: alucontrol <= `EXE_MULTU_OP;
			`EXE_DIV  : alucontrol <= `EXE_DIV_OP;
			`EXE_DIVU : alucontrol <= `EXE_DIVU_OP;
			//Branch instructions
			`EXE_JR   : alucontrol <= `EXE_JR_OP;
			`EXE_JALR : alucontrol <= `EXE_JALR_OP;
			//Trap instructions
			`EXE_BREAK: alucontrol <= `EXE_BREAK_OP;
			`EXE_SYSCALL: alucontrol <= `EXE_SYSCALL_OP;
			default   : alucontrol <= `FUNCT_INVALID;

	end