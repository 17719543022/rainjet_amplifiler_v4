`timescale 1ns/1ps

module filter_rxd (
    input                   clk,
    input                   pin_in,
    output reg              filtered_out
);

reg  [ 4:0]             data_filtered;

always @(posedge clk)
    data_filtered <= {data_filtered[ 3:0], pin_in};

always @(posedge clk)
if (&data_filtered)
    filtered_out <= 1'b1;
else if (~|data_filtered)
    filtered_out <= 1'b0;















endmodule
