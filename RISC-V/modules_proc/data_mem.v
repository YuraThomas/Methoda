module data_mem(
	input [4:0] memi,
	input [31:0] data,
	input [31:0] upr_in, 
	output reg [31:0] out,
	input clk,
	input WrEn

);

reg  [31:0] RAM [0:255];
wire [31:0] mem_in;
wire [31:0] one_bite_mem_zn;
wire [31:0] two_bite_mem_zn;
wire [31:0] one_bite_mem_bez;
wire [31:0] two_bite_mem_bez;
wire [31:0] one_bite_mem;
wire [31:0] two_bite_mem;
wire [31:0] full_bite_mem;

assign one_bite_mem = (memi[4]) ? one_bite_mem_bez : one_bite_mem_zn;
assign two_bite_mem = (memi[4]) ? two_bite_mem_bez : two_bite_mem_zn;

assign one_bite_mem_bez = {24'd0, data[7:0]};
assign one_bite_mem_zn = {{24 {data[7]}}, data[7:0]};
assign two_bite_mem_bez = {16'd0, data[15:0]};
assign two_bite_mem_zn = {{16{data[15]}}, data[15:0]};
assign full_bite_mem = data;

assign mem_in = (memi[3:2] == 2'd0) ? one_bite_mem:
					  (memi[3:2] == 2'd1) ? two_bite_mem:
					  (memi[3:2] == 2'd2) ? full_bite_mem: 32'd0;



always @(posedge clk) begin
	if (WrEn) begin
		if (memi[1]) RAM[upr_in] <= mem_in;
		if (memi[0]) out <= RAM[upr_in];
	end
	
	
end

endmodule
