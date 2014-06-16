//Author      : Alex Zhang (cgzhangwei@gmail.com)
//Date        : Jun. 16. 2014
//Description : Create the testbench
module test;
reg         clk;
reg         resetn;

event start_sim_evt;
event end_sim_evt;
reg          rIF_ValidRd;
reg  [31:0]  rIF_AddrRd;
reg  [3:0]   rIF_TagRd;
reg  [2:0]   rIF_IdRd;
reg  [1:0]   rIF_LenRd;
reg  [3:0]   rIF_QoSRd;
wire         wIF_ReadyRd;
wire         wIF_ValidRsp;
wire [3:0]   wIF_TagRsp;
wire [31:0]  wIF_DataRsp;
wire [1:0]   wIF_StatusRsp;
wire         wIF_EoD;
reg          rIF_ReadyRsp;
reg          rIF_ValidWr;
reg  [31:0]  rIF_AddrWr;
reg  [3:0]   rIF_TagWr;
reg  [2:0]   rIF_IdWr;
reg  [1:0]   rIF_LenWr;
reg  [3:0]   rIF_QoSWr;
wire         wIF_ReadyWr;
reg  [31:0]  rIF_DataWr;
reg  [3:0]   rIF_MaskWr;
reg          rIF_EoD;

reg          rDM_ValidRd;
reg  [31:0]  rDM_AddrRd;
reg  [3:0]   rDM_TagRd;
reg  [2:0]   rDM_IdRd;
reg  [1:0]   rDM_LenRd;
reg  [3:0]   rDM_QoSRd;
wire         wDM_ReadyRd;
wire         wDM_ValidRsp;
wire [3:0]   wDM_TagRsp;
wire [31:0]  wDM_DataRsp;
wire [1:0]   wDM_StatusRsp;
wire         wDM_EoD;
reg          rDM_ReadyRsp;
reg          rDM_ValidWr;
reg  [31:0]  rDM_AddrWr;
reg  [3:0]   rDM_TagWr;
reg  [2:0]   rDM_IdWr;
reg  [1:0]   rDM_LenWr;
reg  [3:0]   rDM_QoSWr;
wire         wDM_ReadyWr;
reg  [31:0]  rDM_DataWr;
reg  [3:0]   rDM_MaskWr;
reg          rDM_EoD;

reg          wMAC_ValidRd;
reg  [31:0]  wMAC_AddrRd;
reg  [3:0]   wMAC_TagRd;
reg  [2:0]   wMAC_IdRd;
reg  [1:0]   wMAC_LenRd;
reg  [3:0]   wMAC_QoSRd;
reg          rMAC_ReadyRd;
reg          rMAC_ValidRsp;
reg  [3:0]   rMAC_TagRsp;
reg  [31:0]  rMAC_DataRsp;
reg  [1:0]   rMAC_StatusRsp;
reg          rMAC_EoD;
reg          wMAC_ReadyRsp;
reg          wMAC_ValidWr;
reg  [31:0]  wMAC_AddrWr;
reg  [3:0]   wMAC_TagWr;
reg  [2:0]   wMAC_IdWr;
reg  [1:0]   wMAC_LenWr;
reg  [3:0]   wMAC_QoSWr;
reg          rMAC_ReadyWr;
reg  [31:0]  wMAC_DataWr;
reg  [3:0]   wMAC_MaskWr;
reg          wMAC_EoD;

