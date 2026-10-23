// Code your design here
// 4-bit ALU - structural/dataflow Verilog, mirrors alu.py
// opcode: 000 ADD, 001 SUB, 010 AND, 011 OR, 100 XOR, 101 NOT A, 110 CMP, 111 PASS A
module full_adder(input a, b, cin, output sum, cout);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (cin & (a ^ b));
endmodule

module alu4 (
    input  [3:0] a, b,
    input  [2:0] op,
    output [3:0] result,
    output       carry, zero, sign, overflow
);
    wire sub = (op == 3'b001) | (op == 3'b110);
    wire [3:0] bx = b ^ {4{sub}};
    wire [4:0] c;
    wire [3:0] sum;
    assign c[0] = sub;

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : fa
            full_adder u (a[i], bx[i], c[i], sum[i], c[i+1]);
        end
    endgenerate

    wire eq = (sum == 4'b0000);
    wire lt = ~c[4];
    wire gt = c[4] & ~eq;

    reg [3:0] r;
    always @(*) begin
        case (op)
            3'b000, 3'b001: r = sum;
            3'b010: r = a & b;
            3'b011: r = a | b;
            3'b100: r = a ^ b;
            3'b101: r = ~a;
            3'b110: r = {1'b0, lt, eq, gt};
            default: r = a;
        endcase
    end

    wire is_arith = (op[2:1] == 2'b00);
    assign result   = r;
    assign carry    = is_arith & c[4];
    assign overflow = is_arith & (c[3] ^ c[4]);
    assign zero     = (r == 4'b0000);
    assign sign     = r[3];
endmodule