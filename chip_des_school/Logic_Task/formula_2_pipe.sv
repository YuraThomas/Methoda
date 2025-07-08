module formula_2_pipe
#(parameter N = 16) (
	input arg_vld,
	input [31:0] a,
	input [31:0] b,
	input [31:0] c,
	input rst,
	input clk,
	output [31:0] res,
	output res_vld
);
logic vld;
assign vld = arg_vld;
logic [31:0] output_shreg_n;
logic [31:0] output_shreg_2n_plus_1;
logic arg_vld_n;
logic arg_vld_2n_plus_1;



logic [15:0] res_16;
assign res = {16'd0, res_16};

logic [15:0] output_data_sqrt_1_16;
logic [15:0] output_data_sqrt_2_16;

logic done_1;
logic [31:0] output_data_sqrt_1;

logic done_2;
logic [31:0] output_data_sqrt_2;

logic [31:0] out_trig;
logic out_vld_trig;
logic [31:0] in_sqrt_3;
logic vld_sqrt_3;

assign output_data_sqrt_1 =  {16'd0, output_data_sqrt_1_16};
assign output_data_sqrt_2 =  {16'd0, output_data_sqrt_2_16};


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

shift_register_with_valid
 #(.depth(N)) SHREG_N (
	.data_i (b),
	.vld_i(vld),
	.clk_i(clk),
	.rst_i (rst),
	.vld_o (arg_vld_n),
	.data_o(output_shreg_n)
);

shift_register_with_valid
 #(.depth(2*N+1)) SHREG_2N_PLUS_ONE (
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
    .y (output_data_sqrt_1_16),
	 .clk (clk),
	 .rst (rst)
);

isqrt SQRT_2 (
    .x_vld (out_vld_trig),
    .x (out_trig),
    .y_vld (done_2),
    .y (output_data_sqrt_2_16),
	 .clk (clk),
	 .rst (rst)
);

isqrt SQRT_3 (
    .x_vld (vld_sqrt_3),
    .x (in_sqrt_3),
    .y_vld (res_vld),
    .y (res_16),
	 .clk (clk),
	 .rst (rst)
);


endmodule
