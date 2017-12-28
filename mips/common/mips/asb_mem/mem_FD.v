module mem_FD(
    input         clk,reset,flush,stallD,
    input  [31:0] instrF,
    input  [31:0] pcplus4F,
    output [31:0] instrD,
    output [31:0] pcplus4D
    );
    
    //32,32 => 64
    D_flip_flop_c #(64) reg_FD(clk,reset,flush,~stallD,
                              {instrF,pcplus4F},
                              {instrD,pcplus4D});

endmodule