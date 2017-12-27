module mem_EM(
        input clk,
        input reset,
        input flush,
        input RegWriteE,MemtoRegE,MemWriteE,BranchE,zeroE,
        input [31:0] aluoutE,writedataE,writeregE,pcbranchE,
        output RegWriteM,MemtoRegM,MemWriteM,BranchM,zeroM,
        output [31:0] aluoutM,writedataM,writeregM,pcbranchM
);

        wire stallE;
        assign stallE=1'b0;
        
        D_flip_flop_c #(5) reg_signal(clk,reset,flush,~stallE,{RegWriteE,MemtoRegE,MemWriteE,BranchE,zeroE},{RegWriteM,MemtoRegM,MemWriteM,BranchM,zeroM});
        D_flip_flop_c #(32) reg_aluout(clk,reset,flush,~stallE,aluoutE,aluoutM);
        D_flip_flop_c #(32) reg_writedata(clk,reset,flush,~stallE,writedataE,writedataM);
        D_flip_flop_c #(32) reg_writereg(clk,reset,flush,~stallE,writeregE,writeregM);
        D_flip_flop_c #(32) reg_pcbranch(clk,reset,flush,~stallE,pcbranchE,pcbranchM);

endmodule