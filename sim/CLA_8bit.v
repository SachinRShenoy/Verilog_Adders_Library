`include "params.vh"
`timescale 1ns/1ps
`default_nettype none

module CLA_8bit (
    input  wire [`N-1:0] A,
    input  wire [`N-1:0] B,
    input  wire          Cin,
    output wire [`N-1:0] Sum,
    output wire          Car
);

    wire [`N-1:0] G;   // Generate
    wire [`N-1:0] P;   // Propagate
    wire [`N:0]   C;   // Carry

    assign C[0] = Cin;

    // Generate & Propagate
    assign G = A & B;
    assign P = A ^ B;

    // Carry Look-Ahead Logic
    assign C[1] = G[0] | (P[0] & C[0]);

    assign C[2] = G[1]
                | (P[1] & G[0])
                | (P[1] & P[0] & C[0]);

    assign C[3] = G[2]
                | (P[2] & G[1])
                | (P[2] & P[1] & G[0])
                | (P[2] & P[1] & P[0] & C[0]);

    assign C[4] = G[3]
                | (P[3] & G[2])
                | (P[3] & P[2] & G[1])
                | (P[3] & P[2] & P[1] & G[0])
                | (P[3] & P[2] & P[1] & P[0] & C[0]);

    assign C[5] = G[4]
                | (P[4] & G[3])
                | (P[4] & P[3] & G[2])
                | (P[4] & P[3] & P[2] & G[1])
                | (P[4] & P[3] & P[2] & P[1] & G[0])
                | (P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    assign C[6] = G[5]
                | (P[5] & G[4])
                | (P[5] & P[4] & G[3])
                | (P[5] & P[4] & P[3] & G[2])
                | (P[5] & P[4] & P[3] & P[2] & G[1])
                | (P[5] & P[4] & P[3] & P[2] & P[1] & G[0])
                | (P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    assign C[7] = G[6]
                | (P[6] & G[5])
                | (P[6] & P[5] & G[4])
                | (P[6] & P[5] & P[4] & G[3])
                | (P[6] & P[5] & P[4] & P[3] & G[2])
                | (P[6] & P[5] & P[4] & P[3] & P[2] & G[1])
                | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0])
                | (P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    assign C[8] = G[7]
                | (P[7] & G[6])
                | (P[7] & P[6] & G[5])
                | (P[7] & P[6] & P[5] & G[4])
                | (P[7] & P[6] & P[5] & P[4] & G[3])
                | (P[7] & P[6] & P[5] & P[4] & P[3] & G[2])
                | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & G[1])
                | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & G[0])
                | (P[7] & P[6] & P[5] & P[4] & P[3] & P[2] & P[1] & P[0] & C[0]);

    // Sum
    assign Sum = P ^ C[`N-1:0];

    // Final Carry
    assign Car = C[`N];

endmodule

`default_nettype wire
