`include "params.vh"
`default_nettype none
`timescale 1ns/1ps


module RCA(input [`N-1:0] A,B,input Cin, output [`N-1:0] Sum,output Car);
	wire [`N:0]q;
	assign q[0]=Cin;
	genvar i;
	generate
	for (i=0;i<`N;i=i+1)begin:RCA_1
		FA (.A(A[i]),.B(B[i]),.Cin(q[i]),.Sum(Sum[i]),.Car(q[i+1]));
	end
	endgenerate 
	assign Car=q[`N];
endmodule

`default_nettype wire
