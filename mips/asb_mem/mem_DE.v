module mem_DE(
    input clk,reset,flush,stallE,
    /*-----control signals-----*/
    //input
    input         RegWriteD,MemtoRegD,MemWriteD,memenD,
    input         ALUSrcD,RegDstD,hilowriteD,cp0writeD,
    input         balD,jrD,jalD,
    input  [7:0]  ALUControlD,
    //output
    output        RegWriteE,MemtoRegE,MemWriteE,memenE,
    output        ALUSrcE,RegDstE,hilowriteE,cp0writeE,
    output        balE,jrE,jalE,
    output [7:0]  ALUControlE,
    /*-----data-----*/
    //input
    input  [31:0] srcaD,writedataD,signimmD,
    input  [31:0] pcplus8D,
    input  [4:0]  rsD,rtD,rdD,saD,
    input  [31:0] cp0dataD,
    //output
    output [31:0] srcaE,writedataE,signimmE,
    output [31:0] pcplus8E,
    output [4:0]  rsE,rtE,rdE,saE,
    output [31:0] cp0dataE,
    /*-----exception info-----*/
    //input
    input         adelD,syscallD,breakD,eretD,invalidD,
    //output
    output        adelE,syscallE,breakE,eretE,invalidE
    );

    // 8,3,8,32,32,32,32,32,20,5 => 204
    D_flip_flop_c #(204) reg_DE(clk,reset,flush,~stallE,
                                {{RegWriteD,MemtoRegD,MemWriteD,memenD,ALUSrcD,RegDstD,hilowriteD,cp0writeD},
                                 {balD,jrD,jalD},
                                 ALUControlD,
                                 srcaD,
                                 writedataD,
                                 signimmD,
                                 pcplus8D,
                                 cp0dataD,
                                 {rsD,rtD,rdD,saD},
                                 {adelD,syscallD,breakD,eretD,invalidD}},
                                {{RegWriteE,MemtoRegE,MemWriteE,memenE,ALUSrcE,RegDstE,hilowriteE,cp0writeE},
                                 {balE,jrE,jalE},
                                 ALUControlE,
                                 srcaE,
                                 writedataE,
                                 signimmE,
                                 pcplus8E,
                                 cp0dataE,
                                 {rsE,rtE,rdE,saE},
                                 {adelE,syscallE,breakE,eretE,invalidE}});

endmodule