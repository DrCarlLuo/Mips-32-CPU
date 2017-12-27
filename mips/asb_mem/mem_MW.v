`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2017 05:55:39 PM
// Design Name: 
// Module Name: mem_MW
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mem_MW(
        input clk,
        input reset,
        input flush,
        input RegWriteM,MemtoRegM,
        input [31:0] aluoutM,readdataM,
        input [4:0] writeregM,
        output RegWriteW,MemtoRegW,
        output [31:0] aluoutW,readdataW,
        output [4:0] writeregW
);

        wire stallM;
        assign stallM=1'b0;
        
        D_flip_flop_c #(2) reg_signal(clk,reset,flush,~stallM,{RegWriteM,MemtoRegM},{RegWriteW,MemtoRegW});
        D_flip_flop_c #(32) reg_aluout(clk,reset,flush,~stallM,aluoutM,aluoutW);
        D_flip_flop_c #(32) reg_readdata(clk,reset,flush,~stallM,readdataM,readdataW);
        D_flip_flop_c #(32) reg_writereg(clk,reset,flush,~stallM,writeregM,writeregW);

endmodule
