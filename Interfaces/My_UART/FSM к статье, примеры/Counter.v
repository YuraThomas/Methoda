module Counter (
    input in,
    input clk,
    output [1:0] out
);

reg [1:0] state;
reg [1:0] next_state;
assign out = state;
initial state = S0;

localparam S0 = 2'd0,
			  S1 = 2'd1,
			  S2 = 2'd2;

always @(*) begin
	case(state)
		S0: next_state = (in) ? S1 : S0;
		S1: next_state = (in) ? S2 : S1;
		S2: next_state = (in) ? S0 : S2;
		default: next_state = S0;
	endcase
end

always @(posedge clk) begin
	state <= next_state;
end

endmodule
