module basic_sum (
	input a_n,
	input b_n,
	input carry_in,
	output carry_out,
	output sum_n
);

assign sum_n = a_n ^ b_n ^ carry_in;
assign carry_out = (a_n & b_n) | (a_n & carry_in) | (b_n & carry_in);

endmodule
	