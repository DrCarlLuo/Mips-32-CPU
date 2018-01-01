module mem_DE(
    input clk,reset,flush,stallE,
    /*-----control signals-----*/
    //input
    input         RegWriteD,MemtoRegD,MemWriteD,memenD,
    input         ALUSrcD,RegDstD,hilowriteD,
    input         balD,jrD,jalD,
    input  [7:0]  ALUControlD,
    //output
    output        RegWriteE,MemtoRegE,MemWriteE,memenE,
    output        ALUSrcE,RegDstE,hilowriteE,
    output        balE,jrE,jalE,
    output [7:0]  ALUControlE,
    /*-----data-----*/
    //input
    input  [31:0] srcaD,writedataD,signimmD,
    input  [31:0] pcplus8D,
    input  [4:0]  rsD,rtD,rdD,saD,
    //output
    output [31:0] srcaE,writedataE,signimmE,
    output [31:0] pcplus8E,
    output [4:0]  rsE,rtE,rdE,saE
    );

    // 7,3,8,32,32,32,32,20 => 166
    D_flip_flop_c #(166) reg_DE(clk,reset,flush,~stallE,
                                {{RegWriteD,MemtoRegD,MemWriteD,memenD,ALUSrcD,RegDstD,hilowriteD},
                                 {balD,jrD,jalD},
                                 ALUControlD,
                                 srcaD,
                                 writedataD,
                                 signimmD,
                                 pcplus8D,
                                 {rsD,rtD,rdD,saD}},
                                {{RegWriteE,MemtoRegE,MemWriteE,memenE,ALUSrcE,RegDstE,hilowriteE},
                                 {balE,jrE,jalE},
                                 ALUControlE,
                                 srcaE,
                                 writedataE,
                                 signimmE,
                                 pcplus8E,
                                 {rsE,rtE,rdE,saE}});

endmodule