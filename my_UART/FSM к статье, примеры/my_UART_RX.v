module my_UART_RX (
	input data_in,
	input clk,
	output reg [7:0] out
);

localparam NUM_CLK = 13'd2;
reg [12:0] cnt = 13'd0;
reg per = 1'd0;
initial out = 8'd0;

always @(posedge clk) begin
	if (cnt == NUM_CLK) begin
		cnt <=13'd0;
		per <= 1'd1;
	end
	else begin
		cnt <= cnt + 13'd1;
		per <= 1'd0;
	end
end

reg [3:0] state = initial_state;
reg [3:0] next_state;
localparam
	initial_state = 4'd0,
	num_0 = 4'd1,
	num_1 = 4'd2,
	num_2 = 4'd3,
	num_3 = 4'd4,
	num_4 = 4'd5,
	num_5 = 4'd6,
	num_6 = 4'd7,
	num_7 = 4'd8,
	start_state = 4'd9;
	
always @(*) begin
	case (state)
		initial_state: next_state = (~data_in) ? start_state : initial_state;
		start_state : next_state = (per) ? num_0 : start_state;
		num_0 : next_state = (per) ? num_1 : num_0;
		num_1 : next_state = (per) ? num_2 : num_1;
		num_2 : next_state = (per) ? num_3 : num_2;
		num_3 : next_state = (per) ? num_4 : num_3;
		num_4 : next_state = (per) ? num_5 : num_4;
		num_5 : next_state = (per) ? num_6 : num_5;
		num_6 : next_state = (per) ? num_7 : num_6;
		num_7 : next_state = (per) ? initial_state : num_7;
		default : next_state = initial_state;
	endcase
	
	case (state)
		num_0 : out[0] = data_in;
		num_1 : out[1] = data_in;
		num_2 : out[2] = data_in;
		num_3 : out[3] = data_in;
		num_4 : out[4] = data_in;
		num_5 : out[5] = data_in;
		num_6 : out[6] = data_in;
		num_7 : out[7] = data_in;
		default : out = 8'd0;
	endcase
end

always @(posedge clk) begin
	state <= next_state;
end

endmodule
