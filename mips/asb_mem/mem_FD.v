module mem_FD(
    input         clk,reset,flush,stallD,
    input  [31:0] instrF,
    input  [31:0] pcplus4F,
    output [31:0] instrD,
    output [31:0] pcplus4D,
    /*-----exception info-----*/
    input  adelF,
    output adelD
    );
    
    //32,32,1 => 65
    D_flip_flop_c #(65) reg_FD(clk,reset,flush,~stallD,
                              {instrF,pcplus4F,adelF},
                              {instrD,pcplus4D,adelD});

endmodule