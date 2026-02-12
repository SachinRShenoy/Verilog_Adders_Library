`timescale 1ns/1ps

module FA(input A,B,Cin, output Sum,Car);
	wire G,P;
	assign G = A & B;
	assign P = A ^ B;
	assign Sum = P ^ Cin;
	assign Car = G | (P & Cin );
endmodule