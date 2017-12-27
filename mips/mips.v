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
    
    wire regwriteD,regwriteE,regwriteE1,regwriteM,regwriteM1,regwriteW;
    wire memtoregD,memtoregE,memtoregE1,memtoregM,memtoregM1,memtoregW;
    wire memwriteD,memwriteE,memwriteE1;
    wire branchD,branchE,branchE1,branchM;
    wire [2:0] alucontrolD,alucontrolE;
    wire alusrcD,alusrcE;
    wire regdstD,regdstE;
    wire zeroE,zeroM;
    wire pcsrcD,pcsrcM;
    
    wire [31:0] instrF,instrD;
    wire [31:0] pcplus4F,pcplus4D,pcplus4D1,pcplus4E;
    wire [31:0] srcaD,srcaE;
    wire [31:0] writedataD,writedataE,writedataE1,writedataM;
    wire [4:0] rsD,rsE;
    wire [4:0] rtD,rtE;
    wire [4:0] rdD,rdE;
    wire [31:0] signimmD,signimmE;
    wire [4:0] writeregE,writeregM,writeregM1,writeregW;
    wire [31:0] pcbranchE,pcbranchM;
    wire [31:0] aluoutE,aluoutM,aluoutM1,aluoutW;
    wire [31:0] readdataM,readdataM1,readdataW;
    wire equalD;
    
    wire [1:0] forwardAE,forwardBE;
    wire forwardAD,forwardBD;
    wire stallF,stallD,flushE;

    
    mem_FD fd(
        .clk(clk),.reset(reset),.flush(flush),.stallD(stallD),
        .instrF(instrF),
        .pcplus4F(pcplus4F),
        .instrD(instrD),
        .pcplus4D(pcplus4D)
    );
    
    mem_DE de(
        .clk(clk),.reset(reset),.flush(flushE),
        .RegWriteD(regwriteD),.MemtoRegD(memtoregD),.MemWriteD(memwriteD),.BranchD(branchD),
        .ALUControlD(alucontrolD),
        .ALUSrcD(alusrcD),.RegDstD(regdstD),
        .srcaD(srcaD),.writedataD(writedataD),.signimmD(signimmD),.pcplus4D(pcplus4D1),
        .RsD(rsD),.RtD(rtD),.RdD(rdD),
        .RegWriteE(regwriteE),.MemtoRegE(memtoregE),.MemWriteE(memwriteE),.BranchE(branchE),
        .ALUControlE(alucontrolE),
        .ALUSrcE(alusrcE),.RegDstE(regdstE),
        .srcaE(srcaE),.writedataE(writedataE),
        .RsE(rsE),.RtE(rtE),.RdE(rdE),
        .signimmE(signimmE),.pcplus4E(pcplus4E)
    );
    
    mem_EM em(
        .clk(clk),.reset(reset),.flush(flush),
        .RegWriteE(regwriteE1),.MemtoRegE(memtoregE1),.MemWriteE(memwriteE1),.BranchE(branchE1),.zeroE(zeroE),
        .aluoutE(aluoutE),.writedataE(writedataE1),.writeregE(writeregE),.pcbranchE(pcbranchE),
        .RegWriteM(regwriteM),.MemtoRegM(memtoregM),.MemWriteM(memwrite),.BranchM(branchM),.zeroM(zeroM),
        .aluoutM(aluoutM),.writedataM(writedataM),.writeregM(writeregM),.pcbranchM(pcbranchM)
        );

     mem_MW mw(
        .clk(clk),.reset(reset),.flush(flush),
        .RegWriteM(regwriteM1),.MemtoRegM(memtoregM1),
        .aluoutM(aluoutM1),.readdataM(readdataM1),.writeregM(writeregM1),
        .RegWriteW(regwriteW),.MemtoRegW(memtoregW),
        .aluoutW(aluoutW),.readdataW(readdataW),.writeregW(writeregW)
        );
    
    controller cntr(
        /*-----Decode input------*/
        .opcode(instrD[31:26]),.funct(instrD[5:0]),
        .equalD(equalD),
        /*-----Execute input-----*/
        .regwriteE(regwriteE),.memtoregE(memtoregE),.memwriteE(memwriteE),.branchE(branchE),
        /*-----Memory input-----*/
        .regwriteM(regwriteM),.memtoregM(memtoregM),.branchM(branchM),.zeroM(zeroM),
        /*-----Decode output------*/
        .regwriteD(regwriteD),.memtoregD(memtoregD),.memwriteD(memwriteD),
        .branchD(branchD),.alusrcD(alusrcD),.regdstD(regdstD),.pcsrcD(pcsrcD),.jump(jump),
        .alucontrolD(alucontrolD),
        /*-----Execute output------*/
        .regwriteE1(regwriteE1),.memtoregE1(memtoregE1),.memwriteE1(memwriteE1),.branchE1(branchE1),          
        /*-----Memory output-----*/
        .regwriteM1(regwriteM1),.memtoregM1(memtoregM1),.pcsrcM(pcsrcM)
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