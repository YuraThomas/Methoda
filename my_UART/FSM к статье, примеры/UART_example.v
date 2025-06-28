module UART_example (
	input clk,
	input [7:0] data_T,
	input start,
	output [7:0] data_R
);

my_UART UART_T (
	.data(data_T),
	.start(start),
	.clk (clk),
	.out(out_T)
);

my_UART_RX UART_R (
	.data_in(out_T),
	.clk(clk),
	.out(data_R)
);

wire out_T;


endmodule
