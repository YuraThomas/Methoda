module right_shift_of_N_by_S_using_right_shift_operation
# (parameter N = 8, S = 3)
(input  [N - 1:0] a, output [N - 1:0] res);

  // Task:
  //
  // Implement a parameterized module
  // that shifts the unsigned input by S bits to the right
  // using logical right shift operation
  assign res = a >> S;


endmodule