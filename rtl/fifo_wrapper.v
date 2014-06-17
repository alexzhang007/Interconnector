//Author     : Alex Zhang (cgzhangwei@gmail.com)
//Date       : Jun.13.2014 
//Description: Implement the fifo with qos
//             FIX Bug16: There is request coming to MAI, fifoWrReq0 cannot be written

module fifo_wrapper (
iWrClk,
iWrResetn,
iWr,
iWrData,
iRdClk,
iRdResetn,
iRd,
oRdData,
iQoS,
oFull,
oEmpty
);

parameter DSIZE  =32;
parameter ANSIZE =2 ; //Normal fifo
parameter HBSIZE =4;  //High BW fifo
input  iWrClk;
input  iWrResetn;
input  iWr;
input  iWrData;
input  iRdClk;
input  iRdResetn;
input  iRd;
input  iQoS;
output  oRdData;
output  oFull;
output  oEmpty;

wire [DSIZE-1:0]  iWrData;
reg  [DSIZE-1:0]  oRdData;
wire [3:0]   iQoS;
reg          oFull;
reg  [4:0]   oEmpty;
wire         wFull0;
wire         wFull1;
wire         wFull2;
wire         wFull3;
wire         wFull4;
wire         wEmpty0;
wire         wEmpty1;
wire         wEmpty2;
wire         wEmpty3;
wire         wEmpty4;
reg          rRd0;
reg          rRd1;
reg          rRd2;
reg          rRd3;
reg          rRd4;
reg          rWr0;
reg          rWr1;
reg          rWr2;
reg          rWr3;
reg          rWr4;
reg  [DSIZE-1:0]  rWrData0;
reg  [DSIZE-1:0]  rWrData1;
reg  [DSIZE-1:0]  rWrData2;
reg  [DSIZE-1:0]  rWrData3;
reg  [DSIZE-1:0]  rWrData4;
wire [DSIZE-1:0]  wRdData0;
wire [DSIZE-1:0]  wRdData1;
wire [DSIZE-1:0]  wRdData2;
wire [DSIZE-1:0]  wRdData3;
wire [DSIZE-1:0]  wRdData4;

assign wFifoStatus = {wFull4, wFull3, wFull2, wFull1, wFull0};

//Empty update
always @(posedge iWrClk or negedge iWrResetn) begin 
    if (~iWrResetn) begin 
        oFull <= 1'b0;
        //oEmpty<= 5'b0;
    end else begin 
        if (iQoS[3]) begin 
            oFull  <= wFull4;
        end else if (iQoS==4'b0000 || iQoS == 4'b0001) begin 
            oFull  <= wFull0;
        end else if (iQoS==4'b0010 || iQoS == 4'b0011) begin 
            oFull  <= wFull0 & wFull1;
        end else if (iQoS==4'b0100 || iQoS == 4'b0101) begin 
            oFull  <= wFull0 & wFull1 & wFull2;
        end else if (iQoS==4'b0010 || iQoS == 4'b0011) begin 
            oFull <= wFull0 & wFull1 & wFull2 & wFull3;
        end 
        oEmpty <= {wEmpty4, wEmpty3, wEmpty2, wEmpty1, wEmpty0};
    end 
end 
//Write request
always @(posedge iWrClk or negedge iWrResetn) begin 
    if (~iWrResetn) begin
        rWr0     <= 1'b0;
        rWr1     <= 1'b0;
        rWr2     <= 1'b0;
        rWr3     <= 1'b0;
        rWr4     <= 1'b0;
        rWrData0 <= 0;
        rWrData1 <= 0;
        rWrData2 <= 0;
        rWrData3 <= 0;
        rWrData4 <= 0;
    end else begin
        casex ({iWr, iQoS}) 
            5'b10000, 5'b10001: begin 
                    rWr0     <= 1'b1;
                    rWrData0 <= iWrData;
                end  
            5'b10010, 5'b10011: begin 
                    if (wFull0) begin 
                        rWr1     <= 1'b1;
                        rWrData1 <= iWrData;
                    end else begin 
                        rWr0     <= 1'b1;
                        rWrData0 <= iWrData;
                    end 
                end
            5'b10100, 5'b10101: begin 
                    if (wFull0&wFull1) begin 
                        rWr2     <= 1'b1;
                        rWrData2 <= iWrData;
                    end else if (wFull0) begin 
                        rWr1     <= 1'b1;
                        rWrData1 <= iWrData;
                    end else begin 
                        rWr0     <= 1'b1;
                        rWrData0 <= iWrData;
                    end 
                end
            5'b10110, 5'b10111: begin 
                    if (wFull0&wFull1&wFull2) begin 
                        rWr3     <= 1'b1;
                        rWrData3 <= iWrData;
                    end else if (wFull0&wFull1) begin 
                        rWr2     <= 1'b1;
                        rWrData2 <= iWrData;
                    end else if (wFull0) begin 
                        rWr1     <= 1'b1;
                        rWrData1 <= iWrData;
                    end else begin 
                        rWr0     <= 1'b1;
                        rWrData0 <= iWrData;
                    end 
                end
            5'b11??? : begin 
                rWr4 <= 1'b1;
                rWrData4 <= iWrData;
                end 
            default : begin 
                    rWr0     <= 1'b0;
                    rWr1     <= 1'b0;
                    rWr2     <= 1'b0;
                    rWr3     <= 1'b0;
                    rWr4     <= 1'b0;
                    rWrData0 <= 0;
                    rWrData1 <= 0;
                    rWrData2 <= 0;
                    rWrData3 <= 0;
                    rWrData4 <= 0;
            end 
        endcase
    end
