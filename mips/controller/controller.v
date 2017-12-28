module controller(
    /*-----Decode input------*/
    input [5:0] opcode,funct,
    input equalD,
    /*-----Execute input-----*/
    input regwriteE,memtoregE,memwriteE,branchE,
    /*-----Memory input-----*/
    input regwriteM,memtoregM,branchM,zeroM,
    /*-----Decode output------*/
    output regwriteD,memtoregD,memwriteD,branchD,alusrcD,regdstD,pcsrcD,jump,
    output [2:0] alucontrolD,
    /*-----Execute output------*/
    output regwriteE1,memtoregE1,memwriteE1,branchE1,
                           
    /*-----Memory output-----*/
    output regwriteM1,memtoregM1,pcsrcM
   );

   wire branch,jump;
   maindec md(opcode,funct,rt,memtoreg,memen,memwrite,branch,alusrc,regdst,
              regwrite,hilowrite,jump,jal,jr,bal);
   aludec  ad(op,funct,alucontrol);
   assign pcsrc={jump,equalD&branch};
   
endmodule