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
   
   wire [1:0] aluop;
   
   /*-----Decode-----*/
   maindec md(opcode,memtoregD,memwriteD,branchD,alusrcD,regdstD,regwriteD,jump,aluop);
   aludec ad(funct,aluop,alucontrolD);
   assign pcsrcD=equalD&branchD;
   
   /*-----Execute-----*/
   assign {regwriteE1,memtoregE1,memwriteE1,branchE1}={regwriteE,memtoregE,memwriteE,branchE};
   
   /*-----Memory-----*/
   assign pcsrcM=branchM&zeroM;
   assign {regwriteM1,memtoregM1}={regwriteM,memtoregM};
   
endmodule