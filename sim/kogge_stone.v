`include "params.vh"
`timescale 1ns/1ps

module kogge_stone(input wire [`N-1:0]A,B,
						 input wire Cin,
						 output wire [`N-1:0] Sum,
						 output wire Cout);
	localparam Stage=$clog2(`N);
	
	wire [`N:0] C;
	assign C[0] = Cin;
	
	
	wire [`N-1:0] P[0:Stage];
	wire [`N-1:0] G[0:Stage];
	genvar i,k;
	
	//Bitlevel P and G
	
	assign P[0] = A ^ B;
	assign G[0] = A & B;
	
	//group G and P
	generate
	for(k = 0; k < Stage; k = k + 1) begin:stagen
		for(i = 0; i < `N; i = i + 1) begin:prefix
			if (i >= (1 << k)) begin
				assign G[k+1][i] = G[k][i] | (P[k][i] & G[k][i - (1 << k)]);
				assign P[k+1][i] = P[k][i] & P[k][i - (1 << k)];
			end
			else begin
			assign G[k+1][i] = G[k][i];
			assign P[k+1][i] = P[k][i];
			end
        end
	end
	endgenerate
	
	//Carry

	generate
	for(i = 0; i < `N; i = i + 1)begin:carry1
		assign C[i+1] = G[Stage][i] | (P[Stage][i] & C[0]);
	end
	endgenerate
	
	//Sum
	generate 
	for(i = 0; i < `N; i = i + 1) begin:sum1
		assign Sum[i] = P[0][i] ^ C[i]; 
	end
	endgenerate
	assign Cout = C[`N];
	
endmodule						 