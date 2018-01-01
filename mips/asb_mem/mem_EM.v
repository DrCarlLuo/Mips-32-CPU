module mem_EM(
    input clk,reset,flush,
    /*-----control signals-----*/
    //input
    input         RegWriteE,MemtoRegE,MemWriteE,hilowriteE,
    //output
    output        RegWriteM,MemtoRegM,MemWriteM,hilowriteM,
    /*-----data-----*/
    //input
    input  [31:0] aluoutE,writedataE,
    input  [4:0]  writeregE,
    input  [63:0] hiloresE,
    input         div_readyE,
    //output
    output [31:0] aluoutM,writedataM,
    output [4:0]  writeregM,
    output [63:0] hiloresM,
    input         div_readyM
    );

    wire stallM;
    assign stallM=1'b0;

    //4,32,32,5,64,1 => 138
    D_flip_flop_c #(138) reg_EM(clk,reset,flush,~stallM,
                                {{RegWriteE,MemtoRegE,MemWriteE,hilowriteE},
                                 aluoutE,
                                 writedataE,
                                 writeregE,
                                 hiloresE,
                                 div_readyE},
                                {{RegWriteM,MemtoRegM,MemWriteM,hilowriteM},
                                 aluoutM,
                                 writedataM,
                                 writeregM,
                                 hiloresM,
                                 div_readyM});

endmodule