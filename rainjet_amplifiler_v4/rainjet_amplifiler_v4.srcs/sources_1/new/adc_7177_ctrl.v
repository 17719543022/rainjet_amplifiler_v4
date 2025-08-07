`timescale 1ns / 1ps
module adc_7177_ctrl(
    input                   clk,
    input                   rst_n,

    output reg              ad7177_cs,
    output reg              ad7177_sck,
    output reg              ad7177_din,
    output reg              ad7177_sync,

    input                   ad7177_dout_18,
    input                   ad7177_dout_17,
    input                   ad7177_dout_16,
    input                   ad7177_dout_15,
    input                   ad7177_dout_14,
    input                   ad7177_dout_13,
    input                   ad7177_dout_12,
    input                   ad7177_dout_11,
    input                   ad7177_dout_10,
    input                   ad7177_dout_9,
    input                   ad7177_dout_8,
    input                   ad7177_dout_7,
    input                   ad7177_dout_6,
    input                   ad7177_dout_5,
    input                   ad7177_dout_4,
    input                   ad7177_dout_3,
    input                   ad7177_dout_2,
    input                   ad7177_dout_1,
    input                   ad7177_dout_0,

    input [31:0]            adc_trigger_length_usb,
    input                   adc_sample_en_usb,
    output reg              adc_sample_en_slave,
    input [15:0]            usb_cfg_bus_usb,
    input                   usb_cfg_valid_usb,
    input [31:0]            usb_sample_period,
    input [ 7:0]            uart_trig_data,
    input [ 7:0]            usb_trigger_value,
    input                   usb_trigger_value_valid,
    input                   usb_impedance_valid,
    input                   uart_ri,

    output reg              adc_initiate_complete,
    output                  result_write_trigger,
    output reg              adc_wren,
    output reg [31:0]       adc_data,

    input                   sw0_d,
    input                   sw1_d,

    output reg              jl_cs_out,
    output reg              jl_sck_out,
    output reg              jl_data_out0,
    output reg              jl_data_out1,
    input                   jl_com1_cs_in,
    input                   jl_com1_sck_in,
    input                   jl_com1_data_in0,
    input                   jl_com1_data_in1,
    input                   jl_com2_cs_in,
    input                   jl_com2_sck_in,
    input                   jl_com2_data_in0,
    input                   jl_com2_data_in1,
    input                   jl_com3_cs_in,
    input                   jl_com3_sck_in,
    input                   jl_com3_data_in0,
    input                   jl_com3_data_in1,

    output                  FPGA_DOUT_OE,
    output                  FPGA_DOUT_LCK,
    output                  FPGA_DOUT_RST,
    output                  FPGA_DOUT_SCK,
    output                  FPGA_DOUT_SIN,
    output reg [31:0]       real_max_value_1,
    output reg [31:0]       real_max_value_2,
    output reg [31:0]       real_max_value_3,
    output reg [31:0]       real_max_value_4,
    output reg [31:0]       real_max_value_5,
    output reg [31:0]       real_max_value_6,
    output reg [31:0]       real_max_value_7,
    output reg [31:0]       real_max_value_8,
    output reg [31:0]       real_max_value_9,
    output reg [31:0]       real_max_value_10,
    output reg [31:0]       real_max_value_11,
    output reg [31:0]       real_max_value_12,
    output reg [31:0]       real_max_value_13,
    output reg [31:0]       real_max_value_14,
    output reg [31:0]       real_max_value_15,
    output reg [31:0]       real_max_value_16,
    output reg [31:0]       real_max_value_17,
    output reg [31:0]       real_max_value_18,
    output reg [31:0]       real_max_value_19,
    output reg [31:0]       real_max_value_20,
    output reg [31:0]       real_max_value_21,
    output reg [31:0]       real_max_value_22,
    output reg [31:0]       real_max_value_23,
    output reg [31:0]       real_max_value_24,
    output reg [31:0]       real_max_value_25,
    output reg [31:0]       real_max_value_26,
    output reg [31:0]       real_max_value_27,
    output reg [31:0]       real_max_value_28,
    output reg [31:0]       real_max_value_29,
    output reg [31:0]       real_max_value_30,
    output reg [31:0]       real_max_value_31,
    output reg [31:0]       real_max_value_32,
    output reg [31:0]       real_max_value_33,
    output reg [31:0]       real_max_value_34,
    output reg [31:0]       real_max_value_35,
    output reg [31:0]       real_max_value_36,
    output reg [31:0]       real_max_value_37,
    output reg [31:0]       real_max_value_38,
    output reg [31:0]       real_max_value_39,
    output reg [31:0]       real_max_value_40,
    output reg [31:0]       real_max_value_41,
    output reg [31:0]       real_max_value_42,
    output reg [31:0]       real_max_value_43,
    output reg [31:0]       real_max_value_44,
    output reg [31:0]       real_max_value_45,
    output reg [31:0]       real_max_value_46,
    output reg [31:0]       real_max_value_47,
    output reg [31:0]       real_max_value_48,
    output reg [31:0]       real_max_value_49,
    output reg [31:0]       real_max_value_50,
    output reg [31:0]       real_max_value_51,
    output reg [31:0]       real_max_value_52,
    output reg [31:0]       real_max_value_53,
    output reg [31:0]       real_max_value_54,
    output reg [31:0]       real_max_value_55,
    output reg [31:0]       real_max_value_56,
    output reg [31:0]       real_max_value_57,
    output reg [31:0]       real_max_value_58,
    output reg [31:0]       real_max_value_59,
    output reg [31:0]       real_max_value_60,
    output reg [31:0]       real_max_value_61,
    output reg [31:0]       real_max_value_62,
    output reg [31:0]       real_max_value_63,
    output reg [31:0]       real_max_value_64,
    output reg [31:0]       real_max_value_65,
    output reg [31:0]       real_max_value_66,
    output reg [31:0]       real_max_value_67,
    output reg [31:0]       real_max_value_68,
    output reg [31:0]       real_max_value_69,
    output reg [31:0]       real_max_value_70,
    output reg [31:0]       real_max_value_71,
    output reg [31:0]       real_max_value_72,
    output reg [31:0]       real_max_value_73,
    output reg [31:0]       real_max_value_74,
    output reg [31:0]       real_max_value_75,
    output reg [31:0]       real_max_value_76,
    output reg [31:0]       real_max_value_77,
    output reg [31:0]       real_max_value_78,
    output reg [31:0]       real_max_value_79,
    output reg [31:0]       real_max_value_80,
    output reg [31:0]       real_max_value_81,
    output reg [31:0]       real_max_value_82,
    output reg [31:0]       real_max_value_83,
    output reg [31:0]       real_max_value_84,
    output reg [31:0]       real_max_value_85,
    output reg [31:0]       real_max_value_86,
    output reg [31:0]       real_max_value_87,
    output reg [31:0]       real_max_value_88,
    output reg [31:0]       real_max_value_89,
    output reg [31:0]       real_max_value_90,
    output reg [31:0]       real_max_value_91,
    output reg [31:0]       real_max_value_92,
    output reg [31:0]       real_max_value_93,
    output reg [31:0]       real_max_value_94,
    output reg [31:0]       real_max_value_95,
    output reg [31:0]       real_max_value_96,
    output reg [31:0]       real_max_value_97,
    output reg [31:0]       real_max_value_98,
    output reg [31:0]       real_max_value_99,
    output reg [31:0]       real_max_value_100,
    output reg [31:0]       real_max_value_101,
    output reg [31:0]       real_max_value_102,
    output reg [31:0]       real_max_value_103,
    output reg [31:0]       real_max_value_104,
    output reg [31:0]       real_max_value_105,
    output reg [31:0]       real_max_value_106,
    output reg [31:0]       real_max_value_107,
    output reg [31:0]       real_max_value_108,
    output reg [31:0]       real_max_value_109,
    output reg [31:0]       real_max_value_110,
    output reg [31:0]       real_max_value_111,
    output reg [31:0]       real_max_value_112,
    output reg [31:0]       real_max_value_113,
    output reg [31:0]       real_max_value_114,
    output reg [31:0]       real_max_value_115,
    output reg [31:0]       real_max_value_116,
    output reg [31:0]       real_max_value_117,
    output reg [31:0]       real_max_value_118,
    output reg [31:0]       real_max_value_119,
    output reg [31:0]       real_max_value_120,
    output reg [31:0]       real_max_value_121,
    output reg [31:0]       real_max_value_122,
    output reg [31:0]       real_max_value_123,
    output reg [31:0]       real_max_value_124,
    output reg [31:0]       real_max_value_125,
    output reg [31:0]       real_max_value_126,
    output reg [31:0]       real_max_value_127,
    output reg [31:0]       real_max_value_128,
    output reg [31:0]       real_max_value_129,
    output reg [31:0]       real_max_value_130,
    output reg [31:0]       real_max_value_131,
    output reg [31:0]       real_max_value_132,
    output reg [31:0]       real_max_value_133,
    output reg [31:0]       real_max_value_134,
    output reg [31:0]       real_max_value_135,
    output reg [31:0]       real_max_value_136,
    output reg [31:0]       real_max_value_137,
    output reg [31:0]       real_max_value_138,
    output reg [31:0]       real_max_value_139,
    output reg [31:0]       real_max_value_140,
    output reg [31:0]       real_max_value_141,
    output reg [31:0]       real_max_value_142,
    output reg [31:0]       real_max_value_143,
    output reg [31:0]       real_max_value_144
);

parameter           ONE_CFG_BIT = 14;
parameter           ONE_CFG_TIME = 32768;
parameter           CFG_NUMBER = 10;
parameter           INITIAL_WAIT_TIME = 96000000; //100ms

reg                 initial_period;

wire   [31:0]       adc_trigger_length;
wire                adc_sample_en;
wire   [15:0]       usb_cfg_bus;
wire                usb_cfg_valid;
wire   [31:0]       adc_sample_period;

reg                 ad7177_dout_18_d1, ad7177_dout_18_d2;
reg                 ad7177_dout_17_d1, ad7177_dout_17_d2;
reg                 ad7177_dout_16_d1, ad7177_dout_16_d2;
reg                 ad7177_dout_15_d1, ad7177_dout_15_d2;
reg                 ad7177_dout_14_d1, ad7177_dout_14_d2;
reg                 ad7177_dout_13_d1, ad7177_dout_13_d2;
reg                 ad7177_dout_12_d1, ad7177_dout_12_d2;
reg                 ad7177_dout_11_d1, ad7177_dout_11_d2;
reg                 ad7177_dout_10_d1, ad7177_dout_10_d2;
reg                 ad7177_dout_9_d1,  ad7177_dout_9_d2 ;
reg                 ad7177_dout_8_d1,  ad7177_dout_8_d2 ;
reg                 ad7177_dout_7_d1,  ad7177_dout_7_d2 ;
reg                 ad7177_dout_6_d1,  ad7177_dout_6_d2 ;
reg                 ad7177_dout_5_d1,  ad7177_dout_5_d2 ;
reg                 ad7177_dout_4_d1,  ad7177_dout_4_d2 ;
reg                 ad7177_dout_3_d1,  ad7177_dout_3_d2 ;
reg                 ad7177_dout_2_d1,  ad7177_dout_2_d2 ;
reg                 ad7177_dout_1_d1,  ad7177_dout_1_d2 ;
reg                 ad7177_dout_0_d1,  ad7177_dout_0_d2 ;

reg    [14:0]       adc_len_cnt; //ADC采样次数计数器

reg                 ad7177_cs_initial;
reg                 ad7177_sck_initial; 

reg    [31:0]       initial_wait_cnt;
reg    [31:0]       initial_time_cnt;
wire   [ 4:0]       initial_index = initial_time_cnt[31 : ONE_CFG_BIT+1 ];

wire                initial_spi_trigger = (initial_time_cnt[ONE_CFG_BIT :0] == 'd5);
reg    [15:0]       spi_state_cnt; 

wire   [ 4:0]       spi_bit_cnt = spi_state_cnt[9:5];
reg    [23:0]       initial_cfg_word;
reg    [23:0]       initial_shfit_word;
reg                 ad7177_din_initial;

wire                valid_initial_cycle = (initial_index < 10);
wire                reset_adc_cycle = (initial_index == 'd0) & initial_period;

reg                 initial_period_d;
reg                 adc_result_read_period;
reg                 adc_data_read_trigger;

wire   [27:0]       adc_result_chip_9_ch0, adc_result_chip_9_ch1;
wire   [27:0]       adc_result_chip_8_ch0, adc_result_chip_8_ch1, adc_result_chip_8_ch2, adc_result_chip_8_ch3;
wire   [27:0]       adc_result_chip_7_ch0, adc_result_chip_7_ch1, adc_result_chip_7_ch2, adc_result_chip_7_ch3;
wire   [27:0]       adc_result_chip_6_ch0, adc_result_chip_6_ch1, adc_result_chip_6_ch2, adc_result_chip_6_ch3;
wire   [27:0]       adc_result_chip_5_ch0, adc_result_chip_5_ch1, adc_result_chip_5_ch2, adc_result_chip_5_ch3;
wire   [27:0]       adc_result_chip_4_ch0, adc_result_chip_4_ch1, adc_result_chip_4_ch2, adc_result_chip_4_ch3;
wire   [27:0]       adc_result_chip_3_ch0, adc_result_chip_3_ch1, adc_result_chip_3_ch2, adc_result_chip_3_ch3;
wire   [27:0]       adc_result_chip_2_ch0, adc_result_chip_2_ch1, adc_result_chip_2_ch2, adc_result_chip_2_ch3;
wire   [27:0]       adc_result_chip_1_ch0, adc_result_chip_1_ch1, adc_result_chip_1_ch2, adc_result_chip_1_ch3;
wire   [27:0]       adc_result_chip_0_ch0, adc_result_chip_0_ch1, adc_result_chip_0_ch2, adc_result_chip_0_ch3;

reg    [27:0]       adc_result_chip_8_ch0_com1, adc_result_chip_8_ch1_com1, adc_result_chip_8_ch2_com1, adc_result_chip_8_ch3_com1;
reg    [27:0]       adc_result_chip_7_ch0_com1, adc_result_chip_7_ch1_com1, adc_result_chip_7_ch2_com1, adc_result_chip_7_ch3_com1;
reg    [27:0]       adc_result_chip_6_ch0_com1, adc_result_chip_6_ch1_com1, adc_result_chip_6_ch2_com1, adc_result_chip_6_ch3_com1;
reg    [27:0]       adc_result_chip_5_ch0_com1, adc_result_chip_5_ch1_com1, adc_result_chip_5_ch2_com1, adc_result_chip_5_ch3_com1;
reg    [27:0]       adc_result_chip_4_ch0_com1, adc_result_chip_4_ch1_com1, adc_result_chip_4_ch2_com1, adc_result_chip_4_ch3_com1;
reg    [27:0]       adc_result_chip_3_ch0_com1, adc_result_chip_3_ch1_com1, adc_result_chip_3_ch2_com1, adc_result_chip_3_ch3_com1;
reg    [27:0]       adc_result_chip_2_ch0_com1, adc_result_chip_2_ch1_com1, adc_result_chip_2_ch2_com1, adc_result_chip_2_ch3_com1;
reg    [27:0]       adc_result_chip_1_ch0_com1, adc_result_chip_1_ch1_com1, adc_result_chip_1_ch2_com1, adc_result_chip_1_ch3_com1;
reg    [27:0]       adc_result_chip_0_ch0_com1, adc_result_chip_0_ch1_com1, adc_result_chip_0_ch2_com1, adc_result_chip_0_ch3_com1;

reg    [27:0]       adc_result_chip_8_ch0_com2, adc_result_chip_8_ch1_com2, adc_result_chip_8_ch2_com2, adc_result_chip_8_ch3_com2;
reg    [27:0]       adc_result_chip_7_ch0_com2, adc_result_chip_7_ch1_com2, adc_result_chip_7_ch2_com2, adc_result_chip_7_ch3_com2;
reg    [27:0]       adc_result_chip_6_ch0_com2, adc_result_chip_6_ch1_com2, adc_result_chip_6_ch2_com2, adc_result_chip_6_ch3_com2;
reg    [27:0]       adc_result_chip_5_ch0_com2, adc_result_chip_5_ch1_com2, adc_result_chip_5_ch2_com2, adc_result_chip_5_ch3_com2;
reg    [27:0]       adc_result_chip_4_ch0_com2, adc_result_chip_4_ch1_com2, adc_result_chip_4_ch2_com2, adc_result_chip_4_ch3_com2;
reg    [27:0]       adc_result_chip_3_ch0_com2, adc_result_chip_3_ch1_com2, adc_result_chip_3_ch2_com2, adc_result_chip_3_ch3_com2;
reg    [27:0]       adc_result_chip_2_ch0_com2, adc_result_chip_2_ch1_com2, adc_result_chip_2_ch2_com2, adc_result_chip_2_ch3_com2;
reg    [27:0]       adc_result_chip_1_ch0_com2, adc_result_chip_1_ch1_com2, adc_result_chip_1_ch2_com2, adc_result_chip_1_ch3_com2;
reg    [27:0]       adc_result_chip_0_ch0_com2, adc_result_chip_0_ch1_com2, adc_result_chip_0_ch2_com2, adc_result_chip_0_ch3_com2;

reg    [27:0]       adc_result_chip_8_ch0_com3, adc_result_chip_8_ch1_com3, adc_result_chip_8_ch2_com3, adc_result_chip_8_ch3_com3;
reg    [27:0]       adc_result_chip_7_ch0_com3, adc_result_chip_7_ch1_com3, adc_result_chip_7_ch2_com3, adc_result_chip_7_ch3_com3;
reg    [27:0]       adc_result_chip_6_ch0_com3, adc_result_chip_6_ch1_com3, adc_result_chip_6_ch2_com3, adc_result_chip_6_ch3_com3;
reg    [27:0]       adc_result_chip_5_ch0_com3, adc_result_chip_5_ch1_com3, adc_result_chip_5_ch2_com3, adc_result_chip_5_ch3_com3;
reg    [27:0]       adc_result_chip_4_ch0_com3, adc_result_chip_4_ch1_com3, adc_result_chip_4_ch2_com3, adc_result_chip_4_ch3_com3;
reg    [27:0]       adc_result_chip_3_ch0_com3, adc_result_chip_3_ch1_com3, adc_result_chip_3_ch2_com3, adc_result_chip_3_ch3_com3;
reg    [27:0]       adc_result_chip_2_ch0_com3, adc_result_chip_2_ch1_com3, adc_result_chip_2_ch2_com3, adc_result_chip_2_ch3_com3;
reg    [27:0]       adc_result_chip_1_ch0_com3, adc_result_chip_1_ch1_com3, adc_result_chip_1_ch2_com3, adc_result_chip_1_ch3_com3;
reg    [27:0]       adc_result_chip_0_ch0_com3, adc_result_chip_0_ch1_com3, adc_result_chip_0_ch2_com3, adc_result_chip_0_ch3_com3;

/*------------------采样频率控制部分设计--------------*/

//默认为采样率 48,000,000/19,200 = 2500hz;

//分离版本，一片7177只用2通道以满足采样频率在5K左右。因此adc_sample_period从÷4变为÷2
wire   [31:0]       sample_period_clk_number_muxed = usb_cfg_bus[12] ? 19200 : adc_sample_period[31:1]; 

always @(posedge clk)
if(~rst_n)
    ad7177_din_initial <= 1'b0;
else
    ad7177_din_initial <= reset_adc_cycle ? 1'b1 : initial_shfit_word[23];

always @(posedge clk)
if(~rst_n)
    ad7177_cs_initial <= 1'b1;
else if ((initial_time_cnt[ONE_CFG_BIT:0] == 'd1)&valid_initial_cycle)
    ad7177_cs_initial <= 1'b0;
else if ((((initial_time_cnt[ONE_CFG_BIT:0] == 'd780)&(~reset_adc_cycle)&valid_initial_cycle)|((initial_time_cnt[ONE_CFG_BIT:0] == 'd2060)&reset_adc_cycle)) & (initial_cfg_word != 24'h0210c2))
    ad7177_cs_initial <= 1'b1;

always @(posedge clk)
if(~rst_n)
    initial_shfit_word <= 'd0;
else if (initial_spi_trigger & valid_initial_cycle)
    initial_shfit_word <= initial_cfg_word;
else if ((spi_state_cnt[4:0] == 'd31)&(spi_bit_cnt <23)&valid_initial_cycle)
    initial_shfit_word <= {initial_shfit_word[22:0],1'b0};

always @(posedge clk)
begin
    case(initial_index)
    //'d1 : initial_cfg_word <= {8'h10, 16'h8004}; // ch1为AIN0为+，AIN4为-
    //'d2 : initial_cfg_word <= {8'h11, 16'h8024}; // ch2为AIN1为+，AIN4为-
    //'d3 : initial_cfg_word <= {8'h12, 16'h0044}; // ch3关闭
    //'d4 : initial_cfg_word <= {8'h13, 16'h0064}; // ch4关闭
     
    //20211125改为ch1为AIN0+,AIN1为-；ch2为AIN2+,AIN3为-                                               
    'd1: initial_cfg_word <= {8'h10, 16'h8001}; // ch1为AIN0为+，AIN1为-
    'd2: initial_cfg_word <= {8'h11, 16'h8043}; // ch2为AIN2为+，AIN3为-
    'd3: initial_cfg_word <= {8'h12, 16'h0044}; // ch3关闭
    'd4: initial_cfg_word <= {8'h13, 16'h0064}; // ch4关闭

    'd5: initial_cfg_word <= {8'h20, 16'h1f00}; /****************************/
    'd6: initial_cfg_word <= {8'h21, 16'h1f00}; /****************************/
    'd7: initial_cfg_word <= {8'h22, 16'h1f00}; /****************************/
    'd8: initial_cfg_word <= {8'h23, 16'h1f00}; /****************************/

    //'d5 : initial_cfg_word <= {8'h20, 16'h1320}; /****************************/
    //'d6 : initial_cfg_word <= {8'h21, 16'h1320}; /*******     config   *******/
    //'d7 : initial_cfg_word <= {8'h22, 16'h1320}; /*******    register  *******/
    //'d8 : initial_cfg_word <= {8'h23, 16'h1320}; /****************************/
    'd9: initial_cfg_word <= {8'h02, 16'h10c2}; /****************************/
    default: initial_cfg_word <= {8'h0, 16'h0};
    endcase
end

always @(posedge clk)
begin
    if(~rst_n)
        ad7177_sck_initial <= 1'b1;
    else if(valid_initial_cycle)
    begin
        case(spi_state_cnt[4:0])
        'd31: ad7177_sck_initial <= 1'b0;
        'd15: ad7177_sck_initial <= 1'b1;
        default: ;
        endcase
    end
end

always @(posedge clk)
if(~rst_n)
    spi_state_cnt <= 'd0;
else if (initial_spi_trigger)
    spi_state_cnt <= reset_adc_cycle ? 32*64 : 32*24;
else if (adc_data_read_trigger)
    spi_state_cnt <= 32 * 32;
else if (spi_state_cnt != 'd0)
    spi_state_cnt <= spi_state_cnt - 'd1;

always @(posedge clk)
if(~rst_n)
    initial_wait_cnt <= INITIAL_WAIT_TIME;
else if (initial_wait_cnt != 'd0)
    initial_wait_cnt <= initial_wait_cnt - 'd1;

always @(posedge clk)
if(~rst_n)
    initial_time_cnt <= 'd0;
else if (initial_period)
begin
    if (initial_time_cnt == CFG_NUMBER * ONE_CFG_TIME)
        initial_time_cnt <= 'd0;
    else 
        initial_time_cnt <= initial_time_cnt + 'd1;
end

always @(posedge clk)
if(~rst_n)
    initial_period <= 'd0;
else if (initial_wait_cnt == 'd1)
    initial_period <= 1'b1;
else if(initial_time_cnt == CFG_NUMBER * ONE_CFG_TIME)
    initial_period <= 'd0;

always @(posedge clk)
begin
    ad7177_dout_18_d2 <= ad7177_dout_18_d1; ad7177_dout_18_d1 <= ad7177_dout_18;
    ad7177_dout_17_d2 <= ad7177_dout_17_d1; ad7177_dout_17_d1 <= ad7177_dout_17;
    ad7177_dout_16_d2 <= ad7177_dout_16_d1; ad7177_dout_16_d1 <= ad7177_dout_16;
    ad7177_dout_15_d2 <= ad7177_dout_15_d1; ad7177_dout_15_d1 <= ad7177_dout_15;
    ad7177_dout_14_d2 <= ad7177_dout_14_d1; ad7177_dout_14_d1 <= ad7177_dout_14;
    ad7177_dout_13_d2 <= ad7177_dout_13_d1; ad7177_dout_13_d1 <= ad7177_dout_13;
    ad7177_dout_12_d2 <= ad7177_dout_12_d1; ad7177_dout_12_d1 <= ad7177_dout_12;
    ad7177_dout_11_d2 <= ad7177_dout_11_d1; ad7177_dout_11_d1 <= ad7177_dout_11;
    ad7177_dout_10_d2 <= ad7177_dout_10_d1; ad7177_dout_10_d1 <= ad7177_dout_10;
    ad7177_dout_9_d2  <= ad7177_dout_9_d1;  ad7177_dout_9_d1  <= ad7177_dout_9;
    ad7177_dout_8_d2  <= ad7177_dout_8_d1;  ad7177_dout_8_d1  <= ad7177_dout_8;
    ad7177_dout_7_d2  <= ad7177_dout_7_d1;  ad7177_dout_7_d1  <= ad7177_dout_7;
    ad7177_dout_6_d2  <= ad7177_dout_6_d1;  ad7177_dout_6_d1  <= ad7177_dout_6;
    ad7177_dout_5_d2  <= ad7177_dout_5_d1;  ad7177_dout_5_d1  <= ad7177_dout_5;
    ad7177_dout_4_d2  <= ad7177_dout_4_d1;  ad7177_dout_4_d1  <= ad7177_dout_4;
    ad7177_dout_3_d2  <= ad7177_dout_3_d1;  ad7177_dout_3_d1  <= ad7177_dout_3;
    ad7177_dout_2_d2  <= ad7177_dout_2_d1;  ad7177_dout_2_d1  <= ad7177_dout_2;
    ad7177_dout_1_d2  <= ad7177_dout_1_d1;  ad7177_dout_1_d1  <= ad7177_dout_1;
    ad7177_dout_0_d2  <= ad7177_dout_0_d1;  ad7177_dout_0_d1  <= ad7177_dout_0;

    initial_period_d <= initial_period;
end

reg    [ 7:0]       trigger_wait_cnt; //以第一通道为基准，dout下降沿后等一个spi时钟，确保所有通道都就绪。

always @(posedge clk)
if(~rst_n)
    trigger_wait_cnt <= 'd0;
else if (ad7177_dout_7_d2 & (~ad7177_dout_7_d1) & adc_initiate_complete & (~adc_result_read_period))
    trigger_wait_cnt <= 'd32;
else if (trigger_wait_cnt != 'd0)
    trigger_wait_cnt <= trigger_wait_cnt - 'd1;

always @(posedge clk)
    adc_data_read_trigger <= (trigger_wait_cnt == 'd1);

always @(posedge clk)
if(~rst_n)
    adc_result_read_period <= 1'b0;
else if(adc_initiate_complete)
begin
    if(adc_data_read_trigger)
        adc_result_read_period <= 1'b1;
    else if (spi_state_cnt == 'd1)
        adc_result_read_period <= 1'b0;
end

always @(posedge clk)
if(~rst_n)
    adc_initiate_complete <= 1'b0;
else if (initial_period_d & (~initial_period))
    adc_initiate_complete <= 1'b1;

reg  [ 7:0]             trigger_value_send;
reg  [ 7:0]             uart_trig_data_reg;
reg  [ 3:0]             trigger_value_cnt;

always @(*)
    trigger_value_send <= (trigger_value_cnt == 'd0) ? 'd0 : uart_trig_data_reg;

always @(posedge clk)
if(~rst_n)
    trigger_value_cnt <= 'd0;
else if (uart_ri | usb_trigger_value_valid)
    trigger_value_cnt <= 'd11;
else if (result_write_trigger & (trigger_value_cnt != 'd0))
    trigger_value_cnt <= trigger_value_cnt - 'd1;

always @(posedge clk)
if(~rst_n)
    uart_trig_data_reg <= 1'b0;
else if (uart_ri)
    uart_trig_data_reg <= uart_trig_data;  
else if (usb_trigger_value_valid)  
    uart_trig_data_reg <= usb_trigger_value;  

adc_7177_result_process result_proc_18(.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout(ad7177_dout_18_d2), .adc_result_ch0(adc_result_chip_9_ch0), .adc_result_ch1(adc_result_chip_9_ch1), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_17(.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout(ad7177_dout_17_d2), .adc_result_ch0(adc_result_chip_8_ch2), .adc_result_ch1(adc_result_chip_8_ch3), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_16(.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout(ad7177_dout_16_d2), .adc_result_ch0(adc_result_chip_8_ch0), .adc_result_ch1(adc_result_chip_8_ch1), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_15(.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout(ad7177_dout_15_d2), .adc_result_ch0(adc_result_chip_7_ch2), .adc_result_ch1(adc_result_chip_7_ch3), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_14(.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout(ad7177_dout_14_d2), .adc_result_ch0(adc_result_chip_7_ch0), .adc_result_ch1(adc_result_chip_7_ch1), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_13(.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout(ad7177_dout_13_d2), .adc_result_ch0(adc_result_chip_6_ch2), .adc_result_ch1(adc_result_chip_6_ch3), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_12(.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout(ad7177_dout_12_d2), .adc_result_ch0(adc_result_chip_6_ch0), .adc_result_ch1(adc_result_chip_6_ch1), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_11(.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout(ad7177_dout_11_d2), .adc_result_ch0(adc_result_chip_5_ch2), .adc_result_ch1(adc_result_chip_5_ch3), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_10(.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout(ad7177_dout_10_d2), .adc_result_ch0(adc_result_chip_5_ch0), .adc_result_ch1(adc_result_chip_5_ch1), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_9 (.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout( ad7177_dout_9_d2), .adc_result_ch0(adc_result_chip_4_ch2), .adc_result_ch1(adc_result_chip_4_ch3), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_8 (.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout( ad7177_dout_8_d2), .adc_result_ch0(adc_result_chip_4_ch0), .adc_result_ch1(adc_result_chip_4_ch1), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_7 (.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout( ad7177_dout_7_d2), .adc_result_ch0(adc_result_chip_3_ch2), .adc_result_ch1(adc_result_chip_3_ch3), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger(result_write_trigger));
adc_7177_result_process result_proc_6 (.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout( ad7177_dout_6_d2), .adc_result_ch0(adc_result_chip_3_ch0), .adc_result_ch1(adc_result_chip_3_ch1), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_5 (.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout( ad7177_dout_5_d2), .adc_result_ch0(adc_result_chip_2_ch2), .adc_result_ch1(adc_result_chip_2_ch3), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_4 (.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout( ad7177_dout_4_d2), .adc_result_ch0(adc_result_chip_2_ch0), .adc_result_ch1(adc_result_chip_2_ch1), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_3 (.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout( ad7177_dout_3_d2), .adc_result_ch0(adc_result_chip_1_ch2), .adc_result_ch1(adc_result_chip_1_ch3), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_2 (.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout( ad7177_dout_2_d2), .adc_result_ch0(adc_result_chip_1_ch0), .adc_result_ch1(adc_result_chip_1_ch1), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_1 (.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout( ad7177_dout_1_d2), .adc_result_ch0(adc_result_chip_0_ch2), .adc_result_ch1(adc_result_chip_0_ch3), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());
adc_7177_result_process result_proc_0 (.clk(clk), .rst_n(rst_n), .read_trigger(adc_data_read_trigger), .read_period(adc_result_read_period), .spi_state_cnt(spi_state_cnt), .ad7177_dout( ad7177_dout_0_d2), .adc_result_ch0(adc_result_chip_0_ch0), .adc_result_ch1(adc_result_chip_0_ch1), .adc_result_ch2(), .adc_result_ch3(), .result_write_trigger());

always @(posedge clk)
begin
    ad7177_cs  <= ad7177_cs_initial;
    ad7177_sck <= ad7177_sck_initial;
    ad7177_din <= ad7177_din_initial;
end

reg    [31:0]    sync_timer_cnt;
reg    [31:0]    sync_timer_cycle_lat;
wire             sync_timer_cnt_ov = (sync_timer_cnt == sync_timer_cycle_lat);

always @(posedge clk)
if(~rst_n)
    sync_timer_cycle_lat <= 1263;
else if (sync_timer_cnt_ov)
    sync_timer_cycle_lat <= sample_period_clk_number_muxed;

always @(posedge clk)
if((~rst_n) | (~adc_initiate_complete))
    ad7177_sync <= 1'b0;
else if (sync_timer_cnt == 'd200)
    ad7177_sync <= 1'b1;
else if (sync_timer_cnt == 'd1000)
    ad7177_sync <= 1'b0;

always @(posedge clk)
if((~rst_n) | (~adc_initiate_complete))
    sync_timer_cnt <= 'd1;
else
begin
    if (sync_timer_cnt_ov)
        sync_timer_cnt <= 'd0;
    else 
        sync_timer_cnt <= sync_timer_cnt + 'd1;
end

reg                 adc_wren_cnt_done;
reg                 result_mux_period;
reg    [ 8:0]       result_mux_cnt;
reg    [31:0]       adc_result_muxed_pre;
reg    [31:0]       adc_result_muxed;
reg    [15:0]       adc_wren_cnt;

always @(posedge clk)
    adc_result_muxed <= adc_result_muxed_pre;
    
always @(posedge clk)
begin
    case(result_mux_cnt)
        9'd0  : adc_result_muxed_pre <= {24'hAA0000, trigger_value_send};
        9'd1  : adc_result_muxed_pre <= {16'h0000, 1'b0, adc_len_cnt};
        9'd2  : adc_result_muxed_pre <= {adc_result_chip_9_ch0, 4'b0};
        9'd3  : adc_result_muxed_pre <= 32'hFFFFFFFF;
        9'd4  : adc_result_muxed_pre <= {adc_result_chip_0_ch0, 4'b0};
        9'd5  : adc_result_muxed_pre <= {adc_result_chip_0_ch1, 4'b0};
        9'd6  : adc_result_muxed_pre <= {adc_result_chip_0_ch2, 4'b0};
        9'd7  : adc_result_muxed_pre <= {adc_result_chip_0_ch3, 4'b0};
        9'd8  : adc_result_muxed_pre <= {adc_result_chip_1_ch0, 4'b0};
        9'd9  : adc_result_muxed_pre <= {adc_result_chip_1_ch1, 4'b0};
        9'd10 : adc_result_muxed_pre <= {adc_result_chip_1_ch2, 4'b0};
        9'd11 : adc_result_muxed_pre <= {adc_result_chip_1_ch3, 4'b0};
        9'd12 : adc_result_muxed_pre <= {adc_result_chip_2_ch0, 4'b0};
        9'd13 : adc_result_muxed_pre <= {adc_result_chip_2_ch1, 4'b0};
        9'd14 : adc_result_muxed_pre <= {adc_result_chip_2_ch2, 4'b0};
        9'd15 : adc_result_muxed_pre <= {adc_result_chip_2_ch3, 4'b0};
        9'd16 : adc_result_muxed_pre <= {adc_result_chip_3_ch0, 4'b0};
        9'd17 : adc_result_muxed_pre <= {adc_result_chip_3_ch1, 4'b0};
        9'd18 : adc_result_muxed_pre <= {adc_result_chip_3_ch2, 4'b0};
        9'd19 : adc_result_muxed_pre <= {adc_result_chip_3_ch3, 4'b0};
        9'd20 : adc_result_muxed_pre <= {adc_result_chip_4_ch0, 4'b0};
        9'd21 : adc_result_muxed_pre <= {adc_result_chip_4_ch1, 4'b0};
        9'd22 : adc_result_muxed_pre <= {adc_result_chip_4_ch2, 4'b0};
        9'd23 : adc_result_muxed_pre <= {adc_result_chip_4_ch3, 4'b0};
        9'd24 : adc_result_muxed_pre <= {adc_result_chip_5_ch0, 4'b0};
        9'd25 : adc_result_muxed_pre <= {adc_result_chip_5_ch1, 4'b0};
        9'd26 : adc_result_muxed_pre <= {adc_result_chip_5_ch2, 4'b0};
        9'd27 : adc_result_muxed_pre <= {adc_result_chip_5_ch3, 4'b0};
        9'd28 : adc_result_muxed_pre <= {adc_result_chip_6_ch0, 4'b0};
        9'd29 : adc_result_muxed_pre <= {adc_result_chip_6_ch1, 4'b0};
        9'd30 : adc_result_muxed_pre <= {adc_result_chip_6_ch2, 4'b0};
        9'd31 : adc_result_muxed_pre <= {adc_result_chip_6_ch3, 4'b0};
        9'd32 : adc_result_muxed_pre <= {adc_result_chip_7_ch0, 4'b0};
        9'd33 : adc_result_muxed_pre <= {adc_result_chip_7_ch1, 4'b0};
        9'd34 : adc_result_muxed_pre <= {adc_result_chip_7_ch2, 4'b0};
        9'd35 : adc_result_muxed_pre <= {adc_result_chip_7_ch3, 4'b0};
        9'd36 : adc_result_muxed_pre <= {adc_result_chip_8_ch0, 4'b0};
        9'd37 : adc_result_muxed_pre <= {adc_result_chip_8_ch1, 4'b0};
        9'd38 : adc_result_muxed_pre <= {adc_result_chip_8_ch2, 4'b0};
        9'd39 : adc_result_muxed_pre <= {adc_result_chip_8_ch3, 4'b0};
        9'd40 : adc_result_muxed_pre <= {adc_result_chip_0_ch0_com1, 4'b0};
        9'd41 : adc_result_muxed_pre <= {adc_result_chip_0_ch1_com1, 4'b0};
        9'd42 : adc_result_muxed_pre <= {adc_result_chip_0_ch2_com1, 4'b0};
        9'd43 : adc_result_muxed_pre <= {adc_result_chip_0_ch3_com1, 4'b0};
        9'd44 : adc_result_muxed_pre <= {adc_result_chip_1_ch0_com1, 4'b0};
        9'd45 : adc_result_muxed_pre <= {adc_result_chip_1_ch1_com1, 4'b0};
        9'd46 : adc_result_muxed_pre <= {adc_result_chip_1_ch2_com1, 4'b0};
        9'd47 : adc_result_muxed_pre <= {adc_result_chip_1_ch3_com1, 4'b0};
        9'd48 : adc_result_muxed_pre <= {adc_result_chip_2_ch0_com1, 4'b0};
        9'd49 : adc_result_muxed_pre <= {adc_result_chip_2_ch1_com1, 4'b0};
        9'd50 : adc_result_muxed_pre <= {adc_result_chip_2_ch2_com1, 4'b0};
        9'd51 : adc_result_muxed_pre <= {adc_result_chip_2_ch3_com1, 4'b0};
        9'd52 : adc_result_muxed_pre <= {adc_result_chip_3_ch0_com1, 4'b0};
        9'd53 : adc_result_muxed_pre <= {adc_result_chip_3_ch1_com1, 4'b0};
        9'd54 : adc_result_muxed_pre <= {adc_result_chip_3_ch2_com1, 4'b0};
        9'd55 : adc_result_muxed_pre <= {adc_result_chip_3_ch3_com1, 4'b0};
        9'd56 : adc_result_muxed_pre <= {adc_result_chip_4_ch0_com1, 4'b0};
        9'd57 : adc_result_muxed_pre <= {adc_result_chip_4_ch1_com1, 4'b0};
        9'd58 : adc_result_muxed_pre <= {adc_result_chip_4_ch2_com1, 4'b0};
        9'd59 : adc_result_muxed_pre <= {adc_result_chip_4_ch3_com1, 4'b0};
        9'd60 : adc_result_muxed_pre <= {adc_result_chip_5_ch0_com1, 4'b0};
        9'd61 : adc_result_muxed_pre <= {adc_result_chip_5_ch1_com1, 4'b0};
        9'd62 : adc_result_muxed_pre <= {adc_result_chip_5_ch2_com1, 4'b0};
        9'd63 : adc_result_muxed_pre <= {adc_result_chip_5_ch3_com1, 4'b0};
        9'd64 : adc_result_muxed_pre <= {adc_result_chip_6_ch0_com1, 4'b0};
        9'd65 : adc_result_muxed_pre <= {adc_result_chip_6_ch1_com1, 4'b0};
        9'd66 : adc_result_muxed_pre <= {adc_result_chip_6_ch2_com1, 4'b0};
        9'd67 : adc_result_muxed_pre <= {adc_result_chip_6_ch3_com1, 4'b0};
        9'd68 : adc_result_muxed_pre <= {adc_result_chip_7_ch0_com1, 4'b0};
        9'd69 : adc_result_muxed_pre <= {adc_result_chip_7_ch1_com1, 4'b0};
        9'd70 : adc_result_muxed_pre <= {adc_result_chip_7_ch2_com1, 4'b0};
        9'd71 : adc_result_muxed_pre <= {adc_result_chip_7_ch3_com1, 4'b0};
        9'd72 : adc_result_muxed_pre <= {adc_result_chip_8_ch0_com1, 4'b0};
        9'd73 : adc_result_muxed_pre <= {adc_result_chip_8_ch1_com1, 4'b0};
        9'd74 : adc_result_muxed_pre <= {adc_result_chip_8_ch2_com1, 4'b0};
        9'd75 : adc_result_muxed_pre <= {adc_result_chip_8_ch3_com1, 4'b0};
        9'd76 : adc_result_muxed_pre <= {adc_result_chip_0_ch0_com2, 4'b0};
        9'd77 : adc_result_muxed_pre <= {adc_result_chip_0_ch1_com2, 4'b0};
        9'd78 : adc_result_muxed_pre <= {adc_result_chip_0_ch2_com2, 4'b0};
        9'd79 : adc_result_muxed_pre <= {adc_result_chip_0_ch3_com2, 4'b0};
        9'd80 : adc_result_muxed_pre <= {adc_result_chip_1_ch0_com2, 4'b0};
        9'd81 : adc_result_muxed_pre <= {adc_result_chip_1_ch1_com2, 4'b0};
        9'd82 : adc_result_muxed_pre <= {adc_result_chip_1_ch2_com2, 4'b0};
        9'd83 : adc_result_muxed_pre <= {adc_result_chip_1_ch3_com2, 4'b0};
        9'd84 : adc_result_muxed_pre <= {adc_result_chip_2_ch0_com2, 4'b0};
        9'd85 : adc_result_muxed_pre <= {adc_result_chip_2_ch1_com2, 4'b0};
        9'd86 : adc_result_muxed_pre <= {adc_result_chip_2_ch2_com2, 4'b0};
        9'd87 : adc_result_muxed_pre <= {adc_result_chip_2_ch3_com2, 4'b0};
        9'd88 : adc_result_muxed_pre <= {adc_result_chip_3_ch0_com2, 4'b0};
        9'd89 : adc_result_muxed_pre <= {adc_result_chip_3_ch1_com2, 4'b0};
        9'd90 : adc_result_muxed_pre <= {adc_result_chip_3_ch2_com2, 4'b0};
        9'd91 : adc_result_muxed_pre <= {adc_result_chip_3_ch3_com2, 4'b0};
        9'd92 : adc_result_muxed_pre <= {adc_result_chip_4_ch0_com2, 4'b0};
        9'd93 : adc_result_muxed_pre <= {adc_result_chip_4_ch1_com2, 4'b0};
        9'd94 : adc_result_muxed_pre <= {adc_result_chip_4_ch2_com2, 4'b0};
        9'd95 : adc_result_muxed_pre <= {adc_result_chip_4_ch3_com2, 4'b0};
        9'd96 : adc_result_muxed_pre <= {adc_result_chip_5_ch0_com2, 4'b0};
        9'd97 : adc_result_muxed_pre <= {adc_result_chip_5_ch1_com2, 4'b0};
        9'd98 : adc_result_muxed_pre <= {adc_result_chip_5_ch2_com2, 4'b0};
        9'd99 : adc_result_muxed_pre <= {adc_result_chip_5_ch3_com2, 4'b0};
        9'd100: adc_result_muxed_pre <= {adc_result_chip_6_ch0_com2, 4'b0};
        9'd101: adc_result_muxed_pre <= {adc_result_chip_6_ch1_com2, 4'b0};
        9'd102: adc_result_muxed_pre <= {adc_result_chip_6_ch2_com2, 4'b0};
        9'd103: adc_result_muxed_pre <= {adc_result_chip_6_ch3_com2, 4'b0};
        9'd104: adc_result_muxed_pre <= {adc_result_chip_7_ch0_com2, 4'b0};
        9'd105: adc_result_muxed_pre <= {adc_result_chip_7_ch1_com2, 4'b0};
        9'd106: adc_result_muxed_pre <= {adc_result_chip_7_ch2_com2, 4'b0};
        9'd107: adc_result_muxed_pre <= {adc_result_chip_7_ch3_com2, 4'b0};
        9'd108: adc_result_muxed_pre <= {adc_result_chip_8_ch0_com2, 4'b0};
        9'd109: adc_result_muxed_pre <= {adc_result_chip_8_ch1_com2, 4'b0};
        9'd110: adc_result_muxed_pre <= {adc_result_chip_8_ch2_com2, 4'b0};
        9'd111: adc_result_muxed_pre <= {adc_result_chip_8_ch3_com2, 4'b0};
        9'd112: adc_result_muxed_pre <= {adc_result_chip_0_ch0_com3, 4'b0};
        9'd113: adc_result_muxed_pre <= {adc_result_chip_0_ch1_com3, 4'b0};
        9'd114: adc_result_muxed_pre <= {adc_result_chip_0_ch2_com3, 4'b0};
        9'd115: adc_result_muxed_pre <= {adc_result_chip_0_ch3_com3, 4'b0};
        9'd116: adc_result_muxed_pre <= {adc_result_chip_1_ch0_com3, 4'b0};
        9'd117: adc_result_muxed_pre <= {adc_result_chip_1_ch1_com3, 4'b0};
        9'd118: adc_result_muxed_pre <= {adc_result_chip_1_ch2_com3, 4'b0};
        9'd119: adc_result_muxed_pre <= {adc_result_chip_1_ch3_com3, 4'b0};
        9'd120: adc_result_muxed_pre <= {adc_result_chip_2_ch0_com3, 4'b0};
        9'd121: adc_result_muxed_pre <= {adc_result_chip_2_ch1_com3, 4'b0};
        9'd122: adc_result_muxed_pre <= {adc_result_chip_2_ch2_com3, 4'b0};
        9'd123: adc_result_muxed_pre <= {adc_result_chip_2_ch3_com3, 4'b0};
        9'd124: adc_result_muxed_pre <= {adc_result_chip_3_ch0_com3, 4'b0};
        9'd125: adc_result_muxed_pre <= {adc_result_chip_3_ch1_com3, 4'b0};
        9'd126: adc_result_muxed_pre <= {adc_result_chip_3_ch2_com3, 4'b0};
        9'd127: adc_result_muxed_pre <= {adc_result_chip_3_ch3_com3, 4'b0};
        9'd128: adc_result_muxed_pre <= {adc_result_chip_4_ch0_com3, 4'b0};
        9'd129: adc_result_muxed_pre <= {adc_result_chip_4_ch1_com3, 4'b0};
        9'd130: adc_result_muxed_pre <= {adc_result_chip_4_ch2_com3, 4'b0};
        9'd131: adc_result_muxed_pre <= {adc_result_chip_4_ch3_com3, 4'b0};
        9'd132: adc_result_muxed_pre <= {adc_result_chip_5_ch0_com3, 4'b0};
        9'd133: adc_result_muxed_pre <= {adc_result_chip_5_ch1_com3, 4'b0};
        9'd134: adc_result_muxed_pre <= {adc_result_chip_5_ch2_com3, 4'b0};
        9'd135: adc_result_muxed_pre <= {adc_result_chip_5_ch3_com3, 4'b0};
        9'd136: adc_result_muxed_pre <= {adc_result_chip_6_ch0_com3, 4'b0};
        9'd137: adc_result_muxed_pre <= {adc_result_chip_6_ch1_com3, 4'b0};
        9'd138: adc_result_muxed_pre <= {adc_result_chip_6_ch2_com3, 4'b0};
        9'd139: adc_result_muxed_pre <= {adc_result_chip_6_ch3_com3, 4'b0};
        9'd140: adc_result_muxed_pre <= {adc_result_chip_7_ch0_com3, 4'b0};
        9'd141: adc_result_muxed_pre <= {adc_result_chip_7_ch1_com3, 4'b0};
        9'd142: adc_result_muxed_pre <= {adc_result_chip_7_ch2_com3, 4'b0};
        9'd143: adc_result_muxed_pre <= {adc_result_chip_7_ch3_com3, 4'b0};
        9'd144: adc_result_muxed_pre <= {adc_result_chip_8_ch0_com3, 4'b0};
        9'd145: adc_result_muxed_pre <= {adc_result_chip_8_ch1_com3, 4'b0};
        9'd146: adc_result_muxed_pre <= {adc_result_chip_8_ch2_com3, 4'b0};
        9'd147: adc_result_muxed_pre <= {adc_result_chip_8_ch3_com3, 4'b0};
        9'd255: adc_result_muxed_pre <= 32'h000000CC;
    default: 
        adc_result_muxed_pre <= 0;
    endcase
end

always @(*)
    adc_data <= {adc_result_muxed[7:0], adc_result_muxed[15:8], adc_result_muxed[23:16], adc_result_muxed[31:24]};

always @(posedge clk)
if ((~rst_n) | result_write_trigger)
    result_mux_cnt <= 'd0;
else if (result_mux_period)
    result_mux_cnt <= result_mux_cnt + 'd1;
  
always @(posedge clk)
if ((~rst_n) | result_write_trigger)
    result_mux_period <= 1'b0;
else if (adc_wren_cnt == 'd285)
    result_mux_period <= 1'b1;
else if (adc_wren_cnt == 'd285 - 'd257)
    result_mux_period <= 1'b0;

always @(posedge clk)
    adc_wren_cnt_done <= (adc_wren_cnt == 'd1);

always @(posedge clk)
if ((~rst_n) | (~adc_sample_en))
    adc_len_cnt <= 'd0;
else if (adc_wren_cnt_done)
    adc_len_cnt <= adc_len_cnt + 15'd1;

always @(posedge clk)
if (~rst_n)
    adc_wren_cnt <= 'd0;
else if (result_write_trigger)
    adc_wren_cnt <= 'd286;
else if (adc_wren_cnt != 'd0)
    adc_wren_cnt <= adc_wren_cnt - 'd1;

always @(posedge clk)
if (~rst_n)
    adc_wren <= 1'b0;
else if (adc_wren_cnt == 'd283)
    adc_wren <= 1'b1;
else if (adc_wren_cnt == 'd283 - 'd256)
    adc_wren <= 1'b0;

/************************************************************************************************
级联输出功能，
连线采用4线通讯。CS,SCK,DATA0,DATA1。
SCK频率为系统频率16分频，也即3M，每个通道28位ADC结果通过14个SCK完成，即4.7微秒
一个板子36导联需要36×14=504个时钟，168微秒。
************************************************************************************************/

reg                 impedance_trigger_switch_pre;
reg                 impedance_trigger_switch;

reg                 jl_master_cs_out;
reg                 jl_master_sck_out;
reg                 jl_master_data_out0;
reg                 jl_master_data_out1;
reg                 usb_cfg_valid_2_send;

reg  [11:0]         jl_master_state_cnt;
wire [ 3:0]         jl_master_bit_index = jl_master_state_cnt[7:4];
wire [ 3:0]         jl_master_w32_index = jl_master_state_cnt[11:8];
reg  [31:0]         jl_master_w32_2_send;

always @(posedge clk)
begin
    case(jl_master_bit_index)
    'd0 : {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[1 :0 ];
    'd1 : {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[3 :2 ];
    'd2 : {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[5 :4 ];
    'd3 : {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[7 :6 ];
    'd4 : {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[9 :8 ];
    'd5 : {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[11:10];
    'd6 : {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[13:12];
    'd7 : {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[15:14];
    'd8 : {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[17:16];
    'd9 : {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[19:18];
    'd10: {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[21:20];
    'd11: {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[23:22];
    'd12: {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[25:24];
    'd13: {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[27:26];
    'd14: {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[29:28];
    'd15: {jl_master_data_out1, jl_master_data_out0} <= jl_master_w32_2_send[31:30];
    default: ;
    endcase
end

always @(posedge clk)
if (~rst_n)
    usb_cfg_valid_2_send <= 0;
else if(usb_cfg_valid)
    usb_cfg_valid_2_send <= 1;
else if(jl_master_state_cnt == 392)
    usb_cfg_valid_2_send <= 0;

always @(*)
begin
    case (jl_master_w32_index)
    'd0: jl_master_w32_2_send <= adc_trigger_length;
    'd1: jl_master_w32_2_send <= {adc_sample_en, usb_cfg_valid_2_send, usb_cfg_bus};
    'd2: jl_master_w32_2_send <= adc_sample_period;
    default: jl_master_w32_2_send <= 0;
    endcase
end

always @(posedge clk)
if (~rst_n)
    jl_master_sck_out <= 0;
else if(jl_master_state_cnt[3:0] == 7)
    jl_master_sck_out <= ~jl_master_cs_out;
else if(jl_master_state_cnt[3:0] == 15)
    jl_master_sck_out <= 0;

always @(posedge clk)
if (~rst_n)
    jl_master_cs_out <= 1;
else if(jl_master_state_cnt == 1)
    jl_master_cs_out <= 0;
else if(jl_master_state_cnt == 1024)
    jl_master_cs_out <= 1;

always @(posedge clk)
if (~rst_n)
    jl_master_state_cnt <= 0;
else 
    jl_master_state_cnt <= jl_master_state_cnt + 'd1;

reg                 jl_slave_cs_out;
reg                 jl_slave_sck_out;
reg                 jl_slave_data_out0;
reg                 jl_slave_data_out1;

wire                jl_out_trigger = (sync_timer_cnt == 10);
reg    [27:0]       jl_out_chip_8_ch0, jl_out_chip_8_ch1, jl_out_chip_8_ch2, jl_out_chip_8_ch3;
reg    [27:0]       jl_out_chip_7_ch0, jl_out_chip_7_ch1, jl_out_chip_7_ch2, jl_out_chip_7_ch3;
reg    [27:0]       jl_out_chip_6_ch0, jl_out_chip_6_ch1, jl_out_chip_6_ch2, jl_out_chip_6_ch3;
reg    [27:0]       jl_out_chip_5_ch0, jl_out_chip_5_ch1, jl_out_chip_5_ch2, jl_out_chip_5_ch3;
reg    [27:0]       jl_out_chip_4_ch0, jl_out_chip_4_ch1, jl_out_chip_4_ch2, jl_out_chip_4_ch3;
reg    [27:0]       jl_out_chip_3_ch0, jl_out_chip_3_ch1, jl_out_chip_3_ch2, jl_out_chip_3_ch3;
reg    [27:0]       jl_out_chip_2_ch0, jl_out_chip_2_ch1, jl_out_chip_2_ch2, jl_out_chip_2_ch3;
reg    [27:0]       jl_out_chip_1_ch0, jl_out_chip_1_ch1, jl_out_chip_1_ch2, jl_out_chip_1_ch3;
reg    [27:0]       jl_out_chip_0_ch0, jl_out_chip_0_ch1, jl_out_chip_0_ch2, jl_out_chip_0_ch3;

reg    [ 7:0]       jl_out_ch_cnt;
wire                jl_out_ch_cnt_ov = (jl_out_ch_cnt == (37 - 1));
reg    [ 7:0]       jl_out_basic_cnt;
wire                jl_out_basic_cnt_ov = (jl_out_basic_cnt == (16*14 - 1));
reg                 jl_out_period;
reg    [27:0]       jl_out_word;

always @(*)
begin
    case(jl_out_ch_cnt)
    'd0 : jl_out_word <= impedance_trigger_switch ? real_max_value_1[31:4] : jl_out_chip_0_ch0;
    'd1 : jl_out_word <= impedance_trigger_switch ? real_max_value_2[31:4] : jl_out_chip_0_ch1;
    'd2 : jl_out_word <= impedance_trigger_switch ? real_max_value_3[31:4] : jl_out_chip_0_ch2;
    'd3 : jl_out_word <= impedance_trigger_switch ? real_max_value_4[31:4] : jl_out_chip_0_ch3;
    'd4 : jl_out_word <= impedance_trigger_switch ? real_max_value_5[31:4] : jl_out_chip_1_ch0;
    'd5 : jl_out_word <= impedance_trigger_switch ? real_max_value_6[31:4] : jl_out_chip_1_ch1;
    'd6 : jl_out_word <= impedance_trigger_switch ? real_max_value_7[31:4] : jl_out_chip_1_ch2;
    'd7 : jl_out_word <= impedance_trigger_switch ? real_max_value_8[31:4] : jl_out_chip_1_ch3;
    'd8 : jl_out_word <= impedance_trigger_switch ? real_max_value_9[31:4] : jl_out_chip_2_ch0;
    'd9 : jl_out_word <= impedance_trigger_switch ? real_max_value_10[31:4]: jl_out_chip_2_ch1;
    'd10: jl_out_word <= impedance_trigger_switch ? real_max_value_11[31:4]: jl_out_chip_2_ch2;
    'd11: jl_out_word <= impedance_trigger_switch ? real_max_value_12[31:4]: jl_out_chip_2_ch3;
    'd12: jl_out_word <= impedance_trigger_switch ? real_max_value_13[31:4]: jl_out_chip_3_ch0;
    'd13: jl_out_word <= impedance_trigger_switch ? real_max_value_14[31:4]: jl_out_chip_3_ch1;
    'd14: jl_out_word <= impedance_trigger_switch ? real_max_value_15[31:4]: jl_out_chip_3_ch2;
    'd15: jl_out_word <= impedance_trigger_switch ? real_max_value_16[31:4]: jl_out_chip_3_ch3;
    'd16: jl_out_word <= impedance_trigger_switch ? real_max_value_17[31:4]: jl_out_chip_4_ch0;
    'd17: jl_out_word <= impedance_trigger_switch ? real_max_value_18[31:4]: jl_out_chip_4_ch1;
    'd18: jl_out_word <= impedance_trigger_switch ? real_max_value_19[31:4]: jl_out_chip_4_ch2;
    'd19: jl_out_word <= impedance_trigger_switch ? real_max_value_20[31:4]: jl_out_chip_4_ch3;
    'd20: jl_out_word <= impedance_trigger_switch ? real_max_value_21[31:4]: jl_out_chip_5_ch0;
    'd21: jl_out_word <= impedance_trigger_switch ? real_max_value_22[31:4]: jl_out_chip_5_ch1;
    'd22: jl_out_word <= impedance_trigger_switch ? real_max_value_23[31:4]: jl_out_chip_5_ch2;
    'd23: jl_out_word <= impedance_trigger_switch ? real_max_value_24[31:4]: jl_out_chip_5_ch3;
    'd24: jl_out_word <= impedance_trigger_switch ? real_max_value_25[31:4]: jl_out_chip_6_ch0;
    'd25: jl_out_word <= impedance_trigger_switch ? real_max_value_26[31:4]: jl_out_chip_6_ch1;
    'd26: jl_out_word <= impedance_trigger_switch ? real_max_value_27[31:4]: jl_out_chip_6_ch2;
    'd27: jl_out_word <= impedance_trigger_switch ? real_max_value_28[31:4]: jl_out_chip_6_ch3;
    'd28: jl_out_word <= impedance_trigger_switch ? real_max_value_29[31:4]: jl_out_chip_7_ch0;
    'd29: jl_out_word <= impedance_trigger_switch ? real_max_value_30[31:4]: jl_out_chip_7_ch1;
    'd30: jl_out_word <= impedance_trigger_switch ? real_max_value_31[31:4]: jl_out_chip_7_ch2;
    'd31: jl_out_word <= impedance_trigger_switch ? real_max_value_32[31:4]: jl_out_chip_7_ch3;
    'd32: jl_out_word <= impedance_trigger_switch ? real_max_value_33[31:4]: jl_out_chip_8_ch0;
    'd33: jl_out_word <= impedance_trigger_switch ? real_max_value_34[31:4]: jl_out_chip_8_ch1;
    'd34: jl_out_word <= impedance_trigger_switch ? real_max_value_35[31:4]: jl_out_chip_8_ch2;
    'd35: jl_out_word <= impedance_trigger_switch ? real_max_value_36[31:4]: jl_out_chip_8_ch3;
    default: jl_out_word <= 0;
    endcase
end

always @(posedge clk)
begin
    if(jl_out_trigger)
    begin
        {jl_out_chip_8_ch0, jl_out_chip_8_ch1, jl_out_chip_8_ch2, jl_out_chip_8_ch3} <= {adc_result_chip_8_ch0, adc_result_chip_8_ch1, adc_result_chip_8_ch2, adc_result_chip_8_ch3};
        {jl_out_chip_7_ch0, jl_out_chip_7_ch1, jl_out_chip_7_ch2, jl_out_chip_7_ch3} <= {adc_result_chip_7_ch0, adc_result_chip_7_ch1, adc_result_chip_7_ch2, adc_result_chip_7_ch3};
        {jl_out_chip_6_ch0, jl_out_chip_6_ch1, jl_out_chip_6_ch2, jl_out_chip_6_ch3} <= {adc_result_chip_6_ch0, adc_result_chip_6_ch1, adc_result_chip_6_ch2, adc_result_chip_6_ch3};
        {jl_out_chip_5_ch0, jl_out_chip_5_ch1, jl_out_chip_5_ch2, jl_out_chip_5_ch3} <= {adc_result_chip_5_ch0, adc_result_chip_5_ch1, adc_result_chip_5_ch2, adc_result_chip_5_ch3};
        {jl_out_chip_4_ch0, jl_out_chip_4_ch1, jl_out_chip_4_ch2, jl_out_chip_4_ch3} <= {adc_result_chip_4_ch0, adc_result_chip_4_ch1, adc_result_chip_4_ch2, adc_result_chip_4_ch3};
        {jl_out_chip_3_ch0, jl_out_chip_3_ch1, jl_out_chip_3_ch2, jl_out_chip_3_ch3} <= {adc_result_chip_3_ch0, adc_result_chip_3_ch1, adc_result_chip_3_ch2, adc_result_chip_3_ch3};
        {jl_out_chip_2_ch0, jl_out_chip_2_ch1, jl_out_chip_2_ch2, jl_out_chip_2_ch3} <= {adc_result_chip_2_ch0, adc_result_chip_2_ch1, adc_result_chip_2_ch2, adc_result_chip_2_ch3};
        {jl_out_chip_1_ch0, jl_out_chip_1_ch1, jl_out_chip_1_ch2, jl_out_chip_1_ch3} <= {adc_result_chip_1_ch0, adc_result_chip_1_ch1, adc_result_chip_1_ch2, adc_result_chip_1_ch3};
        {jl_out_chip_0_ch0, jl_out_chip_0_ch1, jl_out_chip_0_ch2, jl_out_chip_0_ch3} <= {adc_result_chip_0_ch0, adc_result_chip_0_ch1, adc_result_chip_0_ch2, adc_result_chip_0_ch3};
    end
end

always @(posedge clk)
begin
    if ((~rst_n) | (~adc_sample_en))
        jl_slave_sck_out <= 0;
    else
    begin
        case (jl_out_basic_cnt[3:0])
        'd7 : jl_slave_sck_out <= 1;
        'd15: jl_slave_sck_out <= 0;
        default: ;
        endcase
    end
end

always @(posedge clk)
begin
    case (jl_out_basic_cnt[7:4])
    'd0 : {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[1 :0 ];
    'd1 : {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[3 :2 ];
    'd2 : {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[5 :4 ];
    'd3 : {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[7 :6 ];
    'd4 : {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[9 :8 ];
    'd5 : {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[11:10];
    'd6 : {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[13:12];
    'd7 : {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[15:14];
    'd8 : {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[17:16];
    'd9 : {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[19:18];
    'd10: {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[21:20];
    'd11: {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[23:22];
    'd12: {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[25:24];
    'd13: {jl_slave_data_out1, jl_slave_data_out0} <= jl_out_word[27:26];
    default: ;
    endcase              
end

always @(posedge clk)
if ((~rst_n) | (~adc_sample_en))
    jl_out_ch_cnt <= 0;
else if(jl_out_basic_cnt_ov)	
    jl_out_ch_cnt <= jl_out_ch_cnt_ov ? 0 : (jl_out_ch_cnt + 1);
  
always @(posedge clk)
if ((~rst_n) | (~adc_sample_en))
    jl_out_basic_cnt <= 0;
else if(jl_out_period)	
    jl_out_basic_cnt <= jl_out_basic_cnt_ov ? 0 : (jl_out_basic_cnt + 1);

	
always @(posedge clk)
if ((~rst_n) | (~adc_sample_en))
    jl_out_period <= 0;
else if(jl_out_trigger)
    jl_out_period <= 1;
else if(jl_out_basic_cnt_ov & jl_out_ch_cnt_ov)
    jl_out_period <= 0;

always @(posedge clk)
if ((~rst_n) | (~adc_sample_en))
    jl_slave_cs_out <= 1;
else if(jl_out_trigger)
    jl_slave_cs_out <= 0;
else if(jl_out_basic_cnt_ov & jl_out_ch_cnt_ov)
    jl_slave_cs_out <= 1;

always @(posedge clk)
begin
    jl_cs_out    <= (sw0_d & sw1_d) ? jl_master_cs_out    : jl_slave_cs_out;
    jl_sck_out   <= (sw0_d & sw1_d) ? jl_master_sck_out   : jl_slave_sck_out;
    jl_data_out0 <= (sw0_d & sw1_d) ? jl_master_data_out0 : jl_slave_data_out0;
    jl_data_out1 <= (sw0_d & sw1_d) ? jl_master_data_out1 : jl_slave_data_out1;
end                      

/************************************************************************************************
级联输入功能，
连线采用4线通讯。CS,SCK,DATA0,DATA1。
SCK频率为系统频率16分频，也即3M，每个通道28位ADC结果通过14个SCK完成，即4.7微秒
一个板子36导联需要36×14=504个时钟，168微秒。
************************************************************************************************/
reg    [ 7:0]       jl_com1_in_bit_cnt_slave;
reg                 jl_com1_cs_in_d1;
reg                 jl_com1_cs_in_d2;
reg                 jl_com1_cs_in_d3;
reg                 jl_com1_sck_in_d1;
reg                 jl_com1_sck_in_d2;
reg                 jl_com1_sck_in_d3;
wire                jl_com1_sck_in_r = jl_com1_sck_in_d2 & (~jl_com1_sck_in_d3);
wire                jl_com1_cs_in_f = jl_com1_cs_in_d3 & (~jl_com1_cs_in_d2);
wire                jl_com1_cs_in_r = jl_com1_cs_in_d2 & (~jl_com1_cs_in_d3);
reg                 jl_com1_data_in0_d;
reg                 jl_com1_data_in1_d;

reg    [ 7:0]       jl_com2_in_bit_cnt_slave;
reg                 jl_com2_cs_in_d1;
reg                 jl_com2_cs_in_d2;
reg                 jl_com2_cs_in_d3;
reg                 jl_com2_sck_in_d1;
reg                 jl_com2_sck_in_d2;
reg                 jl_com2_sck_in_d3;
wire                jl_com2_sck_in_r = jl_com2_sck_in_d2 & (~jl_com2_sck_in_d3);
wire                jl_com2_cs_in_f = jl_com2_cs_in_d3 & (~jl_com2_cs_in_d2);
wire                jl_com2_cs_in_r = jl_com2_cs_in_d2 & (~jl_com2_cs_in_d3);
reg                 jl_com2_data_in0_d;
reg                 jl_com2_data_in1_d;

reg    [ 7:0]       jl_com3_in_bit_cnt_slave;
reg                 jl_com3_cs_in_d1;
reg                 jl_com3_cs_in_d2;
reg                 jl_com3_cs_in_d3;
reg                 jl_com3_sck_in_d1;
reg                 jl_com3_sck_in_d2;
reg                 jl_com3_sck_in_d3;
wire                jl_com3_sck_in_r = jl_com3_sck_in_d2 & (~jl_com3_sck_in_d3);
wire                jl_com3_cs_in_f = jl_com3_cs_in_d3 & (~jl_com3_cs_in_d2);
wire                jl_com3_cs_in_r = jl_com3_cs_in_d2 & (~jl_com3_cs_in_d3);
reg                 jl_com3_data_in0_d;
reg                 jl_com3_data_in1_d;

reg    [ 7:0]       jl_com1_din_bit_index;
reg    [ 7:0]       jl_com1_din_word_index;
reg    [ 7:0]       jl_com1_din_word_index_d;
reg    [27:0]       jl_com1_din_shift;
reg                 jl_com1_din_vld_point;

reg    [ 7:0]       jl_com2_din_bit_index;
reg    [ 7:0]       jl_com2_din_word_index;
reg    [ 7:0]       jl_com2_din_word_index_d;
reg    [27:0]       jl_com2_din_shift;
reg                 jl_com2_din_vld_point;

reg    [ 7:0]       jl_com3_din_bit_index;
reg    [ 7:0]       jl_com3_din_word_index;
reg    [ 7:0]       jl_com3_din_word_index_d;
reg    [27:0]       jl_com3_din_shift;
reg                 jl_com3_din_vld_point;

always @(posedge clk)
if (sw1_d & sw0_d & (~impedance_trigger_switch))
begin
    if(jl_com1_din_vld_point)
    begin
        case(jl_com1_din_word_index_d)
        'd0 : adc_result_chip_0_ch0_com1 <= jl_com1_din_shift;
        'd1 : adc_result_chip_0_ch1_com1 <= jl_com1_din_shift;
        'd2 : adc_result_chip_0_ch2_com1 <= jl_com1_din_shift;
        'd3 : adc_result_chip_0_ch3_com1 <= jl_com1_din_shift;
        'd4 : adc_result_chip_1_ch0_com1 <= jl_com1_din_shift;
        'd5 : adc_result_chip_1_ch1_com1 <= jl_com1_din_shift;
        'd6 : adc_result_chip_1_ch2_com1 <= jl_com1_din_shift;
        'd7 : adc_result_chip_1_ch3_com1 <= jl_com1_din_shift;
        'd8 : adc_result_chip_2_ch0_com1 <= jl_com1_din_shift;
        'd9 : adc_result_chip_2_ch1_com1 <= jl_com1_din_shift;
        'd10: adc_result_chip_2_ch2_com1 <= jl_com1_din_shift;
        'd11: adc_result_chip_2_ch3_com1 <= jl_com1_din_shift;
        'd12: adc_result_chip_3_ch0_com1 <= jl_com1_din_shift;
        'd13: adc_result_chip_3_ch1_com1 <= jl_com1_din_shift;
        'd14: adc_result_chip_3_ch2_com1 <= jl_com1_din_shift;
        'd15: adc_result_chip_3_ch3_com1 <= jl_com1_din_shift;
        'd16: adc_result_chip_4_ch0_com1 <= jl_com1_din_shift;
        'd17: adc_result_chip_4_ch1_com1 <= jl_com1_din_shift;
        'd18: adc_result_chip_4_ch2_com1 <= jl_com1_din_shift;
        'd19: adc_result_chip_4_ch3_com1 <= jl_com1_din_shift;
        'd20: adc_result_chip_5_ch0_com1 <= jl_com1_din_shift;
        'd21: adc_result_chip_5_ch1_com1 <= jl_com1_din_shift;
        'd22: adc_result_chip_5_ch2_com1 <= jl_com1_din_shift;
        'd23: adc_result_chip_5_ch3_com1 <= jl_com1_din_shift;
        'd24: adc_result_chip_6_ch0_com1 <= jl_com1_din_shift;
        'd25: adc_result_chip_6_ch1_com1 <= jl_com1_din_shift;
        'd26: adc_result_chip_6_ch2_com1 <= jl_com1_din_shift;
        'd27: adc_result_chip_6_ch3_com1 <= jl_com1_din_shift;
        'd28: adc_result_chip_7_ch0_com1 <= jl_com1_din_shift;
        'd29: adc_result_chip_7_ch1_com1 <= jl_com1_din_shift;
        'd30: adc_result_chip_7_ch2_com1 <= jl_com1_din_shift;
        'd31: adc_result_chip_7_ch3_com1 <= jl_com1_din_shift;
        'd32: adc_result_chip_8_ch0_com1 <= jl_com1_din_shift;
        'd33: adc_result_chip_8_ch1_com1 <= jl_com1_din_shift;
        'd34: adc_result_chip_8_ch2_com1 <= jl_com1_din_shift;
        'd35: adc_result_chip_8_ch3_com1 <= jl_com1_din_shift;
        default: ;
        endcase
    end
    if(jl_com2_din_vld_point)
    begin
        case(jl_com2_din_word_index_d)
        'd0 : adc_result_chip_0_ch0_com2 <= jl_com2_din_shift;
        'd1 : adc_result_chip_0_ch1_com2 <= jl_com2_din_shift;
        'd2 : adc_result_chip_0_ch2_com2 <= jl_com2_din_shift;
        'd3 : adc_result_chip_0_ch3_com2 <= jl_com2_din_shift;
        'd4 : adc_result_chip_1_ch0_com2 <= jl_com2_din_shift;
        'd5 : adc_result_chip_1_ch1_com2 <= jl_com2_din_shift;
        'd6 : adc_result_chip_1_ch2_com2 <= jl_com2_din_shift;
        'd7 : adc_result_chip_1_ch3_com2 <= jl_com2_din_shift;
        'd8 : adc_result_chip_2_ch0_com2 <= jl_com2_din_shift;
        'd9 : adc_result_chip_2_ch1_com2 <= jl_com2_din_shift;
        'd10: adc_result_chip_2_ch2_com2 <= jl_com2_din_shift;
        'd11: adc_result_chip_2_ch3_com2 <= jl_com2_din_shift;
        'd12: adc_result_chip_3_ch0_com2 <= jl_com2_din_shift;
        'd13: adc_result_chip_3_ch1_com2 <= jl_com2_din_shift;
        'd14: adc_result_chip_3_ch2_com2 <= jl_com2_din_shift;
        'd15: adc_result_chip_3_ch3_com2 <= jl_com2_din_shift;
        'd16: adc_result_chip_4_ch0_com2 <= jl_com2_din_shift;
        'd17: adc_result_chip_4_ch1_com2 <= jl_com2_din_shift;
        'd18: adc_result_chip_4_ch2_com2 <= jl_com2_din_shift;
        'd19: adc_result_chip_4_ch3_com2 <= jl_com2_din_shift;
        'd20: adc_result_chip_5_ch0_com2 <= jl_com2_din_shift;
        'd21: adc_result_chip_5_ch1_com2 <= jl_com2_din_shift;
        'd22: adc_result_chip_5_ch2_com2 <= jl_com2_din_shift;
        'd23: adc_result_chip_5_ch3_com2 <= jl_com2_din_shift;
        'd24: adc_result_chip_6_ch0_com2 <= jl_com2_din_shift;
        'd25: adc_result_chip_6_ch1_com2 <= jl_com2_din_shift;
        'd26: adc_result_chip_6_ch2_com2 <= jl_com2_din_shift;
        'd27: adc_result_chip_6_ch3_com2 <= jl_com2_din_shift;
        'd28: adc_result_chip_7_ch0_com2 <= jl_com2_din_shift;
        'd29: adc_result_chip_7_ch1_com2 <= jl_com2_din_shift;
        'd30: adc_result_chip_7_ch2_com2 <= jl_com2_din_shift;
        'd31: adc_result_chip_7_ch3_com2 <= jl_com2_din_shift;
        'd32: adc_result_chip_8_ch0_com2 <= jl_com2_din_shift;
        'd33: adc_result_chip_8_ch1_com2 <= jl_com2_din_shift;
        'd34: adc_result_chip_8_ch2_com2 <= jl_com2_din_shift;
        'd35: adc_result_chip_8_ch3_com2 <= jl_com2_din_shift;
        default: ;
        endcase
    end
    if(jl_com3_din_vld_point)
    begin
        case(jl_com3_din_word_index_d)
        'd0 : adc_result_chip_0_ch0_com3 <= jl_com3_din_shift;
        'd1 : adc_result_chip_0_ch1_com3 <= jl_com3_din_shift;
        'd2 : adc_result_chip_0_ch2_com3 <= jl_com3_din_shift;
        'd3 : adc_result_chip_0_ch3_com3 <= jl_com3_din_shift;
        'd4 : adc_result_chip_1_ch0_com3 <= jl_com3_din_shift;
        'd5 : adc_result_chip_1_ch1_com3 <= jl_com3_din_shift;
        'd6 : adc_result_chip_1_ch2_com3 <= jl_com3_din_shift;
        'd7 : adc_result_chip_1_ch3_com3 <= jl_com3_din_shift;
        'd8 : adc_result_chip_2_ch0_com3 <= jl_com3_din_shift;
        'd9 : adc_result_chip_2_ch1_com3 <= jl_com3_din_shift;
        'd10: adc_result_chip_2_ch2_com3 <= jl_com3_din_shift;
        'd11: adc_result_chip_2_ch3_com3 <= jl_com3_din_shift;
        'd12: adc_result_chip_3_ch0_com3 <= jl_com3_din_shift;
        'd13: adc_result_chip_3_ch1_com3 <= jl_com3_din_shift;
        'd14: adc_result_chip_3_ch2_com3 <= jl_com3_din_shift;
        'd15: adc_result_chip_3_ch3_com3 <= jl_com3_din_shift;
        'd16: adc_result_chip_4_ch0_com3 <= jl_com3_din_shift;
        'd17: adc_result_chip_4_ch1_com3 <= jl_com3_din_shift;
        'd18: adc_result_chip_4_ch2_com3 <= jl_com3_din_shift;
        'd19: adc_result_chip_4_ch3_com3 <= jl_com3_din_shift;
        'd20: adc_result_chip_5_ch0_com3 <= jl_com3_din_shift;
        'd21: adc_result_chip_5_ch1_com3 <= jl_com3_din_shift;
        'd22: adc_result_chip_5_ch2_com3 <= jl_com3_din_shift;
        'd23: adc_result_chip_5_ch3_com3 <= jl_com3_din_shift;
        'd24: adc_result_chip_6_ch0_com3 <= jl_com3_din_shift;
        'd25: adc_result_chip_6_ch1_com3 <= jl_com3_din_shift;
        'd26: adc_result_chip_6_ch2_com3 <= jl_com3_din_shift;
        'd27: adc_result_chip_6_ch3_com3 <= jl_com3_din_shift;
        'd28: adc_result_chip_7_ch0_com3 <= jl_com3_din_shift;
        'd29: adc_result_chip_7_ch1_com3 <= jl_com3_din_shift;
        'd30: adc_result_chip_7_ch2_com3 <= jl_com3_din_shift;
        'd31: adc_result_chip_7_ch3_com3 <= jl_com3_din_shift;
        'd32: adc_result_chip_8_ch0_com3 <= jl_com3_din_shift;
        'd33: adc_result_chip_8_ch1_com3 <= jl_com3_din_shift;
        'd34: adc_result_chip_8_ch2_com3 <= jl_com3_din_shift;
        'd35: adc_result_chip_8_ch3_com3 <= jl_com3_din_shift;
        default: ;
        endcase
    end
end

always @(posedge clk)
if (sw1_d & sw0_d & impedance_trigger_switch)
begin
    if(jl_com1_din_vld_point)
    begin
        case(jl_com1_din_word_index_d)
        'd0 : real_max_value_37 <= {jl_com1_din_shift, 4'b0};
        'd1 : real_max_value_38 <= {jl_com1_din_shift, 4'b0};
        'd2 : real_max_value_39 <= {jl_com1_din_shift, 4'b0};
        'd3 : real_max_value_40 <= {jl_com1_din_shift, 4'b0};
        'd4 : real_max_value_41 <= {jl_com1_din_shift, 4'b0};
        'd5 : real_max_value_42 <= {jl_com1_din_shift, 4'b0};
        'd6 : real_max_value_43 <= {jl_com1_din_shift, 4'b0};
        'd7 : real_max_value_44 <= {jl_com1_din_shift, 4'b0};
        'd8 : real_max_value_45 <= {jl_com1_din_shift, 4'b0};
        'd9 : real_max_value_46 <= {jl_com1_din_shift, 4'b0};
        'd10: real_max_value_47 <= {jl_com1_din_shift, 4'b0};
        'd11: real_max_value_48 <= {jl_com1_din_shift, 4'b0};
        'd12: real_max_value_49 <= {jl_com1_din_shift, 4'b0};
        'd13: real_max_value_50 <= {jl_com1_din_shift, 4'b0};
        'd14: real_max_value_51 <= {jl_com1_din_shift, 4'b0};
        'd15: real_max_value_52 <= {jl_com1_din_shift, 4'b0};
        'd16: real_max_value_53 <= {jl_com1_din_shift, 4'b0};
        'd17: real_max_value_54 <= {jl_com1_din_shift, 4'b0};
        'd18: real_max_value_55 <= {jl_com1_din_shift, 4'b0};
        'd19: real_max_value_56 <= {jl_com1_din_shift, 4'b0};
        'd20: real_max_value_57 <= {jl_com1_din_shift, 4'b0};
        'd21: real_max_value_58 <= {jl_com1_din_shift, 4'b0};
        'd22: real_max_value_59 <= {jl_com1_din_shift, 4'b0};
        'd23: real_max_value_60 <= {jl_com1_din_shift, 4'b0};
        'd24: real_max_value_61 <= {jl_com1_din_shift, 4'b0};
        'd25: real_max_value_62 <= {jl_com1_din_shift, 4'b0};
        'd26: real_max_value_63 <= {jl_com1_din_shift, 4'b0};
        'd27: real_max_value_64 <= {jl_com1_din_shift, 4'b0};
        'd28: real_max_value_65 <= {jl_com1_din_shift, 4'b0};
        'd29: real_max_value_66 <= {jl_com1_din_shift, 4'b0};
        'd30: real_max_value_67 <= {jl_com1_din_shift, 4'b0};
        'd31: real_max_value_68 <= {jl_com1_din_shift, 4'b0};
        'd32: real_max_value_69 <= {jl_com1_din_shift, 4'b0};
        'd33: real_max_value_70 <= {jl_com1_din_shift, 4'b0};
        'd34: real_max_value_71 <= {jl_com1_din_shift, 4'b0};
        'd35: real_max_value_72 <= {jl_com1_din_shift, 4'b0};
        default: ;
        endcase
    end
    if(jl_com2_din_vld_point)
    begin
        case(jl_com2_din_word_index_d)
        'd0 : real_max_value_73  <= {jl_com2_din_shift, 4'b0};
        'd1 : real_max_value_74  <= {jl_com2_din_shift, 4'b0};
        'd2 : real_max_value_75  <= {jl_com2_din_shift, 4'b0};
        'd3 : real_max_value_76  <= {jl_com2_din_shift, 4'b0};
        'd4 : real_max_value_77  <= {jl_com2_din_shift, 4'b0};
        'd5 : real_max_value_78  <= {jl_com2_din_shift, 4'b0};
        'd6 : real_max_value_79  <= {jl_com2_din_shift, 4'b0};
        'd7 : real_max_value_80  <= {jl_com2_din_shift, 4'b0};
        'd8 : real_max_value_81  <= {jl_com2_din_shift, 4'b0};
        'd9 : real_max_value_82  <= {jl_com2_din_shift, 4'b0};
        'd10: real_max_value_83  <= {jl_com2_din_shift, 4'b0};
        'd11: real_max_value_84  <= {jl_com2_din_shift, 4'b0};
        'd12: real_max_value_85  <= {jl_com2_din_shift, 4'b0};
        'd13: real_max_value_86  <= {jl_com2_din_shift, 4'b0};
        'd14: real_max_value_87  <= {jl_com2_din_shift, 4'b0};
        'd15: real_max_value_88  <= {jl_com2_din_shift, 4'b0};
        'd16: real_max_value_89  <= {jl_com2_din_shift, 4'b0};
        'd17: real_max_value_90  <= {jl_com2_din_shift, 4'b0};
        'd18: real_max_value_91  <= {jl_com2_din_shift, 4'b0};
        'd19: real_max_value_92  <= {jl_com2_din_shift, 4'b0};
        'd20: real_max_value_93  <= {jl_com2_din_shift, 4'b0};
        'd21: real_max_value_94  <= {jl_com2_din_shift, 4'b0};
        'd22: real_max_value_95  <= {jl_com2_din_shift, 4'b0};
        'd23: real_max_value_96  <= {jl_com2_din_shift, 4'b0};
        'd24: real_max_value_97  <= {jl_com2_din_shift, 4'b0};
        'd25: real_max_value_98  <= {jl_com2_din_shift, 4'b0};
        'd26: real_max_value_99  <= {jl_com2_din_shift, 4'b0};
        'd27: real_max_value_100 <= {jl_com2_din_shift, 4'b0};
        'd28: real_max_value_101 <= {jl_com2_din_shift, 4'b0};
        'd29: real_max_value_102 <= {jl_com2_din_shift, 4'b0};
        'd30: real_max_value_103 <= {jl_com2_din_shift, 4'b0};
        'd31: real_max_value_104 <= {jl_com2_din_shift, 4'b0};
        'd32: real_max_value_105 <= {jl_com2_din_shift, 4'b0};
        'd33: real_max_value_106 <= {jl_com2_din_shift, 4'b0};
        'd34: real_max_value_107 <= {jl_com2_din_shift, 4'b0};
        'd35: real_max_value_108 <= {jl_com2_din_shift, 4'b0};
        default: ;
        endcase
    end
    if(jl_com3_din_vld_point)
    begin
        case(jl_com3_din_word_index_d)
        'd0 : real_max_value_109 <= {jl_com3_din_shift, 4'b0};
        'd1 : real_max_value_110 <= {jl_com3_din_shift, 4'b0};
        'd2 : real_max_value_111 <= {jl_com3_din_shift, 4'b0};
        'd3 : real_max_value_112 <= {jl_com3_din_shift, 4'b0};
        'd4 : real_max_value_113 <= {jl_com3_din_shift, 4'b0};
        'd5 : real_max_value_114 <= {jl_com3_din_shift, 4'b0};
        'd6 : real_max_value_115 <= {jl_com3_din_shift, 4'b0};
        'd7 : real_max_value_116 <= {jl_com3_din_shift, 4'b0};
        'd8 : real_max_value_117 <= {jl_com3_din_shift, 4'b0};
        'd9 : real_max_value_118 <= {jl_com3_din_shift, 4'b0};
        'd10: real_max_value_119 <= {jl_com3_din_shift, 4'b0};
        'd11: real_max_value_120 <= {jl_com3_din_shift, 4'b0};
        'd12: real_max_value_121 <= {jl_com3_din_shift, 4'b0};
        'd13: real_max_value_122 <= {jl_com3_din_shift, 4'b0};
        'd14: real_max_value_123 <= {jl_com3_din_shift, 4'b0};
        'd15: real_max_value_124 <= {jl_com3_din_shift, 4'b0};
        'd16: real_max_value_125 <= {jl_com3_din_shift, 4'b0};
        'd17: real_max_value_126 <= {jl_com3_din_shift, 4'b0};
        'd18: real_max_value_127 <= {jl_com3_din_shift, 4'b0};
        'd19: real_max_value_128 <= {jl_com3_din_shift, 4'b0};
        'd20: real_max_value_129 <= {jl_com3_din_shift, 4'b0};
        'd21: real_max_value_130 <= {jl_com3_din_shift, 4'b0};
        'd22: real_max_value_131 <= {jl_com3_din_shift, 4'b0};
        'd23: real_max_value_132 <= {jl_com3_din_shift, 4'b0};
        'd24: real_max_value_133 <= {jl_com3_din_shift, 4'b0};
        'd25: real_max_value_134 <= {jl_com3_din_shift, 4'b0};
        'd26: real_max_value_135 <= {jl_com3_din_shift, 4'b0};
        'd27: real_max_value_136 <= {jl_com3_din_shift, 4'b0};
        'd28: real_max_value_137 <= {jl_com3_din_shift, 4'b0};
        'd29: real_max_value_138 <= {jl_com3_din_shift, 4'b0};
        'd30: real_max_value_139 <= {jl_com3_din_shift, 4'b0};
        'd31: real_max_value_140 <= {jl_com3_din_shift, 4'b0};
        'd32: real_max_value_141 <= {jl_com3_din_shift, 4'b0};
        'd33: real_max_value_142 <= {jl_com3_din_shift, 4'b0};
        'd34: real_max_value_143 <= {jl_com3_din_shift, 4'b0};
        'd35: real_max_value_144 <= {jl_com3_din_shift, 4'b0};
        default: ;
        endcase
    end
end

always @(posedge clk)
begin
    jl_com1_din_vld_point <= jl_com1_sck_in_r & (jl_com1_din_bit_index == 13);
    jl_com1_din_word_index_d <= jl_com1_din_word_index;
end

always @(posedge clk)
begin
    jl_com2_din_vld_point <= jl_com2_sck_in_r & (jl_com2_din_bit_index == 13);
    jl_com2_din_word_index_d <= jl_com2_din_word_index;
end

always @(posedge clk)
begin
    jl_com3_din_vld_point <= jl_com3_sck_in_r & (jl_com3_din_bit_index == 13);
    jl_com3_din_word_index_d <= jl_com3_din_word_index;
end

always @(posedge clk)
if (sw1_d & sw0_d)
begin
    if(jl_com1_cs_in_f | (~rst_n))
        jl_com1_din_shift <= 0;
    else if(jl_com1_sck_in_r)
        case(jl_com1_din_bit_index)
        'd0 : jl_com1_din_shift[1 :0 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd1 : jl_com1_din_shift[3 :2 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd2 : jl_com1_din_shift[5 :4 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd3 : jl_com1_din_shift[7 :6 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd4 : jl_com1_din_shift[9 :8 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd5 : jl_com1_din_shift[11:10] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd6 : jl_com1_din_shift[13:12] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd7 : jl_com1_din_shift[15:14] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd8 : jl_com1_din_shift[17:16] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd9 : jl_com1_din_shift[19:18] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd10: jl_com1_din_shift[21:20] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd11: jl_com1_din_shift[23:22] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd12: jl_com1_din_shift[25:24] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        'd13: jl_com1_din_shift[27:26] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
        default: ;
    endcase
    if(jl_com2_cs_in_f | (~rst_n))
        jl_com2_din_shift <= 0;
    else if(jl_com2_sck_in_r)
        case(jl_com2_din_bit_index)
        'd0 : jl_com2_din_shift[1 :0 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd1 : jl_com2_din_shift[3 :2 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd2 : jl_com2_din_shift[5 :4 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd3 : jl_com2_din_shift[7 :6 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd4 : jl_com2_din_shift[9 :8 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd5 : jl_com2_din_shift[11:10] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd6 : jl_com2_din_shift[13:12] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd7 : jl_com2_din_shift[15:14] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd8 : jl_com2_din_shift[17:16] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd9 : jl_com2_din_shift[19:18] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd10: jl_com2_din_shift[21:20] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd11: jl_com2_din_shift[23:22] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd12: jl_com2_din_shift[25:24] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        'd13: jl_com2_din_shift[27:26] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
        default: ;
    endcase
    if(jl_com3_cs_in_f | (~rst_n))
        jl_com3_din_shift <= 0;
    else if(jl_com3_sck_in_r)
        case(jl_com3_din_bit_index)
        'd0 : jl_com3_din_shift[1 :0 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd1 : jl_com3_din_shift[3 :2 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd2 : jl_com3_din_shift[5 :4 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd3 : jl_com3_din_shift[7 :6 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd4 : jl_com3_din_shift[9 :8 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd5 : jl_com3_din_shift[11:10] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd6 : jl_com3_din_shift[13:12] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd7 : jl_com3_din_shift[15:14] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd8 : jl_com3_din_shift[17:16] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd9 : jl_com3_din_shift[19:18] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd10: jl_com3_din_shift[21:20] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd11: jl_com3_din_shift[23:22] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd12: jl_com3_din_shift[25:24] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        'd13: jl_com3_din_shift[27:26] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
        default: ;
    endcase
end

always @(posedge clk)
if(jl_com1_cs_in_f | (~rst_n))
    jl_com1_din_bit_index <= 0;
else if(jl_com1_sck_in_r)
    jl_com1_din_bit_index <= (jl_com1_din_bit_index == 'd13) ? 0 : jl_com1_din_bit_index + 1;

always @(posedge clk)
if(jl_com2_cs_in_f | (~rst_n))
    jl_com2_din_bit_index <= 0;
else if(jl_com2_sck_in_r)
    jl_com2_din_bit_index <= (jl_com2_din_bit_index == 'd13) ? 0 : jl_com2_din_bit_index + 1;

always @(posedge clk)
if(jl_com3_cs_in_f | (~rst_n))
    jl_com3_din_bit_index <= 0;
else if(jl_com3_sck_in_r)
    jl_com3_din_bit_index <= (jl_com3_din_bit_index == 'd13) ? 0 : jl_com3_din_bit_index + 1;

always @(posedge clk)
if(jl_com1_cs_in_f | (~rst_n))
    jl_com1_din_word_index <= 0;
else if(jl_com1_sck_in_r & (jl_com1_din_bit_index == 'd13))
    jl_com1_din_word_index <= jl_com1_din_word_index + 1;

always @(posedge clk)
if(jl_com2_cs_in_f | (~rst_n))
    jl_com2_din_word_index <= 0;
else if(jl_com2_sck_in_r & (jl_com2_din_bit_index == 'd13))
    jl_com2_din_word_index <= jl_com2_din_word_index + 1;

always @(posedge clk)
if(jl_com3_cs_in_f | (~rst_n))
    jl_com3_din_word_index <= 0;
else if(jl_com3_sck_in_r & (jl_com3_din_bit_index == 'd13))
    jl_com3_din_word_index <= jl_com3_din_word_index + 1;

always @(posedge clk)
if(jl_com1_cs_in_f | (~rst_n))
    jl_com1_in_bit_cnt_slave <= 0;
else if(jl_com1_sck_in_r)
    jl_com1_in_bit_cnt_slave <= jl_com1_in_bit_cnt_slave + 1;

always @(posedge clk)
if(jl_com2_cs_in_f | (~rst_n))
    jl_com2_in_bit_cnt_slave <= 0;
else if(jl_com2_sck_in_r)
    jl_com2_in_bit_cnt_slave <= jl_com2_in_bit_cnt_slave + 1;

always @(posedge clk)
if(jl_com3_cs_in_f | (~rst_n))
    jl_com3_in_bit_cnt_slave <= 0;
else if(jl_com3_sck_in_r)
    jl_com3_in_bit_cnt_slave <= jl_com3_in_bit_cnt_slave + 1;

reg    [31:0]       adc_trigger_length_shift;
reg                 adc_sample_en_shift;
reg    [15:0]       usb_cfg_bus_shift;  //阻抗检测模式及通道选择
reg                 usb_cfg_valid_shift;//阻抗检测触发
reg    [31:0]       adc_sample_period_shift;

reg    [31:0]       adc_trigger_length_slave;
reg    [15:0]       usb_cfg_bus_slave;  //阻抗检测模式及通道选择
reg                 usb_cfg_valid_slave;//阻抗检测触发
reg    [31:0]       adc_sample_period_slave;

assign adc_trigger_length = (sw0_d & sw1_d) ? adc_trigger_length_usb    : adc_trigger_length_slave;
assign adc_sample_en      = (sw0_d & sw1_d) ? adc_sample_en_usb         : adc_sample_en_slave;
assign usb_cfg_bus        = (sw0_d & sw1_d) ? usb_cfg_bus_usb           : usb_cfg_bus_slave;
assign usb_cfg_valid      = (sw0_d & sw1_d) ? usb_cfg_valid_usb         : usb_cfg_valid_slave;
assign adc_sample_period  = (sw0_d & sw1_d) ? usb_sample_period         : adc_sample_period_slave;

always @(*)
    usb_cfg_valid_slave <= usb_cfg_valid_shift; // 阻抗检测触发

always @(posedge clk)
begin
    case ({sw1_d, sw0_d})
    2'b00:
    begin
        if(jl_com1_cs_in_r)
        begin
            adc_trigger_length_slave <= adc_trigger_length_shift;
            adc_sample_en_slave      <= adc_sample_en_shift;
            usb_cfg_bus_slave        <= usb_cfg_bus_shift;
            adc_sample_period_slave  <= adc_sample_period_shift;
        end
    end
    2'b01:
    begin
        if(jl_com2_cs_in_r)
        begin
            adc_trigger_length_slave <= adc_trigger_length_shift;
            adc_sample_en_slave      <= adc_sample_en_shift;
            usb_cfg_bus_slave        <= usb_cfg_bus_shift;
            adc_sample_period_slave  <= adc_sample_period_shift;
        end
    end
    2'b10:
    begin
        if(jl_com3_cs_in_r)
        begin
            adc_trigger_length_slave <= adc_trigger_length_shift;
            adc_sample_en_slave      <= adc_sample_en_shift;
            usb_cfg_bus_slave        <= usb_cfg_bus_shift;
            adc_sample_period_slave  <= adc_sample_period_shift;
        end
    end
    default: ;
    endcase
end

always @(posedge clk)
begin
    case ({sw1_d, sw0_d})
    2'b00:
    begin
        if(jl_com1_sck_in_r)
            case(jl_com1_in_bit_cnt_slave)
            'd0 : adc_trigger_length_shift[1 :0 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd1 : adc_trigger_length_shift[3 :2 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd2 : adc_trigger_length_shift[5 :4 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd3 : adc_trigger_length_shift[7 :6 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd4 : adc_trigger_length_shift[9 :8 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd5 : adc_trigger_length_shift[11:10] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd6 : adc_trigger_length_shift[13:12] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd7 : adc_trigger_length_shift[15:14] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd8 : adc_trigger_length_shift[17:16] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd9 : adc_trigger_length_shift[19:18] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd10: adc_trigger_length_shift[21:20] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd11: adc_trigger_length_shift[23:22] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd12: adc_trigger_length_shift[25:24] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd13: adc_trigger_length_shift[27:26] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd14: adc_trigger_length_shift[29:28] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd15: adc_trigger_length_shift[31:30] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd16: usb_cfg_bus_shift[1 :0 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd17: usb_cfg_bus_shift[3 :2 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd18: usb_cfg_bus_shift[5 :4 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd19: usb_cfg_bus_shift[7 :6 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd20: usb_cfg_bus_shift[9 :8 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd21: usb_cfg_bus_shift[11:10] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd22: usb_cfg_bus_shift[13:12] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd23: usb_cfg_bus_shift[15:14] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd24: {adc_sample_en_shift, usb_cfg_valid_shift} <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd32: adc_sample_period_shift[1 :0 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd33: adc_sample_period_shift[3 :2 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd34: adc_sample_period_shift[5 :4 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd35: adc_sample_period_shift[7 :6 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd36: adc_sample_period_shift[9 :8 ] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd37: adc_sample_period_shift[11:10] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd38: adc_sample_period_shift[13:12] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd39: adc_sample_period_shift[15:14] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd40: adc_sample_period_shift[17:16] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd41: adc_sample_period_shift[19:18] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd42: adc_sample_period_shift[21:20] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd43: adc_sample_period_shift[23:22] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd44: adc_sample_period_shift[25:24] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd45: adc_sample_period_shift[27:26] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd46: adc_sample_period_shift[29:28] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            'd47: adc_sample_period_shift[31:30] <= {jl_com1_data_in1_d, jl_com1_data_in0_d};
            default: ;
            endcase
        else
            usb_cfg_valid_shift <= 0;
    end
    2'b01:
    begin
        if(jl_com2_sck_in_r)
            case(jl_com2_in_bit_cnt_slave)
            'd0 : adc_trigger_length_shift[1 :0 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd1 : adc_trigger_length_shift[3 :2 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd2 : adc_trigger_length_shift[5 :4 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd3 : adc_trigger_length_shift[7 :6 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd4 : adc_trigger_length_shift[9 :8 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd5 : adc_trigger_length_shift[11:10] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd6 : adc_trigger_length_shift[13:12] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd7 : adc_trigger_length_shift[15:14] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd8 : adc_trigger_length_shift[17:16] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd9 : adc_trigger_length_shift[19:18] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd10: adc_trigger_length_shift[21:20] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd11: adc_trigger_length_shift[23:22] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd12: adc_trigger_length_shift[25:24] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd13: adc_trigger_length_shift[27:26] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd14: adc_trigger_length_shift[29:28] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd15: adc_trigger_length_shift[31:30] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd16: usb_cfg_bus_shift[1 :0 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd17: usb_cfg_bus_shift[3 :2 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd18: usb_cfg_bus_shift[5 :4 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd19: usb_cfg_bus_shift[7 :6 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd20: usb_cfg_bus_shift[9 :8 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd21: usb_cfg_bus_shift[11:10] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd22: usb_cfg_bus_shift[13:12] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd23: usb_cfg_bus_shift[15:14] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd24: {adc_sample_en_shift, usb_cfg_valid_shift} <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd32: adc_sample_period_shift[1 :0 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd33: adc_sample_period_shift[3 :2 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd34: adc_sample_period_shift[5 :4 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd35: adc_sample_period_shift[7 :6 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd36: adc_sample_period_shift[9 :8 ] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd37: adc_sample_period_shift[11:10] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd38: adc_sample_period_shift[13:12] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd39: adc_sample_period_shift[15:14] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd40: adc_sample_period_shift[17:16] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd41: adc_sample_period_shift[19:18] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd42: adc_sample_period_shift[21:20] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd43: adc_sample_period_shift[23:22] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd44: adc_sample_period_shift[25:24] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd45: adc_sample_period_shift[27:26] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd46: adc_sample_period_shift[29:28] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            'd47: adc_sample_period_shift[31:30] <= {jl_com2_data_in1_d, jl_com2_data_in0_d};
            default: ;
            endcase
        else
            usb_cfg_valid_shift <= 0;
    end
    2'b10:
    begin
        if(jl_com3_sck_in_r)
            case(jl_com3_in_bit_cnt_slave)
            'd0 : adc_trigger_length_shift[1 :0 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd1 : adc_trigger_length_shift[3 :2 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd2 : adc_trigger_length_shift[5 :4 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd3 : adc_trigger_length_shift[7 :6 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd4 : adc_trigger_length_shift[9 :8 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd5 : adc_trigger_length_shift[11:10] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd6 : adc_trigger_length_shift[13:12] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd7 : adc_trigger_length_shift[15:14] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd8 : adc_trigger_length_shift[17:16] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd9 : adc_trigger_length_shift[19:18] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd10: adc_trigger_length_shift[21:20] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd11: adc_trigger_length_shift[23:22] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd12: adc_trigger_length_shift[25:24] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd13: adc_trigger_length_shift[27:26] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd14: adc_trigger_length_shift[29:28] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd15: adc_trigger_length_shift[31:30] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd16: usb_cfg_bus_shift[1 :0 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd17: usb_cfg_bus_shift[3 :2 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd18: usb_cfg_bus_shift[5 :4 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd19: usb_cfg_bus_shift[7 :6 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd20: usb_cfg_bus_shift[9 :8 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd21: usb_cfg_bus_shift[11:10] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd22: usb_cfg_bus_shift[13:12] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd23: usb_cfg_bus_shift[15:14] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd24: {adc_sample_en_shift, usb_cfg_valid_shift} <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd32: adc_sample_period_shift[1 :0 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd33: adc_sample_period_shift[3 :2 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd34: adc_sample_period_shift[5 :4 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd35: adc_sample_period_shift[7 :6 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd36: adc_sample_period_shift[9 :8 ] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd37: adc_sample_period_shift[11:10] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd38: adc_sample_period_shift[13:12] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd39: adc_sample_period_shift[15:14] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd40: adc_sample_period_shift[17:16] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd41: adc_sample_period_shift[19:18] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd42: adc_sample_period_shift[21:20] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd43: adc_sample_period_shift[23:22] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd44: adc_sample_period_shift[25:24] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd45: adc_sample_period_shift[27:26] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd46: adc_sample_period_shift[29:28] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            'd47: adc_sample_period_shift[31:30] <= {jl_com3_data_in1_d, jl_com3_data_in0_d};
            default: ;
            endcase
        else
            usb_cfg_valid_shift <= 0;
    end
    default: ;
    endcase
end

always @(posedge clk)
begin
    jl_com1_sck_in_d3 <= jl_com1_sck_in_d2;
    jl_com1_sck_in_d2 <= jl_com1_sck_in_d1;
    jl_com1_sck_in_d1 <= jl_com1_sck_in;

    jl_com1_cs_in_d3 <= jl_com1_cs_in_d2;
    jl_com1_cs_in_d2 <= jl_com1_cs_in_d1;
    jl_com1_cs_in_d1 <= jl_com1_cs_in;

    jl_com1_data_in0_d <= jl_com1_data_in0;
    jl_com1_data_in1_d <= jl_com1_data_in1;
end

always @(posedge clk)
begin
    jl_com2_sck_in_d3 <= jl_com2_sck_in_d2;
    jl_com2_sck_in_d2 <= jl_com2_sck_in_d1;
    jl_com2_sck_in_d1 <= jl_com2_sck_in;

    jl_com2_cs_in_d3 <= jl_com2_cs_in_d2;
    jl_com2_cs_in_d2 <= jl_com2_cs_in_d1;
    jl_com2_cs_in_d1 <= jl_com2_cs_in;

    jl_com2_data_in0_d <= jl_com2_data_in0;
    jl_com2_data_in1_d <= jl_com2_data_in1;
end

always @(posedge clk)
begin
    jl_com3_sck_in_d3 <= jl_com3_sck_in_d2;
    jl_com3_sck_in_d2 <= jl_com3_sck_in_d1;
    jl_com3_sck_in_d1 <= jl_com3_sck_in;

    jl_com3_cs_in_d3 <= jl_com3_cs_in_d2;
    jl_com3_cs_in_d2 <= jl_com3_cs_in_d1;
    jl_com3_cs_in_d1 <= jl_com3_cs_in;

    jl_com3_data_in0_d <= jl_com3_data_in0;
    jl_com3_data_in1_d <= jl_com3_data_in1;
end

/*------------------阻抗检测控制部分设计--------------*/
parameter           TIME_1ms = 48000;
parameter           TIME_DLx = 145;
parameter           IMPEDANCE_WIN_LEN = 128;
parameter           DL_TOTAL_NUM = 36;
reg  [ 7:0]         dl_num_instruction_pre3;
reg  [ 7:0]         dl_num_instruction_pre2;
reg  [ 7:0]         dl_num_instruction_pre1;
reg  [ 7:0]         dl_num_instruction;
reg  [ 7:0]         dl_num_595_loop;
reg  [ 7:0]         dl_num_adc_loop;
reg                 trigger_595_loop;
reg                 trigger_adc_loop;
reg  [31:0]         counter_clk;
reg  [ 7:0]         counter_ms;
reg  [ 7:0]         counter_dl;

reg                 adc_wren_d;
reg  [ 9:0]         counter_adc_wren;
reg  [38:0]         real_sum_value_1;
reg  [38:0]         real_sum_value_2;
reg  [38:0]         real_sum_value_3;
reg  [38:0]         real_sum_value_4;
reg  [38:0]         real_sum_value_5;
reg  [38:0]         real_sum_value_6;
reg  [38:0]         real_sum_value_7;
reg  [38:0]         real_sum_value_8;
reg  [38:0]         real_sum_value_9;
reg  [38:0]         real_sum_value_10;
reg  [38:0]         real_sum_value_11;
reg  [38:0]         real_sum_value_12;
reg  [38:0]         real_sum_value_13;
reg  [38:0]         real_sum_value_14;
reg  [38:0]         real_sum_value_15;
reg  [38:0]         real_sum_value_16;
reg  [38:0]         real_sum_value_17;
reg  [38:0]         real_sum_value_18;
reg  [38:0]         real_sum_value_19;
reg  [38:0]         real_sum_value_20;
reg  [38:0]         real_sum_value_21;
reg  [38:0]         real_sum_value_22;
reg  [38:0]         real_sum_value_23;
reg  [38:0]         real_sum_value_24;
reg  [38:0]         real_sum_value_25;
reg  [38:0]         real_sum_value_26;
reg  [38:0]         real_sum_value_27;
reg  [38:0]         real_sum_value_28;
reg  [38:0]         real_sum_value_29;
reg  [38:0]         real_sum_value_30;
reg  [38:0]         real_sum_value_31;
reg  [38:0]         real_sum_value_32;
reg  [38:0]         real_sum_value_33;
reg  [38:0]         real_sum_value_34;
reg  [38:0]         real_sum_value_35;
reg  [38:0]         real_sum_value_36;

reg                 usb_impedance_valid_1d;
reg                 usb_impedance_valid_2d;
reg                 usb_impedance_valid_3d;
reg                 usb_impedance_valid_4d;

always @(posedge clk or negedge rst_n)
if (~rst_n)
begin
    dl_num_instruction_pre3 <= 8'd0;
    dl_num_instruction_pre2 <= 8'd0;
    dl_num_instruction_pre1 <= 8'd0;
    dl_num_instruction      <= 8'd0;
    usb_impedance_valid_4d  <= 1'b0;
    usb_impedance_valid_3d  <= 1'b0;
    usb_impedance_valid_2d  <= 1'b0;
    usb_impedance_valid_1d  <= 1'b0;
end
else
begin
    dl_num_instruction_pre3 <= usb_cfg_bus[8] * 8'd100 + usb_cfg_bus[ 7:4] * 8'd10 + usb_cfg_bus[ 3:0];
    dl_num_instruction_pre2 <= (dl_num_instruction_pre3 > 8'd36) ? (dl_num_instruction_pre3 - 8'd36) : dl_num_instruction_pre3;
    dl_num_instruction_pre1 <= (dl_num_instruction_pre2 > 8'd36) ? (dl_num_instruction_pre2 - 8'd36) : dl_num_instruction_pre2;
    dl_num_instruction      <= (dl_num_instruction_pre1 > 8'd36) ? (dl_num_instruction_pre1 - 8'd36) : dl_num_instruction_pre1;
    usb_impedance_valid_4d  <= usb_impedance_valid_3d;
    usb_impedance_valid_3d  <= usb_impedance_valid_2d;
    usb_impedance_valid_2d  <= usb_impedance_valid_1d;
    usb_impedance_valid_1d  <= usb_impedance_valid;
end

sipo_595_ctrl sipo_595_ctrl (
    .clk                            (clk),
    .rst_n                          (rst_n),
    .trigger_595                    (trigger_595_loop),
    .dl_num                         (dl_num_595_loop),
    .FPGA_DOUT_OE                   (FPGA_DOUT_OE ),
    .FPGA_DOUT_LCK                  (FPGA_DOUT_LCK),
    .FPGA_DOUT_RST                  (FPGA_DOUT_RST),
    .FPGA_DOUT_SCK                  (FPGA_DOUT_SCK),
    .FPGA_DOUT_SIN                  (FPGA_DOUT_SIN)
);

always @(posedge clk or negedge rst_n)
if (~rst_n)
    impedance_trigger_switch_pre <= 1'b0;
else if (usb_impedance_valid_4d & (dl_num_instruction > 0))
    impedance_trigger_switch_pre <= 1'b1;
else if (usb_impedance_valid_4d & (dl_num_instruction == 0))
    impedance_trigger_switch_pre <= 1'b0;
else
    impedance_trigger_switch_pre <= impedance_trigger_switch_pre;

always @(posedge clk)
    impedance_trigger_switch <= impedance_trigger_switch_pre | usb_cfg_bus[12];

always @(posedge clk or negedge rst_n)
if (~rst_n)
    counter_clk <= 32'hFFFF;
else if ((counter_clk < TIME_1ms - 'd1) | (&counter_clk))
    counter_clk <= counter_clk + 1'b1;
else
    counter_clk <= 32'd0;

always @(posedge clk or negedge rst_n)
if (~rst_n)
    counter_ms <= 8'hFF;
else if ((counter_ms < TIME_DLx - 'd1) | (&counter_ms))
    counter_ms <= (counter_clk == TIME_1ms - 1) ? (counter_ms + 1'b1) : counter_ms;
else
    counter_ms <= (counter_clk == TIME_1ms - 1) ? 8'd0 : counter_ms;

always @(posedge clk or negedge rst_n)
if (~rst_n)
    counter_dl <= 8'hFF;
else if ((counter_dl < DL_TOTAL_NUM - 'd1) | (&counter_dl))
begin
    if (((counter_ms == TIME_DLx - 1) | (&counter_dl)) & (counter_clk == TIME_1ms - 1))
        counter_dl <= counter_dl + 1;
    else
        counter_dl <= counter_dl;
end
else
    counter_dl <= ((counter_ms == TIME_DLx - 1) & (counter_clk == TIME_1ms - 1)) ? 8'd0 : counter_dl;

always @(posedge clk or negedge rst_n)
if (~rst_n)
    trigger_595_loop <= 1'b0;
else
    trigger_595_loop <= ((counter_clk == 32'd1) & (counter_ms == 8'd0));

always @(posedge clk or negedge rst_n)
if (~rst_n)
    trigger_adc_loop <= 1'b0;
else
    trigger_adc_loop <= ((counter_clk == 32'd1) & (counter_ms == 8'd10));

always @(*)
begin
    case (dl_num_adc_loop)
        8'd1 : dl_num_595_loop <= impedance_trigger_switch ? 8'd20 : 8'd0;
        8'd2 : dl_num_595_loop <= impedance_trigger_switch ? 8'd19 : 8'd0;
        8'd3 : dl_num_595_loop <= impedance_trigger_switch ? 8'd18 : 8'd0;
        8'd4 : dl_num_595_loop <= impedance_trigger_switch ? 8'd17 : 8'd0;
        8'd5 : dl_num_595_loop <= impedance_trigger_switch ? 8'd32 : 8'd0;
        8'd6 : dl_num_595_loop <= impedance_trigger_switch ? 8'd31 : 8'd0;
        8'd7 : dl_num_595_loop <= impedance_trigger_switch ? 8'd30 : 8'd0;
        8'd8 : dl_num_595_loop <= impedance_trigger_switch ? 8'd29 : 8'd0;
        8'd9 : dl_num_595_loop <= impedance_trigger_switch ? 8'd28 : 8'd0;
        8'd10: dl_num_595_loop <= impedance_trigger_switch ? 8'd27 : 8'd0;
        8'd11: dl_num_595_loop <= impedance_trigger_switch ? 8'd26 : 8'd0;
        8'd12: dl_num_595_loop <= impedance_trigger_switch ? 8'd25 : 8'd0;
        8'd13: dl_num_595_loop <= impedance_trigger_switch ? 8'd8  : 8'd0;
        8'd14: dl_num_595_loop <= impedance_trigger_switch ? 8'd7  : 8'd0;
        8'd15: dl_num_595_loop <= impedance_trigger_switch ? 8'd6  : 8'd0;
        8'd16: dl_num_595_loop <= impedance_trigger_switch ? 8'd21 : 8'd0;
        8'd17: dl_num_595_loop <= impedance_trigger_switch ? 8'd36 : 8'd0;
        8'd18: dl_num_595_loop <= impedance_trigger_switch ? 8'd35 : 8'd0;
        8'd19: dl_num_595_loop <= impedance_trigger_switch ? 8'd34 : 8'd0;
        8'd20: dl_num_595_loop <= impedance_trigger_switch ? 8'd33 : 8'd0;
        8'd21: dl_num_595_loop <= impedance_trigger_switch ? 8'd5  : 8'd0;
        8'd22: dl_num_595_loop <= impedance_trigger_switch ? 8'd4  : 8'd0;
        8'd23: dl_num_595_loop <= impedance_trigger_switch ? 8'd3  : 8'd0;
        8'd24: dl_num_595_loop <= impedance_trigger_switch ? 8'd2  : 8'd0;
        8'd25: dl_num_595_loop <= impedance_trigger_switch ? 8'd1  : 8'd0;
        8'd26: dl_num_595_loop <= impedance_trigger_switch ? 8'd16 : 8'd0;
        8'd27: dl_num_595_loop <= impedance_trigger_switch ? 8'd15 : 8'd0;
        8'd28: dl_num_595_loop <= impedance_trigger_switch ? 8'd14 : 8'd0;
        8'd29: dl_num_595_loop <= impedance_trigger_switch ? 8'd13 : 8'd0;
        8'd30: dl_num_595_loop <= impedance_trigger_switch ? 8'd12 : 8'd0;
        8'd31: dl_num_595_loop <= impedance_trigger_switch ? 8'd11 : 8'd0;
        8'd32: dl_num_595_loop <= impedance_trigger_switch ? 8'd10 : 8'd0;
        8'd33: dl_num_595_loop <= impedance_trigger_switch ? 8'd9  : 8'd0;
        8'd34: dl_num_595_loop <= impedance_trigger_switch ? 8'd24 : 8'd0;
        8'd35: dl_num_595_loop <= impedance_trigger_switch ? 8'd23 : 8'd0;
        8'd36: dl_num_595_loop <= impedance_trigger_switch ? 8'd22 : 8'd0;
    default:
        dl_num_595_loop <= 8'd0;
    endcase
end

always @(posedge clk or negedge rst_n)
if (~rst_n)
    dl_num_adc_loop <= 8'd0;
else
    dl_num_adc_loop <= counter_dl + 1'b1;

always @(posedge clk)
    adc_wren_d <= adc_wren;

always @(posedge clk)
if (trigger_adc_loop)
    counter_adc_wren <= 10'h3FF;
else if ((adc_wren == 1'b1) & (adc_wren_d == 1'b0))
    counter_adc_wren <= counter_adc_wren + 10'd1;
else
    counter_adc_wren <= counter_adc_wren;

always @(posedge clk)
if (adc_wren)
begin
    real_sum_value_1  <= ((result_mux_cnt == 9'd6 ) & (dl_num_adc_loop == 8'd1 ) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_1  + adc_result_muxed)) : real_sum_value_1;
    real_sum_value_2  <= ((result_mux_cnt == 9'd7 ) & (dl_num_adc_loop == 8'd2 ) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_2  + adc_result_muxed)) : real_sum_value_2;
    real_sum_value_3  <= ((result_mux_cnt == 9'd8 ) & (dl_num_adc_loop == 8'd3 ) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_3  + adc_result_muxed)) : real_sum_value_3;
    real_sum_value_4  <= ((result_mux_cnt == 9'd9 ) & (dl_num_adc_loop == 8'd4 ) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_4  + adc_result_muxed)) : real_sum_value_4;
    real_sum_value_5  <= ((result_mux_cnt == 9'd10) & (dl_num_adc_loop == 8'd5 ) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_5  + adc_result_muxed)) : real_sum_value_5;
    real_sum_value_6  <= ((result_mux_cnt == 9'd11) & (dl_num_adc_loop == 8'd6 ) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_6  + adc_result_muxed)) : real_sum_value_6;
    real_sum_value_7  <= ((result_mux_cnt == 9'd12) & (dl_num_adc_loop == 8'd7 ) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_7  + adc_result_muxed)) : real_sum_value_7;
    real_sum_value_8  <= ((result_mux_cnt == 9'd13) & (dl_num_adc_loop == 8'd8 ) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_8  + adc_result_muxed)) : real_sum_value_8;
    real_sum_value_9  <= ((result_mux_cnt == 9'd14) & (dl_num_adc_loop == 8'd9 ) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_9  + adc_result_muxed)) : real_sum_value_9;
    real_sum_value_10 <= ((result_mux_cnt == 9'd15) & (dl_num_adc_loop == 8'd10) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_10 + adc_result_muxed)) : real_sum_value_10;
    real_sum_value_11 <= ((result_mux_cnt == 9'd16) & (dl_num_adc_loop == 8'd11) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_11 + adc_result_muxed)) : real_sum_value_11;
    real_sum_value_12 <= ((result_mux_cnt == 9'd17) & (dl_num_adc_loop == 8'd12) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_12 + adc_result_muxed)) : real_sum_value_12;
    real_sum_value_13 <= ((result_mux_cnt == 9'd18) & (dl_num_adc_loop == 8'd13) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_13 + adc_result_muxed)) : real_sum_value_13;
    real_sum_value_14 <= ((result_mux_cnt == 9'd19) & (dl_num_adc_loop == 8'd14) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_14 + adc_result_muxed)) : real_sum_value_14;
    real_sum_value_15 <= ((result_mux_cnt == 9'd20) & (dl_num_adc_loop == 8'd15) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_15 + adc_result_muxed)) : real_sum_value_15;
    real_sum_value_16 <= ((result_mux_cnt == 9'd21) & (dl_num_adc_loop == 8'd16) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_16 + adc_result_muxed)) : real_sum_value_16;
    real_sum_value_17 <= ((result_mux_cnt == 9'd22) & (dl_num_adc_loop == 8'd17) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_17 + adc_result_muxed)) : real_sum_value_17;
    real_sum_value_18 <= ((result_mux_cnt == 9'd23) & (dl_num_adc_loop == 8'd18) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_18 + adc_result_muxed)) : real_sum_value_18;
    real_sum_value_19 <= ((result_mux_cnt == 9'd24) & (dl_num_adc_loop == 8'd19) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_19 + adc_result_muxed)) : real_sum_value_19;
    real_sum_value_20 <= ((result_mux_cnt == 9'd25) & (dl_num_adc_loop == 8'd20) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_20 + adc_result_muxed)) : real_sum_value_20;
    real_sum_value_21 <= ((result_mux_cnt == 9'd26) & (dl_num_adc_loop == 8'd21) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_21 + adc_result_muxed)) : real_sum_value_21;
    real_sum_value_22 <= ((result_mux_cnt == 9'd27) & (dl_num_adc_loop == 8'd22) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_22 + adc_result_muxed)) : real_sum_value_22;
    real_sum_value_23 <= ((result_mux_cnt == 9'd28) & (dl_num_adc_loop == 8'd23) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_23 + adc_result_muxed)) : real_sum_value_23;
    real_sum_value_24 <= ((result_mux_cnt == 9'd29) & (dl_num_adc_loop == 8'd24) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_24 + adc_result_muxed)) : real_sum_value_24;
    real_sum_value_25 <= ((result_mux_cnt == 9'd30) & (dl_num_adc_loop == 8'd25) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_25 + adc_result_muxed)) : real_sum_value_25;
    real_sum_value_26 <= ((result_mux_cnt == 9'd31) & (dl_num_adc_loop == 8'd26) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_26 + adc_result_muxed)) : real_sum_value_26;
    real_sum_value_27 <= ((result_mux_cnt == 9'd32) & (dl_num_adc_loop == 8'd27) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_27 + adc_result_muxed)) : real_sum_value_27;
    real_sum_value_28 <= ((result_mux_cnt == 9'd33) & (dl_num_adc_loop == 8'd28) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_28 + adc_result_muxed)) : real_sum_value_28;
    real_sum_value_29 <= ((result_mux_cnt == 9'd34) & (dl_num_adc_loop == 8'd29) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_29 + adc_result_muxed)) : real_sum_value_29;
    real_sum_value_30 <= ((result_mux_cnt == 9'd35) & (dl_num_adc_loop == 8'd30) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_30 + adc_result_muxed)) : real_sum_value_30;
    real_sum_value_31 <= ((result_mux_cnt == 9'd36) & (dl_num_adc_loop == 8'd31) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_31 + adc_result_muxed)) : real_sum_value_31;
    real_sum_value_32 <= ((result_mux_cnt == 9'd37) & (dl_num_adc_loop == 8'd32) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_32 + adc_result_muxed)) : real_sum_value_32;
    real_sum_value_33 <= ((result_mux_cnt == 9'd38) & (dl_num_adc_loop == 8'd33) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_33 + adc_result_muxed)) : real_sum_value_33;
    real_sum_value_34 <= ((result_mux_cnt == 9'd39) & (dl_num_adc_loop == 8'd34) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_34 + adc_result_muxed)) : real_sum_value_34;
    real_sum_value_35 <= ((result_mux_cnt == 9'd40) & (dl_num_adc_loop == 8'd35) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_35 + adc_result_muxed)) : real_sum_value_35;
    real_sum_value_36 <= ((result_mux_cnt == 9'd41) & (dl_num_adc_loop == 8'd36) & (counter_adc_wren < IMPEDANCE_WIN_LEN)) ? ((counter_adc_wren == 10'd0) ? adc_result_muxed : (real_sum_value_36 + adc_result_muxed)) : real_sum_value_36;
end

always @(posedge clk)
if ((counter_adc_wren == IMPEDANCE_WIN_LEN) & adc_wren)
begin
    case (result_mux_cnt)
        9'd6  : real_max_value_1  <= {real_sum_value_1[38:7] };
        9'd7  : real_max_value_2  <= {real_sum_value_2[38:7] };
        9'd8  : real_max_value_3  <= {real_sum_value_3[38:7] };
        9'd9  : real_max_value_4  <= {real_sum_value_4[38:7] };
        9'd10 : real_max_value_5  <= {real_sum_value_5[38:7] };
        9'd11 : real_max_value_6  <= {real_sum_value_6[38:7] };
        9'd12 : real_max_value_7  <= {real_sum_value_7[38:7] };
        9'd13 : real_max_value_8  <= {real_sum_value_8[38:7] };
        9'd14 : real_max_value_9  <= {real_sum_value_9[38:7] };
        9'd15 : real_max_value_10 <= {real_sum_value_10[38:7]};
        9'd16 : real_max_value_11 <= {real_sum_value_11[38:7]};
        9'd17 : real_max_value_12 <= {real_sum_value_12[38:7]};
        9'd18 : real_max_value_13 <= {real_sum_value_13[38:7]};
        9'd19 : real_max_value_14 <= {real_sum_value_14[38:7]};
        9'd20 : real_max_value_15 <= {real_sum_value_15[38:7]};
        9'd21 : real_max_value_16 <= {real_sum_value_16[38:7]};
        9'd22 : real_max_value_17 <= {real_sum_value_17[38:7]};
        9'd23 : real_max_value_18 <= {real_sum_value_18[38:7]};
        9'd24 : real_max_value_19 <= {real_sum_value_19[38:7]};
        9'd25 : real_max_value_20 <= {real_sum_value_20[38:7]};
        9'd26 : real_max_value_21 <= {real_sum_value_21[38:7]};
        9'd27 : real_max_value_22 <= {real_sum_value_22[38:7]};
        9'd28 : real_max_value_23 <= {real_sum_value_23[38:7]};
        9'd29 : real_max_value_24 <= {real_sum_value_24[38:7]};
        9'd30 : real_max_value_25 <= {real_sum_value_25[38:7]};
        9'd31 : real_max_value_26 <= {real_sum_value_26[38:7]};
        9'd32 : real_max_value_27 <= {real_sum_value_27[38:7]};
        9'd33 : real_max_value_28 <= {real_sum_value_28[38:7]};
        9'd34 : real_max_value_29 <= {real_sum_value_29[38:7]};
        9'd35 : real_max_value_30 <= {real_sum_value_30[38:7]};
        9'd36 : real_max_value_31 <= {real_sum_value_31[38:7]};
        9'd37 : real_max_value_32 <= {real_sum_value_32[38:7]};
        9'd38 : real_max_value_33 <= {real_sum_value_33[38:7]};
        9'd39 : real_max_value_34 <= {real_sum_value_34[38:7]};
        9'd40 : real_max_value_35 <= {real_sum_value_35[38:7]};
        9'd41 : real_max_value_36 <= {real_sum_value_36[38:7]};
    default:
    begin
        real_max_value_1  <= real_max_value_1;
        real_max_value_2  <= real_max_value_2;
        real_max_value_3  <= real_max_value_3;
        real_max_value_4  <= real_max_value_4;
        real_max_value_5  <= real_max_value_5;
        real_max_value_6  <= real_max_value_6;
        real_max_value_7  <= real_max_value_7;
        real_max_value_8  <= real_max_value_8;
        real_max_value_9  <= real_max_value_9;
        real_max_value_10 <= real_max_value_10;
        real_max_value_11 <= real_max_value_11;
        real_max_value_12 <= real_max_value_12;
        real_max_value_13 <= real_max_value_13;
        real_max_value_14 <= real_max_value_14;
        real_max_value_15 <= real_max_value_15;
        real_max_value_16 <= real_max_value_16;
        real_max_value_17 <= real_max_value_17;
        real_max_value_18 <= real_max_value_18;
        real_max_value_19 <= real_max_value_19;
        real_max_value_20 <= real_max_value_20;
        real_max_value_21 <= real_max_value_21;
        real_max_value_22 <= real_max_value_22;
        real_max_value_23 <= real_max_value_23;
        real_max_value_24 <= real_max_value_24;
        real_max_value_25 <= real_max_value_25;
        real_max_value_26 <= real_max_value_26;
        real_max_value_27 <= real_max_value_27;
        real_max_value_28 <= real_max_value_28;
        real_max_value_29 <= real_max_value_29;
        real_max_value_30 <= real_max_value_30;
        real_max_value_31 <= real_max_value_31;
        real_max_value_32 <= real_max_value_32;
        real_max_value_33 <= real_max_value_33;
        real_max_value_34 <= real_max_value_34;
        real_max_value_35 <= real_max_value_35;
        real_max_value_36 <= real_max_value_36;
    end
    endcase
end







endmodule
 
