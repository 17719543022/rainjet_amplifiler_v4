module iic_eeprom #(
   	parameter				MAIN_CLK_FREQ = 48000000,
	parameter				I2C_CLK_FREQ = 100000
    )(
    input                   clk,
    input                   rst_n,
    input                   i2c_read_trigger1,
    input                   i2c_write_trigger,
    output                  i2c_write_sync,
    input  [ 7:0]           i2c_byte_in,
    output                  scl,
    input                   sda_in,
    output reg              sda_out,
    output reg              sda_z,
    output reg              i2c_byte_out_en,
    output reg [ 7:0]       i2c_byte_out
);

reg [31:0]              i2c_clk_divider;
reg                     i2c_clk;
reg [15:0]              i2c_clk_group;
reg                     i2c_clk_d;
reg                     i2c_clk_byte_en;
reg                     i2c_clk_byte_en_d;
reg                     i2c_clk_read_trigger;
reg [ 7:0]              i2c_clk_byte_out;
wire                    i2c_clk_byte_en_posedge;
reg                     i2c_clk_write_trigger;
reg                     i2c_clk_write_sync;
reg                     i2c_clk_write_sync_d;

wire                    i2c_read_en;
reg [ 7:0]              i2c_read_en_counter;

wire                    i2c_write_en;
reg [ 7:0]              i2c_write_en_counter;

reg [15:0]              current_state;
reg [15:0]              next_state;

localparam [15:0]       STATE_IDLE              = 16'd1;
localparam [15:0]       STATE_START             = 16'd2;
localparam [15:0]       STATE_CONTROL_BYTE_W    = 16'd4;
localparam [15:0]       STATE_ACK0              = 16'd8;
localparam [15:0]       STATE_ADD1              = 16'd16;
localparam [15:0]       STATE_ACK1              = 16'd32;
localparam [15:0]       STATE_ADD2              = 16'd64;
localparam [15:0]       STATE_ACK2              = 16'd128;
localparam [15:0]       STATE_START_R           = 16'd256;
localparam [15:0]       STATE_CONTROL_BYTE_R    = 16'd512;
localparam [15:0]       STATE_ACK3_L            = 16'd1024;
localparam [15:0]       STATE_DATA_R            = 16'd2048;
localparam [15:0]       STATE_ACK3_H            = 16'd4096;
localparam [15:0]       STATE_DATA_W            = 16'd8192;
localparam [15:0]       STATE_ACK_W             = 16'd16384;
localparam [15:0]       STATE_STOP              = 16'd32768;

localparam [ 7:0]       CONTROL_BYTE_W          = 8'b1010_0000;
localparam [ 7:0]       CONTROL_BYTE_R          = 8'b1010_0001;
localparam [ 7:0]       SEQUENTIAL_WRITE        = 8'd12;
localparam [ 7:0]       SEQUENTIAL_READ         = 8'd12;

reg [ 3:0]              i2c_bit_counter;
reg [ 7:0]              sequential_write_counter;
reg [ 7:0]              sequential_read_counter;

reg                     scl_enable;
reg                     scl_enable_d;

reg                     i2c_read_trigger2;
reg  [31:0]             i2c_read_trigger2_counter;

