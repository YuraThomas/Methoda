module delimost_na_5 (
	input a_i,
	input clk_i,
	input rst_i,
	output div_by_5_o
);

typedef enum {
      STATE_0_FSM,
		STATE_1_FSM,
		STATE_2_FSM,
		STATE_3_FSM,
		STATE_4_FSM
		} state_fsm;

state_fsm state;
state_fsm next_state;

always @(*) begin
	case (state)
		STATE_0_FSM : next_state = (a_i) ? STATE_1_FSM : STATE_0_FSM;
		STATE_1_FSM : next_state = (a_i) ? STATE_3_FSM : STATE_2_FSM;
		STATE_2_FSM : next_state = (a_i) ? STATE_0_FSM : STATE_4_FSM;
		STATE_3_FSM : next_state = (a_i) ? STATE_2_FSM : STATE_1_FSM;
		STATE_4_FSM : next_state = (a_i) ? STATE_4_FSM : STATE_3_FSM;
	endcase
end



always @(posedge clk_i) begin
	if (rst_i) state <= STATE_0_FSM;
	else state <= next_state;
end

assign div_by_5_o = (state == STATE_0_FSM);

endmodule
