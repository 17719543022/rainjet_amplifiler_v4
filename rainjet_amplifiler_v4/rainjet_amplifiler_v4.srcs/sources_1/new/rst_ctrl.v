module rst_ctrl(
    input                   clk,
    input                   rst_i,
    input                   isp_rst,
    output reg              power_up_rst,
    output reg              rst_o  // low active
);

parameter               POWER_ON_RST_CNT = 10000000;
 
reg  [31:0]             rst_cnt;
reg                     external_rst;

always @(posedge clk)
if(rst_cnt == (POWER_ON_RST_CNT - 'd10))
    power_up_rst <= 1'b0;
else if (rst_cnt == POWER_ON_RST_CNT)
    power_up_rst <= 1'b1;

always @(posedge clk)
if (rst_cnt != POWER_ON_RST_CNT)
    rst_cnt <= rst_cnt + 'd1;

always @(posedge clk)
    external_rst <= rst_i;

always @(posedge clk)
    rst_o <= ~(external_rst & power_up_rst & isp_rst);







endmodule
