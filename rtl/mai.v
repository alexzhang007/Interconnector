//Author      : Alex Zhang (cgzhangwei@gmail.com)
//Date        : Jun. 13. 2014
//Description : Implement the memory_access_interconnector(MAI)
//              Fix Bug16: There is request coming to MAI, fifoWrReq0 cannot be written
`define ADDRWR_RANGE 44:13
`define TAGWR_RANGE  12:9
`define IDWR_RANGE   8:6
`define LENWR_RANGE  5:4
`define QOSWR_RANGE  3: 0
`define DATAWR_RANGE 35:4
`define MASKWR_RANGE 3:0

`define ADDRWR_W 32
`define TAGWR_W  4
`define IDWR_W   3
`define LENWR_W  2
`define QOSWR_W  4
`define DATAWR_W 32
`define MASKWR_W 4
`define REQWR_INFO_W  45
`define REQWR_DATA_W  36

`define ADDRRD_W  32
`define TAGRD_W   4
`define IDRD_W    3
`define LENRD_W   2
`define QOSRD_W   4
`define DATARSP_W 32
`define MASKRSP_W 4
`define REQRD_INFO_W   45
`define REQRSP_DATA_W  36

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
oIF_ReadyRd,
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
oDM_ReadyRd,
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
oMAC_ValidRd,
oMAC_AddrRd,
oMAC_TagRd,
oMAC_IdRd,
oMAC_LenRd,
oMAC_QoSRd,
iMAC_ReadyRd,
iMAC_ValidRsp,
iMAC_TagRsp,
iMAC_DataRsp,
iMAC_StatusRsp,
iMAC_EoD,
oMAC_ReadyRsp,
oMAC_ValidWr,
oMAC_AddrWr,
oMAC_TagWr,
oMAC_IdWr,
oMAC_LenWr,
oMAC_QoSWr,
iMAC_ReadyWr,
oMAC_DataWr,
oMAC_MaskWr,
oMAC_EoD
);

parameter WRREQ_IDLE       = 3'b000;
parameter WRREQ_FETCH_REQ  = 3'b001;
parameter WRREQ_FETCH_DATA = 3'b010;
parameter WRREQ_LAST_DATA  = 3'b100;
input  clk;
input  resetn;

//Instruction Fetech (IF)
input  iIF_ValidRd;
input  iIF_AddrRd;
input  iIF_TagRd;
input  iIF_IdRd;
input  iIF_LenRd;
input  iIF_QoSRd;
output oIF_ReadyRd;
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
output oDM_ReadyRd;
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
input   iMAC_ReadyRd;
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
reg          oIF_ReadyRd;
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
reg          oIF_ReadyWr;
reg          rIF_ReadyWr;
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
reg          oDM_ReadyRd;
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
reg          oDM_ReadyWr;
reg          rDM_ReadyWr;
wire [31:0]  iDM_DataWr;
wire [3:0]   iDM_MaskWr;
wire         iDM_EoD;

//Memory Access Controller (MAC)
reg          oMAC_ValidRd;
reg  [31:0]  oMAC_AddrRd;
reg  [3:0]   oMAC_TagRd;
reg  [2:0]   oMAC_IdRd;
reg  [1:0]   oMAC_LenRd;
reg  [3:0]   oMAC_QoSRd;
wire         iMAC_ReadyRd;
wire         iMAC_ValidRsp;
wire [3:0]   iMAC_TagRsp;
wire [31:0]  iMAC_DataRsp;
wire [1:0]   iMAC_StatusRsp;
wire         iMAC_EoD;
reg          oMAC_ReadyRsp;
reg          oMAC_ValidWr;
reg  [31:0]  oMAC_AddrWr;
reg  [3:0]   oMAC_TagWr;
reg  [2:0]   oMAC_IdWr;
reg  [1:0]   oMAC_LenWr;
reg  [3:0]   oMAC_QoSWr;
wire         iMAC_ReadyWr;
reg  [31:0]  oMAC_DataWr;
reg  [3:0]   oMAC_MaskWr;
reg          oMAC_EoD;
reg  [`REQWR_INFO_W-1:0] rIFWrInfo;
reg  [`REQWR_INFO_W-1:0] rDMWrInfo;
reg  [`REQRD_INFO_W-1:0] rIFRdInfo;
reg  [`REQRD_INFO_W-1:0] rDMRdInfo;
reg  [`QOSWR_W-1:0]      rQoS0;
reg  [`QOSWR_W-1:0]      rQoS1;
reg  [`QOSRD_W-1:0]      rQoS2;
reg                      rWr0;
reg                      rWr1;
reg  [`REQWR_DATA_W-1:0] rWrData1;
reg  [`REQWR_INFO_W-1:0] rWrData0;
reg                      ppIF_ValidWr;
reg                      ppDM_ValidWr;
reg  [2:0]               sMacWr;
reg  [2:0]               nsMacWr;
reg  [2:0]               sInWr;
reg  [2:0]               nsInWr;
reg  [3:0]               ppIF_QoSWr;
reg  [3:0]               ppDM_QoSWr;
wire                     wFull0;
wire [4:0]               wEmpty0;
reg                      rRd0;
reg                      rRd1;
reg  [3:0]               counter;
reg  [`REQWR_INFO_W-1:0] wWrReq0;
reg  [`REQWR_DATA_W-1:0] wWrData1;
reg                      rSel;
reg  [31:0]              ppIF_DataWr;
reg  [3:0]               ppIF_MaskWr;
reg  [31:0]              pp2IF_DataWr;
reg  [3:0]               pp2IF_MaskWr;
reg  [31:0]              ppDM_DataWr;
reg  [3:0]               ppDM_MaskWr;
reg  [31:0]              pp2DM_DataWr;
reg  [3:0]               pp2DM_MaskWr;



