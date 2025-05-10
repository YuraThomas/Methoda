module ALU_1 (
	input [1:0] Upr_ALU,
	input [31:0] A,
	input [31:0] B,
	output [31:0] Out_ALU
);

wire [31:0] or_mux;
wire [31:0] and_mux;

assign Out_ALU = (Upr_ALU == 2'd0) ? 32'b0:
					  (Upr_ALU == 2'd1) ? 32'b1:
					  (Upr_ALU == 2'd2) ? or_mux: and_mux;
					  
or_32_b or_ALU (
	.A(A),
	.B(B),
	.out_or(or_mux)

);

and_32_b and_ALU (
	.A(A),
	.B(B),
	.out_and(and_mux)
);
						
endmodule