`timescale 1ns / 1ps



module control_unit (
    input        clk,
    input        rst,
    input        push,
    input        pop,
    output       full,
    output       empty,
    output [3:0] wptr,
    output [3:0] rptr
);

    logic [3:0] rptr_r, rptr_n, wptr_r, wptr_n;
    logic full_r, full_n, empty_r, empty_n;

    assign full  = full_r;
    assign empty = empty_r;
    assign wptr  = wptr_r;
    assign rptr  = rptr_r;

    always_ff @(posedge clk, posedge rst) begin
        if (rst) begin
            full_r  <= 0;
            empty_r <= 1;
            wptr_r  <= 0;
            rptr_r  <= 0;
        end else begin
            full_r  <= full_n;
            empty_r <= empty_n;
            wptr_r  <= wptr_n;
            rptr_r  <= rptr_n;
        end
    end

    always_comb begin
        full_n  = full_r;
        empty_n = empty_r;
        wptr_n  = wptr_r;
        rptr_n  = rptr_r;

        case ({
            push, pop
        })
            2'b10: begin  // Push
                if (!full_r) begin
                    wptr_n  = wptr_r + 1;
                    empty_n = 0;
                    if ((wptr_r + 1) == rptr_r) begin
                        full_n = 1;
                    end
                end
            end
            2'b01: begin  // Pop
                if (!empty_r) begin
                    rptr_n = rptr_r + 1;
                    full_n = 0;
                    if ((rptr_r + 1) == wptr_r) begin
                        empty_n = 1;
                    end
                end
            end
            2'b11: begin  // Push & Pop
                if (full_r) begin
                    rptr_n = rptr_r + 1;
                    wptr_n = wptr_r + 1;
                    full_n = 1;
                end else if (empty_r) begin
                    wptr_n  = wptr_r + 1;
                    empty_n = 0;
                end else begin
                    rptr_n = rptr_r + 1;
                    wptr_n = wptr_r + 1;
                end
            end
        endcase
    end
endmodule


module sram (
    input              clk,
    input  logic [3:0] addr,
    input  logic [7:0] wdata,
    input  logic       we,
    output logic [7:0] rdata
);

    logic [7:0] ram[0:15];

    always_ff @(posedge clk) begin
        if (we) begin
            ram[addr] <= wdata;
        end
    end

    assign rdata = ram[addr];

endmodule
