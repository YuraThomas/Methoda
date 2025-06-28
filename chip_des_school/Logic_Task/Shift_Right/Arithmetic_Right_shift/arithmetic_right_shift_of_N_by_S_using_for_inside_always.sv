module arithmetic_right_shift_of_N_by_S_using_for_inside_always
# (parameter N = 8, S = 3)
(input  [N - 1:0] a, output logic [N - 1:0] res);

always_comb
	for (int i = 0, i = N - 1, i++)
		res[i] = (i > (N-S-1) ? a[N-1] : a[N-i];
  // Task:
  //
  // Implement a module with the logic for the arithmetic right shift,
  // but without using ">>>" operation, concatenations or bit slices.
  // You are allowed to use only "always_comb" with a "for" loop
  // that iterates through the individual bits of the input.


endmodule
