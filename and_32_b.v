module and_32_b (
	input [31:0] A,
	input [31:0] B,
	output [31:0] out_and
);
assign out_and = A & B;

endmodule