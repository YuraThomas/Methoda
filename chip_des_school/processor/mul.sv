module mul
(
input clk,
input rst,

input  [31:0] a,
input  [31:0] b,

input start,

output [31:0] res_mul,

output logic end_mul
);

wire znak;

logic [63:0] ab;

assign res_mul = ab[31:0];

assign znak = a[31] ^ b[31];

logic [31:0] a_abs;
logic [31:0] b_abs;

logic [31:0] a_norm;
logic [31:0] b_norm;



assign a_abs = (a[31]) ? (~a + 1) : a;
assign b_abs = (b[31]) ? (~b + 1) : b;

logic [63:0] ab_abs;
logic [4:0] cnt;

logic [31:0] max_abs;
logic [31:0] min_abs;

assign max_abs = (a_abs > b_abs) ? a_abs : b_abs;
assign min_abs = (a_abs > b_abs) ? b_abs : a_abs;

assign vld = (cnt == 5'd31);

assign ab = (znak) ? (~(ab_abs) + 1) : ab_abs;

logic enable;

always_ff @(posedge clk) begin
	if (rst) enable <= 1'd0;
	else begin
		if(start) enable <= 1'd1;
		if (end_mul) enable <= 1'd0;
	end
end

always_ff @(posedge clk) begin
	if (rst || (~enable)) begin
		ab_abs <= '0;
		cnt <= '0;
	end
	
	else begin
		if (cnt == 5'd31 || end_mul) begin 
			cnt <= '0;
			ab_abs <= '0;
		end
		
		else begin
			ab_abs <= ab_abs + ((max_abs & {32{min_abs [cnt]}}) << cnt);	
			cnt <= cnt + 1;
		end
		
	end
end



assign end_mul =start &( ~(| (min_abs >> cnt)));


endmodule

