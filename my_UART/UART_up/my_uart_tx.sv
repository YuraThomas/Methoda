module my_uart_tx
#(parameter NUM_CLK = 3) (
        input       clk_i,
	input       rst_i,
	
	input [7:0] data_i,
	input       valid_i,
	
	output      ready_o,
	output      tx_o
);


localparam NUM_BIT_COUNT = $clog2 (NUM_CLK);
reg [NUM_BIT_COUNT - 1 : 0] cnt_baud;
reg [9:0] data; 
wire baud;
assign baud = (cnt_baud == NUM_CLK-1);  

always @(posedge clk_i) begin
	if (rst_i) cnt_baud <= {NUM_BIT_COUNT{1'd0}};
	else if (baud) cnt_baud <= {NUM_BIT_COUNT{1'd0}};
	else cnt_baud <= cnt_baud + 1;	
end

state_FSM state;
state_FSM next_state;
typedef enum  {
    INITIAL_STATE_FSM,
    TRANSMIT_DATA_FSM} state_FSM;


always @(*) begin
	next_state = state;
	case (state)
		INITIAL_STATE_FSM: if (valid_i) next_state = TRANSMIT_DATA_FSM;
		TRANSMIT_DATA_FSM : if (data == 10'd1) next_state = INITIAL_STATE_FSM;
	endcase
end
 
always @(posedge clk_i) begin
	if (rst_i) begin
		data  <= 10'd1;
	end
	if ((TRANSMIT_DATA_FSM) && baud) data <= {1'd0, data [9:1] };
	if (valid_i && (state == INITIAL_STATE_FSM)) data <= {1'd1, data_i, 1'd0};
end


always @(posedge clk_i) begin
	if (rst_i) state <= INITIAL_STATE_FSM;
	else state <= next_state;
end


assign tx_o = data[0] | ready_o;
assign ready_o = (state == INITIAL_STATE_FSM);

endmodule
