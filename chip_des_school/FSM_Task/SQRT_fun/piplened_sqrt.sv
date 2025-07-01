module piplened_sqrt (
    input logic [31:0] a_i,
	 input logic [31:0] b_i,
	 input logic [31:0] c_i,
    input arg_vld_i,
    input clk_i,
    input rst_i,
    output logic [31:0] res_o,
    output logic res_vld_o
);

logic [31:0] memory;
assign res_o = memory;
assign res_vld_o = (done_1 && done_2 && done_3);

logic do_1;
logic done_1;
logic [15:0] output_data_sqrt_1;

logic do_2;
logic done_2;
logic [15:0] output_data_sqrt_2;


logic do_3;
logic done_3;
logic [15:0] output_data_sqrt_3;


typedef enum { 
    CALK_SQRT_FSM,
    NO_CALK_FSM
} state_fsm_type;

state_fsm_type state = NO_CALK_FSM;
state_fsm_type next_state;

always_comb begin
    next_state = state;
    case(state)
        NO_CALK_FSM: if (arg_vld_i) next_state = CALK_SQRT_FSM;
        CALK_SQRT_FSM: if (rst_i || res_vld_o) next_state = NO_CALK_FSM;
    endcase
end

always_comb begin
	  do_1 = 1'd0;
	  do_2 = 1'd0;
	  do_3 = 1'd0;
	  memory = 32'd0;
    case(state)
        NO_CALK_FSM: begin
            if (arg_vld_i) begin 
                do_1 = 1'd1;
					 do_2 = 1'd1;
					 do_3 = 1'd1;
					 memory = 32'd0;
            end
        end
        
        CALK_SQRT_FSM: begin
            
				if (done_1 && done_2 && done_3) begin
					memory = output_data_sqrt_1 + output_data_sqrt_2 + output_data_sqrt_3;
				end
        end
    endcase
end

always @(posedge clk_i) begin
	if(rst_i) begin
		state <= NO_CALK_FSM;
	end

	else begin
		state <= next_state;
	end
end

isqrt SQRT_1 (
    .x_vld (do_1),
    .x (a_i),
    .y_vld (done_1),
    .y (output_data_sqrt_1),
    .clk (clk_i),
    .rst (rst_i)
);

isqrt SQRT_2 (
    .x_vld (do_2),
    .x (b_i),
    .y_vld (done_2),
    .y (output_data_sqrt_2),
    .clk (clk_i),
    .rst (rst_i)
); 

isqrt SQRT_3 (
    .x_vld (do_3),
    .x (c_i),
    .y_vld (done_3),
    .y (output_data_sqrt_3),
    .clk (clk_i),
    .rst (rst_i)
); 


endmodule