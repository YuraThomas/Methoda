module signed_or_unsigned_mul

(
  input  [7:0] a, b,
  input                signed_mul,
  output [15:0] res
);

wire [15:0] res_uns = a*b;
wire [15:0] res_sign;
wire [15:0] it_res;
assign res_sign = a[6:0] * b [6:0];
assign minus = ~a[7] & b[7] | a[7] & ~b[7];
assign it_res = (minus) ? (~res_sign + 1) : res_sign;


assign res = (signed_mul) ? it_res : res_uns;


endmodule