mem_access_interconnector  MAI(
  .clk(clk),
  .resetn(resetn),
  //Instruction Fetech (IF)
  .iIF_ValidRd(rIF_ValidRd),
  .iIF_AddrRd(rIF_AddrRd),
  .iIF_TagRd(rIF_TagRd),
  .iIF_IdRd(rIF_IdRd),
  .iIF_LenRd(rIF_LenRd),
  .iIF_QoSRd(rIF_QoSRd),
  .oIF_ReadyRd(wIF_ReadyRd),
  .oIF_ValidRsp(wIF_ValidRsp),
  .oIF_TagRsp(wIF_TagRsp),
  .oIF_DataRsp(wIF_DataRsp),
  .oIF_StatusRsp(wIF_StatusRsp),
  .oIF_EoD(wIF_EoD),
  .iIF_ReadyRsp(rIF_ReadyRsp),
  .iIF_ValidWr(rIF_ValidWr),
  .iIF_AddrWr(rIF_AddrWr),
  .iIF_TagWr(rIF_TagWr),
  .iIF_IdWr(rIF_IdWr),
  .iIF_LenWr(rIF_LenWr),
  .iIF_QoSWr(rIF_QoSWr),
  .oIF_ReadyWr(wIF_ReadyWr),
  .iIF_DataWr(rIF_DataWr),
  .iIF_MaskWr(rIF_MaskWr),
  .iIF_EoD(rIF_EoD),
  
  //Data Memory (DM)
  .iDM_ValidRd(rDM_ValidRd),
  .iDM_AddrRd(rDM_AddrRd),
  .iDM_TagRd(rDM_TagRd),
  .iDM_IdRd(rDM_IdRd),
  .iDM_LenRd(rDM_LenRd),
  .iDM_QoSRd(rDM_QoSRd),
  .oDM_ReadyRd(wDM_ReadyRd),
  .oDM_ValidRsp(wDM_ValidRsp),
  .oDM_TagRsp(wDM_TagRsp),
  .oDM_DataRsp(wDM_DataRsp),
  .oDM_StatusRsp(wDM_StatusRsp),
  .oDM_EoD(wDM_EoD),
  .iDM_ReadyRsp(rDM_ReadyRsp),
  .iDM_ValidWr(rDM_ValidWr),
  .iDM_AddrWr(rDM_AddrWr),
  .iDM_TagWr(rDM_TagWr),
  .iDM_IdWr(rDM_IdWr),
  .iDM_LenWr(rDM_LenWr),
  .iDM_QoSWr(rDM_QoSWr),
  .oDM_ReadyWr(wDM_ReadyWr),
  .iDM_DataWr(rDM_DataWr),
  .iDM_MaskWr(rDM_MaskWr),
  .iDM_EoD(rDM_EoD),
  
  //Memory Access Controller (MAC)
  .oMAC_ValidRd(wMAC_Valid),
  .oMAC_AddrRd(wMAC_AddrRd),
  .oMAC_TagRd(wMAC_TagRd),
  .oMAC_IdRd(wMAC_IdRd),
  .oMAC_LenRd(wMAC_LenRd),
  .oMAC_QoSRd(wMAC_QoSRd),
  .iMAC_ReadyRd(rMAC_ReadyRd),
  .iMAC_ValidRsp(rMAC_ValidRsp),
  .iMAC_TagRsp(rMAC_TagRsp),
  .iMAC_DataRsp(rMAC_DataRsp),
  .iMAC_StatusRsp(rMAC_StatusRsp),
  .iMAC_EoD(rMAC_EoD),
  .oMAC_ReadyRsp(wMAC_ReadyRsp),
  .oMAC_ValidWr(wMAC_ValidWr),
  .oMAC_AddrWr(wMAC_AddrWr),
  .oMAC_TagWr(wMAC_TagWr),
  .oMAC_IdWr(wMAC_IdWr),
  .oMAC_LenWr(wMAC_LenWr),
  .oMAC_QoSWr(wMAC_QoSWr),
  .iMAC_ReadyWr(rMAC_ReadyWr),
  .oMAC_DataWr(wMAC_DataWr),
  .oMAC_MaskWr(wMAC_MaskWr),
  .oMAC_EoD(wMAC_EoD)
);



initial begin 
    basic;
end 
initial begin 
    $fsdbDumpfile("./out/mai.fsdb");
    $fsdbDumpvars(0, test);
end 

