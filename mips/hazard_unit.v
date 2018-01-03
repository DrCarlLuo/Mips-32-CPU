module hazard_unit(
        input stall_by_iram,
        input regwriteM,regwriteW,regwriteE,hilowriteM,
        input cp0writeM,cp0writeW,
        input memtoregE,memtoregM,
        input branchD,jumpD,stall_divE,
        input [4:0] writeregE,writeregM,writeregW,
        input [4:0] writecp0M,writecp0W,
        input [4:0] rsD,rtD,
        input [4:0] rsE,rtE,rdE,
        input [31:0] excepttype,epcM,
        output [1:0] forwardAE,forwardBE,
        output forwardAD,forwardBD,
        output forwardhiloE,
        output [1:0] forwardcp0E,
        output stallF,stallD,stallE,
        output flushF,flushD,flushE,flushM,flushW,
        output [31:0] newpcF
    );
    
    wire branchstall,lwstall,jumpstall,except_flush;

    /*-----functional signals-----*/
    assign lwstall = ((rsD==rtE)||(rtD==rtE))&&memtoregE;
    assign branchstall=(branchD&&regwriteE&&((writeregE==rsD)||(writeregE==rtD)))||(branchD&&memtoregM&&((writeregM==rsD||writeregM==rtD)));
    assign jumpstall=jumpD&&((regwriteE&&(writeregE==rsD))||(memtoregM&&writeregM==rsD));
    assign except_flush=(excepttype!=32'h0);

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
    assign stallF=lwstall||branchstall||jumpstall||stall_divE||(stall_by_iram&!flushF);
    assign stallD=lwstall||branchstall||jumpstall||stall_divE||stall_by_iram;
    assign stallE=stall_divE||stall_by_iram;

    /*-----Assembly line clear-----*/
    assign flushF=except_flush;
    assign flushD=except_flush;
    assign flushE=except_flush||(lwstall&&!stall_by_iram)||branchstall||jumpstall;
    assign flushM=except_flush||stall_by_iram;
    assign flushW=except_flush;

    /*-----Exception pc jump-----*/
    assign newpcF=(excepttype==32'h00000001)?32'hBFC00380:
                  (excepttype==32'h00000004)?32'hBFC00380:
                  (excepttype==32'h00000005)?32'hBFC00380:
                  (excepttype==32'h00000008)?32'hBFC00380:
                  (excepttype==32'h00000009)?32'hBFC00380:
                  (excepttype==32'h0000000a)?32'hBFC00380:
                  (excepttype==32'h0000000c)?32'hBFC00380:
                  (excepttype==32'h0000000d)?32'hBFC00380:
                  (excepttype==32'h0000000e)?epcM:32'h00000000;

endmodule
