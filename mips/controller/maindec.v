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

	reg [10:0] controls;

	assign {memtoreg,memen,memwrite,branch,alusrc,regdst,regwrite,hilowrite,jump,jal,jr,bal}=controls;

	always @(*) begin
		case(op)
		/*-----I_Type-----*/
		`EXE_ADDI  : controls <= 12'b00001010000;
		`EXE_XORI  : controls <= 12'b00001010000;
		`EXE_LUI   : controls <= 12'b00001010000;
		`EXE_ORI   : controls <= 12'b00001010000;
		`EXE_ADDI  : controls <= 12'b00001010000;
		`EXE_ADDIU : controls <= 12'b00001010000;
		`EXE_SLTI  : controls <= 12'b00001010000;
		`EXE_SLTIU : controls <= 12'b00001010000;
		/*-----R_Type-----*/
		default: case(funct)
			//Null instruction
			`EXE_NOP   : controls <= 12'b000000000000;
			//Logic instructions
			`EXE_AND   : controls <= 12'b000001100000;
			`EXE_OR    : controls <= 12'b000001100000;
			`EXE_XOR   : controls <= 12'b000001100000;
			`EXE_NOR   : controls <= 12'b000001100000;
			//Shift instructions
			`EXE_SLL   : controls <= 12'b000001100000;
			`EXE_SRL   : controls <= 12'b000001100000;
			`EXE_SRA   : controls <= 12'b000001100000;
			`EXE_SLLV  : controls <= 12'b000001100000;
			`EXE_SRLV  : controls <= 12'b000001100000;
			`EXE_SRAV  : controls <= 12'b000001100000;
			//Move instructions
			`EXE_MFHI  : controls <= 12'b000001100000;
			`EXE_MFLO  : controls <= 12'b000001100000;
			`EXE_MTHI  : controls <= 12'b000001010000;
			`EXE_MTLO  : controls <= 12'b000001010000;
			//Arithmetic instructions
			`EXE_ADD   : controls <= 12'b000001100000;
			`EXE_ADDU  : controls <= 12'b000001100000;
			`EXE_SUB   : controls <= 12'b000001100000;
			`EXE_SUBU  : controls <= 12'b000001100000;
			`EXE_SLT   : controls <= 12'b000001100000;
			`EXE_SLTU  : controls <= 12'b000001100000;
			`EXE_MULT  : controls <= 12'b000001010000;
			`EXE_MULTU : controls <= 12'b000001010000;
			default	   : controls <= 12'b000000000000;
	end



endmodule