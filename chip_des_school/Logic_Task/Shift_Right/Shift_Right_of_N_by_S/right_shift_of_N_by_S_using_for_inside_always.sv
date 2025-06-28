module right_shift_of_N_by_S_using_for_inside_always
# (parameter N = 8, S = 3)
(input  [N - 1:0] a, output logic [N - 1:0] res);

  // Task:
  //
  // Implement a parameterized module
  // that shifts the unsigned input by S bits to the right
  // using "for" inside "always_comb"
always_comb begin
	for (int i = 0; i < (N - 1); i ++)
      res [i] = i > (N-1-S) ? 1'b0 : a [i + S];


end
endmodule