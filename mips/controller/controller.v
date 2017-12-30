module controller(
    /*-----Decode input------*/
    input [5:0]  opcode,funct,
    input [4:0]  rt,
    input [31:0] compa,compb,
    /*-----Decode output------*/
    output       memtoreg,memen,memwrite,
    output       alusrc,
    output       regdst,regwrite,hilowrite,
    output       jal,jr,bal,
    output [1:0] pcsrc,
    output [7:0] alucontrol
   );

    wire branch,jump,compres;

    maindec md(opcode,funct,rt,memtoreg,memen,memwrite,branch,alusrc,regdst,
              regwrite,hilowrite,jump,jal,jr,bal);
    aludec  ad(opcode,funct,alucontrol);

    eqcmp(compa,compb,op,rt,compres);
    assign pcsrc={jump,comp&branch};
   
endmodule