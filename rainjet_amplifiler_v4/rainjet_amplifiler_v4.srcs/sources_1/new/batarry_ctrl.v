module batarry_ctrl #(
   	parameter				MAIN_CLK_FREQ = 48000000,
	parameter				I2C_CLK_FREQ = 100000
    )(
    input                   clk,
    input                   rst_n,
    input                   supply_key,
    input                   i2c_read_trigger,
    input                   i2c_write_trigger,
    output reg              supply_out,
    output                  scl,
    input                   sda_in,
    output reg              sda_out,
    output reg              sda_z,
    output reg [15:0]       batarry_protocol_volt,
    input                   batarry_sta1,
    input                   batarry_sta2,
    output reg              batarry_led_red,
    output reg              batarry_led_green,
    output reg              batarry_led_blue,
    output [15:0]           batarry_protocol_stat
);

//##################################################################################
//################################    supply_out   #################################
//##################################################################################
localparam              MINISECOND_DIV = 24000;
localparam              MINISECOND_MUL = 2000;

reg                     clk_div;
reg                     clk_div_d;
reg  [15:0]             clk_divisor;
reg  [15:0]             clk_multiplier;
reg  [15:0]             clk_multiplier_d;
reg                     supply_key_d;
reg                     supply_out_for_key;
reg  [15:0]             batarry_protocol_volt_d;

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
    if ((supply_out_for_key == 1'b0) & (supply_key == 1'b0) & (clk_multiplier_d == (MINISECOND_MUL - 'd1)) & (clk_multiplier == MINISECOND_MUL))
        supply_out_for_key <= 1'b1;
    else if ((supply_out_for_key == 1'b1) & (supply_key == 1'b0) & (clk_multiplier_d == (MINISECOND_MUL - 'd1)) & (clk_multiplier == MINISECOND_MUL))
        supply_out_for_key <= 1'b0;
    else
        supply_out_for_key <= supply_out_for_key;
end

always @(posedge clk)
    batarry_protocol_volt_d <= batarry_protocol_volt;

always @(posedge clk)
begin
    if ((batarry_sta1 == 1'b0) & (batarry_sta2 == 1'b0) & (supply_key == 1'b1) & (batarry_protocol_volt < 16'd8727) & (batarry_protocol_volt_d >= 16'd8727))
        supply_out <= 1'b0;
    else
        supply_out <= supply_out_for_key;
end


//##################################################################################
//###############################    IIC_ADS1110   #################################
//##################################################################################

reg [31:0]              i2c_clk_divider;
reg                     i2c_clk;
reg [15:0]              i2c_clk_group;
reg                     i2c_clk_d;
reg                     i2c_clk_read_trigger;
reg                     i2c_clk_write_trigger;

wire                    i2c_read_en;
reg [ 7:0]              i2c_read_en_counter;

wire                    i2c_write_en;
reg [ 7:0]              i2c_write_en_counter;

reg [15:0]              current_state;
reg [15:0]              next_state;

localparam [15:0]       STATE_IDLE              = 16'd1;
localparam [15:0]       STATE_START             = 16'd2;
localparam [15:0]       STATE_READ_ADDRESS      = 16'd4;
localparam [15:0]       STATE_READ_ACK0         = 16'd8;
localparam [15:0]       STATE_READ_UPPER        = 16'd16;
localparam [15:0]       STATE_READ_ACK1         = 16'd32;
localparam [15:0]       STATE_READ_LOWER        = 16'd64;
localparam [15:0]       STATE_READ_ACK2         = 16'd128;
localparam [15:0]       STATE_READ_CONFIG       = 16'd256;
localparam [15:0]       STATE_READ_ACK3         = 16'd512;
localparam [15:0]       STATE_WRITE_ADDRESS     = 16'd1024;
localparam [15:0]       STATE_WRITE_ACK0        = 16'd2048;
localparam [15:0]       STATE_WRITE_CONFIG      = 16'd4096;
localparam [15:0]       STATE_WRITE_ACK1        = 16'd8192;
localparam [15:0]       STATE_STOP              = 16'd16384;

localparam [ 7:0]       READ_ADDRESS            = 8'b1001_0001;
localparam [ 7:0]       WRITE_ADDRESS           = 8'b1001_0000;
localparam [ 7:0]       CONFIGURE_REG           = 8'b0000_1111;

reg  [ 3:0]             i2c_bit_counter;
reg                     i2c_clk_ads1110_read_en;
reg                     i2c_clk_ads1110_read_en_d;
reg  [15:0]             i2c_clk_ads1110_read;

reg                     scl_enable;
reg                     scl_enable_d;

//=======================================================================
// generate i2c_clk
//=======================================================================
always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        i2c_clk_divider <= 32'd0;
        i2c_clk <= 1'b1;
    end
    else
    begin
        if (i2c_clk_divider == MAIN_CLK_FREQ / I2C_CLK_FREQ - 1)
        begin
            i2c_clk_divider <= 0;
            i2c_clk <= ~i2c_clk;
        end
        else
        begin
            i2c_clk_divider <= i2c_clk_divider + 32'd1;
        end
    end
end

//=======================================================================
// state machine control
//=======================================================================
always @(*)
begin
    if (~rst_n)
    begin
        current_state = STATE_IDLE;
    end
    else
    begin
        current_state = next_state;
    end
end

always @(posedge i2c_clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        next_state <= STATE_IDLE;
        sda_out <= 1'b1; sda_z <= 1'b0;
        scl_enable <= 1'b0;
        i2c_bit_counter <= 4'd0;
        i2c_clk_ads1110_read_en <= 1'b0;
        i2c_clk_ads1110_read <= 16'd0;
    end
    else
    begin
        case (current_state)
            STATE_IDLE:
            begin
                if (i2c_read_en | i2c_write_en)
                begin
                    next_state <= STATE_START;
                    i2c_bit_counter <= 4'd0;
                    i2c_clk_ads1110_read_en <= 1'b0;
                end
            end
            STATE_START:
            begin
                if (i2c_read_en)
                begin
                    if (i2c_bit_counter == 4'd1)
                    begin
                        next_state <= STATE_READ_ADDRESS;
                        i2c_bit_counter <= 4'd0;
                        scl_enable <= 1'b1;
                        sda_out <= 1'b0; sda_z <= 1'b0;
                    end
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                end
                if (i2c_write_en)
                begin
                    if (i2c_bit_counter == 4'd1)
                    begin
                        next_state <= STATE_WRITE_ADDRESS;
                        i2c_bit_counter <= 4'd0;
                        scl_enable <= 1'b1;
                        sda_out <= 1'b0; sda_z <= 1'b0;
                    end
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                end
            end
            STATE_READ_ADDRESS:
            begin
                if (i2c_read_en)
                begin
                    if (i2c_bit_counter == 4'd7)
                        next_state <= STATE_READ_ACK0;
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                    sda_out <= READ_ADDRESS[7 - i2c_bit_counter]; sda_z <= 1'b0;
                end
            end
            STATE_READ_ACK0:
            begin
                if (i2c_read_en)
                begin
                    next_state <= STATE_READ_UPPER;
                    i2c_bit_counter <= 4'd0;
                    sda_z <= 1'b1;
                end
            end
            STATE_READ_UPPER:
            begin
                if (i2c_read_en)
                begin
                    if (i2c_bit_counter == 4'd7)
                    begin
                        next_state <= STATE_READ_ACK1;
                        i2c_bit_counter <= 4'd0;
                    end
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                    i2c_clk_ads1110_read <= {i2c_clk_ads1110_read[14:0], sda_in}; sda_z <= 1'b1;
                end
            end
            STATE_READ_ACK1:
            begin
                next_state <= STATE_READ_LOWER;
                i2c_bit_counter <= 4'd0;
                sda_out = 1'b0; sda_z <= 1'b0;
            end
            STATE_READ_LOWER:
            begin
                if (i2c_read_en)
                begin
                    if (i2c_bit_counter == 4'd7)
                    begin
                        next_state <= STATE_READ_ACK2;
                    end
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                    i2c_clk_ads1110_read <= {i2c_clk_ads1110_read[14:0], sda_in}; sda_z <= 1'b1;
                end
            end
            STATE_READ_ACK2:
            begin
                if (i2c_read_en)
                begin
                    next_state <= STATE_READ_CONFIG;
                    i2c_bit_counter <= 4'd0;
                    sda_out = 1'b0; sda_z <= 1'b0;
                end
            end
            STATE_READ_CONFIG:
            begin
                if (i2c_read_en)
                begin
                    if (i2c_bit_counter == 4'd7)
                    begin
                        next_state <= STATE_READ_ACK3;
                    end
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                    sda_z <= 1'b1;
                end
            end
            STATE_READ_ACK3:
            begin
                if (i2c_read_en)
                begin
                    next_state <= STATE_STOP;
                    i2c_bit_counter <= 4'd0;
                    i2c_clk_ads1110_read_en <= 1'b1;
                    sda_out <= 1'b0; sda_z <= 1'b0;
                end
            end
            STATE_WRITE_ADDRESS:
            begin
                if (i2c_write_en)
                begin
                    if (i2c_bit_counter == 4'd7)
                        next_state <= STATE_WRITE_ACK0;
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                    sda_out <= WRITE_ADDRESS[7 - i2c_bit_counter]; sda_z <= 1'b0;
                end
            end
            STATE_WRITE_ACK0:
            begin
                if (i2c_write_en)
                begin
                    next_state <= STATE_WRITE_CONFIG;
                    i2c_bit_counter <= 4'd0;
                    sda_z <= 1'b1;
                end
            end
            STATE_WRITE_CONFIG:
            begin
                if (i2c_write_en)
                begin
                    if (i2c_bit_counter == 4'd7)
                    begin
                        next_state <= STATE_WRITE_ACK1;
                    end
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                    
                    case (i2c_bit_counter)
                        4'd0: begin sda_out <= CONFIGURE_REG[7]; sda_z <= 1'b0; end
                        4'd1: begin sda_out <= CONFIGURE_REG[6]; sda_z <= 1'b0; end
                        4'd2: begin sda_out <= CONFIGURE_REG[5]; sda_z <= 1'b0; end
                        4'd3: begin sda_out <= CONFIGURE_REG[4]; sda_z <= 1'b0; end
                        4'd4: begin sda_out <= CONFIGURE_REG[3]; sda_z <= 1'b0; end
                        4'd5: begin sda_out <= CONFIGURE_REG[2]; sda_z <= 1'b0; end
                        4'd6: begin sda_out <= CONFIGURE_REG[1]; sda_z <= 1'b0; end
                        4'd7: begin sda_out <= CONFIGURE_REG[0]; sda_z <= 1'b0; end
                    default: ;
                    endcase
                end
            end
            STATE_WRITE_ACK1:
            begin
                if (i2c_write_en)
                begin
                    next_state <= STATE_STOP;
                    i2c_bit_counter <= 4'd0;
                    sda_z <= 1'b1;
                end
            end
            STATE_STOP:
            begin
                i2c_clk_ads1110_read_en <= 1'b0;
                if (i2c_bit_counter == 4'd1)
                begin
                    next_state <= STATE_IDLE;
                    i2c_bit_counter <= 4'd0;
                    sda_out <= 1'b1; sda_z <= 1'b0;
                end
                else
                begin
                    i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    scl_enable <= 1'b0;
                    sda_out <= 1'b0; sda_z <= 1'b0;
                end
            end
            default:
            begin
                next_state <= STATE_IDLE;
                i2c_bit_counter <= 4'd0;
                sda_out <= 1'b1; sda_z <= 1'b0;
            end
        endcase
    end
end

always @(posedge clk or negedge rst_n)
if (~rst_n)
begin
    scl_enable_d <= 1'b0;
end
else
begin
    scl_enable_d <= scl_enable;
end

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
    begin
        i2c_clk_group <= 16'hFF;
    end
    else
    begin
        i2c_clk_group <= {i2c_clk_group[14:0], (scl_enable_d ? i2c_clk : 1'b1)};
    end
end

assign scl = i2c_clk_group[15];

always @(posedge clk)
begin
    i2c_clk_ads1110_read_en_d <= i2c_clk_ads1110_read_en;
end

always @(posedge clk)
begin
    if ((i2c_clk_ads1110_read_en == 1'b0) & (i2c_clk_ads1110_read_en_d == 1'b1))
        batarry_protocol_volt <= i2c_clk_ads1110_read;
end

//=======================================================================
// 1. when i2c_read_trigger received, read up ID from eeprom immediately.
// i2c_read_en <= i2c_read_trigger
// 2. read eeprom once after rst_ctrl.rst_n and return it from
// m_strEndPointEnumerate0x88
//=======================================================================
always @(posedge clk)
begin
    i2c_clk_d <= i2c_clk;
end

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
        i2c_clk_read_trigger <= 1'b0;
    else if (i2c_read_trigger)
        i2c_clk_read_trigger <= 1'b1;
    else if ((i2c_clk_d == 1'b0) & (i2c_clk == 1'b1))
        i2c_clk_read_trigger <= 1'b0;
    else
        i2c_clk_read_trigger <= i2c_clk_read_trigger;
end

always @(posedge i2c_clk or negedge rst_n)
begin
    if (~rst_n)
        i2c_read_en_counter <= 8'd255;
    else if (i2c_clk_read_trigger)
        i2c_read_en_counter <= 8'd0;
    else
        i2c_read_en_counter <= (i2c_read_en_counter < 8'd255) ? (i2c_read_en_counter + 8'd1) : i2c_read_en_counter;
end

assign i2c_read_en = (i2c_read_en_counter > 0) & (i2c_read_en_counter < 41);

//=======================================================================
// when i2c_write_trigger received, write ID to eeprom immediately.
// i2c_write_en <= i2c_write_trigger
//=======================================================================

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
        i2c_clk_write_trigger <= 1'b0;
    else if (i2c_write_trigger)
        i2c_clk_write_trigger <= 1'b1;
    else if ((i2c_clk_d == 1'b0) & (i2c_clk == 1'b1))
        i2c_clk_write_trigger <= 1'b0;
    else
        i2c_clk_write_trigger <= i2c_clk_write_trigger;
end

always @(posedge i2c_clk or negedge rst_n)
begin
    if (~rst_n)
        i2c_write_en_counter <= 8'd255;
    else if (i2c_clk_write_trigger)
        i2c_write_en_counter <= 8'd0;
    else
        i2c_write_en_counter <= (i2c_write_en_counter < 8'd255) ? (i2c_write_en_counter + 8'd1) : i2c_write_en_counter;
end

assign i2c_write_en = (i2c_write_en_counter > 0) & (i2c_write_en_counter < 23);

//##################################################################################
//###########################    RED/GREEN/BLUE LED   ##############################
//##################################################################################

//when charging: (batarry_sta1 == 1'b0) & (batarry_sta2 == 1'b1)
//when charge completed: (batarry_sta1 == 1'b1) & (batarry_sta2 == 1'b0)
//batarry_state == 2'b00: low batarry
//batarry_state == 2'b01: charging
//batarry_state == 2'b10: charge complete
//batarry_state == 2'b11: normal
localparam              CNT_1US_MAX = 6'd48;
localparam              CNT_1MS_MAX = 10'd1000;
localparam              CNT_1S_MAX  = 10'd1000;

reg  [31:0]             led_blink_counter;
reg  [ 1:0]             batarry_state;
reg  [ 3:0]             batarry_cells;

reg  [5:0]              cnt_1us;
reg  [9:0]              cnt_1ms;
reg  [9:0]              cnt_1s;
reg                     cnt_1s_en;

always @(posedge clk)
begin
    if (~rst_n)
        batarry_state <= 2'b00;
    else if ((batarry_sta1 == 1'b0) & (batarry_sta2 == 1'b1))
        batarry_state <= 2'b10;
    else if ((batarry_sta1 == 1'b1) & (batarry_sta2 == 1'b0))
        batarry_state <= 2'b01;
    else if (batarry_protocol_volt < 16'd9018)
        batarry_state <= 2'b11;
    else
        batarry_state <= 2'b00;
end

always @(posedge clk)
begin
    if (~rst_n)
        batarry_cells <= 4'd4;
    else if (batarry_protocol_volt > 16'd11636)
        batarry_cells <= 4'd4;
    else if (batarry_protocol_volt > 16'd10763)
        batarry_cells <= 4'd3;
    else if (batarry_protocol_volt > 16'd10036)
        batarry_cells <= 4'd2;
    else if (batarry_protocol_volt > 16'd9309)
        batarry_cells <= 4'd1;
    else
        batarry_cells <= 4'd0;
end

assign batarry_protocol_stat = {6'd0, batarry_state, 4'd0, batarry_cells};

always @(posedge clk)
begin
    if (~rst_n)
        cnt_1us <= 6'd0;
    else if (cnt_1us == (CNT_1US_MAX - 1))
        cnt_1us <= 6'd0;
    else
        cnt_1us <= cnt_1us + 6'd1;
end

always @(posedge clk)
begin
    if (~rst_n)
        cnt_1ms <= 10'd0;
    else if ((cnt_1ms == (CNT_1MS_MAX - 1)) & (cnt_1us == (CNT_1US_MAX - 1)))
        cnt_1ms <= 10'd0;
    else if (cnt_1us == (CNT_1US_MAX - 1))
        cnt_1ms <= cnt_1ms + 10'd1;
    else
        cnt_1ms <= cnt_1ms;
end

always @(posedge clk)
begin
    if (~rst_n)
        cnt_1s <= 10'd0;
    else if ((cnt_1s == (CNT_1S_MAX - 1)) & (cnt_1ms == (CNT_1MS_MAX - 1)) & (cnt_1us == (CNT_1US_MAX - 1)))
        cnt_1s <= 10'd0;
    else if ((cnt_1ms == (CNT_1MS_MAX - 1)) & (cnt_1us == (CNT_1US_MAX - 1)))
        cnt_1s <= cnt_1s + 10'd1;
    else
        cnt_1s <= cnt_1s;
end

always @(posedge clk)
begin
    if (~rst_n)
        cnt_1s_en <= 1'b0;
    else if ((cnt_1s == (CNT_1S_MAX - 1)) & (cnt_1ms == (CNT_1MS_MAX - 1)) & (cnt_1us == (CNT_1US_MAX - 1)))
        cnt_1s_en <= ~cnt_1s_en;
end

always @(posedge clk)
begin
    if (~rst_n)
        led_blink_counter <= 32'd0;
    else if (led_blink_counter == (MAIN_CLK_FREQ - 1))
        led_blink_counter <= 32'd0;
    else
        led_blink_counter <= led_blink_counter + 32'd1;
end

always @(posedge clk)
begin
    if (~rst_n)
    begin
        batarry_led_red <= 1'bz;
        batarry_led_green <= 1'bz;
        batarry_led_blue <= 1'bz;
    end
    else if ((batarry_sta1 == 1'b0) & (batarry_sta2 == 1'b1))
    begin
        if (((cnt_1s_en == 1'b1) & (cnt_1ms < cnt_1s)) | ((cnt_1s_en == 1'b0) & (cnt_1ms > cnt_1s)))
        begin
            batarry_led_red <= 1'bz;
            batarry_led_green <= 1'b0;
            batarry_led_blue <= 1'bz;
        end
        else
        begin
            batarry_led_red <= 1'bz;
            batarry_led_green <= 1'b1;
            batarry_led_blue <= 1'bz;
        end
    end
    else if ((batarry_sta1 == 1'b1) & (batarry_sta2 == 1'b0))
    begin
        batarry_led_red <= 1'bz;
        batarry_led_green <= 1'b1;
        batarry_led_blue <= 1'bz;
    end
    else if (batarry_protocol_volt < 16'd9018)
    begin
        if (led_blink_counter == MAIN_CLK_FREQ / 2 - 1)
        begin
            batarry_led_red <= 1'b0;
            batarry_led_green <= 1'bz;
            batarry_led_blue <= 1'bz;
        end
        else if (led_blink_counter == MAIN_CLK_FREQ - 1)
        begin
            batarry_led_red <= 1'b1;
            batarry_led_green <= 1'bz;
            batarry_led_blue <= 1'bz;
        end
        else
        begin
            batarry_led_red <= batarry_led_red;
            batarry_led_green <= 1'bz;
            batarry_led_blue <= 1'bz;
        end
    end
    else
    begin
        if (led_blink_counter == MAIN_CLK_FREQ / 2 - 1)
        begin
            batarry_led_red <= 1'bz;
            batarry_led_green <= 1'bz;
            batarry_led_blue <= 1'b0;
        end
        else if (led_blink_counter == MAIN_CLK_FREQ - 1)
        begin
            batarry_led_red <= 1'bz;
            batarry_led_green <= 1'bz;
            batarry_led_blue <= 1'b1;
        end
        else
        begin
            batarry_led_red <= 1'bz;
            batarry_led_green <= 1'bz;
            batarry_led_blue <= batarry_led_blue;
        end
    end
end




endmodule
