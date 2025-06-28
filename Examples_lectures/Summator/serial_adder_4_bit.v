module serial_adder_4_bit (
	input [3:0] A,
	input [3:0] B,
	output [4:0] SUM,
	output overflow
);

wire [3:0] carry;

basic_sum SUM_0(
	.a_n(A[0]),
	.b_n(B[0]),
	.carry_in(1'd0),
	.carry_out(carry[0]),
	.sum_n(SUM[0])
);

basic_sum SUM_1 (
	.a_n(A[1]),
	.b_n(B[1]),
	.carry_in(carry[0]),
	.carry_out (carry [1]),
	.sum_n(SUM[1])
);

basic_sum SUM_2(
	.a_n(A[2]),
	.b_n(B[2]),
	.carry_in(carry[1]),
	.carry_out(carry[2]),
	.sum_n(SUM[2])
);

basic_sum SUM_3 (
	.a_n (A[3]),
	.b_n (B[3]),
	.carry_in(carry[2]),
	.carry_out(carry[3]),
	.sum_n(SUM[3])
);

assign SUM[4] = carry[3];

endmodule