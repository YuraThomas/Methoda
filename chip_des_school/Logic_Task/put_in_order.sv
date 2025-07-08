module put_in_order
#(
	parameter width = 16,
	parameter n_inputs = 4) (
	input logic [ n_inputs - 1 : 0 ][ width - 1 : 0 ] up_data,
	input [n_inputs-1:0] up_vlds,
	
	input clk,
	
	output [width-1:0] down_data,
	output down_vld
);

integer i;
logic [n_inputs-1 : 0] done;
logic [n_inputs-1:0][width-1:0] up_data_buf;
logic [n_inputs-1:0][width-1:0] in_data_buf;

always @(posedge clk) begin
	up_data_buf <= in_data_buf;
end

always_comb begin
	for (i = 0; i<n_inputs; i++) begin
		if (up_vlds[i]) begin 
			in_data_buf[i] = up_data[i];
		end
		
		else in_data_buf[i] = 1'd0;
	end
end


typedef enum { 
	WAIT_VLD_STATE_FSM,
	NEXT_DATA_FSM
} fsm_state;

fsm_state state = WAIT_VLD_STATE_FSM;
fsm_state next_state;
logic [31:0] num = 32'd0;

//обработчик состояний
assign down_data = up_data_buf[num];

always @(*) begin
	next_state = state;
	//down_data = {width {1'd0}};
	case(state)
		WAIT_VLD_STATE_FSM : if (up_vlds[num] == 1'd1) next_state = NEXT_DATA_FSM;
		
		NEXT_DATA_FSM : begin
			
			if (num == (n_inputs-1)) begin 
				next_state = WAIT_VLD_STATE_FSM;
			end
				
			else begin 
				if (~up_vlds [(num + 1)]) next_state = WAIT_VLD_STATE_FSM;
			end
			
		end
		
	endcase

end

//обработчик num
always @(posedge clk) begin
	if (state == NEXT_DATA_FSM) begin 
		if (num == (n_inputs-1)) begin 
			num <= 32'd0;
		end
				
		else begin 
			num <= num + 32'd1;
		end
	end
	
	else num <= num;
end
always @(posedge clk) begin
	state <= next_state;
end

assign down_vld = (state == NEXT_DATA_FSM);
endmodule