end 

//Read request
//FIXME: Latch output the data since the write request FSM in mai.v will just have 4 states.
//If here is changed to sequential output, there will be wrong behavior
always @(*) begin 
        if(iRd & ~wEmpty4) begin 
            rRd4    = 1'b1; 
            oRdData = wRdData4;
        end else if (iRd & wEmpty4 & ~wEmpty3) begin 
            rRd3    = 1'b1; 
            oRdData = wRdData3;
        end else if (iRd & wEmpty4 & wEmpty3 & ~wEmpty2) begin 
            rRd2    = 1'b1; 
            oRdData = wRdData2;
        end else if (iRd & wEmpty4 & wEmpty3 & wEmpty2 & ~wEmpty1) begin 
            rRd1    = 1'b1; 
            oRdData = wRdData1;
        end else if (iRd & wEmpty4 & wEmpty3 & wEmpty2 & wEmpty1 & ~wEmpty0) begin 
            rRd0    = 1'b1; 
            oRdData = wRdData0;
        end else begin 
            rRd0    = 1'b0;
            rRd1    = 1'b0;
            rRd2    = 1'b0;
            rRd3    = 1'b0;
            rRd4    = 1'b0;
            oRdData = 0;
        end 
end 

fifo #(.DSIZE(DSIZE), .ASIZE(ANSIZE)) fifo0 (
  .wclk(iWrClk),
  .wrst_n(iWrResetn),
  .wr(rWr0),
  .rclk(iRdClk),
  .rrst_n(iRdResetn),
  .rd(rRd0),
  .wdata(rWrData0),
  .rdata(wRdData0),
  .wfull(wFull0),
  .rempty(wEmpty0)
);
fifo #(.DSIZE(DSIZE), .ASIZE(ANSIZE)) fifo1 (
  .wclk(iWrClk),
  .wrst_n(iWrResetn),
  .wr(rWr1),
  .rclk(iRdClk),
  .rrst_n(iRdResetn),
  .rd(rRd1),
  .wdata(rWrData1),
  .rdata(wRdData1),
  .wfull(wFull1),
  .rempty(wEmpty1)
);
fifo #(.DSIZE(DSIZE), .ASIZE(ANSIZE)) fifo2 (
  .wclk(iWrClk),
  .wrst_n(iWrResetn),
  .wr(rWr2),
  .rclk(iRdClk),
  .rrst_n(iRdResetn),
  .rd(rRd2),
  .wdata(rWrData2),
  .rdata(wRdData2),
  .wfull(wFull2),
  .rempty(wEmpty2)
);
fifo #(.DSIZE(DSIZE), .ASIZE(ANSIZE)) fifo3 (
  .wclk(iWrClk),
  .wrst_n(iWrResetn),
  .wr(rWr3),
  .rclk(iRdClk),
  .rrst_n(iRdResetn),
  .rd(rRd3),
  .wdata(rWrData3),
  .rdata(wRdData3),
  .wfull(wFull3),
  .rempty(wEmpty3)
);

fifo #(.DSIZE(DSIZE), .ASIZE(ANSIZE)) fifoHiBW (
  .wclk(iWrClk),
  .wrst_n(iWrResetn),
  .wr(rWr4),
  .rclk(iRdClk),
  .rrst_n(iRdResetn),
  .rd(rRd4),
  .wdata(rWrData4),
  .rdata(wRdData4),
  .wfull(wFull4),
  .rempty(wEmpty4)
);

endmodule 
