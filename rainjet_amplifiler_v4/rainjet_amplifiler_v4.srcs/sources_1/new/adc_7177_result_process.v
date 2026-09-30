`timescale 1ns / 1ps
module adc_7177_result_process(
    input               clk,
    input               rst_n,
    input  [ 7:0]       ad7177_switch_dl_total,

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

parameter           TOTAL_DL_NUM_18 = 18;
parameter           TOTAL_DL_NUM_36 = 36;

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

assign adc_result_ch0 = adc_result_ch0_sum[29:2];
assign adc_result_ch1 = adc_result_ch1_sum[29:2];
assign adc_result_ch2 = adc_result_ch2_sum[29:2];
assign adc_result_ch3 = adc_result_ch3_sum[29:2];

//assign result_write_trigger = (spi_state_cnt == 'd7) & (adc_result_shift_reg[1:0] == 2'd1);
//assign result_write_trigger = (spi_state_cnt == 'd7) & (adc_result_shift_reg[1:0] == 2'd3);
assign result_write_trigger = (ad7177_switch_dl_total == TOTAL_DL_NUM_18) ? (spi_state_cnt == 'd7) : ((spi_state_cnt == 'd7) & (adc_result_shift_reg[1:0] == 2'd1));




endmodule