always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
        rQoS0         <= 4'b0;
        rQoS1         <= 4'b0;
        rQoS2         <= 4'b0;
        rIFWrInfo     <= 45'b0;
        rDMWrInfo     <= 45'b0;
        rIFRdInfo     <= 45'b0;
        rDMRdInfo     <= 45'b0;
        rSel          <= 1'b0;
        ppIF_DataWr   <= 32'b0;
        pp2IF_DataWr  <= 32'b0;
        ppIF_MaskWr   <= 4'b0;
        pp2IF_MaskWr  <= 4'b0;
        ppDM_DataWr   <= 32'b0;
        pp2DM_DataWr  <= 32'b0;
        ppDM_MaskWr   <= 4'b0;
        pp2DM_MaskWr  <= 4'b0;
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
        ppIF_DataWr   <= iIF_DataWr;
        pp2IF_DataWr  <= ppIF_DataWr;
        ppIF_MaskWr   <= iIF_MaskWr;
        pp2IF_MaskWr  <= ppIF_MaskWr;     
        ppDM_DataWr   <= iDM_DataWr;
        pp2DM_DataWr  <= ppDM_DataWr;
        ppDM_MaskWr   <= iDM_MaskWr;
        pp2DM_MaskWr  <= ppDM_MaskWr;     
        //Arbiter
        if (iIF_ValidWr & iDM_ValidWr)  begin
            rSel <= iIF_QoSWr < iDM_QoSWr ? 1'b1 : 1'b0;
        end else if (iIF_ValidWr) begin 
            rSel <= 1'b0; 
        end else if (iDM_ValidWr) begin 
            rSel <= 1'b1;
        end else begin 
            rSel <= 1'b0;
        end 
    end
end 

always @(*) begin 
    rQoS0 = rSel ? iDM_QoSWr : iIF_QoSWr;
    rQoS1 = rSel ? iDM_QoSWr : iIF_QoSWr;
end 

//Input WrReq fifo
always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
        sInWr <= WRREQ_IDLE;
    end else begin 
        sInWr <= nsInWr;
    end 
