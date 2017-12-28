module datapath(
    input         clk,
    input         reset,
    /*-----Fetch input----*/
    input  [1:0]  pcsrcD,
    input  [31:0] instrF,
    /*-----Decode input----*/
    input  [31:0] instrD,pcplus4D,
    input         regwriteW,
    input  [4:0]  writeregW,
    /*-----Execute input----*/
    input  [7:0]  alucontrolE,
    input         alusrcE,regdstE,
    input  [31:0] srcaE,writedataE,signimmE,
    input  [4:0]  rtE,rdE,saE,
    /*-----Memory input----*/
    input  [31:0] aluoutM,writedataM,writeregM,readdataM,
    input  [63:0] hiloresM,
    /*-----Writeback input----*/
    input         memtoregW,hilowriteW,
    input  [31:0] aluoutW,readdataW,
    input  [63:0] hiloresW,
    /*-----hazard input-----*/
    input  [1:0]  forwardAE,forwardBE,
    input         forwardAD,forwardBD,
    input         forwardhiloE,
    input         stallF,
    /*-----Fetch output----*/
    output [31:0] pcF,pcplus4F,instrF1,
    /*-----Decode output----*/
    output [31:0] srcaD,writedataD,
    output [4:0]  rsD,rtD,rdD,saD,
    output [31:0] signimmD,
    output        equalD,
    /*-----Execute output----*/
    output [31:0] aluoutE,writedataE1,
    output [63:0] hiloresE,
    output [4:0]  writeregE,
    /*-----Memory output----*/
    output [31:0] aluoutM1,readdataM1,writedataM1,
    output [63:0] hiloresM1,
    output [4:0]  writeregM1,
    
    output overflow,zero
    );
    
    wire [31:0] nxtpc;
    wire [25:0] pcjump;
    wire [31:0] eqa,eqb;
    wire [31:0] srca;
    wire [31:0] srcbE;
    wire [63:0] hilo,hiloW;
    wire [31:0] resultW;
    wire [31:0] pcbranchD;
    
    /*-----Fetch-----*/
    assign pcplus4F=pcF+32'h4;
    D_flip_flop #(32) pcreg(clk,reset,~stallF,nxtpc,pcF);
    assign instrF1=instrF;
    mux3 #(32) pcmux(pcplus4F,pcbranchD,{pcplus4F[31:28],pcjump[25:0],2'b00},pcsrcD,nxtpc);
    
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

    assign {rsD,rtD,rdD,saD}=instrD[25:6];

    signext sig_ext(instrD[15:0],instrD[29:28],signimmD);
    assign pcbranchD=pcplus4D+{signimmD[29:0],2'b00};
    assign pcjump=instrD[25:0];
     
    mux2 #(32) eqmuxa(srcaD,aluoutM,forwardAD,eqa);
    mux2 #(32) eqmuxb(writedataD,aluoutM,forwardBD,eqb);
    assign equalD=(eqa==eqb);
     
    /*-----Execute-----*/
    mux3 #(32) srca_mux(srcaE,resultW,aluoutM,forwardAE,srca);
    mux3 #(32) srcb_mux(writedataE,resultW,aluoutM,forwardBE,writedataE1);
    mux2 #(32) srcb_mux1(writedataE1,signimmE,alusrcE,srcbE);
    mux2 #(64) hilo_mux(hiloW,hiloresM,forwardhiloE,hilo);
    alu the_alu(.srca(srca),
                .srcb(srcbE),
                .sa(saE),
                .alucontrol(alucontrolE),
                .hilo(hilo),
                .aluout(aluoutE),
                .hilores(hiloresE),
                .overflow(overflow),
                .zero(zero)
                );

    mux2 #(32) writereg_mux(rtE,rdE,regdstE,writeregE);
     
    /*-----Memory-----*/
    assign aluoutM1=aluoutM;
    assign readdataM1=readdataM;
    assign writedataM1=writedataM;
    assign writeregM1=writeregM;
    assign hiloresM1=hiloresM;
    
    /*-----Writeback-----*/
    mux2 #(32) result_mux(aluoutW,readdataW,memtoregW,resultW);
    hilo_reg the_hilo(
        .clk(clk),.rst(reset),.wea(hilowriteW),
        .hi(hiloresE[63:32]),.lo(hiloresE[31:0]),
        .hi_r(hiloW[63:32]),.lo_r(hiloW[31:0]) 
        );

     
endmodule