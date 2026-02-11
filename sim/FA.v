`timescale 1ns/1ps

module FA(input A,B,Cin, output Sum,Car);
	assign Sum=A^B^Cin;
	assign Car=(A&Cin)|(A&B)|(B&Cin);
endmodule