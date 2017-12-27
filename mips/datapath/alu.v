module alu(
        input [31:0] srca,
        input [31:0] srcb,
        input [2:0] alucontrol,
        output [31:0] aluout,
        output overflow,
        output zero
    );
    
    wire [31:0] compb;//complementary of srcb
    wire [31:0] sum;//summation of the two operand
    wire [31:0] dif;//difference of the two operand
    wire cs,cp;//symbol bit overflow & highest bit overflow
    
    //intermediate results
    adder add_sum(srca,srcb,sum);
    adder add_compb(~srcb,32'h1,compb);
    adder add_dif(srca,compb,dif);
    
    //flags
    assign cp=(aluout[31]!=srca[31]^srcb[31]);
    assign cs=(cp&srca[31])|(cp&srcb[31])|(srca[31]&srcb[31]);
    assign overflow=(cp^cs);
    assign zero=(aluout==0);
    
    assign aluout = (alucontrol==3'b000)?srca&srcb:
                    (alucontrol==3'b001)?srca|srcb:
                    (alucontrol==3'b010)?sum:
                    (alucontrol==3'b100)?srca&(~srcb):
                    (alucontrol==3'b101)?srca|(~srcb):
                    (alucontrol==3'b110)?dif:
                    (alucontrol==3'b111)?{{31{1'b0}},dif[31]&(dif!=32'h0)}:
                    32'h00000000;
  
endmodule