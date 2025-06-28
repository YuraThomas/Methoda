module my_uart_rx
#(parameter NUM_CLK = 3) (
    input        clk_i,
    input        rst_i,
	
    input        rx_i,
	
    output       ready_o,
    output [7:0] data_o
);

reg control_start_rx;
localparam NUM_BIT_COUNT = $clog2 (NUM_CLK);
localparam HALF_BIT_COUNT = NUM_BIT_COUNT/2; 
reg [NUM_BIT_COUNT - 1 : 0] cnt_baud;
reg [8:0] data = 9'd0;   
wire baud;
assign baud = (cnt_baud == NUM_CLK-1);

always @(posedge clk_i) begin
	if (rst_i) cnt_baud <= {NUM_BIT_COUNT{1'd0}};
	else begin
		if (baud) cnt_baud <= {NUM_BIT_COUNT{1'd0}};
		else cnt_baud <= cnt_baud + 1;
		
		case (state)
			INITIAL_STATE_FSM : begin
			cnt_baud <= {NUM_BIT_COUNT{1'd0}};
			control_start_rx <= 1'd1;
			end
			
			CONTROL_INPUT_STATE_FSM : begin
				if( cnt_baud == HALF_BIT_COUNT-1) begin
					control_start_rx <= rx_i;
					cnt_baud <= {NUM_BIT_COUNT{1'd0}};
				end
		
				else cnt_baud <= cnt_baud + 1;
			end
		endcase
	end
end
	
state_FSM state;
state_FSM next_state;
typedef enum { 
    INITIAL_STATE_FSM,
    CONTROL_INPUT_STATE_FSM,
    RECIEVE_DATA_FSM} state_FSM;


always @(*) begin
	next_state = state;
	case (state)
		CONTROL_INPUT_STATE_FSM : begin
			if (~control_start_rx) next_state = RECIEVE_DATA_FSM;
			else next_state = INITIAL_STATE_FSM;
		end
		
		INITIAL_STATE_FSM: if (~rx_i) next_state = CONTROL_INPUT_STATE_FSM;
		RECIEVE_DATA_FSM : if (data [8] == 1'd1) next_state = INITIAL_STATE_FSM;
	endcase
end
 
always @(posedge clk_i) begin
	if (rst_i) data <= 9'd0;
	else begin
		if (INITIAL_STATE_FSM ) data <= 9'd0;
		if (state == RECIEVE_DATA_FSM && baud) data <= {data [7:0], rx_i};
	end
end

always @(posedge clk_i) begin
	if (rst_i) state <= INITIAL_STATE_FSM;
	else state <= next_state;
end


assign data_o = data [7:0];
assign ready_o = (state == INITIAL_STATE_FSM);

endmodule
