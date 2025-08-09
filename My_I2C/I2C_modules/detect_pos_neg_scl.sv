module detect_pos_neg_scl (
	input clk,
	input scl,
	input enable,
	input rst,
	output detect_pos_scl,
	output detect_neg_scl
);

logic detect_0_scl;

logic detect_1_scl;

always @(posedge clk) begin
	if (rst || ~enable ) begin
		detect_0_scl <= 1'd0;
		detect_1_scl <= 1'd0;
		
		detect_pos_scl <= 1'd0;
		detect_neg_scl <= 1'd0;
	end
	
	else begin
		if (~scl) detect_0_scl <= 1'd1;
		if (scl && detect_0_scl) detect_pos_scl <= 1'd1;
		
		if (scl) detect_1_scl <= 1'd1;
		if (~scl && detect_1_scl) detect_neg_scl <= 1'd1;
		
		
	end
end

endmodule