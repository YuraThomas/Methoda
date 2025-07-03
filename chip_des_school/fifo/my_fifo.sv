module my_fifo
#(parameter width = 2, depth = 2)
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

localparam pointer_width = $clog2 (width) + '1;


reg [pointer_width+1 : 0] count_in_fifo;
reg [pointer_width+1 : 0] count_out_fifo;
wire [width-1 : 0] fifo;
wire kek_fifo;
assign kek_fifo = ~(count_out_fifo > count_in_fifo);

always @(posedge clk) begin
	if (rst) begin
		count_in_fifo <= '0;
		read_data <= '0;
		count_out_fifo <= '0;
	end
	else begin
		if (push) begin 
			fifo [count_in_fifo] <= write_data [count_in_fifo];
			count_in_fifo <= count_in_fifo +'1;
		end
	
		if (pop && kek_fifo) begin 
			read_data [count_out_fifo] <= fifo [count_out_fifo];
			count_out_fifo <= count_out_fifo +'1;
		end
	end
end

assign full = (count_in_fifo == (width -'1));
assign empty = (count_in_fifo == '0);
endmodule
