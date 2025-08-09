module counter (
	input rst,
	input enable,
	input [4:0] end_count,
	input clk,
	output out_cnt,
	output [4:0] num
);

logic [4:0] counter;

always @(negedge clk) begin
	if (rst || ~enable) counter <= '0;
	
	else begin
		if (counter == end_count) counter <= '0;
		else counter <= counter + 1;
	end


end

assign out_cnt = (counter == end_count);
assign num = counter;
endmodule
	