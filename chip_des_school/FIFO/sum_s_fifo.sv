module sum_s_fifo (
	input A_time_module,
	input B_time_module,
	input clk,
	input rst,
	input done_A,//через регистр подаем
	input done_B,//через регистр подаем
	input read_sum,
	output S_fifo,
	output full_A,
	output full_B,
	output full_S,
	output empty_A,
	output empty_B,
	output empty_S
	
);

wire done_all = done_A & done_B;


logic [31:0] sum_in_fifo_A;
logic [31:0] sum_in_fifo_B;
logic [31:0] sum_A_B;

always_comb begin
	if (done_all) sum_A_B = sum_in_fifo_A + sum_in_fifo_B;
	else sum_A_B = '0;
end

my_fifo #(.width (32), .depth(1)
) fifo_A (
    .clk(clk),
    .rst(rst),
    .push (done_A),
    .pop (done_all),
    .write_data (A_time_module),
    .read_data (sum_in_fifo_A),
    .empty (empty_A),
    .full(full_A)
);

my_fifo #(.width (32), .depth(1)
) fifo_B (
    .clk(clk),
    .rst(rst),
    .push (done_B),
    .pop (done_all),
    .write_data (B_time_module),
    .read_data (sum_in_fifo_B),
    .empty (empty_B),
    .full(full_B)
);

my_fifo #(.width (32), .depth(1)
) fifo_sum (
    .clk(clk),
    .rst(rst),
    .push (done_all),
    .pop (read_sum),
    .write_data (sum_A_B),
    .read_data (S_fifo),
    .empty (empty_S),
    .full(full_S)
);

endmodule