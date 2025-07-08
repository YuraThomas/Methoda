module a_plus_b_using_fifos
# (
    parameter width = 8, depth = 10
)
(
    input                clk,
    input                rst,

    input                a_valid,
    output               a_ready,
    input  [width - 1:0] a_data,

    input                b_valid,
    output               b_ready,
    input  [width - 1:0] b_data,

    output               sum_valid,
    input                sum_ready,
    output [width - 1:0] sum_data
);

//inst 1

logic push_1;
logic pop_1;
logic [width-1:0] wd_1;
logic [width-1:0] rd_1;
logic empty_1;
logic full_1;

my_fifo
#(.width(width), .depth(depth)) fifo_a (
    .clk(clk),
    .rst(rst),
    .push (push_1),
    .pop(pop_1),
    .write_data(wd_1),
    .read_data(rd_1),
    .empty(empty_1),
    .full(full_1)
);

//inst 2

logic push_2;
logic pop_2;
logic [width-1:0] wd_2;
logic [width-1:0] rd_2;
logic empty_2;
logic full_2;

my_fifo
#(.width(width), .depth(depth)) fifo_b (
    .clk(clk),
    .rst(rst),
    .push (push_2),
    .pop(pop_2),
    .write_data(wd_2),
    .read_data(rd_2),
    .empty(empty_2),
    .full(full_2)
);

//inst 3

logic push_3;
logic pop_3;
logic [width-1:0] wd_3;
logic [width-1:0] rd_3;
logic empty_3;
logic full_3;

my_fifo
#(.width(width), .depth(depth)) fifo_out (
    .clk(clk),
    .rst(rst),
    .push (push_3),
    .pop(pop_3),
    .write_data(wd_3),
    .read_data(rd_3),
    .empty(empty_3),
    .full(full_3)
);

logic [width-1:0] sum;

assign wd_1 = a_data;
assign wd_2 = b_data;

assign push_1 = a_valid && ~full_1;
assign push_2 = b_valid && ~full_2;

assign pop_1 = ~full_3 && ~empty_1 && ~empty_2;
assign pop_2 = ~full_3 && ~empty_1 && ~empty_2;

assign a_ready = ~full_1;
assign b_ready = ~full_2;


assign sum = rd_1 + rd_2;

assign push_3 = pop_1;
assign wd_3 = sum;

assign sum_valid = ~empty_3;
assign sum_data = rd_3;
assign pop_3 = sum_ready & ~empty_3;

endmodule
