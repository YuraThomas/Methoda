module or_32_b (
	input [31:0] A,
	input [31:0] B,
	output [31:0] out_or

);

assign out_or = A | B;
endmodule
