//Author      : Alex Zhang (cgzhangwei@gmail.com)
//Date        : Jun. 13. 2014
//Description : Implement the memory_access_interconnector(MAI)

module mem_access_interconnector (
clk,
resetn,
//Instruction Fetech (IF)
iIF_ValidRd,
iIF_AddrRd,
iIF_TagRd,
iIF_IdRd,
iIF_LenRd,
iIF_QoSRd,
iIF_ReadyRd,
oIF_ValidRsp,
oIF_TagRsp,
oIF_DataRsp,
oIF_StatusRsp,
oIF_EoD,
iIF_ReadyRsp,
iIF_ValidWr,
iIF_AddrWr,
iIF_TagWr,
iIF_IdWr,
iIF_LenWr,
iIF_QoSWr,
oIF_ReadyWr,
iIF_DataWr,
iIF_MaskWr,
iIF_EoD,

//Data Memory (DM)
iDM_ValidRd,
iDM_AddrRd,
iDM_TagRd,
iDM_IdRd,
iDM_LenRd,
iDM_QoSRd,
iDM_ReadyRd,
oDM_ValidRsp,
oDM_TagRsp,
oDM_DataRsp,
oDM_StatusRsp,
oDM_EoD,
iDM_ReadyRsp,
iDM_ValidWr,
iDM_AddrWr,
iDM_TagWr,
iDM_IdWr,
iDM_LenWr,
iDM_QoSWr,
oDM_ReadyWr,
iDM_DataWr,
iDM_MaskWr,
iDM_EoD,

//Memory Access Controller (MAC)
iMAC_ValidRd,
iMAC_AddrRd,
iMAC_TagRd,
iMAC_IdRd,
iMAC_LenRd,
iMAC_QoSRd,
iMAC_ReadyRd,
oMAC_ValidRsp,
oMAC_TagRsp,
oMAC_DataRsp,
oMAC_StatusRsp,
oMAC_EoD,
iMAC_ReadyRsp,
iMAC_ValidWr,
iMAC_AddrWr,
iMAC_TagWr,
iMAC_IdWr,
iMAC_LenWr,
iMAC_QoSWr,
oMAC_ReadyWr,
iMAC_DataWr,
iMAC_MaskWr,
iMAC_EoD
);
input  clk;
input  resetn;

//Instruction Fetech (IF)
input  iIF_ValidRd;
input  iIF_AddrRd;
input  iIF_TagRd;
input  iIF_IdRd;
input  iIF_LenRd;
input  iIF_QoSRd;
input  iIF_ReadyRd;
output oIF_ValidRsp;
output oIF_TagRsp;
output oIF_DataRsp;
output oIF_StatusRsp;
output oIF_EoD;
input  iIF_ReadyRsp;
input  iIF_ValidWr;
input  iIF_AddrWr;
input  iIF_TagWr;
input  iIF_IdWr;
input  iIF_LenWr;
input  iIF_QoSWr;
output oIF_ReadyWr;
input  iIF_DataWr;
input  iIF_MaskWr;
input  iIF_EoD;

//Data Memory (DM)
input  iDM_ValidRd;
input  iDM_AddrRd;
input  iDM_TagRd;
input  iDM_IdRd;
input  iDM_LenRd;
input  iDM_QoSRd;
input  iDM_ReadyRd;
output oDM_ValidRsp;
output oDM_TagRsp;
output oDM_DataRsp;
output oDM_StatusRsp;
output oDM_EoD;
input  iDM_ReadyRsp;
input  iDM_ValidWr;
input  iDM_AddrWr;
input  iDM_TagWr;
input  iDM_IdWr;
input  iDM_LenWr;
input  iDM_QoSWr;
output oDM_ReadyWr;
input  iDM_DataWr;
input  iDM_MaskWr;
input  iDM_EoD;

