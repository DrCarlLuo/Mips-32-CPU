module hazard_unit(
        input regwriteM,regwriteW,regwriteE,hilowriteM,
        input cp0writeM,cp0writeW,
        input memtoregE,memtoregM,
        input branchD,stall_divE,
        input [4:0] writeregE,writeregM,writeregW,
        input [4:0] writecp0M,writecp0W,
        input [4:0] rsD,rtD,
        input [4:0] rsE,rtE,rdE,
        output [1:0] forwardAE,forwardBE,
        output forwardAD,forwardBD,
        output forwardhiloE,
        output [1:0] forwardcp0E,
        output stallF,stallD,stallE,
        output flushE
    );
    
    wire branchstall,lwstall;
    
    /*-----data forwardings-----*/
    assign forwardAE = ((rsE!=0)&&(rsE==writeregM)&&regwriteM)?2'b10:
                       ((rsE!=0)&&(rsE==writeregW)&&regwriteW)?2'b01:2'b00;
                       
    assign forwardBE = ((rtE!=0)&&(rtE==writeregM)&&regwriteM)?2'b10:
                       ((rtE!=0)&&(rtE==writeregW)&&regwriteW)?2'b01:2'b00;
                       
    assign forwardAD = (rsD!=0)&&(rsD==writeregM)&&regwriteM;
    assign forwardBD = (rtD!=0)&&(rtD==writeregM)&&regwriteM;

    assign forwardhiloE = hilowriteM;
    assign forwardcp0E = (rdE==writecp0M&&cp0writeM)?2'b10:
                         (rdE==writecp0W&&cp0writeW)?2'b01:2'b00; 
    
    /*-----Assembly line stalls-----*/                   
    assign lwstall = ((rsD==rtE)||(rtD==rtE))&&memtoregE;
    assign branchstall=(branchD&&regwriteE&&((writeregE==rsD)||(writeregE==rtD)))||(branchD&&memtoregM&&((writeregM==rsD||writeregM==rtD)));
    
    assign stallF=lwstall||branchstall||stall_divE;
    assign stallD=lwstall||branchstall||stall_divE;
    assign stallE=stall_divE;
    assign flushE=lwstall||branchstall;

endmodule
