module detect_pos_neg_signal(
	input signal,
	input clk,
	input rst,
	input enable,
	output detected_pos,
	output detected_neg
);

localparam DETECTED_0_STATE = 1'd0,
			  DETECTED_1_STATE = 1'd1;
			  
logic state;
logic next_state;

always_comb begin
	next_state = state;
	case(state)
		DETECTED_0_STATE : if (signal) next_state  = DETECTED_1_STATE;
		DETECTED_1_STATE : if (~signal) next_state = DETECTED_0_STATE;
	endcase
end

assign detected_pos = ((state == DETECTED_0_STATE) && (next_state == DETECTED_1_STATE));
assign detected_neg = ((state == DETECTED_1_STATE) && (next_state == DETECTED_0_STATE));


always_ff @(posedge clk) begin
	state <= next_state;
end

endmodule