end 
always @(*) begin 
    nsInWr = sInWr;
    case (sInWr)
	WRREQ_IDLE      : begin 
                              if (rIF_ReadyWr | rDM_ReadyWr) 
                                  nsInWr = WRREQ_FETCH_REQ;
                              else 
                                  nsInWr = WRREQ_IDLE;
                          end 
        WRREQ_FETCH_REQ : begin 
                              if (iIF_EoD | iDM_EoD )
                                  nsInWr = WRREQ_LAST_DATA;
                              else
                                  nsInWr = WRREQ_FETCH_DATA;
                          end
        WRREQ_FETCH_DATA: begin 
                              if (iIF_EoD | iDM_EoD)
                                  nsInWr = WRREQ_LAST_DATA;
                              else
                                  nsInWr = WRREQ_FETCH_DATA;
                          end 
        WRREQ_LAST_DATA : begin 
                              nsInWr = WRREQ_IDLE;
                          end 	
    endcase    
end 

always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
        rWr0     <= 1'b0;
        rWrData0 <= 45'b0;
        rWr1     <= 1'b0;
        rWrData1 <= 36'b0;
    end else begin 
        case (sInWr)
            WRREQ_IDLE      : begin 
                                  rWr0     <= 1'b0;
                                  rWrData0 <= 45'b0;
                                  rWr1     <= 1'b0;
                                  rWrData1 <= 36'b0;
                              end 
            WRREQ_FETCH_REQ : begin  
                                  rWr0     <= 1'b1;
                                  rWrData0 <= rSel ? rDMWrInfo : rIFWrInfo ;
                              end 
            WRREQ_FETCH_DATA: begin 
                                  rWr0     <= 1'b0; //FIXME: Performance is very low for data 
                                  rWrData0 <= 45'b0;
                                  rWr1     <= 1'b1;
                                  rWrData1 <= rSel ? {pp2DM_DataWr, pp2DM_MaskWr} : {pp2IF_DataWr, pp2IF_MaskWr}; 
                              end 
            WRREQ_LAST_DATA: begin 
                                  rWr1     <= 1'b1;
                                  rWrData1 <= rSel ? {pp2DM_DataWr, pp2DM_MaskWr} : {pp2IF_DataWr, pp2IF_MaskWr}; 
                              end 
        endcase

    end 
end 

//Acknowledge the request
always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
            oIF_ReadyWr <= 1'b0;
            rIF_ReadyWr <= 1'b0;
            oDM_ReadyWr <= 1'b0;
            rDM_ReadyWr <= 1'b0;
            oIF_ReadyRd <= 1'b0;
            oDM_ReadyRd <= 1'b0;
    end else begin 
        if (ppIF_ValidWr & ppDM_ValidWr) begin 
            if (ppIF_QoSWr > ppDM_QoSWr ) begin 
                oIF_ReadyWr <= ~wFull0;
                rIF_ReadyWr <= ~wFull0;
	    end else begin
                oDM_ReadyWr <= ~wFull0;
                rDM_ReadyWr <= ~wFull0;
            end
        end else if (ppIF_ValidWr ) begin 
            oIF_ReadyWr <= ~wFull0;
            rIF_ReadyWr <= ~wFull0;
        end else if (ppDM_ValidWr) begin 
            oDM_ReadyWr <= ~wFull0;
            rDM_ReadyWr <= ~wFull0;
        end else begin 
            oIF_ReadyWr <= 1'b0;
            rIF_ReadyWr <= 1'b0;
            oDM_ReadyWr <= 1'b0;
            rDM_ReadyWr <= 1'b0;
        end 
        ppIF_ValidWr  <= iIF_ValidWr;
        ppDM_ValidWr  <= iDM_ValidWr;
        ppIF_QoSWr    <= iIF_QoSWr;
        ppDM_QoSWr    <= iDM_QoSWr;
    end 
end 


//Push request out to memory port
//Wr request sMacWr machine
always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
        sMacWr <= WRREQ_IDLE; 
    end else begin 
        sMacWr <= nsMacWr;
    end