task basic ;
    begin 
        $display("Start MAI IP testing.");
        #1;
        fork
            drive_clock;
            reset_unit;
            drive_sim;
            monitor_sim;
        join 
    end 
endtask 
task monitor_sim;
   begin 
   @(end_sim_evt);
   #10;
   $display("Test End");
   $finish;
   end 
endtask
task reset_unit;
    begin 
        #5;
        resetn = 1;
        #10;
        resetn = 0;
//Reset the reg variable 
        rIF_ValidRd   = 1'b0;;
        rIF_AddrRd    = 32'b0;
        rIF_TagRd     = 4'b0;;
        rIF_IdRd      = 3'b0;
        rIF_LenRd     = 2'b0;
        rIF_QoSRd     = 4'b0;
        rIF_ReadyRsp  = 1'b0;
        rIF_ValidWr   = 1'b0;
        rIF_AddrWr    = 32'b0;
        rIF_TagWr     = 4'b0;
        rIF_IdWr      = 3'b0;
        rIF_LenWr     = 2'b0;
        rIF_QoSWr     = 4'b0;
        rIF_DataWr    = 32'b0;
        rIF_MaskWr    = 4'b0;
        rIF_EoD       = 1'b0;

        rDM_ValidRd   = 1'b0;;
        rDM_AddrRd    = 32'b0;
        rDM_TagRd     = 4'b0;;
        rDM_IdRd      = 3'b0;
        rDM_LenRd     = 2'b0;
        rDM_QoSRd     = 4'b0;
        rDM_ReadyRsp  = 1'b0;
        rDM_ValidWr   = 1'b0;
        rDM_AddrWr    = 32'b0;
        rDM_TagWr     = 4'b0;
        rDM_IdWr      = 3'b0;
        rDM_LenWr     = 2'b0;
        rDM_QoSWr     = 4'b0;
        rDM_DataWr    = 32'b0;
        rDM_MaskWr    = 4'b0;
        rDM_EoD       = 1'b0;

        rMAC_ReadyWr  = 1'b0;

        #20;
        resetn = 1;
        ->start_sim_evt;
        $display("Reset is done");
        end
endtask 
task  drive_clock;
    begin 
        clk = 0;
        forever begin 
        #5 clk = ~clk;
        end 
    end 
endtask
task  drive_sim;
    @(start_sim_evt);
   
    @(posedge clk);
    rMAC_ReadyWr  = 1'b1;
    fork 
        begin  : drive_wrreq
            @(posedge clk);
            rIF_ValidWr   = 1'b1;
            rIF_AddrWr    = 32'h2345_F000;
            rIF_TagWr     = 4'b0;
            rIF_IdWr      = 3'b101;
            rIF_LenWr     = 2'b10; //64Bit data
            rIF_QoSWr     = 4'b0110;
            @(posedge clk);
            rIF_ValidWr   = 1'b0;
            rIF_AddrWr    = 32'h0;
            rIF_TagWr     = 4'b0;
            rIF_IdWr      = 3'b0;
            rIF_LenWr     = 2'b0; //64Bit data
            rIF_QoSWr     = 4'b0;
        end 
        begin :drive_wrdata
            // wait ( wIF_ReadyWr == 1'b1);
            @(posedge clk);
            @(posedge clk);
            @(posedge clk);
            rIF_DataWr    = 32'hABCD_EF12;
            rIF_MaskWr    = 4'b1101;
            rIF_EoD       = 1'b0;
            @(posedge clk);
            rIF_DataWr    = 32'hCBCD_EF12;
            rIF_MaskWr    = 4'b1011;
            rIF_EoD       = 1'b1;
            @(posedge clk);
            rIF_DataWr    = 32'h0;
            rIF_MaskWr    = 4'b0;
            rIF_EoD       = 1'b0;
        end
    join
    repeat (100) @(posedge clk);

    ->end_sim_evt;
endtask 

endmodule 
