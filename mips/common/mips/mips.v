module mips(
        input         clk,
        input         reset,
        input  [31:0] instr,
        input  [31:0] readdata,
        output [31:0] pc,
        output        memwrite,
        output [31:0] aluout,
        output [31:0] writedata
    );
    
    wire zero,overflow;
    
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
    wire [31:0] instrF,instrD;
    wire [31:0] pcplus4F,pcplus4D;
    wire [31:0] srcaD,srcaE;
    wire [31:0] writedataD,writedataE,writedataE1,writedataM;
    wire [4:0]  rsD,rsE;
    wire [4:0]  rtD,rtE;
    wire [4:0]  rdD,rdE;
    wire [4:0]  saD,saE;
    wire [31:0] signimmD,signimmE;
    wire [4:0]  writeregE,writeregM,writeregM1,writeregW;
    wire [31:0] aluoutE,aluoutM,aluoutM1,aluoutW;
    wire [31:0] readdataM,readdataW;
    wire [63:0] hiloresE,hiloresM,hiloresM1,hiloresW;
    wire equalD;
    
    wire [1:0] forwardAE,forwardBE;
    wire forwardAD,forwardBD;
    wire forwardhiloE;
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
        //input
        .srcaD(srcaD),.writedataD(writedataD),.signimmD(signimmD),
        .rsD(rsD),.rtD(rtD),.rdD(rdD),.saD(saD),
        //output
        .srcaE(srcaE),.writedataE(writedataE),.signimmE(signimmE),
        .rsE(rsE),.rtE(rtE),.rdE(rdE),.saE(saE)
        );

    mem_EM em(
        .clk(clk),.reset(reset),.flush(flush),
        /*-----control signals-----*/
        //input
        .RegWriteE(regwriteE&(!overflow)),.MemtoRegE(memtoregE),.MemWriteE(memwriteE),.hilowriteE(hilowriteE),
        //output
        .RegWriteM(regwriteM),.MemtoRegM(memtoregM),.MemWriteM(memwrite),.hilowriteM(hilowriteM),
        /*-----data-----*/
        //input
        .aluoutE(aluoutE),.writedataE(writedataE1),
        .writeregE(writeregE),
        .hiloresE(hiloresE),
        //output
        .aluoutM(aluoutM),.writedataM(writedataM),
        .writeregM(writeregM),
        .hiloresM(hiloresM)
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
        .aluoutM(aluoutM1),.readdataM(readdataM),
        .hiloresM(hiloresM1),
        .writeregM(writeregM1),
        //output
        .aluoutW(aluoutW),.readdataW(readdataW),
        .hiloresW(hiloresW),
        .writeregW(writeregW)
        );
    
    /*-----Controller Unit-----*/
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

    /*-----Datapath----*/
    datapath dp(
        .clk(clk),.reset(reset),
        /*-----Fetch input----*/
        .pcsrcD(pcsrcD),.instrF(instr),
        /*-----Decode input----*/
        .instrD(instrD),.pcplus4D(pcplus4D),
        .regwriteW(regwriteW),
        .writeregW(writeregW),
        /*-----Execute input----*/
        .alucontrolE(alucontrolE),
        .alusrcE(alusrcE),.regdstE(regdstE),
        .srcaE(srcaE),.writedataE(writedataE),.signimmE(signimmE),
        .rtE(rtE),.rdE(rdE),.saE(saE),
        /*-----Memory input----*/
        .aluoutM(aluoutM),.writedataM(writedataM),.writeregM(writeregM),.readdataM(readdata),
        .hiloresM(hiloresM),
        /*-----Writeback input----*/
        .memtoregW(memtoregW),.hilowriteW(hilowriteW),
        .aluoutW(aluoutW),.readdataW(readdataW),
        .hiloresW(hiloresW),
        /*-----hazard input-----*/
        .forwardAE(forwardAE),.forwardBE(forwardBE),
        .forwardAD(forwardAD),.forwardBD(forwardBD),
        .forwardhiloE(forwardhiloE),
        .stallF(stallF),
        /*-----Fetch output----*/
        .pcF(pc),.pcplus4F(pcplus4F),.instrF1(instrF),
        /*-----Decode output----*/
        .srcaD(srcaD),.writedataD(writedataD),
        .rsD(rsD),.rtD(rtD),.rdD(rdD),.saD(saD),
        .signimmD(signimmD),
        .equalD(equalD),
        /*-----Execute output----*/
        .aluoutE(aluoutE),.writedataE1(writedataE1),
        .hiloresE(hiloresE),
        .writeregE(writeregE),
        /*-----Memory output----*/
        .aluoutM1(aluoutM1),.readdataM1(readdataM),.writedataM1(writedata),
        .hiloresM1(hiloresM1),
        .writeregM1(writeregM1),
        
        .overflow(overflow)
        );
  assign aluout=aluoutM1;
  
  /*-----Hazard Processor-----*/
  hazard_unit hzu(
        .regwriteM(regwriteM),.regwriteW(regwriteW),.regwriteE(regwriteE),.hilowriteM(hilowriteM),
        .memtoregE(memtoregE),.memtoregM(memtoregM),
        //.branchD(branchD),
        .writeregE(writeregE),.writeregM(writeregM),.writeregW(writeregW),
        .rsD(rsD),.rtD(rtD),
        .rsE(rsE),.rtE(rtE),
        .forwardAE(forwardAE),.forwardBE(forwardBE),
        .forwardAD(forwardAD),.forwardBD(forwardBD),
        .forwardhiloE(forwardhiloE),
        .stallD(stallD),.stallF(stallF),.flushE(flushE)
        );
    
endmodule