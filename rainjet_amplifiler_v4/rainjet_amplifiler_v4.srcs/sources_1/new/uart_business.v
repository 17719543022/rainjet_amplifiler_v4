`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/05 17:26:39
// Design Name: 
// Module Name: uart_business
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_business(
    input                   clk,
    input                   rst_n,
    // 202412080001 read and write
    input                   rx,
    output                  tx,
    output reg              i2c_read_trigger,
    input                   i2c_byte_out_en,
    input      [ 7:0]       i2c_byte_out,
    output reg              i2c_write_trigger,
    input                   i2c_write_sync,
    output reg [ 7:0]       i2c_write_byte_sync,
    // uart trigger data
    output                  uart_ri,
    output reg [ 7:0]       uart_trig_data
    );

    parameter [ 7:0]        SEQUENTIAL_WRITE    = 8'd12;

    wire                    rx_byte_en;
    wire [ 7:0]             rx_byte;

    reg  [ 3:0]             i2c_write_byte_cnt;
    reg  [ 7:0]             rx_byte_array[SEQUENTIAL_WRITE - 1 : 0];
    
    uart_422_moxa uart_422_moxa(
        .clk                    (clk                ),
        .rst_n                  (rst_n              ),
        .rxdi                   (rx                 ),
        .ri                     (rx_byte_en         ),
        .ti                     (                   ),
        .txd                    (tx                 ),
        .sbuf_rec               (rx_byte            ),
        .data_to_send           (i2c_byte_out       ),
        .uart_send_trigger      (i2c_byte_out_en    ),
        .rxdi_fil               (                   ),
        .uart_baud_rate_cnt     (16'd417            ), //9600bps: 5000, 115200bps: 417, 921600: 52
        .uart_tx_state          (                   )
    );

    reg                     rx_start;
    reg                     rx_stop;
    reg                     rx_write_en;
    reg                     i2c_trig_trigger;
    reg                     i2c_trig_trigger_d1;
    reg                     i2c_trig_trigger_d2;
    reg                     i2c_trig_trigger_d3;
    reg                     i2c_trig_trigger_d4;
    reg                     i2c_trig_trigger_d5;
    reg                     rx_trig_en;
    reg  [ 7:0]             rx_trig_hex_h;
    reg  [ 7:0]             rx_trig_hex_l;
    wire [ 3:0]             rx_trig_dec_h;
    wire [ 3:0]             rx_trig_dec_l;
    reg  [ 7:0]             rx_byte_cnt;
    
    always @(posedge clk)
    begin
        if (rx_byte_en)
            rx_start <= (rx_byte == "@") ? 1'b1 : 1'b0;
        else
            rx_start <= 1'b0;
    end
    
    always @(posedge clk)
    begin
        if (rx_byte_en)
            rx_stop <= (rx_byte == "#") ? 1'b1 : 1'b0;
        else
            rx_stop <= 1'b0;
    end
    
    always @(posedge clk)
    begin
        if (rx_byte_en)
            i2c_read_trigger <= ((rx_byte == "R") & (rx_byte_cnt == 8'd1)) ? 1'b1 : 1'b0;
        else
            i2c_read_trigger <= 1'b0;
    end
    
    always @(posedge clk)
    begin
        if ((~rst_n) | rx_start | rx_stop)
            i2c_trig_trigger <= 1'b0;
        else
            i2c_trig_trigger <= rx_byte_en & (rx_byte_cnt == 8'd3) & rx_trig_en;
    end
    
    always @(posedge clk)
    begin
        i2c_trig_trigger_d5 <= i2c_trig_trigger_d4;
        i2c_trig_trigger_d4 <= i2c_trig_trigger_d3;
        i2c_trig_trigger_d3 <= i2c_trig_trigger_d2;
        i2c_trig_trigger_d2 <= i2c_trig_trigger_d1;
        i2c_trig_trigger_d1 <= i2c_trig_trigger;
    end
    
    assign uart_ri = i2c_trig_trigger_d5;
    
    always @(posedge clk)
    begin
        if ((~rst_n) | rx_start | rx_stop)
            rx_trig_en <= 1'b0;
        else if (rx_byte_en & (rx_byte_cnt == 8'd1))
            rx_trig_en <= (rx_byte == "T") ? 1'b1 : 1'b0;
        else
            rx_trig_en <= rx_trig_en;
    end
    
    always @(posedge clk)
    begin
        if ((~rst_n) | rx_start | rx_stop)
        begin
            rx_trig_hex_h <= 8'd0;
            rx_trig_hex_l <= 8'd0;
        end
        else if (rx_trig_en & rx_byte_en)
        begin
            case (rx_byte_cnt)
                8'd2 : rx_trig_hex_h <= rx_byte;
                8'd3 : rx_trig_hex_l <= rx_byte;
            default: ;
            endcase
        end
        else
        begin
            rx_trig_hex_h <= rx_trig_hex_h;
            rx_trig_hex_l <= rx_trig_hex_l;
        end
    end
    
    ascii_2_hex asiic_2_hex_high (
        .clk                        (clk                ),
        .hex_out                    (rx_trig_dec_h      ),
        .asiic_in                   (rx_trig_hex_h      )
    );
    
    ascii_2_hex asiic_2_hex_low (
        .clk                        (clk                ),
        .hex_out                    (rx_trig_dec_l      ),
        .asiic_in                   (rx_trig_hex_l      )
    );

    always @(posedge clk or negedge rst_n)
    if (~rst_n)
        uart_trig_data <= 8'd0;
    else
        uart_trig_data <= rx_trig_dec_h * 4'd10 + rx_trig_dec_l;

    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n)
            rx_byte_cnt <= 8'd0;
        else if (rx_byte_en & (rx_byte_cnt < 8'd64))
            rx_byte_cnt <= (rx_byte == "@") ? 8'd1 : rx_byte_cnt + 8'd1;
        else
            rx_byte_cnt <= rx_byte_cnt;
    end

    always @(posedge clk)
    begin
        if ((~rst_n) | rx_start | rx_stop)
            rx_write_en <= 1'b0;
        else if (rx_byte_en & (rx_byte_cnt == 8'd1))
            rx_write_en <= (rx_byte == "W") ? 1'b1 : 1'b0;
        else
            rx_write_en <= rx_write_en;
    end

    always @(posedge clk)
    if (rx_write_en & rx_byte_en)
    begin
        case (rx_byte_cnt)
            8'd2 : rx_byte_array[ 0] <= rx_byte;
            8'd3 : rx_byte_array[ 1] <= rx_byte;
            8'd4 : rx_byte_array[ 2] <= rx_byte;
            8'd5 : rx_byte_array[ 3] <= rx_byte;
            8'd6 : rx_byte_array[ 4] <= rx_byte;
            8'd7 : rx_byte_array[ 5] <= rx_byte;
            8'd8 : rx_byte_array[ 6] <= rx_byte;
            8'd9 : rx_byte_array[ 7] <= rx_byte;
            8'd10: rx_byte_array[ 8] <= rx_byte;
            8'd11: rx_byte_array[ 9] <= rx_byte;
            8'd12: rx_byte_array[10] <= rx_byte;
            8'd13: rx_byte_array[11] <= rx_byte;
        default: ;
        endcase
    end
    
    always @(posedge clk or negedge rst_n)
    begin
        if (~rst_n)
            i2c_write_trigger <= 1'b0;
        else if (rx_byte_en)
            i2c_write_trigger <=  rx_write_en & (rx_byte == "#");
        else
            i2c_write_trigger <= 1'b0;
    end
    
    always @(posedge clk or negedge rst_n)
    begin
        if ((~rst_n) | (i2c_write_trigger))
            i2c_write_byte_cnt <= 4'd0;
        else
            i2c_write_byte_cnt <= (i2c_write_sync == 1'b1) ? (i2c_write_byte_cnt + 4'd1) : i2c_write_byte_cnt;
    end
    
    always @(posedge clk)
    begin
        if (i2c_write_sync)
        begin
            case (i2c_write_byte_cnt)
                4'd0 : i2c_write_byte_sync <= rx_byte_array[0] ;
                4'd1 : i2c_write_byte_sync <= rx_byte_array[1] ;
                4'd2 : i2c_write_byte_sync <= rx_byte_array[2] ;
                4'd3 : i2c_write_byte_sync <= rx_byte_array[3] ;
                4'd4 : i2c_write_byte_sync <= rx_byte_array[4] ;
                4'd5 : i2c_write_byte_sync <= rx_byte_array[5] ;
                4'd6 : i2c_write_byte_sync <= rx_byte_array[6] ;
                4'd7 : i2c_write_byte_sync <= rx_byte_array[7] ;
                4'd8 : i2c_write_byte_sync <= rx_byte_array[8] ;
                4'd9 : i2c_write_byte_sync <= rx_byte_array[9] ;
                4'd10: i2c_write_byte_sync <= rx_byte_array[10];
                4'd11: i2c_write_byte_sync <= rx_byte_array[11];
            default: ;
            endcase
        end
    end







endmodule
