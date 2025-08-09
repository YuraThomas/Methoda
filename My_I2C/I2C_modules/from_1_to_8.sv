module from_1_to_8
#(parameter NUM = 8) (
	input data_i,
	input clk,
	input enable,
	input rst,
	output vld,
	output [NUM - 1:0] data_o
);

localparam count_razr = $clog2(NUM);

logic [NUM - 1 :0] data = '0;
assign data_o = data ;
logic vld_mem;

always_ff @(posedge clk) begin
	vld <= vld_mem;
	if (rst || ~enable) data <= '0;
	else begin 
		data <= {data [NUM - 2 :0], data_i};
	end
end

counter counter_for_num(
	.rst(rst),
	.enable(enable),
	.end_count(NUM-1),
	.clk(clk),
	.out_cnt(vld_mem),
	.num()
);


endmodule