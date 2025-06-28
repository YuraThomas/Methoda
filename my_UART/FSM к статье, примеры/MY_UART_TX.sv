module my_uart_tx
#(parameter NUM_CLK = 3,
 parameter RAZR_COUNT = 2) (
        input       clk_i,
	input [7:0] data_i,
	input       start_i,
	input       rst_i,
	output      ready_o,
	output      tx_o
);

reg [RAZR_COUNT-1:0] cnt = {RAZR_COUNT{1'd0}};
wire per;
assign per = (cnt == NUM_CLK-1);
assign ready_o = (state == INITIAL_STATE_FM);

reg [9:0] data = 10'd1023;
always @(posedge clk_i) begin

	if (rst_i) begin
		cnt <= {RAZR_COUNT{1'd0}};
	end
	
	else if (cnt == NUM_CLK-1) begin
		cnt <= {RAZR_COUNT{1'd0}};
	end
	
	else begin
		cnt <= cnt + 1;
	end
	
end

reg state = INITIAL_STATE_FM;
reg next_state;
localparam
	INITIAL_STATE_FM = 1'd0,
	TRANSMIT_DATA_FM = 1'd1;

always @(*) begin
	next_state = state;
	case (state)
		INITIAL_STATE_FM: if (start_i) next_state = TRANSMIT_DATA_FM;
		TRANSMIT_DATA_FM : if (data == 10'd1) next_state = INITIAL_STATE_FM;
	endcase
end
 
always @(posedge clk_i) begin
	if (start_i == 1'd1) data <= {1'd1, data_i, 1'd0};
	if (state == INITIAL_STATE_FM ) data <= 10'd1;
	if (state == TRANSMIT_DATA_FM && per) data <= {1'd0, data [9:1] };
end

always @(posedge clk_i) begin
	state <= next_state;
end


assign tx_o = data[0];

endmodule
