`timescale 1ns/1ps
`default_nettype none
/*
	Initial Pi = Ai ^ Bi;
	Initial Gi = Ai & Bi;
	
	Carry = Gi | (Pi&Gi-1);
	
	Group Propogate and Generate
	
	Pi:j = P(i:k) & P(k-1:j);
	Gi:j = G(i:k) | (P(i:k)&G(k-1:j);
	
	Carry i = Gi-1:0 | (Pi-1:0 & Cin);
	Sum i = Pi ^ Carryi

*/

module KS(
	input [3:0]A,B,
	input Cin,
	output [3:0]Sum,
	output Cout
);
	
	wire [3:0] P, G;
	wire [4:0] C;
	
	assign C[0]=Cin;
	
	assign P = A ^ B;
	assign G = A & B;
	
	//LAYER 1 - Distance = 1
	
	wire p10,p21,p32;
	wire g10,g21,g32;
	
	assign p10 = P[1] & P[0];
	assign p21 = P[2] & P[1];
	assign p32 = P[3] & P[2];
	
	assign g10 = G[1] | (P[1] & G[0]);
	assign g21 = G[2] | (P[2] & G[1]);
	assign g32 = G[3] | (P[3] & G[2]);
		
	//Layer 2 - Distance = 2
	
	wire p20,p31;
	wire g20,g31;
	
	assign p20 = p21 & P[0];
	assign p31 = p32 & p10;
	
	assign g20 = g21 | (p21 & G[0]);
	assign g31 = g32 | (p32 & g10);
	
	//Carry computation 
	
	assign C[1] = G[0]| (P[0] & C[0]);
	assign C[2] = g10 | (p10 & C[0]);
	assign C[3] = g20 | (p20 & C[0]);
	assign C[4] = g31 | (p31 & C[0]);
	
	
	//Sum computation 
	
	assign Cout = C[4];
	assign Sum = P ^ C[3:0];
	
endmodule

`default_nettype wire