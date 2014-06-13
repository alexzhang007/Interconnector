//Author      : Alex Zhang (cgzhangwei@gmail.com)
//Date        : Jun. 04. 2014
//Description : Create the testbench
//              Fix Bug7: Loading the register_file with 0 data. Sequential logic should be used in that block. But i notice that when computer is sleeping, resuming can call back the original data. So i try to use the loading. 
module test;
reg         clk;
reg         resetn;
reg         rRd;
reg         rWr;
reg  [31:0] rWrData;
wire [31:0] rRdData;
reg  [3:0]  rQos;
wire        wFull;
wire        wEmpty;

event start_sim_evt;
event end_sim_evt;
fifo_wrapper (
  .iWrClk(clk),
  .iWrResetn(resetn),
  .iRdClk(clk),
  .iRdResetn(resetn),
  .iWr(rWr),
  .iRd(rRd),
  .iQoS(rQos),
  .iWrData(rWrData),
  .oRdData(rRdData),
  .oFull (wFull),
  .oEmpty(wEmpty)
);
initial begin 
    basic;
end 
initial begin 
    $fsdbDumpfile("./out/fifo.fsdb");
    $fsdbDumpvars(0, test);
end 

task basic ;
    begin 
        $display("Start multi-FIFO IP testing.");
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
        rRd    = 0;
        rWr    = 0;
        rWrData  = 0;
        rQos     = 0;
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
    rRd      = 0;
    rWr      = 1;
    rWrData  = 32'h1234_5678;
    rQos     = 4'b0001;
    @(posedge clk);
    rRd      = 0;
    rWr      = 1;
    rWrData  = 32'h2234_5678;
    rQos     = 4'b0001;
    repeat (5) @(posedge clk);
    rRd      = 1;
    rWr      = 0;
    rWrData  = 32'b0;
    @(posedge clk);
    rRd       = 0;
    rWr       = 0;
    rWrData   = 0;
    repeat (100) @(posedge clk);

    ->end_sim_evt;
endtask 

endmodule 
