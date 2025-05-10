module DX_2_en (
	input [1:0] a,
	input enable,
	output [3:0] b
);

assign b[0] = ~a[0] & ~a[1] & enable;
assign b[1] = a[0] & ~a[1] & enable;
assign b[2] = ~a[0] & a[1] & enable;
assign b[3] = a[0] & a[1] & enable;

endmodule
