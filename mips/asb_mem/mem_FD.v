module mem_FD(
    input clk,
    input reset,
    input flush,
    input stallD,
    input [31:0] instrF,
    input [31:0] pcplus4F,
    output [31:0] instrD,
    output [31:0] pcplus4D
    );
    
    D_flip_flop_c #(32) reg_instr(clk,reset,flush,~stallD,instrF,instrD);
    D_flip_flop_c #(32) reg_pcplus4(clk,reset,flush,~stallD,pcplus4F,pcplus4D);

endmodule