`include "defines.vh"
module maindec(
    input  [31:0] instrD,
	output 		  memtoreg,memen,memwrite,
	output 		  branch,alusrc,
	output 		  regdst,regwrite,hilowrite,cp0write,
	output 		  jump,jal,jr,bal,
	output        syscallD,breakD,eretD,invalidD
	);

    wire [5:0] op,rt,funct,rs;
    wire zero10_6;

    assign op=instrD[31:26];
    assign rt=instrD[20:16];
    assign funct=instrD[5:0];
    assign rs=instrD[25:21];
    
    assign syscallD=((op==6'b000000)&&(funct==`EXE_SYSCALL));
    assign breakD=((op==6'b000000)&&(funct==`EXE_BREAK));
    assign eretD=(instrD==`EXE_ERET);
    assign zero10_6=(instrD[10:6]==5'b00000);

    assign {memtoreg,memen,memwrite,branch,alusrc,regdst,regwrite,hilowrite,jump,jal,jr,bal,cp0write,invalidD}=
            /*-----I_Type-----*/
            (op==`EXE_ANDI)?  14'b00001010000000:
            (op==`EXE_XORI)?  14'b00001010000000:
            ((op==`EXE_LUI)&&(rs==5'b0))?   14'b00001010000000:
            (op==`EXE_ORI)?   14'b00001010000000:
            (op==`EXE_ADDI)?  14'b00001010000000:
            (op==`EXE_ADDIU)? 14'b00001010000000:
            (op==`EXE_SLTI)?  14'b00001010000000:
            (op==`EXE_SLTIU)? 14'b00001010000000:
            /*-----J_Type-----*/
            (op==`EXE_J)?     14'b00000000100000:
            (op==`EXE_JAL)?   14'b00000010110000:
            (op==`EXE_BEQ)?   14'b00010000000000:
            ((op==`EXE_BGTZ)&&(rt==5'b0))?  14'b00010000000000:
            ((op==`EXE_BLEZ)&&(rt==5'b0))?  14'b00010000000000:
            (op==`EXE_BNE)?   14'b00010000000000:
            (op==`EXE_REGIMM_INST)?(
                (rt==`EXE_BLTZ)?    14'b00010000000000:
                (rt==`EXE_BLTZAL)?  14'b00010010000100:
                (rt==`EXE_BGEZ)?    14'b00010000000000:
                (rt==`EXE_BGEZAL)?  14'b00010010000100:
                                    14'b00000000000001):
            
            (op==`EXE_LB)?    14'b11001010000000:
            (op==`EXE_LBU)?   14'b11001010000000:
            (op==`EXE_LH)?    14'b11001010000000:
            (op==`EXE_LHU)?   14'b11001010000000:
            (op==`EXE_LW)?    14'b11001010000000:
            (op==`EXE_SB)?    14'b01101000000000:
            (op==`EXE_SH)?    14'b01101000000000:
            (op==`EXE_SW)?    14'b01101000000000:
            /*-----privileged instruction-----*/
            ((op==6'b010000)&&(instrD[10:3]==8'b0))?(
                (instrD[25:21]==5'b00100)? 14'b00000000000010://mtc0
                (instrD[25:21]==5'b00000)? 14'b00000010000000://mfc0
                (instrD==`EXE_ERET)?        14'b00000000000000:
                                            14'b00000000000001):
            /*-----R_Type-----*/
            (op==6'b000000)?(
                //Null instruction
                //(funct==`EXE_NOP)?   14'b00000000000000:
                //Logic instructions
                ((funct==`EXE_AND)&&zero10_6)?   14'b00000110000000:
                ((funct==`EXE_OR)&&zero10_6)?    14'b00000110000000:
                ((funct==`EXE_XOR)&&zero10_6)?   14'b00000110000000:
                ((funct==`EXE_NOR)&&zero10_6)?   14'b00000110000000:
                //Shift instructions
                ((funct==`EXE_SLL)&&(rs==5'b0))?   14'b00000110000000:
                ((funct==`EXE_SRL)&&(rs==5'b0))?   14'b00000110000000:
                ((funct==`EXE_SRA)&&(rs==5'b0))?   14'b00000110000000:
                ((funct==`EXE_SLLV)&&zero10_6)?  14'b00000110000000:
                ((funct==`EXE_SRLV)&&zero10_6)?  14'b00000110000000:
                ((funct==`EXE_SRAV)&&zero10_6)?  14'b00000110000000:
                //Move instructions
                ((funct==`EXE_MFHI)&&(instrD[25:16]==10'b0)&&zero10_6)?  14'b00000110000000:
                ((funct==`EXE_MFLO)&&(instrD[25:16]==10'b0)&&zero10_6)?  14'b00000110000000:
                ((funct==`EXE_MTHI)&&(instrD[20:6]==15'b0))?  14'b00000101000000:
                ((funct==`EXE_MTLO)&&(instrD[20:6]==15'b0))?  14'b00000101000000:
                //Arithmetic instructions
                ((funct==`EXE_ADD)&&zero10_6)?   14'b00000110000000:
                ((funct==`EXE_ADDU)&&zero10_6)?  14'b00000110000000:
                ((funct==`EXE_SUB)&&zero10_6)?   14'b00000110000000:
                ((funct==`EXE_SUBU)&&zero10_6)?  14'b00000110000000:
                ((funct==`EXE_SLT)&&zero10_6)?   14'b00000110000000:
                ((funct==`EXE_SLTU)&&zero10_6)?  14'b00000110000000:
                ((funct==`EXE_MULT)&&(instrD[15:6]==10'b0))?  14'b00000101000000:
                ((funct==`EXE_MULTU)&&(instrD[15:6]==10'b0))? 14'b00000101000000:
                ((funct==`EXE_DIV)&&(instrD[15:6]==10'b0))?   14'b00000101000000:
                ((funct==`EXE_DIVU)&&(instrD[15:6]==10'b0))?  14'b00000101000000:
                //jr instructions
                ((funct==`EXE_JALR)&&(rt==5'b0)&&zero10_6)?  14'b00000110101000:
                ((funct==`EXE_JR)&&(instrD[20:6]==15'b0))?    14'b00000000100000:
                //trap instructions
                (funct==`EXE_SYSCALL)?14'b00000000000000:
                (funct==`EXE_BREAK)?  14'b00000000000000:
                                      14'b00000000000001):
                                      14'b00000000000001;

endmodule