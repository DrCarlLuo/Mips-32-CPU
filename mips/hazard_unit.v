`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/24/2017 11:07:34 AM
// Design Name: 
// Module Name: hazard_unit
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


module hazard_unit(
        input regwriteM,regwriteW,regwriteE,
        input memtoregE,memtoregM,
        input branchD,
        input [4:0] writeregE,writeregM,writeregW,
        input [4:0] rsD,rtD,
        input [4:0] rsE,rtE,
        output [1:0] forwardAE,forwardBE,
        output forwardAD,forwardBD,
        output stallF,stallD,flushE
    );
    
    wire branchstall,lwstall;
    
    assign forwardAE = ((rsE!=0)&&(rsE==writeregM)&&regwriteM)?2'b10:
                       ((rsE!=0)&&(rsE==writeregW)&&regwriteW)?2'b01:2'b00;
                       
    assign forwardBE = ((rtE!=0)&&(rtE==writeregM)&&regwriteM)?2'b10:
                       ((rtE!=0)&&(rtE==writeregW)&&regwriteW)?2'b01:2'b00;
                       
    assign forwardAD = (rsD!=0)&&(rsD==writeregM)&&regwriteM;
    assign forwardBD = (rtD!=0)&&(rtD==writeregM)&&regwriteM;
                       
    assign lwstall = ((rsD==rtE)||(rtD==rtE))&&memtoregE;
    assign branchstall=(branchD&&regwriteE&&((writeregE==rsD)||(writeregE==rtD)))||(branchD&&memtoregM&&((writeregM==rsD)||(writeregM==rtD)));
    
    assign stallF=lwstall||branchstall;
    assign stallD=lwstall||branchstall;
    assign flushE=lwstall||branchstall;
endmodule
