module D_flip_flop_c #(parameter WIDTH=8)
    (
        input clk,
        input reset,
        input clear,
        input enable,
        input [WIDTH-1:0] d,
        output reg [WIDTH-1:0] q
    );
    
    always @(posedge clk,posedge reset)
        if(reset||clear)  q<=0;
        else if(enable)   q<=d; 
endmodule
