module arithmetic_right_shift_of_N_by_S_using_concatenation
# (parameter N = 8, S = 3)
(input  [N - 1:0] a, output [N - 1:0] res);

  assign res = {{(N-S){a[N-1]}}, a[N-1:N-S-1]};


endmodule
