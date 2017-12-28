`timescale 1ns / 1ps
module mem_MW(
    input         clk,reset,flush,
    /*-----control signals-----*/
    //input
    input         RegWriteM,MemtoRegM,hilowriteM,
    //output
    output        RegWriteW,MemtoRegW,hilowriteW,
    /*-----data-----*/
    //input
    input  [31:0] aluoutM,readdataM,
    input  [63:0] hiloresM,
    input  [4:0]  writeregM,
    //output
    output [31:0] aluoutW,readdataW,
    output [63:0] hiloresW,
    output [4:0]  writeregW
    );

    wire stallM;
    assign stallM=1'b0;

    //3,32,32,64,5 => 136
    D_flip_flop_c #(136) reg_MW(clk,reset,flush,~stallM,
                                {{RegWriteM,MemtoRegM,hilowriteM},
                                 aluoutM,
                                 readdataM,
                                 hiloresM,
                                 writeregM},
                                {{RegWriteW,MemtoRegW,hilowriteW},
                                 aluoutW,
                                 readdataW,
                                 hiloresW,
                                 writeregW});

endmodule
