module mem_FD(
    input         clk,reset,flush,stallD,
    input  [31:0] instrF,
    input  [31:0] pcplus4F,
    output [31:0] instrD,
    output [31:0] pcplus4D,
    /*-----exception info-----*/
    input         adelF,in_delayF,
    input  [31:0] bad_addrF,
    output        adelD,in_delayD,
    output [31:0] bad_addrD
    );
    
    //32,32,1,1,32 => 98
    D_flip_flop_c #(98) reg_FD(clk,reset,flush,~stallD,
                              {instrF,pcplus4F,adelF,in_delayF,bad_addrF},
                              {instrD,pcplus4D,adelD,in_delayD,bad_addrD});

endmodule