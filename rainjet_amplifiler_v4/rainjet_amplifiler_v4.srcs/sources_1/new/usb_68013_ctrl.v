module usb_68013_ctrl (
    input                   clk,
    input                   rst_n,

    output			        USB_IFCLK,
    output reg              SLV_WR,
    output reg              SLV_RD,
    output reg              SLV_OE,
    output                  SLV_CS,
    output reg              SLV_ADD0,
    output reg              SLV_ADD1,
    input                   SLV_FLAGA,
    input                   SLV_FLAGB,
    output reg              SLV_RST,

    output reg [15:0]       USB_DATA_OUT,
    input [15:0]            USB_DATA_IN,

    output reg [15:0]       adc_sample_period,
    output reg [ 2:0]       adc_trigger_mode,
    output reg [ 2:0]       adc_trigger_source,
    output reg [31:0]       adc_trigger_delay,
    output reg [31:0]       adc_trigger_length,
    output reg [11:0]       adc_trigger_level,
    output reg              adc_sample_en_usb,

    input                   adc_initiate_complete,
    input                   i2c_byte_out_en,
    input [ 7:0]            i2c_byte_out,
    input [31:0]            USB_WR_DATA_ADC,
    input                   fifo_2_usb_empty,
    input [15:0]            fifo_2_usb_usedw,
    output reg              fifo_2_usb_rdreq_usb,

    output reg              usb_cfg_valid,
    output reg              usb_trigger_value_valid,
    output reg [127:0]      usb_cfg_bus,
    output reg              usb_impedance_valid,

    input [31:0]            real_max_value_1,
    input [31:0]            real_max_value_2,
    input [31:0]            real_max_value_3,
    input [31:0]            real_max_value_4,
    input [31:0]            real_max_value_5,
    input [31:0]            real_max_value_6,
    input [31:0]            real_max_value_7,
    input [31:0]            real_max_value_8,
    input [31:0]            real_max_value_9,
    input [31:0]            real_max_value_10,
    input [31:0]            real_max_value_11,
    input [31:0]            real_max_value_12,
    input [31:0]            real_max_value_13,
    input [31:0]            real_max_value_14,
    input [31:0]            real_max_value_15,
    input [31:0]            real_max_value_16,
    input [31:0]            real_max_value_17,
    input [31:0]            real_max_value_18,
    input [31:0]            real_max_value_19,
    input [31:0]            real_max_value_20,
    input [31:0]            real_max_value_21,
    input [31:0]            real_max_value_22,
    input [31:0]            real_max_value_23,
    input [31:0]            real_max_value_24,
    input [31:0]            real_max_value_25,
    input [31:0]            real_max_value_26,
    input [31:0]            real_max_value_27,
    input [31:0]            real_max_value_28,
    input [31:0]            real_max_value_29,
    input [31:0]            real_max_value_30,
    input [31:0]            real_max_value_31,
    input [31:0]            real_max_value_32,
    input [31:0]            real_max_value_33,
    input [31:0]            real_max_value_34,
    input [31:0]            real_max_value_35,
    input [31:0]            real_max_value_36,
    input [31:0]            real_max_value_37,
    input [31:0]            real_max_value_38,
    input [31:0]            real_max_value_39,
    input [31:0]            real_max_value_40,
    input [31:0]            real_max_value_41,
    input [31:0]            real_max_value_42,
    input [31:0]            real_max_value_43,
    input [31:0]            real_max_value_44,
    input [31:0]            real_max_value_45,
    input [31:0]            real_max_value_46,
    input [31:0]            real_max_value_47,
    input [31:0]            real_max_value_48,
    input [31:0]            real_max_value_49,
    input [31:0]            real_max_value_50,
    input [31:0]            real_max_value_51,
    input [31:0]            real_max_value_52,
    input [31:0]            real_max_value_53,
    input [31:0]            real_max_value_54,
    input [31:0]            real_max_value_55,
    input [31:0]            real_max_value_56,
    input [31:0]            real_max_value_57,
    input [31:0]            real_max_value_58,
    input [31:0]            real_max_value_59,
    input [31:0]            real_max_value_60,
    input [31:0]            real_max_value_61,
    input [31:0]            real_max_value_62,
    input [31:0]            real_max_value_63,
    input [31:0]            real_max_value_64,
    input [31:0]            real_max_value_65,
    input [31:0]            real_max_value_66,
    input [31:0]            real_max_value_67,
    input [31:0]            real_max_value_68,
    input [31:0]            real_max_value_69,
    input [31:0]            real_max_value_70,
    input [31:0]            real_max_value_71,
    input [31:0]            real_max_value_72,
    input [31:0]            real_max_value_73,
    input [31:0]            real_max_value_74,
    input [31:0]            real_max_value_75,
    input [31:0]            real_max_value_76,
    input [31:0]            real_max_value_77,
    input [31:0]            real_max_value_78,
    input [31:0]            real_max_value_79,
    input [31:0]            real_max_value_80,
    input [31:0]            real_max_value_81,
    input [31:0]            real_max_value_82,
    input [31:0]            real_max_value_83,
    input [31:0]            real_max_value_84,
    input [31:0]            real_max_value_85,
    input [31:0]            real_max_value_86,
    input [31:0]            real_max_value_87,
    input [31:0]            real_max_value_88,
    input [31:0]            real_max_value_89,
    input [31:0]            real_max_value_90,
    input [31:0]            real_max_value_91,
    input [31:0]            real_max_value_92,
    input [31:0]            real_max_value_93,
    input [31:0]            real_max_value_94,
    input [31:0]            real_max_value_95,
    input [31:0]            real_max_value_96,
    input [31:0]            real_max_value_97,
    input [31:0]            real_max_value_98,
    input [31:0]            real_max_value_99,
    input [31:0]            real_max_value_100,
    input [31:0]            real_max_value_101,
    input [31:0]            real_max_value_102,
    input [31:0]            real_max_value_103,
    input [31:0]            real_max_value_104,
    input [31:0]            real_max_value_105,
    input [31:0]            real_max_value_106,
    input [31:0]            real_max_value_107,
    input [31:0]            real_max_value_108,
    input [31:0]            real_max_value_109,
    input [31:0]            real_max_value_110,
    input [31:0]            real_max_value_111,
    input [31:0]            real_max_value_112,
    input [31:0]            real_max_value_113,
    input [31:0]            real_max_value_114,
    input [31:0]            real_max_value_115,
    input [31:0]            real_max_value_116,
    input [31:0]            real_max_value_117,
    input [31:0]            real_max_value_118,
    input [31:0]            real_max_value_119,
    input [31:0]            real_max_value_120,
    input [31:0]            real_max_value_121,
    input [31:0]            real_max_value_122,
    input [31:0]            real_max_value_123,
    input [31:0]            real_max_value_124,
    input [31:0]            real_max_value_125,
    input [31:0]            real_max_value_126,
    input [31:0]            real_max_value_127,
    input [31:0]            real_max_value_128,
    input [31:0]            real_max_value_129,
    input [31:0]            real_max_value_130,
    input [31:0]            real_max_value_131,
    input [31:0]            real_max_value_132,
    input [31:0]            real_max_value_133,
    input [31:0]            real_max_value_134,
    input [31:0]            real_max_value_135,
    input [31:0]            real_max_value_136,
    input [31:0]            real_max_value_137,
    input [31:0]            real_max_value_138,
    input [31:0]            real_max_value_139,
    input [31:0]            real_max_value_140,
    input [31:0]            real_max_value_141,
    input [31:0]            real_max_value_142,
    input [31:0]            real_max_value_143,
    input [31:0]            real_max_value_144
);

parameter           MAIN_CLK_FREQ = 48000000;

reg   [15:0]        pc_cmd_data;
reg   [ 7:0]        pc_cmd_word_cnt; //对USB指令数据进行计数，单位是16bit，也就是2字节
wire                usb_read_sample_point;
reg                 usb_read_sample_point_d;
wire                pc_cmd_start = usb_read_sample_point_d & (pc_cmd_data[7:0] == "@");
wire                pc_cmd_stop  = usb_read_sample_point_d & ((pc_cmd_data[15:8] == "#")|(pc_cmd_data[7:0] == "#"));
reg   [ 7:0]        pc_cur_cmd;
reg                 bulk_out_trigger_pre;
reg                 bulk_out_trigger_pre_1;
reg                 bulk_out_trigger_pre_2;
reg                 bulk_out_trigger;
reg                 bulk_out_state;
reg   [ 8:0]        bulk_out_state_cnt;
reg                 bulk_out_state_d;
reg                 adc_start_point_org;
reg   [15:0]        USB_DATA_OUT_CMD;

