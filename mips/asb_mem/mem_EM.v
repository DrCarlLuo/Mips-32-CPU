module mem_EM(
    input clk,reset,flush,
    /*-----control signals-----*/
    //input
    input         RegWriteE,MemtoRegE,MemWriteE,memenE,hilowriteE,
    input  [7:0]  ALUControlE,
    //output
    output        RegWriteM,MemtoRegM,MemWriteM,memenM,hilowriteM,
    output [7:0]  ALUControlM,
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

    //5,32,32,5,64,1 => 139
    D_flip_flop_c #(139) reg_EM(clk,reset,flush,~stallM,
                                {{RegWriteE,MemtoRegE,MemWriteE,memenE,hilowriteE},
                                 aluoutE,
                                 writedataE,
                                 writeregE,
                                 hiloresE,
                                 div_readyE},
                                {{RegWriteM,MemtoRegM,MemWriteM,memenM,hilowriteM},
                                 aluoutM,
                                 writedataM,
                                 writeregM,
                                 hiloresM,
                                 div_readyM});

endmodule