`timescale 1ns/1ps

module HA(input A,B, output Sum,Car);
	assign Sum = A^B;
	assign Car = A&B;
endmodule