end  
always @(*) begin 
    nsMacWr = sMacWr;
    case (sMacWr)
        WRREQ_IDLE       : begin 
                               if (|(~wEmpty0)) begin 
                                   nsMacWr = WRREQ_FETCH_REQ;
                               end else begin 
                                   nsMacWr = WRREQ_IDLE;
                               end 
                           end 
        WRREQ_FETCH_REQ  : begin 
                               if (iMAC_ReadyWr) begin 
                                   nsMacWr = WRREQ_FETCH_DATA;
                               end 
                           end  
        WRREQ_FETCH_DATA: begin 
                               if (counter >1) begin 
                                   nsMacWr = WRREQ_FETCH_DATA;
                               end else begin 
                                   nsMacWr = WRREQ_LAST_DATA;
                               end
                           end 
        WRREQ_LAST_DATA  : begin 
                               nsMacWr = WRREQ_IDLE;
                           end
        default          : begin 
                               nsMacWr = WRREQ_IDLE;
                           end
    endcase 
end 

always @(posedge clk or negedge resetn) begin 
    if (~resetn) begin 
         rRd0         <= 1'b0;
         rRd1         <= 1'b0;
         counter      <= 4'b0; 
         oMAC_ValidWr <= 1'b0;
         oMAC_EoD     <= 1'b0;
    end else begin 
        case (sMacWr )
            WRREQ_IDLE       : begin 
                                   rRd0         <= 1'b0;
                                   rRd1         <= 1'b0;
                                   oMAC_AddrWr  <= 32'b0;
                                   oMAC_TagWr   <= 4'b0;
                                   oMAC_IdWr    <= 3'b0;
                                   oMAC_QoSWr   <= 4'b0;
                                   oMAC_LenWr   <= 2'b0;
                                   counter      <= 4'b0; 
                                   oMAC_ValidWr <= 1'b0;
                                   oMAC_DataWr  <= 32'b0;
                                   oMAC_MaskWr  <= 4'b0;
                                   oMAC_EoD     <= 1'b0;
                               end 
            WRREQ_FETCH_REQ  : begin 
                                   rRd0         <= 1'b1;
                                   counter      <= wWrReq0[`LENWR_RANGE]==2'b00 ? 1  :
                                                   wWrReq0[`LENWR_RANGE]==2'b01 ? 2  : 
                                                   wWrReq0[`LENWR_RANGE]==2'b10 ? 4  : 
                                                   wWrReq0[`LENWR_RANGE]==2'b11 ? 8  : 0 ;
                                   oMAC_ValidWr <= 1'b1;
                               end
            WRREQ_FETCH_DATA : begin 
                                   rRd0         <= 1'b0;
                                   oMAC_ValidWr <= 1'b0;
                                   rRd1         <= 1'b1;
                                   counter      <= counter - 1;
                               end 
            WRREQ_LAST_DATA  : begin 
                                   rRd1         <= 1'b1;
                                   oMAC_DataWr  <= wWrData1[`DATAWR_RANGE];
                                   oMAC_MaskWr  <= wWrData1[`MASKWR_RANGE];
                                   oMAC_EoD     <= 1'b1; 
                               end
        endcase
    end 
end 
//FIXME I am not sure whether the latch output signals different with that of sequential output.
always @(*) begin 
    oMAC_AddrWr  = wWrReq0[`ADDRWR_RANGE];
    oMAC_TagWr   = wWrReq0[`TAGWR_RANGE];
    oMAC_IdWr    = wWrReq0[`IDWR_RANGE];
    oMAC_QoSWr   = wWrReq0[`QOSWR_RANGE];
    oMAC_LenWr   = wWrReq0[`LENWR_RANGE];
    oMAC_DataWr  = wWrData1[`DATAWR_RANGE];
    oMAC_MaskWr  = wWrData1[`MASKWR_RANGE];
end 

//FIXME, need to change the DSIZE of wr request
fifo_wrapper #(.DSIZE(45), .ANSIZE(5), .HBSIZE(7) ) fifoWrReq0 (
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

fifo_wrapper #(.DSIZE(36), .ANSIZE(5), .HBSIZE(7) ) fifoWrData1 (
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

fifo_wrapper #(.DSIZE(45), .ANSIZE(5), .HBSIZE(7) ) fifoRdReq2 (
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

fifo_wrapper #(.DSIZE(36), .ANSIZE(5), .HBSIZE(7) ) fifoRdRspData3 (
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
