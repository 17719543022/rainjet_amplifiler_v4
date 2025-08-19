module iic_ads1110 #(
   	parameter				MAIN_CLK_FREQ = 48000000,
	parameter				I2C_CLK_FREQ = 100000
    )(
    input                   clk,
    input                   rst_n,
    input                   sw0,
    output                  scl,
    input                   sda_in,
    output reg              sda_out,
    output reg              sda_z,
    output reg              i2c_byte_en,
    output reg [15:0]       i2c_byte_out
);

reg                     i2c_read_trigger;
reg [31:0]              trigger_counter;
reg [31:0]              trigger_counter_d;

reg                     i2c_write_trigger;

always @(posedge clk)
if (~rst_n)
    trigger_counter <= 32'd0;
else if ((sw0 == 'd0) & (trigger_counter < MAIN_CLK_FREQ + 32'd10))
    trigger_counter <= trigger_counter + 32'd1;
else
    trigger_counter <= trigger_counter;

always @(posedge clk)
    trigger_counter_d <= trigger_counter;

always @(posedge clk)
if ((trigger_counter == MAIN_CLK_FREQ) & (trigger_counter_d == MAIN_CLK_FREQ - 'd1))
    i2c_read_trigger <= 1'b1;
else
    i2c_read_trigger <= 1'b0;
    
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
localparam [15:0]       STATE_ADDRESS_BYTE      = 16'd4;
localparam [15:0]       STATE_RW                = 16'd8;
localparam [15:0]       STATE_READ_ACK0         = 16'd16;
localparam [15:0]       STATE_READ_UPPER        = 16'd32;
localparam [15:0]       STATE_READ_ACK1         = 16'd64;
localparam [15:0]       STATE_READ_LOWER        = 16'd128;
localparam [15:0]       STATE_READ_ACK2         = 16'd256;
localparam [15:0]       STATE_READ_CONFIG       = 16'd512;
localparam [15:0]       STATE_READ_ACK3         = 16'd1024;
localparam [15:0]       STATE_WRITE_ACK0        = 16'd2048;
localparam [15:0]       STATE_WRITE_DRDY        = 16'd4096;
localparam [15:0]       STATE_WRITE_CONFIG      = 16'd8192;
localparam [15:0]       STATE_STOP              = 16'd16384;

localparam [ 7:0]       SLAVE_ADDRESS           = 7'b100_1000;

reg [ 3:0]              i2c_bit_counter;
reg                     i2c_clk_byte_en;
reg                     i2c_clk_byte_en_d;
reg [ 7:0]              sequential_write_counter;
reg [ 7:0]              sequential_read_counter;

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
        sequential_write_counter <= 8'd0;
        sequential_read_counter <= 8'd0;
        sda_out <= 1'b1; sda_z <= 1'b0;
        scl_enable <= 1'b0;
        i2c_bit_counter <= 4'd0;
        i2c_clk_byte_en <= 1'b0;
    end
    else
    begin
        case (current_state)
            STATE_IDLE:
            begin
                if (i2c_read_en | i2c_write_en)
                begin
                    next_state <= STATE_START;
                    sequential_write_counter <= 8'd0;
                    sequential_read_counter <= 8'd0;
                    i2c_bit_counter <= 4'd0;
                    i2c_clk_byte_en <= 1'b0;
                end
            end
            STATE_START:
            begin
                if (i2c_read_en | i2c_write_en)
                begin
                    if (i2c_bit_counter == 4'd1)
                    begin
                        next_state <= STATE_ADDRESS_BYTE;
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
            STATE_ADDRESS_BYTE:
            begin
                if (i2c_read_en | i2c_write_en)
                begin
                    if (i2c_bit_counter == 4'd6)
                        next_state <= STATE_RW;
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                    sda_out <= SLAVE_ADDRESS[6 - i2c_bit_counter]; sda_z <= 1'b0;
                end
            end
            STATE_RW:
            begin
                if (i2c_read_en)
                begin
                    next_state <= STATE_READ_ACK0;
                    i2c_bit_counter <= 4'd0;
                    sda_out <= 1'b1; sda_z <= 1'b0;
                end
                else if (i2c_write_en)
                begin
                    next_state <= STATE_WRITE_ACK0;
                end
                else
                begin
                    next_state <= STATE_IDLE;
                end
            end
            STATE_READ_ACK0:
            begin
                if (i2c_read_en)
                begin
                    next_state <= STATE_READ_UPPER;
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
                    sda_z <= 1'b1;
                    
                    case (i2c_bit_counter)
                        4'd0: i2c_byte_out[15] <= sda_in;
                        4'd1: i2c_byte_out[14] <= sda_in;
                        4'd2: i2c_byte_out[13] <= sda_in;
                        4'd3: i2c_byte_out[12] <= sda_in;
                        4'd4: i2c_byte_out[11] <= sda_in;
                        4'd5: i2c_byte_out[10] <= sda_in;
                        4'd6: i2c_byte_out[ 9] <= sda_in;
                        4'd7: i2c_byte_out[ 8] <= sda_in;
                    default: ;
                    endcase
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
                    sda_z <= 1'b1;
                    
                    case (i2c_bit_counter)
                        4'd0: i2c_byte_out[ 7] <= sda_in;
                        4'd1: i2c_byte_out[ 6] <= sda_in;
                        4'd2: i2c_byte_out[ 5] <= sda_in;
                        4'd3: i2c_byte_out[ 4] <= sda_in;
                        4'd4: i2c_byte_out[ 3] <= sda_in;
                        4'd5: i2c_byte_out[ 2] <= sda_in;
                        4'd6: i2c_byte_out[ 1] <= sda_in;
                        4'd7: i2c_byte_out[ 0] <= sda_in;
                    default: ;
                    endcase
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
                    sda_out <= 1'b0; sda_z <= 1'b0;
                end
            end
            STATE_STOP:
            begin
                if (i2c_bit_counter == 4'd1)
                begin
                    next_state <= STATE_IDLE;
                    i2c_clk_byte_en <= 1'b0;
                    sda_out <= 1'b1; sda_z <= 1'b0;
                end
                else
                begin
                    i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    i2c_clk_byte_en <= 1'b1;
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
        i2c_clk_group <= 16'd65535;
    end
    else
    begin
        i2c_clk_group <= {i2c_clk_group[14:0], (scl_enable_d ? i2c_clk : 1'b1)};
    end
end

assign scl = i2c_clk_group[15];

always @(posedge clk)
begin
    i2c_clk_byte_en_d <= i2c_clk_byte_en;
end

always @(posedge clk)
begin
    i2c_byte_en <= ((i2c_clk_byte_en == 1'b1) & (i2c_clk_byte_en_d == 1'b0));
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

assign i2c_write_en = (i2c_write_en_counter > 0) & (i2c_write_en_counter < 139);



endmodule
