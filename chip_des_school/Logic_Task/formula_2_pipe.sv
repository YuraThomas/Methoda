module formula_2_pipe (
	input vld,
	input a,
	input b,
	input c,
	input rst,
	input clk,
	output [31:0] res,
	output res_vld
);

logic [31:0] output_shreg_n;
logic [31:0] output_shreg_2n_plus_1;
logic arg_vld_n;
logic arg_vld_2n_plus_1;

logic done_1;
logic [31:0] output_data_sqrt_1;

logic done_2;
logic [31:0] output_data_sqrt_2;

logic [31:0] sum;
logic [31:0] out_trig;
logic out_vld_trig;
logic [31:0] in_sqrt_3;
logic vld_sqrt_3;
logic done_3;

always @(posedge clk) begin
	if (rst) vld_sqrt_3 <= 1'd0;
	else vld_sqrt_3 <= done_2;
end

always @(posedge clk) begin
	if (done_2) in_sqrt_3 <= output_data_sqrt_2 + output_shreg_2n_plus_1;
	else in_sqrt_3 = 32'd0;
end

always @(posedge clk) begin
	if (done_1) out_trig <= output_data_sqrt_1 + output_shreg_n;
	else out_trig <= out_trig;
end

always @(posedge clk) begin
	out_vld_trig <= done_1;
end

modern_shift_reg
 #(.N(16)) SHREG_N (
	.data_i (b),
	.vld_i(vld),
	.clk_i(clk),
	.rst_i (rst),
	.vld_o (arg_vld_n),
	.data_o(output_shreg_n)
);

modern_shift_reg
 #(.N(32)) SHREG_2N_PLUS_ONE (
	.data_i (a),
	.vld_i(vld),
	.clk_i(clk),
	.rst_i (rst),
	.vld_o (arg_vld_2n_plus_1),
	.data_o(output_shreg_2n_plus_1)
);

isqrt SQRT_1 (
    .x_vld (vld),
    .x (c),
    .y_vld (done_1),
    .y (output_data_sqrt_1),
	 .clk (clk),
	 .rst (rst)
);

isqrt SQRT_2 (
    .x_vld (out_vld_trig),
    .x (out_trig),
    .y_vld (done_2),
    .y (output_data_sqrt_2),
	 .clk (clk),
	 .rst (rst)
);

isqrt SQRT_3 (
    .x_vld (vld_sqrt_3),
    .x (in_sqrt_3),
    .y_vld (res_vld),
    .y (res),
	 .clk (clk),
	 .rst (rst)
);


endmodule