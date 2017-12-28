module mux2 #(parameter WIDTH=8)
    (
        input [WIDTH-1:0] inpa,
        input [WIDTH-1:0] inpb,
        input choice,
        output [WIDTH-1:0] res
    );
    
    wire [WIDTH-1:0] ech;
    
    assign ech={WIDTH{choice}};
    
    assign res=(inpa&~ech)|(inpb&ech);
endmodule