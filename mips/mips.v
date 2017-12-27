module mips(
        input clk,
        input reset,
        input [31:0] instr,
        input [31:0] readdata,
        output [31:0] pc,
        output memwrite,
        output [31:0] aluout,
        output [31:0] writedata
    );
    
    wire zero,memtoreg,pcsrc,alusrc,regdst,regwrit,overflow;
    wire [2:0] alucontroD;
    
    wire flush,jump;
    assign flush=1'b0;
    
    /*-----signal wires-----*/
    wire memtoregD,memtoregE,memtoregM,memtoregW;
    wire memenD;
    wire memwriteD,memwriteE;
    wire alusrcD,alusrcE;
    wire regdstD,regdstE;
    wire regwriteD,regwriteE,regwriteM,regwriteW;
    wire hilowriteD,hilowriteE,hilowriteM,hilowriteW;
    wire jalD,jrD,balD;
    wire [1:0] pcsrcD;
    wire [7:0] alucontrolD,alucontrolE;
    
    /*-----data wires-----*/
    wire zeroE,zeroM;
    wire [31:0] instrF,instrD;
    wire [31:0] pcplus4F,pcplus4D,pcplus4D1,pcplus4E;
    wire [31:0] srcaD,srcaE;
    wire [31:0] writedataD,writedataE,writedataE1,writedataM;
    wire [4:0]  rsD,rsE;
    wire [4:0]  rtD,rtE;
    wire [4:0]  rdD,rdE;
    wire [31:0] signimmD,signimmE;
    wire [4:0]  writeregE,writeregM,writeregM1,writeregW;
    wire [31:0] pcbranchE,pcbranchM;
    wire [31:0] aluoutE,aluoutM,aluoutM1,aluoutW;
    wire [31:0] readdataM,readdataM1,readdataW;
    wire equalD;
    
    wire [1:0] forwardAE,forwardBE;
    wire forwardAD,forwardBD;
    wire stallF,stallD,flushE;

    /*-----Assembly line registers-----*/
    mem_FD fd(
        .clk(clk),.reset(reset),.flush(flush),.stallD(stallD),
        .instrF(instrF),
        .pcplus4F(pcplus4F),
        .instrD(instrD),
        .pcplus4D(pcplus4D)
        );

    mem_DE de(
        .clk(clk),.reset(reset),.flush(flushE),
        /*-----control signals-----*/
        //input
        .RegWriteD(regwriteD),.MemtoRegD(memtoregD),.MemWriteD(memwriteD),
        .ALUSrcD(alusrcD),.RegDstD(regdstD),.hilowriteD(hilowriteD),
        .ALUControlD(alucontrolD),
        //output
        .RegWriteE(regwriteE),.MemtoRegE(memtoregE),.MemWriteE(memwriteE),
        .ALUSrcE(alusrcE),.RegDstE(regdstE),.hilowriteE(hilowriteE),
        .ALUControlE(alucontrolE),
        /*-----data-----*/
        .srcaD(srcaD),.writedataD(writedataD),.signimmD(signimmD),.pcplus4D(pcplus4D1),
        .RsD(rsD),.RtD(rtD),.RdD(rdD),
        .srcaE(srcaE),.writedataE(writedataE),
        .RsE(rsE),.RtE(rtE),.RdE(rdE),
        .signimmE(signimmE),.pcplus4E(pcplus4E)
        );

    mem_EM em(
        .clk(clk),.reset(reset),.flush(flush),
        /*-----control signals-----*/
        //input
        .RegWriteE(regwriteE),.MemtoRegE(memtoregE),.MemWriteE(memwriteE),.hilowriteE(hilowriteE),
        //output
        .RegWriteM(regwriteM),.MemtoRegM(memtoregM),.MemWriteM(memwriteM),.hilowriteM(hilowriteM),
        /*-----data-----*/
        //input
        .aluoutE(aluoutE),.writedataE(writedataE1),.writeregE(writeregE),.pcbranchE(pcbranchE),
        //output
        .aluoutM(aluoutM),.writedataM(writedataM),.writeregM(writeregM),.pcbranchM(pcbranchM)
        );

    mem_MW mw(
        .clk(clk),.reset(reset),.flush(flush),
        .RegWriteM(regwriteM1),.MemtoRegM(memtoregM1),
        .aluoutM(aluoutM1),.readdataM(readdataM1),.writeregM(writeregM1),
        .RegWriteW(regwriteW),.MemtoRegW(memtoregW),
        .aluoutW(aluoutW),.readdataW(readdataW),.writeregW(writeregW)
        );

    mem_MW mw(
        .clk(clk),.reset(reset),.flush(flush),
        /*-----control signals-----*/
        //input
        .RegWriteM(regwriteM),.MemtoRegM(memtoregM),.hilowriteM(hilowriteM),
        //output
        .RegWriteW(regwriteW),.MemtoRegW(memtoregW),.hilowriteW(hilowriteW),
        /*-----data-----*/
        //input
        .aluoutM(aluoutM1),.readdataM(readdataM1),.writeregM(writeregM1),
        //output
        .aluoutW(aluoutW),.readdataW(readdataW),.writeregW(writeregW)
        );
    
    controller cntr(
        /*-----Decode input------*/
        .opcode(instrD[31:26]),.funct(instrD[5:0]),
        .rt(rtD),
        .equalD(equalD),
        /*-----Decode output------*/
        .memtoreg(memtoregD),.memen(memenD),.memwrite(memwriteD),
        .alusrc(alusrcD),
        .regdst(regdstD),.regwrite(regwriteD),.hilowrite(hilowriteD),
        .jal(jalD),.jr(jrD),.bal(balD),
        .pcsrc(pcsrcD),
        .alucontrol(alucontrolD)
       );
        
    datapath dp(
       .clk(clk),.reset(reset),
       /*-----Fetch input----*/
       .pcsrcM(pcsrcM),.pcsrcD(pcsrcD),.jump(jump),
       .pcbranchM(pcbranchM),.instrF(instr),
       /*-----Decode input----*/
       .instrD(instrD),.pcplus4D(pcplus4D),
       .regwriteW(regwriteW),
       .writeregW(writeregW),
       /*-----Execute input----*/
       .alucontrolE(alucontrolE),
       .alusrcE(alusrcE),.regdstE(regdstE),
       .srcaE(srcaE),.writedataE(writedataE),.signimmE(signimmE),.pcplus4E(pcplus4E),
       .RtE(rtE),.RdE(rdE),
       /*-----Memory input----*/
       .aluoutM(aluoutM),.writedataM(writedataM),.writeregM(writeregM),.readdataM(readdata),
       /*-----Writeback input----*/
       .memtoregW(memtoregW),
       .aluoutW(aluoutW),.readdataW(readdataW),
        /*-----hazard input-----*/
       .forwardAE(forwardAE),.forwardBE(forwardBE),
       .forwardAD(forwardAD),.forwardBD(forwardBD),
       .stallF(stallF),
       /*-----Fetch output----*/
       .pcF(pc),.pcplus4F(pcplus4F),.instrF1(instrF),
       /*-----Decode output----*/
       .srcaD(srcaD),.writedataD(writedataD),
       .rsD(rsD),.rtD(rtD),.rdD(rdD),
       .signimmD(signimmD),.pcplus4D1(pcplus4D1),
       .equalD(equalD),
       /*-----Execute output----*/
       .zeroE(zeroE),
       .aluoutE(aluoutE),.writedataE1(writedataE1),.pcbranchE(pcbranchE),
       .writeregE(writeregE),
       /*-----Memory output----*/
       .aluoutM1(aluoutM1),.readdataM1(readdataM1),.writedataM1(writedata),
       .writeregM1(writeregM1),
       
       .overflow(overflow)
       );

  assign aluout=aluoutM1;
  
  hazard_unit hzu(
          .regwriteM(regwriteM),.regwriteW(regwriteW),.regwriteE(regwriteE),
          .memtoregE(memtoregE),.memtoregM(memtoregM),
          .branchD(branchD),
          .writeregE(writeregE),.writeregM(writeregM),.writeregW(writeregW),
          .rsD(rsD),.rtD(rtD),
          .rsE(rsE),.rtE(rtE),
          .forwardAE(forwardAE),.forwardBE(forwardBE),
          .forwardAD(forwardAD),.forwardBD(forwardBD),
          .stallD(stallD),.stallF(stallF),.flushE(flushE)
      );
    
endmodule