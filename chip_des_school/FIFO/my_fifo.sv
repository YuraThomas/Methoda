module my_fifo
#(parameter width = 2, depth = 4)
(
    input                clk,
    input                rst,
    input                push,
    input                pop,
    input  [width - 1:0] write_data,
    output [width - 1:0] read_data,
    output               empty,
    output               full
);

localparam pointer_depth = $clog2 (depth);
localparam depth_minus_1 = depth - 1;


logic [pointer_depth +1 : 0] count_in_fifo;
logic [pointer_depth +1 : 0] count_out_fifo;

reg [pointer_depth : 0] chislo;
wire [width-1 : 0] fifo [depth -1 : 0];

wire uslovie_schitivanie = pop & (chislo > 0);

always @(posedge clk) begin
	if (rst) begin
		count_in_fifo <= '0;
		read_data <= '0;
		count_out_fifo <= '0;
		chislo = '0;
	end
	else begin
		if (push) begin 
			fifo [count_in_fifo] <= write_data;
			chislo <= chislo +'1;
			
			if (count_in_fifo == (depth_minus_1)) count_in_fifo <= '0;
			else count_in_fifo <= count_in_fifo +'1;
		end
	
		if (uslovie_schitivanie) begin 
			read_data <= fifo [count_out_fifo];
			chislo <= chislo - '1;
			if (count_out_fifo == (depth_minus_1)) count_out_fifo <= '0;
			else count_out_fifo <= count_out_fifo +'1;
		end
			
	end
end


assign empty = (chislo == '0);
assign full = (chislo == (depth -'1));
endmodule
