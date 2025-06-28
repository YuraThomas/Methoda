module  UART_all (
	input clk,
	input data_in,
	input start_peredavat,
	input [7:0] nado_peredat,
	output [7:0] suda_peredat,
	output data_out	
);

my_UART_RX input_data (
	.data_in(data_in),
	.clk(clk),
	.out(suda_peredat)
);

my_UART output_data (
	.data(nado_peredat),
	.start(start_peredavat),
	.clk(clk),
	.out(data_out)
);

endmodule
