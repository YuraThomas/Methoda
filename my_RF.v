module my_RF (
	input [1:0] upr_1,
	input [1:0] upr_2,
	input clk,
	input [1:0] upr_in,
	input data,
	input WE,
	output out_1,
	output out_2
);

wire [3:0] out_dx_in;
wire [3:0] out_dx_1;
wire [3:0] out_dx_2;
wire [3:0] out_dx_upr_buf_1;
wire [3:0] out_dx_upr_buf_2;
wire [3:0] in_buf;


buf_z buf_out_1(
	.in(in_buf),
	.upr(out_dx_1),
	.out(out_1)
);

buf_z buf_out_2(
	.in(in_buf),
	.upr(out_dx_2),
	.out(out_2)
);

DX_2_en DX_in (
	.a(upr_in),
	.enable(WE),
	.b(out_dx_in)
);

DX2 DX_out_1 (
	.a_0(upr_1[0]),
	.a_1(upr_1[1]),
	.b_0(out_dx_1[0]),
	.b_1(out_dx_1[1]),
	.b_2(out_dx_1[2]),
	.b_3(out_dx_1[3])
);

DX2 DX_out_2 (
	.a_0(upr_2[0]),
	.a_1(upr_2[1]),
	.b_0(out_dx_2[0]),
	.b_1(out_dx_2[1]),
	.b_2(out_dx_2[2]),
	.b_3(out_dx_2[3])
);

D_trig_s_en D_0(
	.data(data),
	.Load(out_dx_in[0]),
	.clk(clk),
	.out(in_buf[0])
);

D_trig_s_en D_1(
	.data(data),
	.Load(out_dx_in[1]),
	.clk(clk),
	.out(in_buf[1])
);

D_trig_s_en D_2(
	.data(data),
	.Load(out_dx_in[2]),
	.clk(clk),
	.out(in_buf[2])
);

D_trig_s_en D_3(
	.data(data),
	.Load(out_dx_in[3]),
	.clk(clk),
	.out(in_buf[3])
);

endmodule