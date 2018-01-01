`include "defines.vh"

module alu(
		input  [31:0] srca,
		input  [31:0] srcb,
		input  [4:0]  sa,
		input  [7:0]  alucontrol,
		input  [63:0] hilo,
        input  [63:0] div_res,
        input  div_readyE,div_readyM,
		output [31:0] aluout,
		output [63:0] hilores,
        output        stall_div,
		output        overflow,
		output        zero
	);

    wire [31:0] compb;//complementary of srcb
    wire [31:0] sum,dif,andr,orr,xorr;//Addition,subtraction,and,or,xor results
    wire cs,cp;//symbol bit overflow & highest bit overflow
    wire [31:0] mult_a,mult_b;
    wire [63:0] mult_res;//multiplication result
    wire mmp;

    //flags
    assign zero=(aluout==0);
    assign mmp=(alucontrol==`EXE_ADD_OP);
    assign overflow=
            ((alucontrol==`EXE_ADD_OP)||(alucontrol==`EXE_ADDI_OP))?
                ((!srca[31]&&!srcb[31])&&aluout[31])||((srca[31]&&srcb[31])&&(!aluout[31])):
            (alucontrol==`EXE_SUB_OP)?
                ((!srca[31]&&~compb[31])&&aluout[31])||((srca[31]&&compb[31])&&(!aluout[31])):0;
    
    //intermediate results
    assign sum=srca+srcb;
    assign compb=~srcb+32'b1;
    assign dif=srca+compb;
    assign andr=srca&srcb;
    assign orr=srca|srcb;
    assign xorr=srca^srcb;
    assign mult_a=((alucontrol==`EXE_MULT_OP)&&(srca[31]==1'b1))?(~srca+1):srca;
    assign mult_b=((alucontrol==`EXE_MULT_OP)&&(srcb[31]==1'b1))?(~srcb+1):srcb;
    assign mult_res=((alucontrol==`EXE_MULT_OP)&&(srca[31]^srcb[31]==1'b1))?
    				~(mult_a*mult_b)+1:mult_a*mult_b;

    //aluout value
    assign aluout = 
    				/*-----Logic-----*/
    				(alucontrol==`EXE_AND_OP)? 	 andr:
    				(alucontrol==`EXE_ANDI_OP)?	 andr:
    				(alucontrol==`EXE_OR_OP)?	 orr:
    				(alucontrol==`EXE_ORI_OP)?	 orr:
    				(alucontrol==`EXE_XOR_OP)?	 xorr:
    				(alucontrol==`EXE_XORI_OP)?	 xorr:
    				(alucontrol==`EXE_NOR_OP)?	 ~orr:
    				(alucontrol==`EXE_LUI_OP)?	 {srcb[15:0],{16{1'b0}}}:
    				/*-----Shift-----*/
    				(alucontrol==`EXE_SLL_OP)? 	 srcb << sa:
    				(alucontrol==`EXE_SRL_OP)?	 srcb >> sa:
    				(alucontrol==`EXE_SRA_OP)?	 
                        ({32{srcb[31]}} << (6'd32-{1'b0,sa})) | srcb >> sa:
    				(alucontrol==`EXE_SLLV_OP)?	 srcb << srca[4:0]:
    				(alucontrol==`EXE_SRLV_OP)?	 srcb >> srca[4:0]:
    				(alucontrol==`EXE_SRAV_OP)?	 
                        ({32{srcb[31]}} << (6'd32-{1'b0,srca[4:0]})) | srcb >> srca[4:0]:
    				/*-----MF-----*/
    				(alucontrol==`EXE_MFHI_OP)?	 hilo[63:32]:
    				(alucontrol==`EXE_MFLO_OP)?	 hilo[31:0]:
    				/*-----Arithmetic-----*/
    				(alucontrol==`EXE_ADD_OP)?	 sum:
    				(alucontrol==`EXE_ADDU_OP)?  sum:
                    (alucontrol==`EXE_ADDI_OP)?  sum:
                    (alucontrol==`EXE_ADDIU_OP)? sum:
    				(alucontrol==`EXE_SUB_OP)?	 dif:
    				(alucontrol==`EXE_SUBU_OP)?	 dif:
    				(alucontrol==`EXE_SLT_OP)?   
                        {{31{1'b0}},((srca[31]&&!srcb[31])||(dif[31]))&&(!(!srca[31]&&srcb[31]))}:
    				(alucontrol==`EXE_SLTU_OP)?  {{31{1'b0}},srca<srcb}:
    				(alucontrol==`EXE_SLTI_OP)?
                        {{31{1'b0}},((srca[31]&&!srcb[31])||(dif[31]))&&(!(!srca[31]&&srcb[31]))}:
    				(alucontrol==`EXE_SLTIU_OP)? {{31{1'b0}},srca<srcb}:
    				32'h00000000;

    //HILO register value
    assign hilores = (alucontrol==`EXE_MULT_OP)?  mult_res:
    				 (alucontrol==`EXE_MULTU_OP)? mult_res:
    				 (alucontrol==`EXE_MTHI_OP)?  {srca,hilo[31:0]}:
    				 (alucontrol==`EXE_MTLO_OP)?  {hilo[63:32],srca}:
                     (div_readyE&&!div_readyM)?   div_res:
    				 hilo;

    assign stall_div=((alucontrol==`EXE_DIV_OP||alucontrol==`EXE_DIVU_OP)&&!div_readyM);

endmodule