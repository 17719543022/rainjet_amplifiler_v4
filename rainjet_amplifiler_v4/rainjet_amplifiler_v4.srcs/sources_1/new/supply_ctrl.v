module supply_ctrl #(
   	parameter				MAIN_CLK_FREQ = 48000000
    )(
    input                   clk,
    input                   supply_key,
    output reg              supply_out
);

localparam              MINISECOND_DIV = 24000;
localparam              MINISECOND_MUL = 2000;

reg                     clk_div;
reg                     clk_div_d;
reg  [15:0]             clk_divisor;
reg  [15:0]             clk_multiplier;
reg  [15:0]             clk_multiplier_d;
reg                     supply_key_d;

always @(posedge clk)
if (clk_divisor < MINISECOND_DIV)
    clk_divisor <= clk_divisor + 16'd1;
else
    clk_divisor <= 16'd0;

always @(posedge clk)
if (clk_divisor == 16'd1)
    clk_div <= ~clk_div;

always @(posedge clk)
    clk_div_d <= clk_div;

always @(posedge clk)
    supply_key_d <= supply_key;

always @(posedge clk)
begin
    if ((supply_key == 1'b0) & (supply_key_d == 1'b1))
        clk_multiplier <= 16'd0;
    else if ((supply_key == 1'b0) & (clk_multiplier < MINISECOND_MUL) & (clk_div_d == 1'b0) & (clk_div == 1'b1))
        clk_multiplier <= clk_multiplier + 16'd1;
    else
        clk_multiplier <= clk_multiplier;
end

always @(posedge clk)
    clk_multiplier_d <= clk_multiplier;

always @(posedge clk)
begin
    if ((supply_out == 1'b0) & (supply_key == 1'b0) & (clk_multiplier_d == (MINISECOND_MUL - 'd1)) & (clk_multiplier == MINISECOND_MUL))
        supply_out <= 1'b1;
    else if ((supply_out == 1'b1) & (supply_key == 1'b0) & (clk_multiplier_d == (MINISECOND_MUL - 'd1)) & (clk_multiplier == MINISECOND_MUL))
        supply_out <= 1'b0;
    else
        supply_out <= supply_out;
end




endmodule
