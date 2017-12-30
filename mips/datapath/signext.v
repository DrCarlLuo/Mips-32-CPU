module signext(
        input  [15:0] a,
        input  [1:0]  immtype, 
        output [31:0] y
    );
    
    assign y= (immtype==2'b11)? {{16{1'b0}},a}:{{16{a[15]}},a};
    
endmodule