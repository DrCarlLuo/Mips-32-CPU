`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2017 05:28:36 PM
// Design Name: 
// Module Name: regfile
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

module regfile(
	input wire clk,
	input wire reset,
	input wire we3,
	input wire[4:0] ra1,ra2,wa3,
	input wire[31:0] wd3,
	output wire[31:0] rd1,rd2
    );

	reg [31:0] rf[31:0];
	
	assign rd1 = (ra1 != 0) ? rf[ra1] : 0;
    assign rd2 = (ra2 != 0) ? rf[ra2] : 0;

	always @(negedge clk or posedge reset) begin
		if(we3&~reset) begin
            rf[wa3] <= wd3;
        end
	   	if(reset) fork
	   	    rf[0] <= 0;
            rf[1] <= 0;
            rf[2] <= 0;
            rf[3] <= 0;
            rf[4] <= 0;
            rf[5] <= 0;
            rf[6] <= 0;
            rf[7] <= 0;
            rf[8] <= 0;
            rf[9] <= 0;
            rf[10] <= 0;
            rf[11] <= 0;
            rf[12] <= 0;
            rf[13] <= 0;
            rf[14] <= 0;
            rf[15] <= 0;
            rf[16] <= 0;
            rf[17] <= 0;
            rf[18] <= 0;
            rf[19] <= 0;
            rf[20] <= 0;
            rf[21] <= 0;
            rf[22] <= 0;
            rf[23] <= 0;
            rf[24] <= 0;
            rf[25] <= 0;
            rf[26] <= 0;
            rf[27] <= 0;
            rf[28] <= 0;
            rf[29] <= 0;
            rf[30] <= 0;
            rf[31] <= 0;
        join
	end
endmodule
