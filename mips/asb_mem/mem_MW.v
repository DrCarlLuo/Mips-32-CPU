module mem_MW(
    input         clk,reset,flush,
    /*-----control signals-----*/
    //input
    input         RegWriteM,MemtoRegM,hilowriteM,cp0writeM,
    //output
    output        RegWriteW,MemtoRegW,hilowriteW,cp0writeW,
    /*-----data-----*/
    //input
    input  [31:0] aluoutM,readdataM,
    input  [63:0] hiloresM,
    input  [31:0] cp0resM,
    input  [4:0]  writeregM,
    input  [4:0]  writecp0M,
    //output
    output [31:0] aluoutW,readdataW,
    output [63:0] hiloresW,
    output [31:0] cp0resW,
    output [4:0]  writeregW,
    output [4:0]  writecp0W
    /*-----exception info-----*/
    );

    wire stallW;
    assign stallW=1'b0;

    //4,32,32,64,32,5,5 => 174
    D_flip_flop_c #(174) reg_MW(clk,reset,flush,~stallW,
                                {{RegWriteM,MemtoRegM,hilowriteM,cp0writeM},
                                 aluoutM,
                                 readdataM,
                                 hiloresM,
                                 cp0resM,
                                 writeregM,
                                 writecp0M},
                                {{RegWriteW,MemtoRegW,hilowriteW,cp0writeW},
                                 aluoutW,
                                 readdataW,
                                 hiloresW,
                                 cp0resW,
                                 writeregW,
                                 writecp0W});

endmodule
