module detect_start_end (
	input  rst,
	input  sda,
	input  clk,
	input  scl,
	
	input  enable,
	
	output detected_start,
	output detected_end
	
);

logic detect_pos_sda;
logic detect_neg_sda;


always_ff @(posedge clk) begin
	if (rst) begin 
		detected_start <= 1'd0;
		detected_end   <= 1'd0;
	end
	
	else begin
		if (enable) begin
			if (detected_end && scl)   detected_end   <= detected_end;
			else                       detected_end   <= detect_pos_sda && scl;
			
			if (detected_start && scl) detected_start <= detected_start;	
			else                       detected_start <= detect_neg_sda && scl;
			
		end
		
		else begin 
			detected_start <= 1'd0;
			detected_end   <= 1'd0;
		end
	end
end


detect_pos_neg_signal detector_sda (
	.clk(clk),
	.signal(sda),
	.enable(enable),
	.rst(rst),
	.detected_pos(detect_pos_sda),
	.detected_neg(detect_neg_sda)
);


endmodule

