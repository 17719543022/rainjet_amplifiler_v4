`timescale 1ns / 1ps
module adc_7177_result_process(
    input               clk,
    input               rst_n,

    input               read_trigger,
    input               read_period,
    input  [15:0]       spi_state_cnt,
    input               ad7177_dout,

    output [27:0]       adc_result_ch0,
    output [27:0]       adc_result_ch1,
    output [27:0]       adc_result_ch2,
    output [27:0]       adc_result_ch3,

    output              result_write_trigger
);

reg    [31:0]       adc_result_shift_reg;
reg    [27:0]       adc_result_ch0_org,    adc_result_ch1_org,    adc_result_ch2_org,    adc_result_ch3_org;
reg    [27:0]       adc_result_ch0_org_d1, adc_result_ch1_org_d1, adc_result_ch2_org_d1, adc_result_ch3_org_d1;
reg    [27:0]       adc_result_ch0_org_d2, adc_result_ch1_org_d2, adc_result_ch2_org_d2, adc_result_ch3_org_d2;
reg    [27:0]       adc_result_ch0_org_d3, adc_result_ch1_org_d3, adc_result_ch2_org_d3, adc_result_ch3_org_d3;
reg    [29:0]       adc_result_ch0_sum,    adc_result_ch1_sum,    adc_result_ch2_sum,    adc_result_ch3_sum;
reg                 ad7177_dout_d1, ad7177_dout_d2;

always @(posedge clk)
begin
    ad7177_dout_d2 <= ad7177_dout_d1;
    ad7177_dout_d1 <= ad7177_dout;
end

always @(posedge clk)
if (~rst_n)
    adc_result_shift_reg <= 'd0;
else if (read_trigger)
    adc_result_shift_reg <= 32'hffffffff;
else if (read_period & (spi_state_cnt[4:0] == 'd13))
    adc_result_shift_reg <= {adc_result_shift_reg[30:0], ad7177_dout_d2};

always @(posedge clk)
if (spi_state_cnt == 'd10)
    case (adc_result_shift_reg[1:0])
    //2'd0: adc_result_ch0 <= adc_result_shift_reg[31:4];
    //2'd1: adc_result_ch1 <= adc_result_shift_reg[31:4];
    //2'd2: adc_result_ch2 <= adc_result_shift_reg[31:4];
    //2'd3: adc_result_ch3 <= adc_result_shift_reg[31:4];
    2'd0: adc_result_ch0_org <= adc_result_shift_reg[31:4];
    2'd1: adc_result_ch1_org <= adc_result_shift_reg[31:4];
    2'd2: adc_result_ch2_org <= adc_result_shift_reg[31:4];
    2'd3: adc_result_ch3_org <= adc_result_shift_reg[31:4];
    default: ;
    endcase

always @(posedge clk)
if (spi_state_cnt == 'd9)
begin
    adc_result_ch3_org_d3 <= adc_result_ch3_org_d2;
    adc_result_ch3_org_d2 <= adc_result_ch3_org_d1;
    adc_result_ch3_org_d1 <= adc_result_ch3_org;

    adc_result_ch2_org_d3 <= adc_result_ch2_org_d2;
    adc_result_ch2_org_d2 <= adc_result_ch2_org_d1;
    adc_result_ch2_org_d1 <= adc_result_ch2_org;

    adc_result_ch1_org_d3 <= adc_result_ch1_org_d2;
    adc_result_ch1_org_d2 <= adc_result_ch1_org_d1;
    adc_result_ch1_org_d1 <= adc_result_ch1_org;

    adc_result_ch0_org_d3 <= adc_result_ch0_org_d2;
    adc_result_ch0_org_d2 <= adc_result_ch0_org_d1;
    adc_result_ch0_org_d1 <= adc_result_ch0_org;
end

always @(posedge clk)
if (spi_state_cnt == 'd8)
begin
    adc_result_ch0_sum <= adc_result_ch0_org_d3 + adc_result_ch0_org_d2 + adc_result_ch0_org_d1 + adc_result_ch0_org;
    adc_result_ch1_sum <= adc_result_ch1_org_d3 + adc_result_ch1_org_d2 + adc_result_ch1_org_d1 + adc_result_ch1_org;
    adc_result_ch2_sum <= adc_result_ch2_org_d3 + adc_result_ch2_org_d2 + adc_result_ch2_org_d1 + adc_result_ch2_org;
    adc_result_ch3_sum <= adc_result_ch3_org_d3 + adc_result_ch3_org_d2 + adc_result_ch3_org_d1 + adc_result_ch3_org;
end

//2020.8.16通道1,2的对应关系对调。
//assign adc_result_ch0 = adc_result_ch0_sum[29:2];
//assign adc_result_ch1 = adc_result_ch1_sum[29:2];

//20220814之前的状态
assign adc_result_ch0 = adc_result_ch0_sum[29:2];
assign adc_result_ch1 = adc_result_ch1_sum[29:2];
assign adc_result_ch2 = adc_result_ch2_sum[29:2];
assign adc_result_ch3 = adc_result_ch3_sum[29:2];

//2022年8月14日，应李工要求，将输出调整为之前的5倍
//assign adc_result_ch0 = adc_result_ch1_sum[29:0]; // + adc_result_ch1_sum[29:2];
//assign adc_result_ch1 = adc_result_ch0_sum[29:0]; // + adc_result_ch0_sum[29:2];
//assign adc_result_ch2 = adc_result_ch2_sum[29:0]; // + adc_result_ch2_sum[29:2];
//assign adc_result_ch3 = adc_result_ch3_sum[29:0]; // + adc_result_ch3_sum[29:2];

//assign adc_result_ch0 = {adc_result_ch1_sum[29:2],1'b0}; 
//assign adc_result_ch1 = {adc_result_ch0_sum[29:2],1'b0}; 
//assign adc_result_ch2 = {adc_result_ch2_sum[29:2],1'b0}; 
//assign adc_result_ch3 = {adc_result_ch3_sum[29:2],1'b0}; 

//2022年12月21号，增加8倍
//assign adc_result_ch0 = adc_result_ch1_sum[29:0];
//assign adc_result_ch1 = adc_result_ch0_sum[29:0];
//assign adc_result_ch2 = adc_result_ch2_sum[29:0];
//assign adc_result_ch3 = adc_result_ch3_sum[29:0];

//分离版本，每片ADC处理2个通道
assign result_write_trigger = (spi_state_cnt == 'd7) & (adc_result_shift_reg[1:0] == 2'd1);
//assign result_write_trigger = (spi_state_cnt == 'd7) & (adc_result_shift_reg[1:0] == 2'd3);





endmodule
 
