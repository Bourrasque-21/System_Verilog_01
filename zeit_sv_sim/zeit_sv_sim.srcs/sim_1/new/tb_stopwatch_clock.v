`timescale 1ns / 1ps

module tb_stopwatch_clock ();
    reg clk;
    reg reset;
    reg cnt_mode;
    reg sw_time_set;
    reg btn_run_stop;
    reg btn_clear;
    reg btn_up;
    reg btn_down;
    reg btn_next;
    wire [25:0] stopwatch_time;
    wire [23:0] clock_time;


    stopwatch_clock dut (
        .clk           (clk),
        .reset         (reset),
        .cnt_mode      (cnt_mode),
        .sw_time_set   (sw_time_set),
        .btn_run_stop  (btn_run_stop),
        .btn_clear     (btn_clear),
        .btn_up        (btn_up),
        .btn_down      (btn_down),
        .btn_next      (btn_next),
        .stopwatch_time(stopwatch_time),
        .clock_time    (clock_time)
    );

    always #5 clk = ~clk;
    initial begin
        #0;
        clk          = 0;
        reset        = 1;
        sw_time_set  = 0;
        cnt_mode     = 0;

        btn_run_stop = 0;
        btn_clear    = 0;
        btn_up       = 0;
        btn_down     = 0;
        btn_next     = 0;

        #50;
        reset = 0;
        #15000000;
        #10;
        btn_run_stop = 1;

        #10;
        btn_run_stop = 0;


        $stop;
    end

endmodule
