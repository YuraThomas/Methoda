module comp_menshe (
	input [31:0] A,
	input [31:0] B,
	output out
);

wire [31:0] S;
assign S = A-B;
assign out = (A[31] & ~B[31]) | (~A[31] & ~B[31] & S[31]) | (A[31] & B[31] & S[31]);

endmodule
