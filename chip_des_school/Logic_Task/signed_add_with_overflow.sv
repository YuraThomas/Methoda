module signed_add_with_overflow
(
  input  [3:0] a, b,
  output [3:0] sum,
  output       overflow
);

wire per_plus = (~a[3] & ~b[3] & sum[3]);
wire per_minus = (a[3] & b[3] & ~sum[3]);

assign overflow = per_plus | per_minus;
assign sum = (per_plus) ? {1'd0, 3'd1} : 
				 (per_minus) ? {1'd1, 3'd0} : (a+b);


endmodule
