module D_flip_flop #(parameter WIDTH=8)
    (
        input clk,
        input reset,
        input enable,
        input [WIDTH-1:0] d,
        output reg [WIDTH-1:0] q
    );
    
    always @(posedge clk,posedge reset)
        if(reset)  q<=0;
        else if(enable)       q<=d; 
endmodule