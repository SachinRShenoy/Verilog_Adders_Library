`include "params.vh"
`timescale 1ns/1ps
`default_nettype none

module All_adders (

    input  wire [`N-1:0] A,
    input  wire [`N-1:0] B,
    input  wire          Cin,
    input  wire [2:0]    Sel,

    output wire [`N-1:0] Sum,
    output wire          Car
);

    // ---------------- Internal wires ----------------
    wire [`N-1:0] Sum_rca;
    wire [`N-1:0] Sum_cla;
    wire [`N-1:0] Sum_ksN;

    wire Car_rca, Car_cla, Car_ksN;

    wire [3:0] Sum_ks4;
    wire Car_ks4;

    // ---------------- RCA (N-bit) ----------------
    RCA u_rca (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum_rca),
        .Car(Car_rca)
    );

    // ---------------- CLA (N-bit) ----------------
    CLA_8bit u_cla (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum_cla),
        .Car(Car_cla)
    );

    // ---------------- kogge_stone (N-bit) ----------------
    kogge_stone u_ksN (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum_ksN),
        .Cout(Car_ksN)
    );

    // ---------------- KS (4-bit ONLY) ----------------
    KS u_ks4 (
        .A(A[3:0]),     // Slice lower 4 bits
        .B(B[3:0]),
        .Cin(Cin),
        .Sum(Sum_ks4),
        .Cout(Car_ks4)
    );

    // ---------------- Output MUX ----------------
    reg [`N-1:0] Sum_reg;
    reg Car_reg;

    always @(*) begin
        case (Sel)

            3'b000: begin   // RCA
                Sum_reg = Sum_rca;
                Car_reg = Car_rca;
            end

            3'b001: begin   // CLA
                Sum_reg = Sum_cla;
                Car_reg = Car_cla;
            end

            3'b010: begin   // kogge_stone (N-bit)
                Sum_reg = Sum_ksN;
                Car_reg = Car_ksN;
            end

            3'b011: begin   // KS (4-bit)
                Sum_reg = {{(`N-4){1'b0}}, Sum_ks4};
                Car_reg = Car_ks4;
            end

            default: begin
                Sum_reg = {`N{1'b0}};
                Car_reg = 1'b0;
            end

        endcase
    end

    assign Sum = Sum_reg;
    assign Car = Car_reg;

endmodule

`default_nettype wire
