// Code your testbench here
// or browse Examples
// EDA Playground testbench: exhaustive self-check + waveform dump for EPWave
`timescale 1ns/1ps
module alu_tb;
    reg  [3:0] a, b;
    reg  [2:0] op;
    wire [3:0] result;
    wire carry, zero, sign, overflow;
    integer i, j, k, errors;
    reg [3:0] exp;

    alu4 dut(a, b, op, result, carry, zero, sign, overflow);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, alu_tb);
        errors = 0;
        for (k = 0; k < 8; k = k + 1)
            for (i = 0; i < 16; i = i + 1)
                for (j = 0; j < 16; j = j + 1) begin
                    op = k; a = i; b = j; #1;
                    case (k)
                        0: exp = (a + b) & 4'hF;
                        1: exp = (a - b) & 4'hF;
                        2: exp = a & b;
                        3: exp = a | b;
                        4: exp = a ^ b;
                        5: exp = ~a;
                        6: exp = {1'b0, a < b, a == b, a > b};
                        default: exp = a;
                    endcase
                    if (result !== exp) begin
                        errors = errors + 1;
                        $display("FAIL op=%0d a=%0d b=%0d got=%b exp=%b", k, i, j, result, exp);
                    end
                end
        if (errors == 0) $display("PASS: all 2048 cases correct");
        else $display("Done. Errors = %0d", errors);
        $finish;
    end
endmodule