reg   [15:0]        shift_adc_sample_period;
reg   [ 2:0]        shift_adc_trigger_mode;
reg   [ 2:0]        shift_adc_trigger_source;
reg   [23:0]        shift_adc_trigger_delay;
reg   [31:0]        shift_adc_trigger_length;
reg   [11:0]        shift_adc_trigger_level;
wire  [ 3:0]        pc_cmd_data_hex_l, pc_cmd_data_hex_h;
reg                 cmd_data_capture_point;

reg   [23:0]        delay_cnt_100ms;
wire  [23:0]        delay_cnt_100ms_val = MAIN_CLK_FREQ/10 - 1;

reg   [ 7:0]        usb_state;
reg   [ 7:0]        usb_state_next;
reg   [ 3:0]        usb_read_state_cnt;
reg   [ 9:0]        usb_ack_state_cnt;
reg   [ 9:0]        usb_adc_wr_state_cnt;
reg                 fifo_2_usb_rdreq_period;

reg   [15:0]        usb_wr_address;
reg   [31:0]        usb_wr_data;
reg                 usb_wren;

parameter           USB_IDLE           = 8'd0;
parameter           USB_READ_BEGIN     = 8'd1; //读数据的第一拍
parameter           USB_READ_STATE     = 8'd2; //读数据状态
parameter           USB_ACK_BEGIN      = 8'd3; //返回数据的第一拍
parameter           USB_ACK_STATE      = 8'd4; //返回数据状态
parameter           USB_ADC_WR_BEGIN   = 8'd5; //返回数据的第一拍
parameter           USB_ADC_WR_STATE   = 8'd6; //返回数据状态

wire  [31:0]        adc_sample_period_32 = usb_cfg_bus[127:96];

always@(posedge clk)  
if (~rst_n)
    adc_sample_en_usb <= 1'b0;
