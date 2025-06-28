module formula_1_impl_2_fsm_tb;
  logic clk;
  initial begin
     #100000 $finish ;
  end
  
	initial begin
		clk <= 1'd0;
		forever
      # 500 clk <= ~ clk;
	end

logic rst;
logic res_vld;
logic [31:0] a;
logic [31:0] b;
logic [31:0] c;
logic [31:0] result;
logic arg_vld;

  initial begin
	 rst = 1'd1;
	 #700 @(posedge clk) rst = 1'd0;
	 @(posedge clk);
	 arg_vld = 1'd1;
         a = 32'd1;
	 b = 32'd4;
	 c = 32'd9;
  end

  
formula_1_impl_2_fsm tst_FSM
(
    .clk(clk),
    .rst(rst),
    .arg_vld(arg_vld),
    .a(a),
    .b(b),
    .c(c),
    .res_vld (res_vld),
    .res(result)

);

endmodule
 
