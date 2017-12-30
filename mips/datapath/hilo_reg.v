module hilo_reg(
	input  wire        clk,rst,wea,
	input  wire [31:0] hi,lo,
	output reg  [31:0] hi_r,lo_r 
	);

	always @(negedge clk or rst) begin
		if(rst) begin
			hi_r<=0;
			lo_r<=0;
		end
		else if(wea) begin
			hi_r<=hi;
			lo_r<=lo;
		end
	end
endmodule