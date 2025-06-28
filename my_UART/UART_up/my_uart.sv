module my_uart (

         input        rst_tx_i,
	 
	 input        valid_tx_i,
	 input [7:0]  data_for_tx_i,
	 
	 input        clk_i,
	 
	 input        rst_rx_i,
	 input        data_rx_i,
	 
	 output       data_tx_o,
	 output       ready_tx_o,
	 
	 output       ready_rx_o,
	 output [7:0] data_from_rx_o
);

my_uart_tx
#(.NUM_CLK(5208)) tx (
   .clk_i(clk_i),
	.rst_i(rst_tx_i),
	.data_i(data_for_tx_i),
	.valid_i(valid_tx_i),
	.ready_o(ready_tx_o),
	.tx_o(data_tx_o)
);

my_uart_rx
#(.NUM_CLK(5208)) rx (
   .clk_i(clk_i),
	.rst_i(rst_rx_i),
   .data_i(data_rx_i),
	.ready_o (ready_rx_o),
	.rx_o(data_from_rx_o)
);

endmodule
