module start_end_sda (
	input clk,
	input scl,
	input enable,
	output sda,
	input vivod,
	output end_clk
	
);

logic start_nya;
logic end_nya;
logic end_start;

assign end_clk = end_start;

always @(posedge clk) begin 
	if(enable) begin 
			if (~scl) begin
					start_nya <= 1'd1;
					if (end_nya) begin 
						end_start <= 1'd1;
					end
			end
			
			if (end_nya) begin 
					sda <= vivod;
			end
			
			else sda <= 1'dz;
			
			if (scl) begin
					if(start_nya) begin
						start_nya <= 1'd0;
						end_nya <= 1'd1;
					end			
			end
	end
	
	else begin
			start_nya <= 1'd0;
			end_nya <= 1'd0;
			end_start <= 1'd0;
	
	end
end
endmodule