module ALU_dragon(
	input [4:0] Upr_ALU,
	input [31:0] A,
	input [31:0] B,
	output C,
	output [31:0] Out_ALU
);

ALU_3 ALU(
	.Upr_ALU(Upr_ALU),
	.A(A),
	.B(B),
	.C(C),
	.Out_ALU(Out_ALU)
);

endmodule