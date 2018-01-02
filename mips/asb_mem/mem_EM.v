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
    input  [31:0] pcplus8E,
    input         div_readyE,
    //output
    output [31:0] aluoutM,writedataM,
    output [4:0]  writeregM,
    output [4:0]  writecp0M,
    output [63:0] hiloresM,
    output [31:0] cp0resM,
    output [31:0] pcplus8M,
    input         div_readyM,
    /*-----exception info-----*/
    //input
    input         adelE,syscallE,breakE,eretE,invalidE,overflowE,in_delayE,
    //output
    output        adelM,syscallM,breakM,eretM,invalidM,overflowM,in_delayM
    );

    wire stallM;
    wire tmp;
    assign stallM=1'b0;

    //6,8,32,32,5,5,64,1,32,32,7 => 224
    D_flip_flop_c #(224) reg_EM(clk,reset,flush,~stallM,
                                {{RegWriteE,MemtoRegE,MemWriteE,memenE,hilowriteE,cp0writeE},
                                 ALUControlE,
                                 aluoutE,
                                 writedataE,
                                 writeregE,
                                 writecp0E,
                                 hiloresE,
                                 div_readyE,
                                 cp0resE,
                                 pcplus8E,
                                 {adelE,syscallE,breakE,eretE,invalidE,overflowE,in_delayE}},
                                {{RegWriteM,MemtoRegM,MemWriteM,memenM,hilowriteM,cp0writeM},
                                 ALUControlM,
                                 aluoutM,
                                 writedataM,
                                 writeregM,
                                 writecp0M,
                                 hiloresM,
                                 div_readyM,
                                 cp0resM,
                                 pcplus8M,
                                 {adelM,syscallM,breakM,eretM,invalidM,overflowM,in_delayM}});
                                 

endmodule