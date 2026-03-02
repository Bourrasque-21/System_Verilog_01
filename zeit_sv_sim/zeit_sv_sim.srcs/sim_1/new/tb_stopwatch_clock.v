/*
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
        // 기본 초기화
        clk          = 1'b0;
        reset        = 1'b1;
        cnt_mode     = 1'b1;  // 0: up
        sw_time_set  = 1'b0;

        btn_run_stop = 1'b0;
        btn_clear    = 1'b0;
        btn_up       = 1'b0;
        btn_down     = 1'b0;
        btn_next     = 1'b0;

        // 리셋 유지 후 해제
        repeat (5) @(posedge clk);
        reset = 1'b0;

        // ============================
        // 1) Clock 정상 증가 확인
        // (tick이 느리면 여기서는 변화가 안 보일 수 있음)
        // ============================
        repeat (200) @(posedge clk);

        // ============================
        // 2) Stopwatch: RUN(토글) -> 조금 진행 -> STOP(토글)
        // ============================

        btn_run_stop = 1'b1;
        @(posedge clk);

        btn_run_stop = 1'b0;
        @(posedge clk);


btn_clear = 1'b1;
        @(posedge clk);
        #100;
        btn_clear = 1'b0;
        @(posedge clk);


        // 조금 기다리기 (tick이 느리면 더 늘려야 함)
        repeat (500000) @(posedge clk);

        // STOP 토글
        @(posedge clk);
        btn_run_stop = 1'b1;
        @(posedge clk);
        btn_run_stop = 1'b0;

        // STOP 상태 유지 확인
        repeat (2000) @(posedge clk);

        // ============================
        // 3) Stopwatch: STOP 상태에서 CLEAR 동작 확인
        // ============================
        @(posedge clk);
        btn_clear = 1'b1;
        @(posedge clk);
        btn_clear = 1'b0;

        repeat (200) @(posedge clk);

        // ============================
        // 4) Stopwatch: RUN 중 CLEAR 무시 확인
        // RUN 토글 -> 잠깐 진행 -> clear 펄스 -> 더 진행 -> STOP 토글
        // ============================
        @(posedge clk);
        btn_run_stop = 1'b1;
        @(posedge clk);
        btn_run_stop = 1'b0;

        repeat (200000) @(posedge clk);

        // RUN 중 clear (무시돼야 함)
        @(posedge clk);
        btn_clear = 1'b1;
        @(posedge clk);
        btn_clear = 1'b0;

        repeat (200000) @(posedge clk);

        // STOP 토글
        @(posedge clk);
        btn_run_stop = 1'b1;
        @(posedge clk);
        btn_run_stop = 1'b0;

        repeat (200) @(posedge clk);

        // ============================
        // 5) Stopwatch: RUN 도중 mode 변경 즉시 반영 확인
        // up으로 달리다 down으로 바꾸기
        // ============================
        // 다시 RUN
        @(posedge clk);
        btn_run_stop = 1'b1;
        @(posedge clk);
        btn_run_stop = 1'b0;

        cnt_mode = 1'b1;  // up
        repeat (200000) @(posedge clk);

        // 모드 변경 (즉시 down 동작해야 함)
        cnt_mode = 1'b1;  // down
        repeat (200000) @(posedge clk);

        // STOP
        @(posedge clk);
        btn_run_stop = 1'b1;
        @(posedge clk);
        btn_run_stop = 1'b0;

        // ============================
        // 6) Clock: TIME-SET 진입 -> NEXT로 필드 이동 -> UP/DOWN 적용 -> 종료
        // (time-set 동안 clock tick 정지)
        // sel: 00 msec -> 01 sec -> 10 min -> 11 hour -> 00 ...
        // ============================
        sw_time_set  = 1'b1;
        repeat (10) @(posedge clk);

        // msec 선택(00)에서 up 3번
        @(posedge clk);
        btn_up = 1'b1;
        @(posedge clk);
        btn_up = 1'b0;
        @(posedge clk);
        btn_up = 1'b1;
        @(posedge clk);
        btn_up = 1'b0;
        @(posedge clk);
        btn_up = 1'b1;
        @(posedge clk);
        btn_up = 1'b0;

        // next -> sec(01)
        @(posedge clk);
        btn_next = 1'b1;
        @(posedge clk);
        btn_next = 1'b0;

        // sec에서 up 2번
        @(posedge clk);
        btn_up = 1'b1;
        @(posedge clk);
        btn_up = 1'b0;
        @(posedge clk);
        btn_up = 1'b1;
        @(posedge clk);
        btn_up = 1'b0;

        // next -> min(10)
        @(posedge clk);
        btn_next = 1'b1;
        @(posedge clk);
        btn_next = 1'b0;

        // min에서 down 1번
        @(posedge clk);
        btn_down = 1'b1;
        @(posedge clk);
        btn_down = 1'b0;

        // next -> hour(11)
        @(posedge clk);
        btn_next = 1'b1;
        @(posedge clk);
        btn_next = 1'b0;

        // hour에서 up 1번
        @(posedge clk);
        btn_up = 1'b1;
        @(posedge clk);
        btn_up = 1'b0;

        // time-set 종료 (다시 tick으로 증가)
        sw_time_set = 1'b0;
        repeat (500) @(posedge clk);

        $stop;
    end
endmodule
*/