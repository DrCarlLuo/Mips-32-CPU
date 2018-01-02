module exception(
	input 		  rst,
	input 		  adel,ades,syscall,break,eret,invalid,overflow,
	input  [31:0] cp0_status,cp0_cause,
	output [31:0] excepttype
	);

	assign excepttype=
				(rst)? 32'b0:
					(((cp0_cause[15:8] & cp0_status[15:8]) != 8'h00) && (cp0_status[1] == 1'b0) && (cp0_status[0] == 1'b1))?
								32'h00000001:
					(adel)? 	32'h00000004:
					(ades)? 	32'h00000005:
					(syscall)?  32'h00000008:
					(break)? 	32'h00000009:
					(eret)?		32'h0000000e:
					(invalid)?  32'h0000000a:
					(overflow)? 32'h0000000c:
								32'h00000000;

endmodule