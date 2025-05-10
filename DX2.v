module DX2(
	input a_0,
	input a_1,
	output b_0,
	output b_1,
	output b_2,
	output b_3
);

assign b_0 = ~a_0&~a_1;
assign b_1 = a_0&~a_1;
assign b_2 = ~a_0&a_1;
assign b_3 = a_0&a_1;

endmodule