module formula_2_impl_2_fsm
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
assign res = data;
logic do_1;
logic [31:0] input_data_sqrt_1;
logic done_1;
logic [15:0] output_data_sqrt_1;

typedef enum { 
		SUM_1_FSM,
		SUM_2_FSM,
		SUM_3_FSM,
		NO_CALK_FSM}
		state_fsm_type;
	

state_fsm_type state;
state_fsm_type next_state;

always @(*) begin
	next_state = state;
	case (state)
		NO_CALK_FSM : 
			if (arg_vld) next_state = SUM_1_FSM;	
		SUM_1_FSM : 
				if (done_1) next_state = SUM_2_FSM;
		SUM_2_FSM : 
				if (done_1) next_state = SUM_3_FSM;
		SUM_3_FSM :
			if (done_1) next_state = NO_CALK_FSM;
	endcase

end

always @(*) begin
	res_vld = 1'd0;
	case (state)
		NO_CALK_FSM : begin
				input_data_sqrt_1 = c;
				do_1 = 1'd0;
				if (arg_vld) begin
					data = 32'd0;	
					do_1 = 1'd1;
				end
		end
		
		SUM_1_FSM : begin
				do_1 = 1'd0;
				if (done_1) begin
					data = {16'd0, output_data_sqrt_1};
					input_data_sqrt_1 = b + data;
					do_1 = 1'd1;
				end
		end
		
		SUM_2_FSM : begin
				do_1 = 1'd0;
				if (done_1) begin
					data = {16'd0, output_data_sqrt_1};
					input_data_sqrt_1 = a + data;
					do_1 = 1'd1;
				end
		end
		
		SUM_3_FSM : begin
			do_1 = 1'd0;
				if (done_1) begin 
					res_vld = 1'd1;
					data = {16'd0, output_data_sqrt_1};
				end
		end
	endcase

end

always @(posedge clk) begin
	if (rst) state <= NO_CALK_FSM;
	else state <= next_state;

end

isqrt SQRT_1 (
    .x_vld (do_1),
    .x (input_data_sqrt_1),
    .y_vld (done_1),
    .y (output_data_sqrt_1),
	 .clk (clk),
	 .rst (rst)
);

endmodule