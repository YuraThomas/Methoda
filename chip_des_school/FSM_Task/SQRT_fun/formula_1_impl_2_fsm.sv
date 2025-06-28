module formula_1_impl_2_fsm
(
    input               clk,
    input               rst,

    input               arg_vld,
    input        [31:0] a,
    input        [31:0] b,
    input        [31:0] c,

    output logic        res_vld,
    output logic [31:0] res


);

logic [31:0] data;

typedef enum { 
		CALK_1_SQRT_ONE_FSM,
		CALK_1_SQRT_TWO_FSM,
		CALK_2_FSM,
		NO_CALK_FSM}
		state_fsm_type;
	

state_fsm_type state;
state_fsm_type next_state;

always @(*) begin
	next_state = state;
	case (state)
		NO_CALK_FSM : 
			if (arg_vld) next_state = CALK_2_FSM;	
		CALK_2_FSM : 
			begin
				if (done_1) next_state = CALK_1_SQRT_ONE_FSM;
				else if (done_2) next_state = CALK_1_SQRT_TWO_FSM;
			end
		CALK_1_SQRT_ONE_FSM :
			if (done_1) next_state = NO_CALK_FSM;
		CALK_1_SQRT_TWO_FSM :		
			if (done_2) next_state = NO_CALK_FSM;
	endcase

end

always @(posedge clk) begin
	res <= data;
	
	if (state == NO_CALK_FSM) begin 
		data <= 32'd0;
		do_1 <= 1'd0;
		do_2 <= 1'd0;
	end
	
	if (state == CALK_2_FSM) begin 
			if (done_1) begin
				data <= data + {16'd0, output_data_sqrt_1};
			end
			else if (done_2) begin
				data <= data + {16'd0, output_data_sqrt_2};
			end
			do_1 <= 1'd1;
			do_2 <= 1'd1;
			input_data_sqrt_1 <= a;
			input_data_sqrt_2 <= b;
	end
	
	if (state == CALK_1_SQRT_ONE_FSM) begin
			if (done_2) begin
				data <= data + {16'd0, output_data_sqrt_2};
				do_2 <= 1'd0;
			end
			do_1 <= 1'd1;
			input_data_sqrt_1 <= c;
	end
	if (state == CALK_1_SQRT_TWO_FSM) begin
			if (done_1) begin
				data <= data + {16'd0, output_data_sqrt_1};
				do_1 <= 1'd0;
			end
		
			if (done_2) begin 
				data <= data + {16'd0, output_data_sqrt_2};
			end
			do_2 <= 1'd1;
			input_data_sqrt_2 <= c;
	end
	
	

end

always @(posedge clk) begin
	if (rst) state <= NO_CALK_FSM;
	else state <= next_state;

end

logic do_1;
logic [31:0] input_data_sqrt_1;
logic done_1;
logic [15:0] output_data_sqrt_1;

logic do_2;
logic [31:0] input_data_sqrt_2;
logic done_2;
logic [15:0] output_data_sqrt_2;

assign res_vld = (state == NO_CALK_FSM);

isqrt SQRT_1 (
    .x_vld (do_1),
    .x (input_data_sqrt_1),
    .y_vld (done_1),
    .y (output_data_sqrt_1),
	 .clk (clk),
	 .rst (rst)
);

isqrt SQRT_2 (
    .x_vld (do_2),
    .x (input_data_sqrt_2),
    .y_vld (done_2),
    .y (output_data_sqrt_2),
	 .clk (clk),
	 .rst (rst)
);






endmodule
