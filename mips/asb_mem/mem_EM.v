module mem_EM(
    input clk,reset,flush,
    /*-----control signals-----*/
    //input
    input         RegWriteE,MemtoRegE,MemWriteE,memenE,hilowriteE,cp0writeE,
    input  [7:0]  ALUControlE,
    //output
    output        RegWriteM,MemtoRegM,MemWriteM,memenM,hilowriteM,cp0writeM,
    output [7:0]  ALUControlM,
    /*-----data-----*/
    //input
    input  [31:0] aluoutE,writedataE,
    input  [4:0]  writeregE,
    input  [4:0]  writecp0E,
    input  [63:0] hiloresE,
    input  [31:0] cp0resE,
    input         div_readyE,
    //output
    output [31:0] aluoutM,writedataM,
    output [4:0]  writeregM,
    output [4:0]  writecp0M,
    output [63:0] hiloresM,
    output [31:0] cp0resM,
    input         div_readyM,
    /*-----exception info-----*/
    //input
    input         adelE,syscallE,breakE,eretE,invalidE,overflowE,
    //output
    output        adelM,syscallM,breakM,eretM,invalidM,overflowM
    );

    wire stallM;
    wire tmp;
    assign stallM=1'b0;

    //6,8,32,32,5,5,64,1,32,6 => 191
    D_flip_flop_c #(191) reg_EM(clk,reset,flush,~stallM,
                                {{RegWriteE,MemtoRegE,MemWriteE,memenE,hilowriteE,cp0writeE},
                                 ALUControlE,
                                 aluoutE,
                                 writedataE,
                                 writeregE,
                                 writecp0E,
                                 hiloresE,
                                 div_readyE,
                                 cp0resE,
                                 {adelE,syscallE,breakE,eretE,invalidE,overflowE}},
                                {{RegWriteM,MemtoRegM,MemWriteM,memenM,hilowriteM,cp0writeM},
                                 ALUControlM,
                                 aluoutM,
                                 writedataM,
                                 writeregM,
                                 writecp0M,
                                 hiloresM,
                                 div_readyM,
                                 cp0resM,
                                 {adelM,syscallM,breakM,eretM,invalidM,overflowM}});
                                 

endmodule