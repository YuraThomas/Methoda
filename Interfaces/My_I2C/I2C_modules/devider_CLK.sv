module devider_CLK (
	input clk,
	output SCL
);

reg [8:0] num;

always_ff @(posedge clk) begin
	if (num[8]) num <= '0;
	else num <= num + 1;
end

assign SCL = num[4];
endmodule