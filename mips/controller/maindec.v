`include "defines.vh"
module maindec(
    input  [31:0] instrD,
	output 		  memtoreg,memen,memwrite,
	output 		  branch,alusrc,
	output 		  regdst,regwrite,hilowrite,cp0write,
	output 		  jump,jal,jr,bal,
	output        syscallD,breakD,eretD,invalidD
	);

    wire [5:0] op,rt,funct;

    assign op=instrD[31:26];
    assign rt=instrD[20:16];
    assign funct=instrD[5:0];
    
    assign syscallD=1'b0;
    assign breakD=1'b0;
    assign eretD=1'b0;
    assign invalidD=1'b0;

	assign {memtoreg,memen,memwrite,branch,alusrc,regdst,regwrite,hilowrite,jump,jal,jr,bal,cp0write}=
			/*-----I_Type-----*/
            (op==`EXE_ADDI)?  13'b0000101000000:
            (op==`EXE_XORI)?  13'b0000101000000:
            (op==`EXE_LUI)?   13'b0000101000000:
            (op==`EXE_ORI)?   13'b0000101000000:
            (op==`EXE_ADDI)?  13'b0000101000000:
            (op==`EXE_ADDIU)? 13'b0000101000000:
            (op==`EXE_SLTI)?  13'b0000101000000:
            (op==`EXE_SLTIU)? 13'b0000101000000:
            /*-----J_Type-----*/
            (op==`EXE_J)?     13'b0000000010000:
            (op==`EXE_JAL)?   13'b0000001011000:
            (op==`EXE_BEQ)?   13'b0001000000000:
            (op==`EXE_BGTZ)?  13'b0001000000000:
            (op==`EXE_BLEZ)?  13'b0001000000000:
            (op==`EXE_BNE)?   13'b0001000000000:
            (op==`EXE_REGIMM_INST)?(
                (rt==`EXE_BLTZ)?    13'b0001000000000:
                (rt==`EXE_BLTZAL)?  13'b0001001000010:
                (rt==`EXE_BGEZ)?    13'b0001000000000:
                (rt==`EXE_BGEZAL)?  13'b0001001000010:
                                    13'b0000000000000):
            
            (op==`EXE_LB)?    13'b1100101000000:
            (op==`EXE_LBU)?   13'b1100101000000:
            (op==`EXE_LH)?    13'b1100101000000:
            (op==`EXE_LHU)?   13'b1100101000000:
            (op==`EXE_LW)?    13'b1100101000000:
            (op==`EXE_SB)?    13'b0110100000000:
            (op==`EXE_SH)?    13'b0110100000000:
            (op==`EXE_SW)?    13'b0110100000000:
            /*-----privileged instruction-----*/
            (op==6'b010000)?(
                (instrD[25:21]==5'b00100)? 13'b0000000000001://mtc0
                (instrD[25:21]==5'b00000)? 13'b0000001000000://mfc0
                                           13'b0000000000000):
			/*-----R_Type-----*/
				//Null instruction
				//(funct==`EXE_NOP)?   13'b0000000000000:
				//Logic instructions
                (funct==`EXE_AND)?   13'b0000011000000:
                (funct==`EXE_OR)?    13'b0000011000000:
                (funct==`EXE_XOR)?   13'b0000011000000:
                (funct==`EXE_NOR)?   13'b0000011000000:
				//Shift instructions
                (funct==`EXE_SLL)?   13'b0000011000000:
                (funct==`EXE_SRL)?   13'b0000011000000:
                (funct==`EXE_SRA)?   13'b0000011000000:
                (funct==`EXE_SLLV)?  13'b0000011000000:
                (funct==`EXE_SRLV)?  13'b0000011000000:
                (funct==`EXE_SRAV)?  13'b0000011000000:
				//Move instructions
                (funct==`EXE_MFHI)?  13'b0000011000000:
                (funct==`EXE_MFLO)?  13'b0000011000000:
                (funct==`EXE_MTHI)?  13'b0000010100000:
                (funct==`EXE_MTLO)?  13'b0000010100000:
				//Arithmetic instructions
                (funct==`EXE_ADD)?   13'b0000011000000:
                (funct==`EXE_ADDU)?  13'b0000011000000:
                (funct==`EXE_SUB)?   13'b0000011000000:
                (funct==`EXE_SUBU)?  13'b0000011000000:
                (funct==`EXE_SLT)?   13'b0000011000000:
                (funct==`EXE_SLTU)?  13'b0000011000000:
                (funct==`EXE_MULT)?  13'b0000010100000:
                (funct==`EXE_MULTU)? 13'b0000010100000:
                //jr instructions
                (funct==`EXE_JALR)?  13'b0000011010100:
                (funct==`EXE_JR)?    13'b0000000010000:
				13'b0000000000000;

endmodule