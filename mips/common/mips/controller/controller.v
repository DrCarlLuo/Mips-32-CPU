module controller(
    /*-----Decode input------*/
    input [5:0] opcode,funct,
    input [4:0] rt,
    input equalD,
    /*-----Decode output------*/
    output memtoreg,memen,memwrite,
    output alusrc,
    output regdst,regwrite,hilowrite,
    output jal,jr,bal,
    output [1:0] pcsrc,
    output [7:0] alucontrol
   );

   wire branch,jump;
   maindec md(opcode,funct,rt,memtoreg,memen,memwrite,branch,alusrc,regdst,
              regwrite,hilowrite,jump,jal,jr,bal);
   aludec  ad(opcode,funct,alucontrol);
   assign pcsrc={jump,equalD&branch};
   
   
endmodule