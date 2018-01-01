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
    input         balE,jrE,jalE,
    input  [31:0] srcaE,writedataE,signimmE,
    input  [31:0] pcplus8E,
    input  [4:0]  rtE,rdE,saE,
    /*-----Memory input----*/
    input         memwriteM,
    input  [31:0] aluoutM,writedataM,writeregM,readdata,
    input  [7:0]  alucontrolM,
    input  [63:0] hiloresM,
    input         div_readyM,
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
    output [31:0] pcplus8D,
    output [31:0] compa,compb,
    /*-----Execute output----*/
    output [31:0] aluoutE,writedataE1,
    output [63:0] hiloresE,
    output [4:0]  writeregE,
    output        div_readyE,stall_div,
    /*-----Memory output----*/
    output [31:0] aluoutM1,readdataM,writedata,
    output [63:0] hiloresM1,
    output [4:0]  writeregM1,
    output [3:0]  wea,
    
    output overflow,zero
    );
    
    wire [31:0] nxtpc;
    wire [31:0] pcjump;
    wire [31:0] srca;
    wire [31:0] srcbE;
    wire [63:0] hilo,hiloW;
    wire [31:0] resultW;
    wire [31:0] pcbranchD;

    wire [5:0]  writeregE_pre;
    wire [31:0] aluoutE_pre;

    wire        div_annul;
    wire [63:0] div_resE;
    
    /*-----Fetch-----*/
    assign pcplus4F=pcF+32'h4;
    D_flip_flop #(32) pcreg(clk,reset,~stallF,nxtpc,pcF);
    assign instrF1=instrF;
    mux3 #(32) pcmux(pcplus4F,pcbranchD,pcjump,pcsrcD,nxtpc);
    
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
    assign pcplus8D=pcplus4D+32'h4;

    mux2 #(32) jump_mux({pcplus4D[31:28],instrD[25:0],2'b00},srcaD,(pcsrcD[1]&&(instrD[31:26]==6'b000000)),pcjump);
     
    mux2 #(32) eqmuxa(srcaD,aluoutM,forwardAD,compa);
    mux2 #(32) eqmuxb(writedataD,aluoutM,forwardBD,compb);
     
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
                .div_res(div_resE),
                .div_readyE(div_readyE),.div_readyM(div_readyM),
                .aluout(aluoutE_pre),
                .hilores(hiloresE),
                .stall_div(stall_div),
                .overflow(overflow),
                .zero(zero)
                );

    mux2 #(32) writereg_mux(rtE,rdE,regdstE,writeregE_pre);
    mux2 #(5)  alreg_mux(writeregE_pre,5'b11111,jalE|balE,writeregE);
    mux2 #(32) alres_mux(aluoutE_pre,pcplus8E,jalE|jrE|balE,aluoutE);

    div div_unit(
        .clk(clk),.rst(reset),
        .signed_div_i(~alucontrolE[0]),
        .opdata1_i(srca),.opdata2_i(srcbE),
        .start_i(stall_div),.annul_i(div_annul),
        .result_o(div_resE),.ready_o(div_readyE)
        );
    assign div_annul=1'b0;
     
    /*-----Memory-----*/
    assign aluoutM1=aluoutM;
    assign writeregM1=writeregM;
    assign hiloresM1=hiloresM;

    memsel mem_unit(.alucontrolM(alucontrolM),
                    .aluoutM(aluoutM),
                    .writedataM(writedataM),
                    .memwriteM(memwriteM),
                    .readdata(readdata),
                    .wea(wea),
                    .readdataM(readdataM),
                    .writedata(writedata));
    
    /*-----Writeback-----*/
    mux2 #(32) result_mux(aluoutW,readdataW,memtoregW,resultW);
    hilo_reg the_hilo(
        .clk(clk),.rst(reset),.wea(hilowriteW),
        .hi(hiloresE[63:32]),.lo(hiloresE[31:0]),
        .hi_r(hiloW[63:32]),.lo_r(hiloW[31:0]) 
        );

     
endmodule