always @(posedge clk)
begin
    if (~rst_n)
        i2c_read_trigger2_counter <= 32'd0;
    else
        i2c_read_trigger2_counter <= (i2c_read_trigger2_counter < I2C_CLK_FREQ) ? (i2c_read_trigger2_counter + 32'd1) : i2c_read_trigger2_counter;
end

always @(posedge clk)
begin
    if (i2c_read_trigger2_counter == (I2C_CLK_FREQ - 5))
        i2c_read_trigger2 <= 1'b1;
    else
        i2c_read_trigger2 <= 1'b0;
end

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
        i2c_clk_byte_out <= 8'd0;
        i2c_clk_write_sync <= 1'b0;
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
                    i2c_clk_byte_out <= 8'd0;
                    i2c_clk_write_sync <= 1'b0;
                end
            end
            STATE_START:
            begin
                if (i2c_read_en | i2c_write_en)
                begin
                    if (i2c_bit_counter == 4'd1)
                    begin
                        next_state <= STATE_CONTROL_BYTE_W;
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
            STATE_CONTROL_BYTE_W:
            begin
                if (i2c_read_en | i2c_write_en)
                begin
                    if (i2c_bit_counter == 4'd7)
                        next_state <= STATE_ACK0;
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                    sda_out <= CONTROL_BYTE_W[7 - i2c_bit_counter]; sda_z <= 1'b0;
                end
            end
            STATE_ACK0:
            begin
                if (i2c_read_en | i2c_write_en)
                begin
                    next_state <= STATE_ADD1;
                    i2c_bit_counter <= 4'd0;
                    sda_z <= 1'b1;
                end
            end
            STATE_ADD1:
            begin
                if (i2c_read_en | i2c_write_en)
                begin
                    if (i2c_bit_counter == 4'd7)
                    begin
                        next_state <= STATE_ACK1;
                    end
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                    sda_out <= 1'b0; sda_z <= 1'b0;
                end
            end
            STATE_ACK1:
            begin
                if (i2c_read_en | i2c_write_en)
                begin
                    next_state <= STATE_ADD2;
                    i2c_bit_counter <= 4'd0;
                    sda_z <= 1'b1;
                end
            end
            STATE_ADD2:
            begin
                if (i2c_read_en | i2c_write_en)
                begin
                    if (i2c_bit_counter == 4'd7)
                    begin
                        next_state <= STATE_ACK2;
                    end
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                    sda_out <= 1'b0; sda_z <= 1'b0;
                end
            end
            STATE_ACK2:
            begin
                if (i2c_read_en)
                begin
                    next_state <= STATE_START_R;
                    i2c_bit_counter <= 4'd0;
                    sda_z <= 1'b1;
                end
                if (i2c_write_en)
                begin
                    next_state <= STATE_DATA_W;
                    sequential_write_counter <= sequential_write_counter + 8'd1;
                    i2c_bit_counter <= 4'd0;
                    sda_z <= 1'b1;
                    i2c_clk_write_sync <= 1'b1;
                end
            end
            STATE_START_R:
            begin
                if (i2c_read_en)
                begin
                    if (i2c_bit_counter == 4'd1)
                    begin
                        next_state <= STATE_CONTROL_BYTE_R;
                        i2c_bit_counter <= 4'd0;
                        scl_enable <= 1'b1;
                        sda_out <= 1'b0; sda_z <= 1'b0;
                    end
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                        scl_enable <= 1'b0;
                        sda_out <= 1'b1; sda_z <= 1'b0;
                    end
                end
            end
            STATE_CONTROL_BYTE_R:
            begin
                if (i2c_read_en)
                begin
                    if (i2c_bit_counter == 4'd7)
                    begin
                        next_state <= STATE_ACK3_L;
                    end
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                    sda_out <= CONTROL_BYTE_R[7 - i2c_bit_counter]; sda_z <= 1'b0;
                end
            end
            STATE_ACK3_L:
            begin
                if (i2c_read_en)
                begin
                    next_state <= STATE_DATA_R;
                    sequential_read_counter <= sequential_read_counter + 8'd1;
                    i2c_bit_counter <= 4'd0;
                    sda_out <= 1'b0; sda_z <= 1'b0;
                end
            end
            STATE_DATA_R:
            begin
                if (i2c_read_en)
                begin
                    if (i2c_bit_counter == 4'd7)
                    begin
                        next_state <= (sequential_read_counter < SEQUENTIAL_READ) ? STATE_ACK3_L : STATE_ACK3_H;
                        i2c_clk_byte_en <= 1'b1;
                    end
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                        i2c_clk_byte_en <= 1'b0;
                    end
                    sda_z <= 1'b1;
                    
                    case (i2c_bit_counter)
                        4'd0: i2c_clk_byte_out[7] <= sda_in;
                        4'd1: i2c_clk_byte_out[6] <= sda_in;
                        4'd2: i2c_clk_byte_out[5] <= sda_in;
                        4'd3: i2c_clk_byte_out[4] <= sda_in;
                        4'd4: i2c_clk_byte_out[3] <= sda_in;
                        4'd5: i2c_clk_byte_out[2] <= sda_in;
                        4'd6: i2c_clk_byte_out[1] <= sda_in;
                        4'd7: i2c_clk_byte_out[0] <= sda_in;
                    default:;
                    endcase
                end
            end
            STATE_ACK3_H:
            begin
                if (i2c_read_en)
                begin
                    i2c_bit_counter <= 4'd0;
                    next_state <= STATE_STOP;
                    sda_out <= 1'b1; sda_z <= 1'b0;
                end
            end
            STATE_DATA_W:
            begin
                if (i2c_write_en)
                begin
                    if (i2c_bit_counter == 4'd7)
                    begin
                        next_state <= (sequential_write_counter < SEQUENTIAL_WRITE) ? STATE_ACK2 : STATE_ACK_W;
                        i2c_bit_counter <= 4'd0;
                    end
                    else
                    begin
                        i2c_bit_counter <= i2c_bit_counter + 4'd1;
                    end
                    
                    case (i2c_bit_counter)
                        4'd0: begin sda_out <= i2c_byte_in[7]; sda_z <= 1'b0; end
                        4'd1: begin sda_out <= i2c_byte_in[6]; sda_z <= 1'b0; end
                        4'd2: begin sda_out <= i2c_byte_in[5]; sda_z <= 1'b0; end
                        4'd3: begin sda_out <= i2c_byte_in[4]; sda_z <= 1'b0; end
                        4'd4: begin sda_out <= i2c_byte_in[3]; sda_z <= 1'b0; end
                        4'd5: begin sda_out <= i2c_byte_in[2]; sda_z <= 1'b0; end
                        4'd6: begin sda_out <= i2c_byte_in[1]; sda_z <= 1'b0; end
                        4'd7: begin sda_out <= i2c_byte_in[0]; sda_z <= 1'b0; end
                    default:;
                    endcase
                    i2c_clk_write_sync <= 1'b0;
                end
            end
            STATE_ACK_W:
            begin
                if (i2c_write_en)
                begin
                    next_state <= STATE_STOP;
                    i2c_bit_counter <= 4'd0;
                    sda_out <= 1'bz; sda_z <= 1'b1;
                end
            end
            STATE_STOP:
            begin
                if (i2c_bit_counter == 4'd1)
                begin
                    next_state <= STATE_IDLE;
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

//=======================================================================
// 1. when i2c_read_trigger1 received, read up ID from eeprom immediately.
// i2c_read_en <= i2c_read_trigger1
// 2. read eeprom once after rst_ctrl.rst_n and return it from
// m_strEndPointEnumerate0x88
//=======================================================================
always @(posedge clk)
begin
    i2c_clk_d <= i2c_clk;
    i2c_clk_byte_en_d <= i2c_clk_byte_en;
end

always @(posedge clk or negedge rst_n)
begin
    if (~rst_n)
        i2c_clk_read_trigger <= 1'b0;
    else if (i2c_read_trigger1 | i2c_read_trigger2)
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

always @(posedge clk)
begin
    if (i2c_clk_byte_en_posedge)
        i2c_byte_out <= i2c_clk_byte_out;
end

always @(posedge clk)
begin
    i2c_byte_out_en <= i2c_clk_byte_en_posedge;
end

assign i2c_read_en = (i2c_read_en_counter > 0) & (i2c_read_en_counter < 151);
assign i2c_clk_byte_en_posedge = (i2c_clk_byte_en == 1'b1) & (i2c_clk_byte_en_d == 1'b0);

//=======================================================================
// when i2c_write_trigger received, write ID to eeprom immediately.
// i2c_write_en <= i2c_write_trigger
//=======================================================================

always @(posedge clk)
begin
    i2c_clk_write_sync_d <= i2c_clk_write_sync;
end

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
assign i2c_write_sync = (i2c_clk_write_sync == 1'b1) & (i2c_clk_write_sync_d == 1'b0);









endmodule
