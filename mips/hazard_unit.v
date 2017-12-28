module hazard_unit(
        input regwriteM,regwriteW,regwriteE,hilowriteM,
        input memtoregE,memtoregM,
        input branchD,
        input [4:0] writeregE,writeregM,writeregW,
        input [4:0] rsD,rtD,
        input [4:0] rsE,rtE,
        output [1:0] forwardAE,forwardBE,
        output forwardAD,forwardBD,
        output forwardhiloE,
        output stallF,stallD,flushE
    );
    
    wire branchstall,lwstall;
    
    /*-----data forwardings-----*/
    assign forwardAE = ((rsE!=0)&&(rsE==writeregM)&&regwriteM)?2'b10:
                       ((rsE!=0)&&(rsE==writeregW)&&regwriteW)?2'b01:2'b00;
                       
    assign forwardBE = ((rtE!=0)&&(rtE==writeregM)&&regwriteM)?2'b10:
                       ((rtE!=0)&&(rtE==writeregW)&&regwriteW)?2'b01:2'b00;
                       
    assign forwardAD = (rsD!=0)&&(rsD==writeregM)&&regwriteM;
    assign forwardBD = (rtD!=0)&&(rtD==writeregM)&&regwriteM;

    assign forwardhiloE=hilowriteM;
    
    /*-----Assembly line stalls-----*/                   
    assign lwstall = ((rsD==rtE)||(rtD==rtE))&&memtoregE;
    assign branchstall=(branchD&&regwriteE&&((writeregE==rsD)||(writeregE==rtD)))||(branchD&&memtoregM&&((writeregM==rsD)||(writeregM==rtD)));
    
    assign stallF=lwstall||branchstall;
    assign stallD=lwstall||branchstall;
    assign flushE=lwstall||branchstall;
endmodule