//Memory Access Controller (MAC)
output  oMAC_ValidRd;
output  oMAC_AddrRd;
output  oMAC_TagRd;
output  oMAC_IdRd;
output  oMAC_LenRd;
output  oMAC_QoSRd;
output  oMAC_ReadyRd;
input   iMAC_ValidRsp;
input   iMAC_TagRsp;
input   iMAC_DataRsp;
input   iMAC_StatusRsp;
input   iMAC_EoD;
output  oMAC_ReadyRsp;
output  oMAC_ValidWr;
output  oMAC_AddrWr;
output  oMAC_TagWr;
output  oMAC_IdWr;
output  oMAC_LenWr;
output  oMAC_QoSWr;
input   iMAC_ReadyWr;
output  oMAC_DataWr;
output  oMAC_MaskWr;
output  oMAC_EoD;


//Instruction Fetech (IF)
wire         iIF_ValidRd;
wire [31:0]  iIF_AddrRd;
wire [3:0]   iIF_TagRd;
wire [2:0]   iIF_IdRd;
wire [1:0]   iIF_LenRd;
wire [3:0]   iIF_QoSRd;
wire         iIF_ReadyRd;
wire         oIF_ValidRsp;
wire [3:0]   oIF_TagRsp;
wire [31:0]  oIF_DataRsp;
wire [1:0]   oIF_StatusRsp;
wire         oIF_EoD;
wire         iIF_ReadyRsp;
wire         iIF_ValidWr;
wire [31:0]  iIF_AddrWr;
wire [3:0]   iIF_TagWr;
wire [2:0]   iIF_IdWr;
wire [1:0]   iIF_LenWr;
wire [3:0]   iIF_QoSWr;
wire         oIF_ReadyWr;
wire [31:0]  iIF_DataWr;
wire [3:0]   iIF_MaskWr;
wire         iIF_EoD;

//Data Memory (DM)
wire         iDM_ValidRd;
wire [31:0]  iDM_AddrRd;
wire [3:0]   iDM_TagRd;
wire [2:0]   iDM_IdRd;
wire [1:0]   iDM_LenRd;
wire [3:0]   iDM_QoSRd;
wire         iDM_ReadyRd;
wire         oDM_ValidRsp;
wire [3:0]   oDM_TagRsp;
wire [31:0]  oDM_DataRsp;
wire [1:0]   oDM_StatusRsp;
wire         oDM_EoD;
wire         iDM_ReadyRsp;
wire         iDM_ValidWr;
wire [31:0]  iDM_AddrWr;
wire [3:0]   iDM_TagWr;
wire [2:0]   iDM_IdWr;
wire [1:0]   iDM_LenWr;
wire [3:0]   iDM_QoSWr;
wire         oDM_ReadyWr;
wire [31:0]  iDM_DataWr;
wire [3:0]   iDM_MaskWr;
wire         iDM_EoD;

//Memory Access Controller (MAC)
wire         oMAC_ValidRd;
wire [31:0]  oMAC_AddrRd;
wire [3:0]   oMAC_TagRd;
wire [2:0]   oMAC_IdRd;
wire [1:0]   oMAC_LenRd;
wire [3:0]   oMAC_QoSRd;
wire         oMAC_ReadyRd;
wire         iMAC_ValidRsp;
wire [3:0]   iMAC_TagRsp;
wire [31:0]  iMAC_DataRsp;
wire [1:0]   iMAC_StatusRsp;
wire         iMAC_EoD;
wire         oMAC_ReadyRsp;
wire         oMAC_ValidWr;
wire [31:0]  oMAC_AddrWr;
wire [3:0]   oMAC_TagWr;
wire [2:0]   oMAC_IdWr;
wire [1:0]   oMAC_LenWr;
wire [3:0]   oMAC_QoSWr;
wire         iMAC_ReadyWr;
wire [31:0]  oMAC_DataWr;
wire [3:0]   oMAC_MaskWr;
wire         oMAC_EoD;

//Register counter declare
reg  [7:0]   rFifoWrReqCnt;
reg  [7:0]   rFifoWrDataCnt;
reg  [7:0]   rFifoRdReqCnt;
reg  [7:0]   rFifoRdRspCnt;

