module mem_EM(
    input clk,
    input reset,
    input flush,
    /*-----control signals-----*/
    //input
    input RegWriteE,MemtoRegE,MemWriteE,hilowriteE,
    //output
    output RegWriteM,MemtoRegM,MemWriteM,hilowriteM,
    /*-----data-----*/
    //input
    input [31:0] aluoutE,writedataE,writeregE,pcbranchE,
    //output
    output [31:0] aluoutM,writedataM,writeregM,pcbranchM
    );

    wire stallE;
    assign stallE=1'b0;

    D_flip_flop_c #(4) reg_signal(clk,reset,flush,~stallE,
                                  {RegWriteE,MemtoRegE,MemWriteE,hilowriteE},
                                  {RegWriteM,MemtoRegM,MemWriteM,hilowriteM});
    D_flip_flop_c #(32) reg_aluout(clk,reset,flush,~stallE,aluoutE,aluoutM);
    D_flip_flop_c #(32) reg_writedata(clk,reset,flush,~stallE,writedataE,writedataM);
    D_flip_flop_c #(32) reg_writereg(clk,reset,flush,~stallE,writeregE,writeregM);
    D_flip_flop_c #(32) reg_pcbranch(clk,reset,flush,~stallE,pcbranchE,pcbranchM);

endmodule