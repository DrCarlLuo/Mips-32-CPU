module mem_DE(
    input clk,
    input reset,
    input flush,
    input RegWriteD,MemtoRegD,MemWriteD,BranchD,
    input [2:0] ALUControlD,
    input ALUSrcD,RegDstD,
    input [31:0] srcaD,writedataD,signimmD,pcplus4D,
    input [4:0] RsD,RtD,RdD,
    output RegWriteE,MemtoRegE,MemWriteE,BranchE,
    output [2:0] ALUControlE,
    output ALUSrcE,RegDstE,
    output [31:0] srcaE,writedataE,
    output [4:0] RsE,RtE,RdE,
    output [31:0] signimmE,pcplus4E
);

    wire stallD;
    assign stallD=1'b0;
    
    D_flip_flop_c #(9) reg_sigs(clk,reset,flush,~stallD,{RegWriteD,MemtoRegD,MemWriteD,BranchD,ALUControlD,ALUSrcD,RegDstD},{RegWriteE,MemtoRegE,MemWriteE,BranchE,ALUControlE,ALUSrcE,RegDstE});
    D_flip_flop_c #(32) reg_srca(clk,reset,flush,~stallD,srcaD,srcaE);
    D_flip_flop_c #(32) reg_writedata(clk,reset,flush,~stallD,writedataD,writedataE);
    //D_flip_flop_c #(32) reg_instr(clk,reset,flush,~stallD,instrD,instrE);
    D_flip_flop_c #(15) reg_Rt_Rd(clk,reset,flush,~stallD,{RsD,RtD,RdD},{RsE,RtE,RdE});
    D_flip_flop_c #(32) reg_signimm(clk,reset,flush,~stallD,signimmD,signimmE);
    D_flip_flop_c #(32) reg_pcplus4(clk,reset,flush,~stallD,pcplus4D,pcplus4E);

endmodule