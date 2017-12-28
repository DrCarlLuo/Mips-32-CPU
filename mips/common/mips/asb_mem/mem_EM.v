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
    //output
    output [31:0] aluoutM,writedataM,
    output [4:0]  writeregM,
    output [63:0] hiloresM
    );

    wire stallE;
    assign stallE=1'b0;

    //4,32,32,5,64 => 137
    D_flip_flop_c #(137) reg_EM(clk,reset,flush,~stallE,
                                {{RegWriteE,MemtoRegE,MemWriteE,hilowriteE},
                                 aluoutE,
                                 writedataE,
                                 writeregE,
                                 hiloresE},
                                {{RegWriteM,MemtoRegM,MemWriteM,hilowriteM},
                                 aluoutM,
                                 writedataM,
                                 writeregM,
                                 hiloresM});

endmodule