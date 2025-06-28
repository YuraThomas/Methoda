module signed_add_with_saturation
(
  input  [3:0] a, b,
  output [3:0] sum,
  output       sat
);

assign sum = a + b;
assign sat = (a[3] & b[3] & ~sum[3]) | (~a[3] & ~b[3] & sum[3]);

endmodule