always @(posedge clk or negedge resetn) begin
    if (~resetn) begin 
        rFifoWrReqCnt   <= 8'b0;
        rFifoWrDataCnt  <= 8'b0;
        rFifoRdReqCnt   <= 8'b0;
        rFifoRdRspCnt   <= 8'b0;
    end else begin 
        if (iMAC_ReadyWr) rFifoWrReqCnt <= rFifoWrReqCnt - 1;
        else if (oIF_ReadyWr | oDM_ReadyWr) rFifoWrReqCnt <= rFifoWrReq + 1; 
        else if (iMAC_ReadyWr & (oIF_ReadyWr | oDM_ReadyWr)) rFifoWrReqCnt <= rFifoWrReq ;

        if (iMAC_ReadyRd) rFifoRdReqCnt <= rFifoRdReqCnt - 1;
        else if (oIF_ReadyRd | oDM_ReadyRd) rFifoRdReqCnt <= rFifoRdReq + 1; 
        else if (iMAC_ReadyRd & (oIF_ReadyRd | oDM_ReadyRd)) rFifoRdReqCnt <= rFifoRdReq ;
    end 
end 

always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
        rQoS0 <= 4'b0;
    end else begin 
        //Save the info
        if (iIF_ValidWr) begin 
            rIFWrInfo <= {iIF_AddrWr, iIF_TagWr, iIF_IdWr, iIF_LenWr, iIF_QoSWr}; 
        end
        if (iDM_ValidWr) begin 
            rDMWrInfo <= {iDM_AddrWr, iDM_TagWr, iDM_IdWr, iDM_LenWr, iDM_QoSWr};
        end 
        if (iIF_ValidRd) begin 
            rIFRdInfo <= {iIF_AddrRd, iIF_TagRd, iIF_IdRd, iIF_LenRd, iIF_QoSRd}; 
        end
        if (iDM_ValidRd) begin 
            rDMRdInfo <= {iDM_AddrRd, iDM_TagRd, iDM_IdRd, iDM_LenRd, iDM_QoSRd};
        end 
        //Arbiter
        if (iIF_ValidWr & iDM_ValidWr) 
            rQoS0 <= iIF_QoSWr > iDM_QoSWr ? iIF_QoSWr : iDM_QoSWr;
        else if (iIF_ValidWr)
            rQoS0 <= iIF_QoSWr ;
        else if (iDM_ValidWr)
            rQoS0 <= iDM_QoSWr;
        else 
            rQoS0 <= 4'b0;
        if (iIF_ValidRd & iDM_ValidRd) 
            rQoS2 <= iIF_QoSRd > iDM_QoSRd ? iIF_QoSRd : iDM_QoSRd;
        else if (iIF_ValidRd)
            rQoS2 <= iIF_QoSRd ;
        else if (iDM_ValidRd)
            rQoS2 <= iDM_QoSRd;
        else 
            rQoS2 <= 4'b0;
        //Push into fifo
        if (oIF_ReadyWr) begin 
            rWr0     <= 1'b1;
            rWrData0 <= rIFWrInfo;
            if (~iIF_EoD) begin 
                rWr1     <= 1'b1;
                rWrData1 <= iIF_DataWr;
            end  else begin 
                rWr1     <= 1'b0;
                rWrData1 <= 32'b0;
            end
        end else begin 
            rWr0     <= 1'b0;
            rWrData0 <= ??'b0;
        end 
        if (oDM_ReadyWr) begin 
            rWr0     <= 1'b1;
            rWrData0 <= rDMWrInfo;
            if (~iDM_EoD) begin 
                rWr1     <= 1'b1;
                rWrData1 <= iDM_DataWr;
            end  else begin 
                rWr1     <= 1'b0;
                rWrData1 <= 32'b0;
            end
        end else begin 
            rWr0     <= 1'b0;
            rWrData0 <= ??'b0;
        end 
        if (oIF_ReadyRd) begin 
            rWr2     <= 1'b1;
            rWrData2 <= rIFWrInfo;
        end else begin 
            rWr2     <= 1'b0;
            rWrData2 <= ??'b0;
        end 
        if (oDM_ReadyRd) begin 
            rWr2     <= 1'b1;
            rWrData2 <= rIFWrInfo;
        end else begin 
            rWr2     <= 1'b0;
            rWrData2 <= ??'b0;
        end 
    end 
