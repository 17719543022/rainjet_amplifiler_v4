module iic_ads1110 #(
   	parameter				MAIN_CLK_FREQ = 48000000,
	parameter				I2C_CLK_FREQ = 100000
    )(
    input                   clk,
    input                   rst_n,
    input                   sw0,
    input                   sw1,
    output                  scl,
    input                   sda_in,
    output reg              sda_out,
    output reg              sda_z,
    output reg              i2c_byte_en,
    output reg [15:0]       i2c_byte_out
);

reg                     i2c_read_trigger;
reg [31:0]              read_trigger_counter;
reg [31:0]              read_trigger_counter_d;

reg                     i2c_write_trigger;
reg [31:0]              write_trigger_counter;
reg [31:0]              write_trigger_counter_d;

always @(posedge clk)
if (~rst_n)
    read_trigger_counter <= 32'd0;
else if ((sw0 == 'd0) & (read_trigger_counter < MAIN_CLK_FREQ + 32'd10))
    read_trigger_counter <= read_trigger_counter + 32'd1;
else
    read_trigger_counter <= read_trigger_counter;

always @(posedge clk)
    read_trigger_counter_d <= read_trigger_counter;

always @(posedge clk)
if ((read_trigger_counter == MAIN_CLK_FREQ) & (read_trigger_counter_d == MAIN_CLK_FREQ - 'd1))
    i2c_read_trigger <= 1'b1;
else
    i2c_read_trigger <= 1'b0;

always @(posedge clk)
if (~rst_n)
    write_trigger_counter <= 32'd0;
else if ((sw1 == 'd0) & (write_trigger_counter < MAIN_CLK_FREQ + 32'd10))
    write_trigger_counter <= write_trigger_counter + 32'd1;
else
    write_trigger_counter <= write_trigger_counter;

always @(posedge clk)
    write_trigger_counter_d <= write_trigger_counter;

always @(posedge clk)
if ((write_trigger_counter == MAIN_CLK_FREQ) & (write_trigger_counter_d == MAIN_CLK_FREQ - 'd1))
    i2c_write_trigger <= 1'b1;
else
    i2c_write_trigger <= 1'b0;

reg [31:0]              i2c_clk_divider;
reg                     i2c_clk;
reg [127:0]             i2c_clk_group;
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

reg [ 3:0]              i2c_bit_counter;
reg                     i2c_clk_byte_en;
reg                     i2c_clk_byte_en_d;

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
        i2c_clk_byte_en <= 1'b0;
        i2c_byte_out <= 16'd0;
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
                    i2c_clk_byte_en <= 1'b0;
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
                    i2c_byte_out <= {i2c_byte_out[14:0], sda_in}; sda_z <= 1'b1;
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
                    i2c_byte_out <= {i2c_byte_out[14:0], sda_in}; sda_z <= 1'b1;
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
                    i2c_clk_byte_en <= 1'b1;
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
                i2c_clk_byte_en <= 1'b0;
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
        i2c_clk_group <= 128'hFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
    end
    else
    begin
        i2c_clk_group <= {i2c_clk_group[126:0], (scl_enable_d ? i2c_clk : 1'b1)};
    end
end

assign scl = i2c_clk_group[127];

always @(posedge clk)
begin
    i2c_clk_byte_en_d <= i2c_clk_byte_en;
end

always @(posedge clk)
begin
    i2c_byte_en <= ((i2c_clk_byte_en == 1'b0) & (i2c_clk_byte_en_d == 1'b1));
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



endmodule
