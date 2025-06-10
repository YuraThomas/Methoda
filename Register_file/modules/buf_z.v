module buf_z (
	input [3:0] in,
	input [3:0] upr,
	output out
);

assign out = (upr [0] == 1) ? in [0] : 1'bz;
assign out = (upr [1] == 1) ? in [1] : 1'bz;
assign out = (upr [2] == 1) ? in [2] : 1'bz;
assign out = (upr [3] == 1) ? in [3] : 1'bz;

endmodule
	