end 
//Acknowledge the request
always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
            oIF_ReadyWr <= 1'b0;
            oDM_ReadyWr <= 1'b0;
            oIF_ReadyRd <= 1'b0;
            oDM_ReadyRd <= 1'b0;
    end else begin 
        if (ppIF_ValidWr & ppIF_ValidWr) begin 
            if (ppIF_QoSWr > ppDM_QoSWr )
                oIF_ReadyWr <= ~wFull0;
            else
                oDM_ReadyWr <= ~wFull0;
        end else if (ppIF_ValidWr ) begin 
            oIF_ReadyWr <= ~wFull0;
        end else if (ppDM_ValidWr) begin 
            oDM_ReadyWr <= ~wFull0;
        end else begin 
            oIF_ReadyWr <= 1'b0;
            oDM_ReadyWr <= 1'b0;
        end 
        if (ppIF_ValidRd & ppIF_ValidRd) begin 
            if (ppIF_QoSRd > ppDM_QoSRd )
                oIF_ReadyRd <= ~wFull2;
            else
                oDM_ReadyRd <= ~wFull2;
        end else if (ppIF_ValidRd ) begin 
            oIF_ReadyRd <= ~wFull2;
        end else if (ppDM_ValidRd) begin 
            oDM_ReadyRd <= ~wFull2;
        end else begin 
            oIF_ReadyRd <= 1'b0;
            oDM_ReadyRd <= 1'b0;
        end 
    end 
end 
//Push request out to memory port
//Wr request state machine

always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
        rRd0 <= 1'b0;
    end else begin 
        if (|wEmpty0) begin
            rRd0 <= 1'b1;
            {oMAC_AddrWr, oMAC_TagWr, oMAC_IdWr, oMAC_LenWr, oMAC_QoSWr} <= wWrReq0;  //FIXME: QoS and Len is only needed
            oMAC_ValidWr <= 1'b1;

        end else  begin 
            rRd0 <= 1'b0;
            oMAC_ValidWr <= 1'b0;
            {oMAC_AddrWr, oMAC_TagWr, oMAC_IdWr, oMAC_LenWr, oMAC_QoSWr} <= 0; 
        end 
        if (iMAC_ReadyWr)
        
    end 

end 


//FIXME, need to change the DSIZE of wr request
fifo_wrapper #(.DSIZE(32), .ANSIZE(5), .HBSIZE(7) ) fifoWrReq0 (
  .iWrClk(clk),
  .iWrResetn(resetn),
  .iWr(rWr0),
  .iWrData(rWrData0),
  .iRdClk(clk),
  .iRdResetn(resetn),
  .iRd(rRd0),
  .oRdData(wWrReq0),
  .iQoS(rQoS0),
  .oFull(wFull0),
  .oEmpty(wEmpty0)
);

fifo_wrapper #(.DSIZE(32), .ANSIZE(5), .HBSIZE(7) ) fifoWrData1 (
  .iWrClk(clk),
  .iWrResetn(resetn),
  .iWr(rWr1),
  .iWrData(rWrData1),
  .iRdClk(clk),
  .iRdResetn(resetn),
  .iRd(rRd1),
  .oRdData(wWrData1),
  .iQoS(rQoS1),
  .oFull(wFull1),
  .oEmpty(wEmpty1)
);

fifo_wrapper #(.DSIZE(32), .ANSIZE(5), .HBSIZE(7) ) fifoRdReq2 (
  .iWrClk(clk),
  .iWrResetn(resetn),
  .iWr(rWr2),
  .iWrData(),
  .iRdClk(clk),
  .iRdResetn(resetn),
  .iRd(rRd2),
  .oRdData(wRdData2),
  .iQoS(rQoS2),
  .oFull(wFull2),
  .oEmpty(wEmpty2)
);

fifo_wrapper #(.DSIZE(32), .ANSIZE(5), .HBSIZE(7) ) fifoRdRspData3 (
  .iWrClk(clk),
  .iWrResetn(resetn),
  .iWr(rWr3),
  .iWrData(),
  .iRdClk(clk),
  .iRdResetn(resetn),
  .iRd(rRd3),
  .oRdData(),
  .iQoS(rQoS3),
  .oFull(wFull3),
  .oEmpty(wEmpty3)
);



endmodule 
