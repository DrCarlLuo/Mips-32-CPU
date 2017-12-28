module mem_DE(
    input clk,reset,flush,
    /*-----control signals-----*/
    //input
    input         RegWriteD,MemtoRegD,MemWriteD,
    input         ALUSrcD,RegDstD,hilowriteD,
    input  [7:0]  ALUControlD,
    //output
    output        RegWriteE,MemtoRegE,MemWriteE,
    output        ALUSrcE,RegDstE,hilowriteE,
    output [7:0]  ALUControlE,
    /*-----data-----*/
    //input
    input  [31:0] srcaD,writedataD,signimmD,
    input  [4:0]  rsD,rtD,rdD,saD,
    //output
    output [31:0] srcaE,writedataE,signimmE,
    output [4:0]  rsE,rtE,rdE,saE
    );

    wire stallD;
    assign stallD=1'b0;

    // 6,8,32,32,32,20 => 130
    D_flip_flop_c #(130) reg_DE(clk,reset,flush,~stallD,
                                {{RegWriteD,MemtoRegD,MemWriteD,ALUSrcD,RegDstD,hilowriteD},
                                 ALUControlD,
                                 srcaD,
                                 writedataD,
                                 signimmD,
                                 {rsD,rtD,rdD,saD}},
                                {{RegWriteE,MemtoRegE,MemWriteE,ALUSrcE,RegDstE,hilowriteE},
                                 ALUControlE,
                                 srcaE,
                                 writedataE,
                                 signimmE,
                                 {rsE,rtE,rdE,saE}});

endmodule