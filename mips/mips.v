module mips(
        input         clk,
        input         reset,
        input         stall_by_iram,
        input  [31:0] instr,
        input  [31:0] readdata,
        input  [5:0]  int_i,
        output [31:0] pc,
        output        memen,
        output [3:0]  wea,
        output [31:0] aluout,
        output [31:0] writedata,
        output        memwriteM,adelM,adesM
    );
    
    wire zero,overflow;
    
    wire flush,jump;
    assign flush=1'b0;
    
    /*-----signal wires-----*/
    wire memtoregD,memtoregE,memtoregM,memtoregW;
    wire memenD,memenE,memenM;
    wire memwriteD,memwriteE,memwriteM1;
    wire branchD,jumpD;
    wire alusrcD,alusrcE;
    wire regdstD,regdstE;
    wire regwriteD,regwriteE,regwriteM,regwriteW;
    wire hilowriteD,hilowriteE,hilowriteM,hilowriteW;
    wire cp0writeD,cp0writeE,cp0writeM,cp0writeW;
    wire jalD,jalE;
    wire jrD,jrE;
    wire balD,balE;
    wire [1:0] pcsrcD;
    wire [7:0] alucontrolD,alucontrolE,alucontrolM;
    
    /*-----data wires-----*/
    wire [31:0] instrF,instrD;
    wire [31:0] pcplus4F,pcplus4D;
    wire [31:0] pcplus8D,pcplus8E,pcplus8E1,pcplus8M;
    wire [31:0] srcaD,srcaE;
    wire [31:0] writedataD,writedataE,writedataE1,writedataM;
    wire [4:0]  rsD,rsE;
    wire [4:0]  rtD,rtE;
    wire [4:0]  rdD,rdE;
    wire [4:0]  saD,saE;
    wire [31:0] signimmD,signimmE;
    wire [4:0]  writeregE,writeregM,writeregM1,writeregW;
    wire [4:0]  writecp0E,writecp0M,writecp0M1,writecp0W;
    wire [31:0] aluoutE,aluoutM,aluoutM1,aluoutW;
    wire [31:0] readdataM,readdataW;
    wire [63:0] hiloresE,hiloresM,hiloresM1,hiloresW;
    wire [31:0] cp0resE,cp0resM,cp0resM1,cp0resW;
    wire [31:0] compa,compb;
    wire        div_readyE,div_readyM;
    wire        stall_divE;
    wire [31:0] cp0dataD,cp0dataE;
    
    /*-----hazard wires-----*/
    wire [1:0] forwardAE,forwardBE;
    wire forwardAD,forwardBD;
    wire forwardhiloE;
    wire [1:0] forwardcp0E;
    wire stallF,stallD,stallE;
    wire flushF,flushD,flushE,flushM,flushW;
    wire [31:0] newpcF,epcM;

    /*-----exception wires-----*/
    wire adelF,adelD,adelE,adelM1;
    wire syscallD,syscallE,syscallM;
    wire breakD,breakE,breakM;
    wire eretD,eretE,eretM;
    wire invalidD,invalidE,invalidM;
    wire overflowE,overflowM;
    wire in_delayF,in_delayD,in_delayE,in_delayM;
    wire [31:0] excepttype;
    wire [31:0] bad_addrF,bad_addrD,bad_addrE,bad_addrM;
    
    assign memen=memenM&(excepttype==32'h0);
    assign memwriteM=memwriteM1&(excepttype==32'h0);
    assign in_delayF=jumpD|branchD;

    /*-----Assembly line registers-----*/
    mem_FD fd(
        .clk(clk),.reset(reset),.flush(flushD),.stallD(stallD),
        .instrF(instrF),
        .pcplus4F(pcplus4F),
        .instrD(instrD),
        .pcplus4D(pcplus4D),
        /*-----exception info-----*/
        .adelF(adelF),.in_delayF(in_delayF),
        .bad_addrF(bad_addrF),
        .adelD(adelD),.in_delayD(in_delayD),
        .bad_addrD(bad_addrD)
        );

    mem_DE de(
        .clk(clk),.reset(reset),.flush(flushE),.stallE(stallE),
        /*-----control signals-----*/
        //input
        .RegWriteD(regwriteD),.MemtoRegD(memtoregD),.MemWriteD(memwriteD),.memenD(memenD),
        .ALUSrcD(alusrcD),.RegDstD(regdstD),.hilowriteD(hilowriteD),.cp0writeD(cp0writeD),
        .balD(balD),.jrD(jrD),.jalD(jalD),
        .ALUControlD(alucontrolD),
        //output
        .RegWriteE(regwriteE),.MemtoRegE(memtoregE),.MemWriteE(memwriteE),.memenE(memenE),
        .ALUSrcE(alusrcE),.RegDstE(regdstE),.hilowriteE(hilowriteE),.cp0writeE(cp0writeE),
        .balE(balE),.jrE(jrE),.jalE(jalE),
        .ALUControlE(alucontrolE),
        /*-----data-----*/
        //input
        .srcaD(srcaD),.writedataD(writedataD),.signimmD(signimmD),
        .pcplus8D(pcplus8D),
        .rsD(rsD),.rtD(rtD),.rdD(rdD),.saD(saD),
        .cp0dataD(cp0dataD),
        //output
        .srcaE(srcaE),.writedataE(writedataE),.signimmE(signimmE),
        .pcplus8E(pcplus8E),
        .rsE(rsE),.rtE(rtE),.rdE(rdE),.saE(saE),
        .cp0dataE(cp0dataE),
        /*-----exception info-----*/
        //input
        .adelD(adelD),.syscallD(syscallD),.breakD(breakD),
        .eretD(eretD),.invalidD(invalidD),.in_delayD(in_delayD),
        .bad_addrD(bad_addrD),
        //output
        .adelE(adelE),.syscallE(syscallE),.breakE(breakE),
        .eretE(eretE),.invalidE(invalidE),.in_delayE(in_delayE),
        .bad_addrE(bad_addrE)
        );

    mem_EM em(
        .clk(clk),.reset(reset),.flush(flushM),
        /*-----control signals-----*/
        //input
        .RegWriteE(regwriteE&(!overflowE)),.MemtoRegE(memtoregE),.MemWriteE(memwriteE),
        .memenE(memenE),.hilowriteE(hilowriteE),.cp0writeE(cp0writeE),
        .ALUControlE(alucontrolE),
        //output
        .RegWriteM(regwriteM),.MemtoRegM(memtoregM),.MemWriteM(memwriteM1),
        .memenM(memenM),.hilowriteM(hilowriteM),.cp0writeM(cp0writeM),
        .ALUControlM(alucontrolM),
        /*-----data-----*/
        //input
        .aluoutE(aluoutE),.writedataE(writedataE1),
        .writeregE(writeregE),
        .writecp0E(writecp0E),
        .hiloresE(hiloresE),
        .cp0resE(cp0resE),
        .pcplus8E(pcplus8E1),
        .div_readyE(div_readyE&&!div_readyM),
        //output
        .aluoutM(aluoutM),.writedataM(writedataM),
        .writeregM(writeregM),
        .writecp0M(writecp0M),
        .hiloresM(hiloresM),
        .cp0resM(cp0resM),
        .pcplus8M(pcplus8M),
        .div_readyM(div_readyM),
        /*-----exception info-----*/
        //input
        .adelE(adelE),.syscallE(syscallE),.breakE(breakE),
        .eretE(eretE),.invalidE(invalidE),.overflowE(overflowE),.in_delayE(in_delayE),
        .bad_addrE(bad_addrE),
        //output
        .adelM(adelM1),.syscallM(syscallM),.breakM(breakM),
        .eretM(eretM),.invalidM(invalidM),.overflowM(overflowM),.in_delayM(in_delayM),
        .bad_addrM(bad_addrM)
        );

    mem_MW mw(
        .clk(clk),.reset(reset),.flush(flushW),
        /*-----control signals-----*/
        //input
        .RegWriteM(regwriteM),.MemtoRegM(memtoregM),.hilowriteM(hilowriteM),.cp0writeM(cp0writeM),
        //output
        .RegWriteW(regwriteW),.MemtoRegW(memtoregW),.hilowriteW(hilowriteW),.cp0writeW(cp0writeW),
        /*-----data-----*/
        //input
        .aluoutM(aluoutM1),.readdataM(readdataM),
        .hiloresM(hiloresM1),
        .cp0resM(cp0resM),
        .writeregM(writeregM1),
        .writecp0M(writecp0M1),
        //output
        .aluoutW(aluoutW),.readdataW(readdataW),
        .hiloresW(hiloresW),
        .cp0resW(cp0resW),
        .writeregW(writeregW),
        .writecp0W(writecp0W)
        );
    
    /*-----Controller Unit-----*/
    controller cntr(
        /*-----Decode input------*/
        .instrD(instrD),
        .compa(compa),.compb(compb),
        /*-----Decode output------*/
        .memtoreg(memtoregD),.memen(memenD),.memwrite(memwriteD),
        .alusrc(alusrcD),.branch(branchD),.jump(jumpD),
        .regdst(regdstD),.regwrite(regwriteD),.hilowrite(hilowriteD),.cp0write(cp0writeD),
        .jal(jalD),.jr(jrD),.bal(balD),
        .syscallD(syscallD),.breakD(breakD),.eretD(eretD),.invalidD(invalidD),
        .pcsrc(pcsrcD),
        .alucontrol(alucontrolD)
        );

    /*-----Datapath----*/
    datapath dp(
        .clk(clk),.reset(reset),
        /*-----Fetch input----*/
        .pcsrcD(pcsrcD),.instrF(instr),.newpcF(newpcF),
        /*-----Decode input----*/
        .instrD(instrD),.pcplus4D(pcplus4D),
        .regwriteW(regwriteW),.cp0writeW(cp0writeW),
        .writeregW(writeregW),
        .writecp0W(writecp0W),
        /*-----Execute input----*/
        .alucontrolE(alucontrolE),
        .alusrcE(alusrcE),.regdstE(regdstE),
        .balE(balE),.jrE(jrE),.jalE(jalE),
        .srcaE(srcaE),.writedataE(writedataE),.signimmE(signimmE),
        .pcplus8E(pcplus8E),
        .cp0dataE(cp0dataE),
        .rtE(rtE),.rdE(rdE),.saE(saE),
        /*-----Memory input----*/
        .memwriteM(memwriteM1),.memtoregM(memtoregM),
        .aluoutM(aluoutM),.writedataM(writedataM),.readdata(readdata),
        .writeregM(writeregM),.writecp0M(writecp0M),
        .alucontrolM(alucontrolM),
        .hiloresM(hiloresM),
        .cp0resM(cp0resM),
        .pcplus8M(pcplus8M),
        .div_readyM(div_readyM),
        .adelM(adelM1),.syscallM(syscallM),.breakM(breakM),.eretM(eretM),
        .invalidM(invalidM),.overflowM(overflowM),.in_delayM(in_delayM),
        .int_i(int_i),
        .bad_addrM(bad_addrM),
        /*-----Writeback input----*/
        .memtoregW(memtoregW),.hilowriteW(hilowriteW),
        .aluoutW(aluoutW),.readdataW(readdataW),
        .hiloresW(hiloresW),
        .cp0resW(cp0resW),
        /*-----hazard input-----*/
        .forwardAE(forwardAE),.forwardBE(forwardBE),
        .forwardAD(forwardAD),.forwardBD(forwardBD),
        .forwardhiloE(forwardhiloE),.forwardcp0E(forwardcp0E),
        .stallF(stallF),.flushF(flushF),
        /*-----Fetch output----*/
        .pcF(pc),.pcplus4F(pcplus4F),.instrF1(instrF),
        .adelF(adelF),
        .bad_addrF(bad_addrF),
        /*-----Decode output----*/
        .srcaD(srcaD),.writedataD(writedataD),
        .rsD(rsD),.rtD(rtD),.rdD(rdD),.saD(saD),
        .signimmD(signimmD),
        .pcplus8D(pcplus8D),
        .cp0dataD(cp0dataD),
        .compa(compa),.compb(compb),
        /*-----Execute output----*/
        .aluoutE(aluoutE),.writedataE1(writedataE1),
        .hiloresE(hiloresE),
        .cp0resE(cp0resE),
        .writeregE(writeregE),
        .writecp0E(writecp0E),
        .pcplus8E1(pcplus8E1),
        .div_readyE(div_readyE),.stall_div(stall_divE), 
        .overflowE(overflowE),
        /*-----Memory output----*/
        .aluoutM1(aluoutM1),.readdataM(readdataM),.writedata(writedata),
        .hiloresM1(hiloresM1),
        .cp0resM1(cp0resM1),
        .writeregM1(writeregM1),
        .writecp0M1(writecp0M1),
        .wea(wea),
        .excepttype(excepttype),.epcM(epcM),
        .adesM(adesM),.adel_final(adelM)
        );
  assign aluout=aluoutM1;
  
  /*-----Hazard Processor-----*/
  hazard_unit hzu(
        .stall_by_iram(stall_by_iram),
        .regwriteM(regwriteM),.regwriteW(regwriteW),.regwriteE(regwriteE),.hilowriteM(hilowriteM),
        .cp0writeM(cp0writeM),.cp0writeW(cp0writeW),
        .memtoregE(memtoregE),.memtoregM(memtoregM),
        .branchD(branchD),.jumpD(jumpD),.stall_divE(stall_divE),
        .writeregE(writeregE),.writeregM(writeregM),.writeregW(writeregW),
        .writecp0M(writecp0M),.writecp0W(writecp0W),
        .rsD(rsD),.rtD(rtD),
        .rsE(rsE),.rtE(rtE),.rdE(rdE),
        .excepttype(excepttype),.epcM(epcM),
        .forwardAE(forwardAE),.forwardBE(forwardBE),
        .forwardAD(forwardAD),.forwardBD(forwardBD),
        .forwardhiloE(forwardhiloE),
        .forwardcp0E(forwardcp0E),
        .stallD(stallD),.stallF(stallF),.stallE(stallE),
        .flushF(flushF),.flushD(flushD),.flushE(flushE),.flushM(flushM),.flushW(flushW),
        .newpcF(newpcF)
        );
    
endmodule