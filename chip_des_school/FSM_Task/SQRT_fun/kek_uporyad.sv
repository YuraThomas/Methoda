module kek_uporyad (
	input [31:0] up_data_0,
	input [31:0] up_data_1,
	input [31:0] up_data_2,
	input [31:0] up_data_3,
	
	input [3:0] up_vlds,
	input [3:0] vld_modules,
	
	input clk,
	
	output [31:0] down_data,
	output down_vld
);


typedef enum {
	WAIT_FSM,
	OUT_0_FSM,
	OUT_1_FSM,
	OUT_2_FSM,
	OUT_3_FSM
} fsm_state;

fsm_state state;
fsm_state next_state;

always_comb begin
	down_vld = 1'd0;
	next_state = state;
	down_data = 32'd0;
	case (state)
		WAIT_FSM : begin 
			if (up_vlds[0]) begin
				next_state = OUT_0_FSM;
				down_vld = 1'd1;
				down_data = up_data_0;
			end
			
		end
		
		OUT_0_FSM : begin 
			if (up_vlds[1]) begin
				next_state = OUT_1_FSM;
				down_vld = 1'd1;
				down_data = up_data_1;
			end
			
		end
		
		OUT_1_FSM : begin 
			if (up_vlds[2]) begin
				next_state = OUT_2_FSM;
				down_vld = 1'd1;
				down_data = up_data_2;
			end
			
		end
		
		OUT_2_FSM : begin 
			if (up_vlds[3]) begin
				next_state = OUT_3_FSM;
				down_vld = 1'd1;
				down_data = up_data_3;
			end
			
		end
		
		OUT_3_FSM : begin 
				next_state = WAIT_FSM;
				down_vld = 1'd0;
				down_data = 32'd0;
			
		end
	endcase
end

always @(posedge clk) begin
	state <= next_state;
end

endmodule