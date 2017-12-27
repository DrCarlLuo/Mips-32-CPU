module mem_MW(
    input clk,
    input reset,
    input flush,
    /*-----control signals-----*/
    //input
    input RegWriteM,MemtoRegM,hilowriteM,
    //output
    output RegWriteW,MemtoRegW,hilowriteW,
    /*-----data-----*/
    //input
    input [31:0] aluoutM,readdataM,
    input [4:0] writeregM,
    //output
    output [31:0] aluoutW,readdataW,
    output [4:0] writeregW
    );

    wire stallM;
    assign stallM=1'b0;
    
    D_flip_flop_c #(3) reg_signal(clk,reset,flush,~stallM,
                                  {RegWriteM,MemtoRegM,hilowriteM},
                                  {RegWriteW,MemtoRegW,hilowriteW});
    D_flip_flop_c #(32) reg_aluout(clk,reset,flush,~stallM,aluoutM,aluoutW);
    D_flip_flop_c #(32) reg_readdata(clk,reset,flush,~stallM,readdataM,readdataW);
    D_flip_flop_c #(32) reg_writereg(clk,reset,flush,~stallM,writeregM,writeregW);

endmodule
