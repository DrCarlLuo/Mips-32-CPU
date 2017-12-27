module datapath(
        input clk,
        input reset,
        /*-----Fetch input----*/
        input pcsrcM,pcsrcD,jump,
        input [31:0] pcbranchM,instrF,
        /*-----Decode input----*/
        input [31:0] instrD,pcplus4D,
        input regwriteW,
        input [4:0] writeregW,
        /*-----Execute input----*/
        input [2:0] alucontrolE,
        input alusrcE,regdstE,
        input [31:0] srcaE,writedataE,signimmE,pcplus4E,
        input [4:0] RtE,RdE,
        /*-----Memory input----*/
        input [31:0] aluoutM,writedataM,writeregM,readdataM,
        /*-----Writeback input----*/
        input memtoregW,
        input [31:0] aluoutW,readdataW,
        /*-----hazard input-----*/
        input [1:0] forwardAE,forwardBE,
        input forwardAD,forwardBD,
        input stallF,
        /*-----Fetch output----*/
        output [31:0] pcF,pcplus4F,instrF1,
        /*-----Decode output----*/
        output [31:0] srcaD,writedataD,
        output [4:0] rsD,rtD,rdD,
        output [31:0] signimmD,pcplus4D1,
        output equalD,
        /*-----Execute output----*/
        output zeroE,
        output [31:0] aluoutE,writedataE1,pcbranchE,
        output [4:0] writeregE,
        /*-----Memory output----*/
        output [31:0] aluoutM1,readdataM1,writedataM1,
        output [4:0] writeregM1,
        
        output overflow
    );
    
    wire [31:0] nxtpc,nxtpc1;
    wire [25:0] pcjump;
    wire [31:0] signimml2D,signimml2E;
    wire [31:0] srca;
    wire [31:0] srcbE;
    wire [31:0] resultW;
    wire [31:0] eqa,eqb;
    wire [31:0] pcbranchD;
    
    /*-----Fetch-----*/
    adder pcadder(pcF,32'h4,pcplus4F);
    mux2 #(32) pcmux1(pcplus4F,pcbranchD,pcsrcD,nxtpc1);
    //assign nxtpc=nxtpc1;
    mux2 #(32) pcmux2(nxtpc1,{pcplus4F[31:28],pcjump[25:0],2'b00},jump,nxtpc);//ofer choice:jump
    D_flip_flop #(32) pcreg(clk,reset,~stallF,nxtpc,pcF);
    assign instrF1=instrF;
    
    /*-----Decode-----*/
    regfile rf(.clk(clk),
               .reset(reset),
               .we3(regwriteW),
               .ra1(instrD[25:21]),
               .ra2(instrD[20:16]),
               .wa3(writeregW),
               .wd3(resultW),
               .rd1(srcaD),
               .rd2(writedataD)
               );
     assign {rsD,rtD,rdD}=instrD[25:11];
     assign pcplus4D1=pcplus4D;
     signext sig_ext(instrD[15:0],signimmD);
     
     mux2 #(32) eqmuxa(srcaD,aluoutM,forwardAD,eqa);
     mux2 #(32) eqmuxb(writedataD,aluoutM,forwardBD,eqb);
     assign equalD=(eqa==eqb);
     
     sl2 shift_immD(signimmD,signimml2D);
     adder pcadder3(signimml2D,pcplus4D,pcbranchD);
     
     assign pcjump=instrD[25:0];
     
     /*-----Execute-----*/
     mux3 #(32) srca_mux(srcaE,resultW,aluoutM,forwardAE,srca);
     mux3 #(32) srcb_mux(writedataE,resultW,aluoutM,forwardBE,writedataE1);
     mux2 #(32) srcb_mux1(writedataE1,signimmE,alusrcE,srcbE);
     alu the_alu(.srca(srca),
                 .srcb(srcbE),
                 .alucontrol(alucontrolE),
                 .aluout(aluoutE),
                 .overflow(overflow),
                 .zero(zeroE)
                 );
     mux2 #(32) writereg_mux(RtE,RdE,regdstE,writeregE);
     sl2 shift_imm(signimmE,signimml2E);
     adder pcadder2(signimml2E,pcplus4E,pcbranchE);
     
     /*-----Memory-----*/
     assign aluoutM1=aluoutM;
     assign readdataM1=readdataM;
     assign writedataM1=writedataM;
     assign writeregM1=writeregM;
     
     /*-----Writeback-----*/
     mux2 #(32) result_mux(aluoutW,readdataW,memtoregW,resultW);
     
endmodule