module floating_point_summator (
	input  [31:0] num_1,
	input  [31:0] num_2,
	output [31:0] sum_float
);

wire sign_1 = num_1[31];
wire [7:0] exp_1 = num_1[30:23];
wire [22:0] mant_1 = num_1[22:0];

wire sign_2 = num_2[31];
wire [7:0] exp_2 = num_2[30:23];
wire [22:0] mant_2 = num_2[22:0];

logic sign_mx, sign_mn;
logic [7:0] exp_mx, exp_mn;
logic [22:0] mant_mx, mant_mn;


always_comb begin
	if (exp_1 > exp_2) begin
		{sign_mx, exp_mx, mant_mx} = {sign_1, exp_1, mant_1};
		{sign_mn, exp_mn, mant_mn} = {sign_2, exp_2, mant_2};
	end else if (exp_1 < exp_2) begin
		{sign_mx, exp_mx, mant_mx} = {sign_2, exp_2, mant_2};
		{sign_mn, exp_mn, mant_mn} = {sign_1, exp_1, mant_1};
	end else begin // exp_1 == exp_2
		if (mant_1 >= mant_2) begin
			{sign_mx, exp_mx, mant_mx} = {sign_1, exp_1, mant_1};
			{sign_mn, exp_mn, mant_mn} = {sign_2, exp_2, mant_2};
		end else begin
			{sign_mx, exp_mx, mant_mx} = {sign_2, exp_2, mant_2};
			{sign_mn, exp_mn, mant_mn} = {sign_1, exp_1, mant_1};
		end
	end
end



wire denorm_mx = (exp_mx == 8'd0);
wire denorm_mn = (exp_mn == 8'd0);

wire [23:0] mant_mx_ext = (denorm_mx) ? {1'b0, mant_mx} : {1'b1, mant_mx};
wire [23:0] mant_mn_ext = (denorm_mn) ? {1'b0, mant_mn} : {1'b1, mant_mn};


logic [7:0] exp_diff;

always_comb begin
	exp_diff = exp_mx - exp_mn;
	case ({denorm_mx, denorm_mn})
	2'd00 : exp_diff = exp_mx - exp_mn;
	2'd11 : exp_diff = 8'd0;
	2'd01 : exp_diff = exp_mx - 1;
	endcase
end

wire [23:0] mant_mn_shifted = (exp_diff > 8'd24) ? 24'd0 : (mant_mn_ext >> exp_diff);


wire op_sub = sign_1 ^ sign_2;
logic [24:0] mant_res;

always_comb begin
	if (op_sub) begin
		mant_res = {1'b0, mant_mx_ext} - {1'b0, mant_mn_shifted};
	end else begin
		mant_res = {1'b0, mant_mx_ext} + {1'b0, mant_mn_shifted};
	end
end


wire overflow_right = mant_res[24];

logic [4:0] leading_zeros;
always_comb begin
	casez (mant_res[23:0])
		24'b1??????????????????????? : leading_zeros = 5'd0;
		24'b01?????????????????????? : leading_zeros = 5'd1;
		24'b001????????????????????? : leading_zeros = 5'd2;
		24'b0001???????????????????? : leading_zeros = 5'd3;
		24'b00001??????????????????? : leading_zeros = 5'd4;
		24'b000001?????????????????? : leading_zeros = 5'd5;
		24'b0000001????????????????? : leading_zeros = 5'd6;
		24'b00000001???????????????? : leading_zeros = 5'd7;
		24'b000000001??????????????? : leading_zeros = 5'd8;
		24'b0000000001?????????????? : leading_zeros = 5'd9;
		24'b00000000001????????????? : leading_zeros = 5'd10;
		24'b000000000001???????????? : leading_zeros = 5'd11;
		24'b0000000000001??????????? : leading_zeros = 5'd12;
		24'b00000000000001?????????? : leading_zeros = 5'd13;
		24'b000000000000001????????? : leading_zeros = 5'd14;
		24'b0000000000000001???????? : leading_zeros = 5'd15;
		24'b00000000000000001??????? : leading_zeros = 5'd16;
		24'b000000000000000001?????? : leading_zeros = 5'd17;
		24'b0000000000000000001????? : leading_zeros = 5'd18;
		24'b00000000000000000001???? : leading_zeros = 5'd19;
		24'b000000000000000000001??? : leading_zeros = 5'd20;
		24'b0000000000000000000001?? : leading_zeros = 5'd21;
		24'b00000000000000000000001? : leading_zeros = 5'd22;
		24'b000000000000000000000001 : leading_zeros = 5'd23;
		default                      : leading_zeros = 5'd24;
	endcase
end

logic [7:0]  exp_sum;
logic [22:0] mant_sum;
logic        final_sign;


logic [23:0] kostyl_for_mant_sum;
assign kostyl_for_mant_sum = mant_res[23:0] << leading_zeros;

wire [7:0] exp_mx_real = (denorm_mx) ? 8'd1 : exp_mx;


always_comb begin
	exp_sum        = exp_mx;
	mant_sum       = mant_res[22:0];
	final_sign     = sign_mx;

	if (mant_res == 25'd0) begin
		exp_sum  = 8'd0;
		mant_sum = 23'd0;
		final_sign = 1'b0;
	end 
	else if (overflow_right) begin
		exp_sum  = exp_mx_real + 1;
		mant_sum = mant_res[23:1];
	end 
	else begin
			if (exp_mx_real > leading_zeros) begin
				exp_sum  = exp_mx_real - leading_zeros;
				mant_sum = kostyl_for_mant_sum[22:0];
			end
			
			else begin
				exp_sum  = 8'd0;
				mant_sum = (mant_res[23:0] << (exp_mx_real - 8'd1));
			end
	end
	
end




assign sum_float = {final_sign, exp_sum, mant_sum};


endmodule
