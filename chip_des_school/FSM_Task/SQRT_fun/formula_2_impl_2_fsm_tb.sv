module formula_2_impl_2_fsm_tb;

logic [31:0] a;
logic [31:0] b;
logic [31:0] c;
logic clk;
logic rst;
logic arg_vld;
logic res_vld;
logic [31:0] res;

initial begin
	#100000 $finish ;
end
  
initial begin
	clk <= 1'd0;
	forever
     # 500 clk <= ~ clk;
end

initial begin
	rst = 1'd1;
	#1000 @(posedge clk) rst = 1'd0;
	@ (posedge clk)
	c = 32'd16;
	b = 32'd5;
	a = 32'd78;
	arg_vld = 1'd1;
	if (res_vld) begin
		arg_vld = 1'd0;
		#1000 @(posedge clk)
		c = 32'd9;
	   b = 32'd13;
	   a = 32'd96;
		arg_vld = 1'd0;
	end
end

formula_2_impl_2_fsm SQRT_1
(
    .clk(clk),
    .rst(rst),
    .arg_vld(arg_vld),
    .a(a),
    .b(b),
    .c(c),
    .res_vld(res_vld),
    .res(res)
);
endmodule