module arithmetic_right_shift_of_N_by_S_using_for_inside_generate
# (parameter N = 8, S = 3)
(input  [N - 1:0] a, output [N - 1:0] res);

genvar i;

  generate
    for (i = 0; i < N; i++) begin : bus_gen
        assign res[i] = (i > (N-S-1)) ? a[N-1] : a [i + S];
    end
endgenerate


endmodule