else if (delay_cnt_100ms == 24'd1)
    adc_sample_en_usb <= 1'b1;
else if (bulk_out_trigger & (pc_cur_cmd == "M"))
    adc_sample_en_usb <= 1'b0;

always@(posedge clk)  
if (~rst_n)
    delay_cnt_100ms <= 24'd0;
else if (adc_start_point_org)
    delay_cnt_100ms <= delay_cnt_100ms_val;
else if (delay_cnt_100ms != 24'd0)
    delay_cnt_100ms <= delay_cnt_100ms - 24'd1;

always@(posedge clk)  
    adc_start_point_org <= (bulk_out_trigger & (pc_cur_cmd == "K"));

always@(posedge clk)  
if (~rst_n)
begin
    adc_sample_period  <= 'd9500;
    adc_trigger_mode   <= 'd0;
    adc_trigger_source <= 'd0;
    adc_trigger_delay  <= 'd0;
    adc_trigger_length <= 'd0;
    adc_trigger_level  <= 'd0;
end
else if (bulk_out_trigger & (pc_cur_cmd == "K"))
begin
    adc_sample_period  <= (shift_adc_sample_period >= 'd9500) ? 'd9500: shift_adc_sample_period; //频率限制
    adc_trigger_mode   <= shift_adc_trigger_mode;  
    adc_trigger_source <= shift_adc_trigger_source;
    adc_trigger_delay  <= shift_adc_trigger_delay; 
    adc_trigger_length <= shift_adc_trigger_length;
    adc_trigger_level  <= shift_adc_trigger_level; 
end

always@(posedge clk)  
if (~rst_n)
    shift_adc_trigger_level <= 12'd0;
else if ((pc_cur_cmd == "K") & cmd_data_capture_point)
    case (pc_cmd_word_cnt)
    8'd11: shift_adc_trigger_level[11: 4] <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    8'd12: shift_adc_trigger_level[ 3: 0] <= pc_cmd_data_hex_l;
    default: ;
    endcase

always@(posedge clk)  
if (~rst_n)
    shift_adc_trigger_length <= 32'd0;
else if ((pc_cur_cmd == "K") & cmd_data_capture_point)
    case (pc_cmd_word_cnt)
    8'd7 : shift_adc_trigger_length[31:24] <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    8'd8 : shift_adc_trigger_length[23:16] <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    8'd9 : shift_adc_trigger_length[15: 8] <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    8'd10: shift_adc_trigger_length[ 7: 0] <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    default: ;
    endcase

always@(posedge clk)  
if (~rst_n)
    shift_adc_trigger_delay <= 32'd0;
else if ((pc_cur_cmd == "K") & cmd_data_capture_point)
    case (pc_cmd_word_cnt)
    8'd4: shift_adc_trigger_delay[23:16] <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    8'd5: shift_adc_trigger_delay[15: 8] <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    8'd6: shift_adc_trigger_delay[ 7: 0] <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    default: ;
    endcase

always@(posedge clk)
begin  
    cmd_data_capture_point  <= usb_read_sample_point_d;
    usb_read_sample_point_d <= usb_read_sample_point;
end

always@(posedge clk)  
if (~rst_n)
begin
    shift_adc_trigger_source <= 8'd0;
    shift_adc_trigger_mode   <= 8'd0;
end
else if ((pc_cur_cmd == "K") & cmd_data_capture_point & (pc_cmd_word_cnt == 3))
begin
    shift_adc_trigger_source <= pc_cmd_data_hex_h;
    shift_adc_trigger_mode   <= pc_cmd_data_hex_l;
end

always@(posedge clk)  
if (~rst_n)
    shift_adc_sample_period <= 16'd0;
else if ((pc_cur_cmd == "K") & cmd_data_capture_point & (pc_cmd_word_cnt == 1))
    shift_adc_sample_period[7:0] <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
else if ((pc_cur_cmd == "K") & cmd_data_capture_point & (pc_cmd_word_cnt == 2))
    shift_adc_sample_period[15:8] <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};

ascii_2_hex ascii_2_hex_low (.clk(clk), .hex_out(pc_cmd_data_hex_l), .asiic_in(pc_cmd_data[7:0] ));
ascii_2_hex ascii_2_hex_high(.clk(clk), .hex_out(pc_cmd_data_hex_h), .asiic_in(pc_cmd_data[15:8]));

always@(posedge clk)  
if(~rst_n)  
    bulk_out_state_cnt <= 'd0;
else if (bulk_out_trigger)
    bulk_out_state_cnt <= 9'd256;
else if (bulk_out_state_cnt != 9'd0)
    bulk_out_state_cnt <= bulk_out_state_cnt - 9'd1;

always@(posedge clk)  
if(~rst_n)  
    bulk_out_state <= 1'b0;
else 
    bulk_out_state <= (bulk_out_state_cnt != 9'd0);

always@(posedge clk)  
begin
    bulk_out_trigger <= bulk_out_trigger_pre_2;
    bulk_out_trigger_pre_2 <= bulk_out_trigger_pre_1;
    bulk_out_trigger_pre_1 <= bulk_out_trigger_pre;
end

always@(posedge clk)  
if(~rst_n)  
    bulk_out_trigger_pre <= 1'b0;
else 
    bulk_out_trigger_pre <= pc_cmd_stop;

always@(posedge clk)  
if(~rst_n)  
    pc_cmd_word_cnt <= 'd0;
else if(pc_cmd_start)
    pc_cmd_word_cnt <= 'd0;
else if (usb_read_sample_point_d)
    pc_cmd_word_cnt <= pc_cmd_word_cnt + 8'd1;

always@(posedge clk)  
  bulk_out_state_d <= bulk_out_state;

always@(posedge clk)  
if(~rst_n)  
    pc_cur_cmd <= "0";
else if (pc_cmd_start)
    pc_cur_cmd <= pc_cmd_data[15:8];
else if (bulk_out_state_d & (~bulk_out_state))
    pc_cur_cmd <= "0";

always@(posedge clk)  
if(~rst_n)  
    pc_cmd_data <= 16'd0;
else if (usb_read_sample_point & adc_initiate_complete)
    pc_cmd_data <= USB_DATA_IN;
else
    pc_cmd_data <= pc_cmd_data;

// read eeprom once after rst_ctrl.rst_n and return it from
// m_strEndPointEnumerate0x88
reg   [ 3:0]        i2c_byte_out_counter;
parameter [ 7:0]    SEQUENTIAL_WRITE = 8'd12;
reg   [ 7:0]        i2c_byte_out_array[SEQUENTIAL_WRITE - 1 : 0];
wire  [ 3:0]        i2c_byte_out_ascii[SEQUENTIAL_WRITE - 1 : 0];

ascii_2_hex ascii_2_hex_0 (.clk(clk), .hex_out(i2c_byte_out_ascii[0]),  .asiic_in(i2c_byte_out_array[0]));
ascii_2_hex ascii_2_hex_1 (.clk(clk), .hex_out(i2c_byte_out_ascii[1]),  .asiic_in(i2c_byte_out_array[1]));
ascii_2_hex ascii_2_hex_2 (.clk(clk), .hex_out(i2c_byte_out_ascii[2]),  .asiic_in(i2c_byte_out_array[2]));
ascii_2_hex ascii_2_hex_3 (.clk(clk), .hex_out(i2c_byte_out_ascii[3]),  .asiic_in(i2c_byte_out_array[3]));
ascii_2_hex ascii_2_hex_4 (.clk(clk), .hex_out(i2c_byte_out_ascii[4]),  .asiic_in(i2c_byte_out_array[4]));
ascii_2_hex ascii_2_hex_5 (.clk(clk), .hex_out(i2c_byte_out_ascii[5]),  .asiic_in(i2c_byte_out_array[5]));
ascii_2_hex ascii_2_hex_6 (.clk(clk), .hex_out(i2c_byte_out_ascii[6]),  .asiic_in(i2c_byte_out_array[6]));
ascii_2_hex ascii_2_hex_7 (.clk(clk), .hex_out(i2c_byte_out_ascii[7]),  .asiic_in(i2c_byte_out_array[7]));
ascii_2_hex ascii_2_hex_8 (.clk(clk), .hex_out(i2c_byte_out_ascii[8]),  .asiic_in(i2c_byte_out_array[8]));
ascii_2_hex ascii_2_hex_9 (.clk(clk), .hex_out(i2c_byte_out_ascii[9]),  .asiic_in(i2c_byte_out_array[9]));
ascii_2_hex ascii_2_hex_10(.clk(clk), .hex_out(i2c_byte_out_ascii[10]), .asiic_in(i2c_byte_out_array[10]));
ascii_2_hex ascii_2_hex_11(.clk(clk), .hex_out(i2c_byte_out_ascii[11]), .asiic_in(i2c_byte_out_array[11]));

always @(posedge clk)
begin
    if (~rst_n)
        i2c_byte_out_counter <= 4'd0;
    else if (i2c_byte_out_en)
    begin
        i2c_byte_out_array[i2c_byte_out_counter] <= i2c_byte_out;
        i2c_byte_out_counter <= (i2c_byte_out_counter == SEQUENTIAL_WRITE - 1) ? 4'd0 : (i2c_byte_out_counter + 4'd1);
    end
    else
        i2c_byte_out_counter <= i2c_byte_out_counter;
end

assign USB_IFCLK = ~clk ;
assign SLV_CS = 1'b0;

always@(posedge clk)
begin
    case (usb_state)
    USB_IDLE: {SLV_ADD1, SLV_ADD0} <= 2'b10;
    USB_ADC_WR_BEGIN: {SLV_ADD1, SLV_ADD0} <= 2'b10;
    USB_ADC_WR_STATE: {SLV_ADD1, SLV_ADD0} <= 2'b10;
    USB_ACK_STATE: {SLV_ADD1, SLV_ADD0} <= 2'b11;
    default: {SLV_ADD1, SLV_ADD0} <= 2'b00;
    endcase
end

wire [15:0] usb_wr_data_adc_short = usb_adc_wr_state_cnt[0] ? USB_WR_DATA_ADC[15:0] : USB_WR_DATA_ADC[31:16];
wire [31:0] len_in_beat = {adc_trigger_length,2'b00} + {adc_trigger_length,1'b0};

always@(posedge clk)
    USB_DATA_OUT <= (usb_state == USB_ACK_STATE) ? USB_DATA_OUT_CMD: usb_wr_data_adc_short;

always@(*)
begin
    case (usb_ack_state_cnt)
    10'd514: USB_DATA_OUT_CMD <= {pc_cur_cmd, "@"};
    10'd513: USB_DATA_OUT_CMD <= {pc_cur_cmd, "@"};
    10'd512: USB_DATA_OUT_CMD <= {16'h0000};
    10'd511: USB_DATA_OUT_CMD <= {7'h0, adc_initiate_complete, 8'h0};
    10'd510: USB_DATA_OUT_CMD <= {i2c_byte_out_ascii[2], i2c_byte_out_ascii[3], i2c_byte_out_ascii[0], i2c_byte_out_ascii[1]}; // Product Date
    10'd509: USB_DATA_OUT_CMD <= {i2c_byte_out_ascii[7], i2c_byte_out_ascii[7], i2c_byte_out_ascii[4], i2c_byte_out_ascii[5]};
    10'd508: USB_DATA_OUT_CMD <= {16'h0000}; // Serial Number
    10'd507: USB_DATA_OUT_CMD <= {i2c_byte_out_ascii[10], i2c_byte_out_ascii[11], i2c_byte_out_ascii[8], i2c_byte_out_ascii[9]};
    10'd506: USB_DATA_OUT_CMD <= {16'h2520}; // Version
    10'd505: USB_DATA_OUT_CMD <= {16'h0704};
    10'd504: USB_DATA_OUT_CMD <= {16'h0000}; // Channel
    10'd503: USB_DATA_OUT_CMD <= {16'h2400};
    10'd502: USB_DATA_OUT_CMD <= {adc_sample_period_32[23:16], adc_sample_period_32[31:24]}; // lADFreq
    10'd501: USB_DATA_OUT_CMD <= {adc_sample_period_32[7:0], adc_sample_period_32[15:8]};
    10'd500: USB_DATA_OUT_CMD <= {16'h0000};
    10'd499: USB_DATA_OUT_CMD <= {adc_sample_period[7:0], adc_sample_period[15:8]}; // 48M/lADFreq
    10'd498: USB_DATA_OUT_CMD <= {adc_trigger_length[23:16], adc_trigger_length[31:24]}; // TriggerLength
    10'd497: USB_DATA_OUT_CMD <= {adc_trigger_length[7:0], adc_trigger_length[15:8]};
    10'd496: USB_DATA_OUT_CMD <= {16'hAA55};
    10'd495: USB_DATA_OUT_CMD <= {16'h00ff};
    10'd494: USB_DATA_OUT_CMD <= {16'h0000}; // MaxFreq
    10'd493: USB_DATA_OUT_CMD <= {16'h1027};
    10'd492: USB_DATA_OUT_CMD <= {16'hAA55};
    10'd491: USB_DATA_OUT_CMD <= {16'h00ff};
    10'd490: USB_DATA_OUT_CMD <= {real_max_value_1[23:16],  real_max_value_1[31:24] };
    10'd489: USB_DATA_OUT_CMD <= {real_max_value_1[ 7: 0],  real_max_value_1[15: 8] };
    10'd488: USB_DATA_OUT_CMD <= {real_max_value_2[23:16],  real_max_value_2[31:24] };
    10'd487: USB_DATA_OUT_CMD <= {real_max_value_2[ 7: 0],  real_max_value_2[15: 8] };
    10'd486: USB_DATA_OUT_CMD <= {real_max_value_3[23:16],  real_max_value_3[31:24] };
    10'd485: USB_DATA_OUT_CMD <= {real_max_value_3[ 7: 0],  real_max_value_3[15: 8] };
    10'd484: USB_DATA_OUT_CMD <= {real_max_value_4[23:16],  real_max_value_4[31:24] };
    10'd483: USB_DATA_OUT_CMD <= {real_max_value_4[ 7: 0],  real_max_value_4[15: 8] };
    10'd482: USB_DATA_OUT_CMD <= {real_max_value_5[23:16],  real_max_value_5[31:24] };
    10'd481: USB_DATA_OUT_CMD <= {real_max_value_5[ 7: 0],  real_max_value_5[15: 8] };
    10'd480: USB_DATA_OUT_CMD <= {real_max_value_6[23:16],  real_max_value_6[31:24] };
    10'd479: USB_DATA_OUT_CMD <= {real_max_value_6[ 7: 0],  real_max_value_6[15: 8] };
    10'd478: USB_DATA_OUT_CMD <= {real_max_value_7[23:16],  real_max_value_7[31:24] };
    10'd477: USB_DATA_OUT_CMD <= {real_max_value_7[ 7: 0],  real_max_value_7[15: 8] };
    10'd476: USB_DATA_OUT_CMD <= {real_max_value_8[23:16],  real_max_value_8[31:24] };
    10'd475: USB_DATA_OUT_CMD <= {real_max_value_8[ 7: 0],  real_max_value_8[15: 8] };
    10'd474: USB_DATA_OUT_CMD <= {real_max_value_9[23:16],  real_max_value_9[31:24] };
    10'd473: USB_DATA_OUT_CMD <= {real_max_value_9[ 7: 0],  real_max_value_9[15: 8] };
    10'd472: USB_DATA_OUT_CMD <= {real_max_value_10[23:16], real_max_value_10[31:24]};
    10'd471: USB_DATA_OUT_CMD <= {real_max_value_10[ 7: 0], real_max_value_10[15: 8]};
    10'd470: USB_DATA_OUT_CMD <= {real_max_value_11[23:16], real_max_value_11[31:24]};
    10'd469: USB_DATA_OUT_CMD <= {real_max_value_11[ 7: 0], real_max_value_11[15: 8]};
    10'd468: USB_DATA_OUT_CMD <= {real_max_value_12[23:16], real_max_value_12[31:24]};
    10'd467: USB_DATA_OUT_CMD <= {real_max_value_12[ 7: 0], real_max_value_12[15: 8]};
    10'd466: USB_DATA_OUT_CMD <= {real_max_value_13[23:16], real_max_value_13[31:24]};
    10'd465: USB_DATA_OUT_CMD <= {real_max_value_13[ 7: 0], real_max_value_13[15: 8]};
    10'd464: USB_DATA_OUT_CMD <= {real_max_value_14[23:16], real_max_value_14[31:24]};
    10'd463: USB_DATA_OUT_CMD <= {real_max_value_14[ 7: 0], real_max_value_14[15: 8]};
    10'd462: USB_DATA_OUT_CMD <= {real_max_value_15[23:16], real_max_value_15[31:24]};
    10'd461: USB_DATA_OUT_CMD <= {real_max_value_15[ 7: 0], real_max_value_15[15: 8]};
    10'd460: USB_DATA_OUT_CMD <= {real_max_value_16[23:16], real_max_value_16[31:24]};
    10'd459: USB_DATA_OUT_CMD <= {real_max_value_16[ 7: 0], real_max_value_16[15: 8]};
    10'd458: USB_DATA_OUT_CMD <= {real_max_value_17[23:16], real_max_value_17[31:24]};
    10'd457: USB_DATA_OUT_CMD <= {real_max_value_17[ 7: 0], real_max_value_17[15: 8]};
    10'd456: USB_DATA_OUT_CMD <= {real_max_value_18[23:16], real_max_value_18[31:24]};
    10'd455: USB_DATA_OUT_CMD <= {real_max_value_18[ 7: 0], real_max_value_18[15: 8]};
    10'd454: USB_DATA_OUT_CMD <= {real_max_value_19[23:16], real_max_value_19[31:24]};
    10'd453: USB_DATA_OUT_CMD <= {real_max_value_19[ 7: 0], real_max_value_19[15: 8]};
    10'd452: USB_DATA_OUT_CMD <= {real_max_value_20[23:16], real_max_value_20[31:24]};
    10'd451: USB_DATA_OUT_CMD <= {real_max_value_20[ 7: 0], real_max_value_20[15: 8]};
    10'd450: USB_DATA_OUT_CMD <= {real_max_value_21[23:16], real_max_value_21[31:24]};
    10'd449: USB_DATA_OUT_CMD <= {real_max_value_21[ 7: 0], real_max_value_21[15: 8]};
    10'd448: USB_DATA_OUT_CMD <= {real_max_value_22[23:16], real_max_value_22[31:24]};
    10'd447: USB_DATA_OUT_CMD <= {real_max_value_22[ 7: 0], real_max_value_22[15: 8]};
    10'd446: USB_DATA_OUT_CMD <= {real_max_value_23[23:16], real_max_value_23[31:24]};
    10'd445: USB_DATA_OUT_CMD <= {real_max_value_23[ 7: 0], real_max_value_23[15: 8]};
    10'd444: USB_DATA_OUT_CMD <= {real_max_value_24[23:16], real_max_value_24[31:24]};
    10'd443: USB_DATA_OUT_CMD <= {real_max_value_24[ 7: 0], real_max_value_24[15: 8]};
    10'd442: USB_DATA_OUT_CMD <= {real_max_value_25[23:16], real_max_value_25[31:24]};
    10'd441: USB_DATA_OUT_CMD <= {real_max_value_25[ 7: 0], real_max_value_25[15: 8]};
    10'd440: USB_DATA_OUT_CMD <= {real_max_value_26[23:16], real_max_value_26[31:24]};
    10'd439: USB_DATA_OUT_CMD <= {real_max_value_26[ 7: 0], real_max_value_26[15: 8]};
    10'd438: USB_DATA_OUT_CMD <= {real_max_value_27[23:16], real_max_value_27[31:24]};
    10'd437: USB_DATA_OUT_CMD <= {real_max_value_27[ 7: 0], real_max_value_27[15: 8]};
    10'd436: USB_DATA_OUT_CMD <= {real_max_value_28[23:16], real_max_value_28[31:24]};
    10'd435: USB_DATA_OUT_CMD <= {real_max_value_28[ 7: 0], real_max_value_28[15: 8]};
    10'd434: USB_DATA_OUT_CMD <= {real_max_value_29[23:16], real_max_value_29[31:24]};
    10'd433: USB_DATA_OUT_CMD <= {real_max_value_29[ 7: 0], real_max_value_29[15: 8]};
    10'd432: USB_DATA_OUT_CMD <= {real_max_value_30[23:16], real_max_value_30[31:24]};
    10'd431: USB_DATA_OUT_CMD <= {real_max_value_30[ 7: 0], real_max_value_30[15: 8]};
    10'd430: USB_DATA_OUT_CMD <= {real_max_value_31[23:16], real_max_value_31[31:24]};
    10'd429: USB_DATA_OUT_CMD <= {real_max_value_31[ 7: 0], real_max_value_31[15: 8]};
    10'd428: USB_DATA_OUT_CMD <= {real_max_value_32[23:16], real_max_value_32[31:24]};
    10'd427: USB_DATA_OUT_CMD <= {real_max_value_32[ 7: 0], real_max_value_32[15: 8]};
    10'd426: USB_DATA_OUT_CMD <= {real_max_value_33[23:16], real_max_value_33[31:24]};
    10'd425: USB_DATA_OUT_CMD <= {real_max_value_33[ 7: 0], real_max_value_33[15: 8]};
    10'd424: USB_DATA_OUT_CMD <= {real_max_value_34[23:16], real_max_value_34[31:24]};
    10'd423: USB_DATA_OUT_CMD <= {real_max_value_34[ 7: 0], real_max_value_34[15: 8]};
    10'd422: USB_DATA_OUT_CMD <= {real_max_value_35[23:16], real_max_value_35[31:24]};
    10'd421: USB_DATA_OUT_CMD <= {real_max_value_35[ 7: 0], real_max_value_35[15: 8]};
    10'd420: USB_DATA_OUT_CMD <= {real_max_value_36[23:16], real_max_value_36[31:24]};
    10'd419: USB_DATA_OUT_CMD <= {real_max_value_36[ 7: 0], real_max_value_36[15: 8]};
    10'd418: USB_DATA_OUT_CMD <= {real_max_value_37[23:16], real_max_value_37[31:24]};
    10'd417: USB_DATA_OUT_CMD <= {real_max_value_37[ 7: 0], real_max_value_37[15: 8]};
    10'd416: USB_DATA_OUT_CMD <= {real_max_value_38[23:16], real_max_value_38[31:24]};
    10'd415: USB_DATA_OUT_CMD <= {real_max_value_38[ 7: 0], real_max_value_38[15: 8]};
    10'd414: USB_DATA_OUT_CMD <= {real_max_value_39[23:16], real_max_value_39[31:24]};
    10'd413: USB_DATA_OUT_CMD <= {real_max_value_39[ 7: 0], real_max_value_39[15: 8]};
    10'd412: USB_DATA_OUT_CMD <= {real_max_value_40[23:16], real_max_value_40[31:24]};
    10'd411: USB_DATA_OUT_CMD <= {real_max_value_40[ 7: 0], real_max_value_40[15: 8]};
    10'd410: USB_DATA_OUT_CMD <= {real_max_value_41[23:16], real_max_value_41[31:24]};
    10'd409: USB_DATA_OUT_CMD <= {real_max_value_41[ 7: 0], real_max_value_41[15: 8]};
    10'd408: USB_DATA_OUT_CMD <= {real_max_value_42[23:16], real_max_value_42[31:24]};
    10'd407: USB_DATA_OUT_CMD <= {real_max_value_42[ 7: 0], real_max_value_42[15: 8]};
    10'd406: USB_DATA_OUT_CMD <= {real_max_value_43[23:16], real_max_value_43[31:24]};
    10'd405: USB_DATA_OUT_CMD <= {real_max_value_43[ 7: 0], real_max_value_43[15: 8]};
    10'd404: USB_DATA_OUT_CMD <= {real_max_value_44[23:16], real_max_value_44[31:24]};
    10'd403: USB_DATA_OUT_CMD <= {real_max_value_44[ 7: 0], real_max_value_44[15: 8]};
    10'd402: USB_DATA_OUT_CMD <= {real_max_value_45[23:16], real_max_value_45[31:24]};
    10'd401: USB_DATA_OUT_CMD <= {real_max_value_45[ 7: 0], real_max_value_45[15: 8]};
    10'd400: USB_DATA_OUT_CMD <= {real_max_value_46[23:16], real_max_value_46[31:24]};
    10'd399: USB_DATA_OUT_CMD <= {real_max_value_46[ 7: 0], real_max_value_46[15: 8]};
    10'd398: USB_DATA_OUT_CMD <= {real_max_value_47[23:16], real_max_value_47[31:24]};
    10'd397: USB_DATA_OUT_CMD <= {real_max_value_47[ 7: 0], real_max_value_47[15: 8]};
    10'd396: USB_DATA_OUT_CMD <= {real_max_value_48[23:16], real_max_value_48[31:24]};
    10'd395: USB_DATA_OUT_CMD <= {real_max_value_48[ 7: 0], real_max_value_48[15: 8]};
    10'd394: USB_DATA_OUT_CMD <= {real_max_value_49[23:16], real_max_value_49[31:24]};
    10'd393: USB_DATA_OUT_CMD <= {real_max_value_49[ 7: 0], real_max_value_49[15: 8]};
    10'd392: USB_DATA_OUT_CMD <= {real_max_value_50[23:16], real_max_value_50[31:24]};
    10'd391: USB_DATA_OUT_CMD <= {real_max_value_50[ 7: 0], real_max_value_50[15: 8]};
    10'd390: USB_DATA_OUT_CMD <= {real_max_value_51[23:16], real_max_value_51[31:24]};
    10'd389: USB_DATA_OUT_CMD <= {real_max_value_51[ 7: 0], real_max_value_51[15: 8]};
    10'd388: USB_DATA_OUT_CMD <= {real_max_value_52[23:16], real_max_value_52[31:24]};
    10'd387: USB_DATA_OUT_CMD <= {real_max_value_52[ 7: 0], real_max_value_52[15: 8]};
    10'd386: USB_DATA_OUT_CMD <= {real_max_value_53[23:16], real_max_value_53[31:24]};
    10'd385: USB_DATA_OUT_CMD <= {real_max_value_53[ 7: 0], real_max_value_53[15: 8]};
    10'd384: USB_DATA_OUT_CMD <= {real_max_value_54[23:16], real_max_value_54[31:24]};
    10'd383: USB_DATA_OUT_CMD <= {real_max_value_54[ 7: 0], real_max_value_54[15: 8]};
    10'd382: USB_DATA_OUT_CMD <= {real_max_value_55[23:16], real_max_value_55[31:24]};
    10'd381: USB_DATA_OUT_CMD <= {real_max_value_55[ 7: 0], real_max_value_55[15: 8]};
    10'd380: USB_DATA_OUT_CMD <= {real_max_value_56[23:16], real_max_value_56[31:24]};
    10'd379: USB_DATA_OUT_CMD <= {real_max_value_56[ 7: 0], real_max_value_56[15: 8]};
    10'd378: USB_DATA_OUT_CMD <= {real_max_value_57[23:16], real_max_value_57[31:24]};
    10'd377: USB_DATA_OUT_CMD <= {real_max_value_57[ 7: 0], real_max_value_57[15: 8]};
    10'd376: USB_DATA_OUT_CMD <= {real_max_value_58[23:16], real_max_value_58[31:24]};
    10'd375: USB_DATA_OUT_CMD <= {real_max_value_58[ 7: 0], real_max_value_58[15: 8]};
    10'd374: USB_DATA_OUT_CMD <= {real_max_value_59[23:16], real_max_value_59[31:24]};
    10'd373: USB_DATA_OUT_CMD <= {real_max_value_59[ 7: 0], real_max_value_59[15: 8]};
    10'd372: USB_DATA_OUT_CMD <= {real_max_value_60[23:16], real_max_value_60[31:24]};
    10'd371: USB_DATA_OUT_CMD <= {real_max_value_60[ 7: 0], real_max_value_60[15: 8]};
    10'd370: USB_DATA_OUT_CMD <= {real_max_value_61[23:16], real_max_value_61[31:24]};
    10'd369: USB_DATA_OUT_CMD <= {real_max_value_61[ 7: 0], real_max_value_61[15: 8]};
    10'd368: USB_DATA_OUT_CMD <= {real_max_value_62[23:16], real_max_value_62[31:24]};
    10'd367: USB_DATA_OUT_CMD <= {real_max_value_62[ 7: 0], real_max_value_62[15: 8]};
    10'd366: USB_DATA_OUT_CMD <= {real_max_value_63[23:16], real_max_value_63[31:24]};
    10'd365: USB_DATA_OUT_CMD <= {real_max_value_63[ 7: 0], real_max_value_63[15: 8]};
    10'd364: USB_DATA_OUT_CMD <= {real_max_value_64[23:16], real_max_value_64[31:24]};
    10'd363: USB_DATA_OUT_CMD <= {real_max_value_64[ 7: 0], real_max_value_64[15: 8]};
    10'd362: USB_DATA_OUT_CMD <= {real_max_value_65[23:16], real_max_value_65[31:24]};
    10'd361: USB_DATA_OUT_CMD <= {real_max_value_65[ 7: 0], real_max_value_65[15: 8]};
    10'd360: USB_DATA_OUT_CMD <= {real_max_value_66[23:16], real_max_value_66[31:24]};
    10'd359: USB_DATA_OUT_CMD <= {real_max_value_66[ 7: 0], real_max_value_66[15: 8]};
    10'd358: USB_DATA_OUT_CMD <= {real_max_value_67[23:16], real_max_value_67[31:24]};
    10'd357: USB_DATA_OUT_CMD <= {real_max_value_67[ 7: 0], real_max_value_67[15: 8]};
    10'd356: USB_DATA_OUT_CMD <= {real_max_value_68[23:16], real_max_value_68[31:24]};
    10'd355: USB_DATA_OUT_CMD <= {real_max_value_68[ 7: 0], real_max_value_68[15: 8]};
    10'd354: USB_DATA_OUT_CMD <= {real_max_value_69[23:16], real_max_value_69[31:24]};
    10'd353: USB_DATA_OUT_CMD <= {real_max_value_69[ 7: 0], real_max_value_69[15: 8]};
    10'd352: USB_DATA_OUT_CMD <= {real_max_value_70[23:16], real_max_value_70[31:24]};
    10'd351: USB_DATA_OUT_CMD <= {real_max_value_70[ 7: 0], real_max_value_70[15: 8]};
    10'd350: USB_DATA_OUT_CMD <= {real_max_value_71[23:16], real_max_value_71[31:24]};
    10'd349: USB_DATA_OUT_CMD <= {real_max_value_71[ 7: 0], real_max_value_71[15: 8]};
    10'd348: USB_DATA_OUT_CMD <= {real_max_value_72[23:16], real_max_value_72[31:24]};
    10'd347: USB_DATA_OUT_CMD <= {real_max_value_72[ 7: 0], real_max_value_72[15: 8]};
    10'd346: USB_DATA_OUT_CMD <= {real_max_value_73[23:16], real_max_value_73[31:24]};
    10'd345: USB_DATA_OUT_CMD <= {real_max_value_73[ 7: 0], real_max_value_73[15: 8]};
    10'd344: USB_DATA_OUT_CMD <= {real_max_value_74[23:16], real_max_value_74[31:24]};
    10'd343: USB_DATA_OUT_CMD <= {real_max_value_74[ 7: 0], real_max_value_74[15: 8]};
    10'd342: USB_DATA_OUT_CMD <= {real_max_value_75[23:16], real_max_value_75[31:24]};
    10'd341: USB_DATA_OUT_CMD <= {real_max_value_75[ 7: 0], real_max_value_75[15: 8]};
    10'd340: USB_DATA_OUT_CMD <= {real_max_value_76[23:16], real_max_value_76[31:24]};
    10'd339: USB_DATA_OUT_CMD <= {real_max_value_76[ 7: 0], real_max_value_76[15: 8]};
    10'd338: USB_DATA_OUT_CMD <= {real_max_value_77[23:16], real_max_value_77[31:24]};
    10'd337: USB_DATA_OUT_CMD <= {real_max_value_77[ 7: 0], real_max_value_77[15: 8]};
    10'd336: USB_DATA_OUT_CMD <= {real_max_value_78[23:16], real_max_value_78[31:24]};
    10'd335: USB_DATA_OUT_CMD <= {real_max_value_78[ 7: 0], real_max_value_78[15: 8]};
    10'd334: USB_DATA_OUT_CMD <= {real_max_value_79[23:16], real_max_value_79[31:24]};
    10'd333: USB_DATA_OUT_CMD <= {real_max_value_79[ 7: 0], real_max_value_79[15: 8]};
    10'd332: USB_DATA_OUT_CMD <= {real_max_value_80[23:16], real_max_value_80[31:24]};
    10'd331: USB_DATA_OUT_CMD <= {real_max_value_80[ 7: 0], real_max_value_80[15: 8]};
    10'd330: USB_DATA_OUT_CMD <= {real_max_value_81[23:16], real_max_value_81[31:24]};
    10'd329: USB_DATA_OUT_CMD <= {real_max_value_81[ 7: 0], real_max_value_81[15: 8]};
    10'd328: USB_DATA_OUT_CMD <= {real_max_value_82[23:16], real_max_value_82[31:24]};
    10'd327: USB_DATA_OUT_CMD <= {real_max_value_82[ 7: 0], real_max_value_82[15: 8]};
    10'd326: USB_DATA_OUT_CMD <= {real_max_value_83[23:16], real_max_value_83[31:24]};
    10'd325: USB_DATA_OUT_CMD <= {real_max_value_83[ 7: 0], real_max_value_83[15: 8]};
    10'd324: USB_DATA_OUT_CMD <= {real_max_value_84[23:16], real_max_value_84[31:24]};
    10'd323: USB_DATA_OUT_CMD <= {real_max_value_84[ 7: 0], real_max_value_84[15: 8]};
    10'd322: USB_DATA_OUT_CMD <= {real_max_value_85[23:16], real_max_value_85[31:24]};
    10'd321: USB_DATA_OUT_CMD <= {real_max_value_85[ 7: 0], real_max_value_85[15: 8]};
    10'd320: USB_DATA_OUT_CMD <= {real_max_value_86[23:16], real_max_value_86[31:24]};
    10'd319: USB_DATA_OUT_CMD <= {real_max_value_86[ 7: 0], real_max_value_86[15: 8]};
    10'd318: USB_DATA_OUT_CMD <= {real_max_value_87[23:16], real_max_value_87[31:24]};
    10'd317: USB_DATA_OUT_CMD <= {real_max_value_87[ 7: 0], real_max_value_87[15: 8]};
    10'd316: USB_DATA_OUT_CMD <= {real_max_value_88[23:16], real_max_value_88[31:24]};
    10'd315: USB_DATA_OUT_CMD <= {real_max_value_88[ 7: 0], real_max_value_88[15: 8]};
    10'd314: USB_DATA_OUT_CMD <= {real_max_value_89[23:16], real_max_value_89[31:24]};
    10'd313: USB_DATA_OUT_CMD <= {real_max_value_89[ 7: 0], real_max_value_89[15: 8]};
    10'd312: USB_DATA_OUT_CMD <= {real_max_value_90[23:16], real_max_value_90[31:24]};
    10'd311: USB_DATA_OUT_CMD <= {real_max_value_90[ 7: 0], real_max_value_90[15: 8]};
    10'd310: USB_DATA_OUT_CMD <= {real_max_value_91[23:16], real_max_value_91[31:24]};
    10'd309: USB_DATA_OUT_CMD <= {real_max_value_91[ 7: 0], real_max_value_91[15: 8]};
    10'd308: USB_DATA_OUT_CMD <= {real_max_value_92[23:16], real_max_value_92[31:24]};
    10'd307: USB_DATA_OUT_CMD <= {real_max_value_92[ 7: 0], real_max_value_92[15: 8]};
    10'd306: USB_DATA_OUT_CMD <= {real_max_value_93[23:16], real_max_value_93[31:24]};
    10'd305: USB_DATA_OUT_CMD <= {real_max_value_93[ 7: 0], real_max_value_93[15: 8]};
    10'd304: USB_DATA_OUT_CMD <= {real_max_value_94[23:16], real_max_value_94[31:24]};
    10'd303: USB_DATA_OUT_CMD <= {real_max_value_94[ 7: 0], real_max_value_94[15: 8]};
    10'd302: USB_DATA_OUT_CMD <= {real_max_value_95[23:16], real_max_value_95[31:24]};
    10'd301: USB_DATA_OUT_CMD <= {real_max_value_95[ 7: 0], real_max_value_95[15: 8]};
    10'd300: USB_DATA_OUT_CMD <= {real_max_value_96[23:16], real_max_value_96[31:24]};
    10'd299: USB_DATA_OUT_CMD <= {real_max_value_96[ 7: 0], real_max_value_96[15: 8]};
    10'd298: USB_DATA_OUT_CMD <= {real_max_value_97[23:16], real_max_value_97[31:24]};
    10'd297: USB_DATA_OUT_CMD <= {real_max_value_97[ 7: 0], real_max_value_97[15: 8]};
    10'd296: USB_DATA_OUT_CMD <= {real_max_value_98[23:16], real_max_value_98[31:24]};
    10'd295: USB_DATA_OUT_CMD <= {real_max_value_98[ 7: 0], real_max_value_98[15: 8]};
    10'd294: USB_DATA_OUT_CMD <= {real_max_value_99[23:16], real_max_value_99[31:24]};
    10'd293: USB_DATA_OUT_CMD <= {real_max_value_99[ 7: 0], real_max_value_99[15: 8]};
    10'd292: USB_DATA_OUT_CMD <= {real_max_value_100[23:16], real_max_value_100[31:24]};
    10'd291: USB_DATA_OUT_CMD <= {real_max_value_100[ 7: 0], real_max_value_100[15: 8]};
    10'd290: USB_DATA_OUT_CMD <= {real_max_value_101[23:16], real_max_value_101[31:24]};
    10'd289: USB_DATA_OUT_CMD <= {real_max_value_101[ 7: 0], real_max_value_101[15: 8]};
    10'd288: USB_DATA_OUT_CMD <= {real_max_value_102[23:16], real_max_value_102[31:24]};
    10'd287: USB_DATA_OUT_CMD <= {real_max_value_102[ 7: 0], real_max_value_102[15: 8]};
    10'd286: USB_DATA_OUT_CMD <= {real_max_value_103[23:16], real_max_value_103[31:24]};
    10'd285: USB_DATA_OUT_CMD <= {real_max_value_103[ 7: 0], real_max_value_103[15: 8]};
    10'd284: USB_DATA_OUT_CMD <= {real_max_value_104[23:16], real_max_value_104[31:24]};
    10'd283: USB_DATA_OUT_CMD <= {real_max_value_104[ 7: 0], real_max_value_104[15: 8]};
    10'd282: USB_DATA_OUT_CMD <= {real_max_value_105[23:16], real_max_value_105[31:24]};
    10'd281: USB_DATA_OUT_CMD <= {real_max_value_105[ 7: 0], real_max_value_105[15: 8]};
    10'd280: USB_DATA_OUT_CMD <= {real_max_value_106[23:16], real_max_value_106[31:24]};
    10'd279: USB_DATA_OUT_CMD <= {real_max_value_106[ 7: 0], real_max_value_106[15: 8]};
    10'd278: USB_DATA_OUT_CMD <= {real_max_value_107[23:16], real_max_value_107[31:24]};
    10'd277: USB_DATA_OUT_CMD <= {real_max_value_107[ 7: 0], real_max_value_107[15: 8]};
    10'd276: USB_DATA_OUT_CMD <= {real_max_value_108[23:16], real_max_value_108[31:24]};
    10'd275: USB_DATA_OUT_CMD <= {real_max_value_108[ 7: 0], real_max_value_108[15: 8]};
    10'd274: USB_DATA_OUT_CMD <= {real_max_value_109[23:16], real_max_value_109[31:24]};
    10'd273: USB_DATA_OUT_CMD <= {real_max_value_109[ 7: 0], real_max_value_109[15: 8]};
    10'd272: USB_DATA_OUT_CMD <= {real_max_value_110[23:16], real_max_value_110[31:24]};
    10'd271: USB_DATA_OUT_CMD <= {real_max_value_110[ 7: 0], real_max_value_110[15: 8]};
    10'd270: USB_DATA_OUT_CMD <= {real_max_value_111[23:16], real_max_value_111[31:24]};
    10'd269: USB_DATA_OUT_CMD <= {real_max_value_111[ 7: 0], real_max_value_111[15: 8]};
    10'd268: USB_DATA_OUT_CMD <= {real_max_value_112[23:16], real_max_value_112[31:24]};
    10'd267: USB_DATA_OUT_CMD <= {real_max_value_112[ 7: 0], real_max_value_112[15: 8]};
    10'd266: USB_DATA_OUT_CMD <= {real_max_value_113[23:16], real_max_value_113[31:24]};
    10'd265: USB_DATA_OUT_CMD <= {real_max_value_113[ 7: 0], real_max_value_113[15: 8]};
    10'd264: USB_DATA_OUT_CMD <= {real_max_value_114[23:16], real_max_value_114[31:24]};
    10'd263: USB_DATA_OUT_CMD <= {real_max_value_114[ 7: 0], real_max_value_114[15: 8]};
    10'd262: USB_DATA_OUT_CMD <= {real_max_value_115[23:16], real_max_value_115[31:24]};
    10'd261: USB_DATA_OUT_CMD <= {real_max_value_115[ 7: 0], real_max_value_115[15: 8]};
    10'd260: USB_DATA_OUT_CMD <= {real_max_value_116[23:16], real_max_value_116[31:24]};
    10'd259: USB_DATA_OUT_CMD <= {real_max_value_116[ 7: 0], real_max_value_116[15: 8]};
    10'd258: USB_DATA_OUT_CMD <= {real_max_value_117[23:16], real_max_value_117[31:24]};
    10'd257: USB_DATA_OUT_CMD <= {real_max_value_117[ 7: 0], real_max_value_117[15: 8]};
    10'd256: USB_DATA_OUT_CMD <= {real_max_value_118[23:16], real_max_value_118[31:24]};
    10'd255: USB_DATA_OUT_CMD <= {real_max_value_118[ 7: 0], real_max_value_118[15: 8]};
    10'd254: USB_DATA_OUT_CMD <= {real_max_value_119[23:16], real_max_value_119[31:24]};
    10'd253: USB_DATA_OUT_CMD <= {real_max_value_119[ 7: 0], real_max_value_119[15: 8]};
    10'd252: USB_DATA_OUT_CMD <= {real_max_value_120[23:16], real_max_value_120[31:24]};
    10'd251: USB_DATA_OUT_CMD <= {real_max_value_120[ 7: 0], real_max_value_120[15: 8]};
    10'd250: USB_DATA_OUT_CMD <= {real_max_value_121[23:16], real_max_value_121[31:24]};
    10'd249: USB_DATA_OUT_CMD <= {real_max_value_121[ 7: 0], real_max_value_121[15: 8]};
    10'd248: USB_DATA_OUT_CMD <= {real_max_value_122[23:16], real_max_value_122[31:24]};
    10'd247: USB_DATA_OUT_CMD <= {real_max_value_122[ 7: 0], real_max_value_122[15: 8]};
    10'd246: USB_DATA_OUT_CMD <= {real_max_value_123[23:16], real_max_value_123[31:24]};
    10'd245: USB_DATA_OUT_CMD <= {real_max_value_123[ 7: 0], real_max_value_123[15: 8]};
    10'd244: USB_DATA_OUT_CMD <= {real_max_value_124[23:16], real_max_value_124[31:24]};
    10'd243: USB_DATA_OUT_CMD <= {real_max_value_124[ 7: 0], real_max_value_124[15: 8]};
    10'd242: USB_DATA_OUT_CMD <= {real_max_value_125[23:16], real_max_value_125[31:24]};
    10'd241: USB_DATA_OUT_CMD <= {real_max_value_125[ 7: 0], real_max_value_125[15: 8]};
    10'd240: USB_DATA_OUT_CMD <= {real_max_value_126[23:16], real_max_value_126[31:24]};
    10'd239: USB_DATA_OUT_CMD <= {real_max_value_126[ 7: 0], real_max_value_126[15: 8]};
    10'd238: USB_DATA_OUT_CMD <= {real_max_value_127[23:16], real_max_value_127[31:24]};
    10'd237: USB_DATA_OUT_CMD <= {real_max_value_127[ 7: 0], real_max_value_127[15: 8]};
    10'd236: USB_DATA_OUT_CMD <= {real_max_value_128[23:16], real_max_value_128[31:24]};
    10'd235: USB_DATA_OUT_CMD <= {real_max_value_128[ 7: 0], real_max_value_128[15: 8]};
    10'd234: USB_DATA_OUT_CMD <= {real_max_value_129[23:16], real_max_value_129[31:24]};
    10'd233: USB_DATA_OUT_CMD <= {real_max_value_129[ 7: 0], real_max_value_129[15: 8]};
    10'd232: USB_DATA_OUT_CMD <= {real_max_value_130[23:16], real_max_value_130[31:24]};
    10'd231: USB_DATA_OUT_CMD <= {real_max_value_130[ 7: 0], real_max_value_130[15: 8]};
    10'd230: USB_DATA_OUT_CMD <= {real_max_value_131[23:16], real_max_value_131[31:24]};
    10'd229: USB_DATA_OUT_CMD <= {real_max_value_131[ 7: 0], real_max_value_131[15: 8]};
    10'd228: USB_DATA_OUT_CMD <= {real_max_value_132[23:16], real_max_value_132[31:24]};
    10'd227: USB_DATA_OUT_CMD <= {real_max_value_132[ 7: 0], real_max_value_132[15: 8]};
    10'd226: USB_DATA_OUT_CMD <= {real_max_value_133[23:16], real_max_value_133[31:24]};
    10'd225: USB_DATA_OUT_CMD <= {real_max_value_133[ 7: 0], real_max_value_133[15: 8]};
    10'd224: USB_DATA_OUT_CMD <= {real_max_value_134[23:16], real_max_value_134[31:24]};
    10'd223: USB_DATA_OUT_CMD <= {real_max_value_134[ 7: 0], real_max_value_134[15: 8]};
    10'd222: USB_DATA_OUT_CMD <= {real_max_value_135[23:16], real_max_value_135[31:24]};
    10'd221: USB_DATA_OUT_CMD <= {real_max_value_135[ 7: 0], real_max_value_135[15: 8]};
    10'd220: USB_DATA_OUT_CMD <= {real_max_value_136[23:16], real_max_value_136[31:24]};
    10'd219: USB_DATA_OUT_CMD <= {real_max_value_136[ 7: 0], real_max_value_136[15: 8]};
    10'd218: USB_DATA_OUT_CMD <= {real_max_value_137[23:16], real_max_value_137[31:24]};
    10'd217: USB_DATA_OUT_CMD <= {real_max_value_137[ 7: 0], real_max_value_137[15: 8]};
    10'd216: USB_DATA_OUT_CMD <= {real_max_value_138[23:16], real_max_value_138[31:24]};
    10'd215: USB_DATA_OUT_CMD <= {real_max_value_138[ 7: 0], real_max_value_138[15: 8]};
    10'd214: USB_DATA_OUT_CMD <= {real_max_value_139[23:16], real_max_value_139[31:24]};
    10'd213: USB_DATA_OUT_CMD <= {real_max_value_139[ 7: 0], real_max_value_139[15: 8]};
    10'd212: USB_DATA_OUT_CMD <= {real_max_value_140[23:16], real_max_value_140[31:24]};
    10'd211: USB_DATA_OUT_CMD <= {real_max_value_140[ 7: 0], real_max_value_140[15: 8]};
    10'd210: USB_DATA_OUT_CMD <= {real_max_value_141[23:16], real_max_value_141[31:24]};
    10'd209: USB_DATA_OUT_CMD <= {real_max_value_141[ 7: 0], real_max_value_141[15: 8]};
    10'd208: USB_DATA_OUT_CMD <= {real_max_value_142[23:16], real_max_value_142[31:24]};
    10'd207: USB_DATA_OUT_CMD <= {real_max_value_142[ 7: 0], real_max_value_142[15: 8]};
    10'd206: USB_DATA_OUT_CMD <= {real_max_value_143[23:16], real_max_value_143[31:24]};
    10'd205: USB_DATA_OUT_CMD <= {real_max_value_143[ 7: 0], real_max_value_143[15: 8]};
    10'd204: USB_DATA_OUT_CMD <= {real_max_value_144[23:16], real_max_value_144[31:24]};
    10'd203: USB_DATA_OUT_CMD <= {real_max_value_144[ 7: 0], real_max_value_144[15: 8]};
    10'd202: USB_DATA_OUT_CMD <= {16'hAAAA};
    10'd201: USB_DATA_OUT_CMD <= {16'h3333};
    10'd200: USB_DATA_OUT_CMD <= {16'hCCCC};
    10'd196: USB_DATA_OUT_CMD <= {16'hCCCC};
    
    default: USB_DATA_OUT_CMD <= {16'h0000};
    endcase
end

assign usb_read_sample_point = (usb_read_state_cnt == 'd5); 

always @(posedge clk)
    fifo_2_usb_rdreq_usb <= (usb_state == USB_ADC_WR_STATE) & fifo_2_usb_rdreq_period & usb_adc_wr_state_cnt[0];

always @(posedge clk)
if(~rst_n)  
    fifo_2_usb_rdreq_period <= 1'b0;
else if (usb_state == USB_ADC_WR_STATE)
begin
    if (usb_adc_wr_state_cnt == 'd260)
        fifo_2_usb_rdreq_period <= 1'b1;
    else if (usb_adc_wr_state_cnt == 'd4)
        fifo_2_usb_rdreq_period <= 1'b0;
end

always @(posedge clk)
if(~rst_n)  
    SLV_WR <= 1'b1;
else if (usb_state == USB_ACK_STATE)
begin
    if (usb_ack_state_cnt == 'd514)
        SLV_WR <= 1'b0;
    else if (usb_ack_state_cnt == 'd2)
        SLV_WR <= 1'b1;
end
else if (usb_state == USB_ADC_WR_STATE)
begin
    if (usb_adc_wr_state_cnt == 'd257)
        SLV_WR <= 1'b0;
    else if (usb_adc_wr_state_cnt == 'd1)
        SLV_WR <= 1'b1;
end

always @(posedge clk)
if(~rst_n)  
    SLV_OE <= 1'b1;
else  
    SLV_OE <= ~((usb_state == USB_READ_STATE) & ((usb_read_state_cnt == 'd7)|(usb_read_state_cnt == 'd6)|(usb_read_state_cnt == 'd5)|(usb_read_state_cnt == 'd4)|(usb_read_state_cnt == 'd3)|(usb_read_state_cnt == 'd2)|(usb_read_state_cnt == 'd1)));   

always @(posedge clk)
if(~rst_n)  
    SLV_RD <= 1'b1;
else 
    SLV_RD <= ~((usb_state == USB_READ_STATE) & (usb_read_state_cnt == 'd4));

always @(posedge clk)
if(~rst_n)  
    usb_adc_wr_state_cnt <= 'd0;
else 
begin
    if (usb_state == USB_ADC_WR_BEGIN)
        usb_adc_wr_state_cnt <= 'd264;
    else if (usb_adc_wr_state_cnt != 'd0)
        usb_adc_wr_state_cnt <= usb_adc_wr_state_cnt - 'd1;
end

always @(posedge clk)
if(~rst_n)  
    usb_ack_state_cnt <= 'd0;
else  
begin
    if (usb_state == USB_ACK_BEGIN)
        usb_ack_state_cnt <= 'd516;
    else if (usb_ack_state_cnt != 'd0)
        usb_ack_state_cnt <= usb_ack_state_cnt - 'd1;
end

always @(posedge clk)
if(~rst_n)  
    usb_read_state_cnt <= 'd0;
else  
begin
    if (usb_state == USB_READ_BEGIN)
        usb_read_state_cnt <= 'd7;
    else if (usb_read_state_cnt != 'd0)
        usb_read_state_cnt <= usb_read_state_cnt - 'd1;
end

always @(posedge clk)
if(~rst_n)  
    usb_state <= USB_IDLE;
else 
    usb_state <= usb_state_next;   

always @(*)
begin
    case(usb_state)
    USB_IDLE: 
    begin
        if (SLV_FLAGA)
            usb_state_next <= USB_READ_BEGIN;
        else if (adc_sample_en_usb & SLV_FLAGB & ((fifo_2_usb_usedw > 16'd130) | ((fifo_2_usb_usedw == 0) & (~fifo_2_usb_empty))))
            usb_state_next <= USB_ADC_WR_BEGIN;
        else
            usb_state_next <= USB_IDLE;
    end
    USB_ADC_WR_BEGIN: 
    begin
        usb_state_next <= USB_ADC_WR_STATE;
    end
    USB_ADC_WR_STATE: 
    begin
        if (usb_adc_wr_state_cnt == 'd0)
            usb_state_next <= USB_IDLE;
        else
            usb_state_next <= USB_ADC_WR_STATE;
    end
    USB_READ_BEGIN: 
    begin
        usb_state_next <= USB_READ_STATE;
    end
    USB_READ_STATE: 
    begin
        if (usb_read_state_cnt == 'd0)
        begin
            if (SLV_FLAGA)
                usb_state_next <= USB_READ_BEGIN;
            else
            begin
                if (pc_cur_cmd == "R")
                    usb_state_next <= USB_ACK_BEGIN;
                else
                    usb_state_next <= USB_IDLE;
            end
        end
        else
            usb_state_next <= USB_READ_STATE;
    end
    USB_ACK_BEGIN: 
    begin
        usb_state_next <= USB_ACK_STATE;
    end
    USB_ACK_STATE: 
    begin
        if (usb_ack_state_cnt == 'd0)
            usb_state_next <= USB_IDLE;
        else
            usb_state_next <= USB_ACK_STATE;
    end
    default: usb_state_next <= USB_IDLE;
    endcase
end

reg [7:0] usb_rst_cnt;	

always @(posedge clk)
    SLV_RST <= (usb_rst_cnt == 8'hff);

always @(posedge clk)
if(~rst_n)  
    usb_rst_cnt <= 'd0;
else if (usb_rst_cnt != 8'hff)
    usb_rst_cnt <= usb_rst_cnt + 'd1;

always@(posedge clk)  
if (~rst_n)
begin
    usb_wr_address <= 16'd0;
    usb_wr_data    <= 32'd0;
end
else if ((pc_cur_cmd == "Z") & cmd_data_capture_point )
    case (pc_cmd_word_cnt)
    'd1:  usb_wr_address[15: 8]  <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    'd2:  usb_wr_address[ 7: 0]  <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    'd3:  usb_wr_data[31:24]     <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    'd4:  usb_wr_data[23:16]     <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    'd5:  usb_wr_data[15: 8]     <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    'd6:  usb_wr_data[ 7: 0]     <= {pc_cmd_data_hex_l, pc_cmd_data_hex_h};
    default:;
    endcase

always@(posedge clk)  
    usb_wren <= ((pc_cur_cmd == "Z") & cmd_data_capture_point & (pc_cmd_word_cnt == 'd6));

always@(posedge clk)  
if (~rst_n)
  usb_cfg_bus <= {32'd40000, 96'd0};
else if (usb_wren)
    case (usb_wr_address)
    'd2: usb_cfg_bus[127:96] <= (usb_wr_data[31:0] >= 6000) ? usb_wr_data[31:0]: 'd6000;
    'd3: usb_cfg_bus[95:64]  <= usb_wr_data[31:0];
    'd4: usb_cfg_bus[63:32]  <= usb_wr_data[31:0];
    'd5: usb_cfg_bus[31:0]   <= usb_wr_data[31:0];
    default:;
    endcase

always@(posedge clk)  
    usb_cfg_valid <= usb_wren & ((usb_wr_address == 'd2)|(usb_wr_address == 'd3)|(usb_wr_address == 'd4)|(usb_wr_address == 'd5));

reg      usb_impedance_valid_pre1;
reg      usb_impedance_valid_pre2;

always@(posedge clk)  
begin
    usb_impedance_valid_pre1 <= usb_wren & (usb_wr_address == 'd5); //& usb_wr_data[12];
    usb_impedance_valid_pre2 <= usb_impedance_valid_pre1;
    usb_impedance_valid      <= usb_impedance_valid_pre2;
end

always@(posedge clk)  
    usb_trigger_value_valid <= usb_wren & (usb_wr_address == 'd3);



endmodule
