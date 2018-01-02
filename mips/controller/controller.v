module controller(
    /*-----Decode input------*/
    input [31:0] instrD,
    input [31:0] compa,compb,
    /*-----Decode output------*/
    output       memtoreg,memen,memwrite,
    output       alusrc,branch,
    output       regdst,regwrite,hilowrite,cp0write,
    output       jal,jr,bal,
    output       syscallD,breakD,eretD,invalidD,
    output [1:0] pcsrc,
    output [7:0] alucontrol
   );

    wire jump,compres;

    maindec md(instrD,memtoreg,memen,memwrite,branch,alusrc,regdst,
              regwrite,hilowrite,cp0write,jump,jal,jr,bal,syscallD,breakD,eretD,invalidD);
    aludec  ad(instrD,alucontrol);

    eqcmp cmp(compa,compb,instrD[31:26],instrD[20:16],compres);
    assign pcsrc={jump,compres&branch};
   
endmodule