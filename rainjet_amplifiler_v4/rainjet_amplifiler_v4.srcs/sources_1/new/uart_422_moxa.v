module uart_422_moxa (
    input                   clk,
    input                   rst_n,
    input                   rxdi,
    output reg              ri,
    output reg              ti,
    output reg              txd,
    output reg [ 7:0]       sbuf_rec,
    input      [ 7:0]       data_to_send,
    input                   uart_send_trigger,
    output                  rxdi_fil,
    input  [15:0]           uart_baud_rate_cnt,
    output reg              uart_tx_state
);

reg  [ 7:0]         sbuf_shfit;
reg  [ 7:0]         uart_rx_state;
reg  [ 7:0]         uart_rx_state_next;
reg  [15:0]         uart_rx_cnt;

reg  [15:0]         uart_tx_cnt;
reg  [ 3:0]         uart_tx_bit_cnt;
wire [ 3:0]         uart_tx_bit_number = 4'd10;

parameter           RXD_STATE_IDLE  = 0;
parameter           RXD_STATE_START = 1;
parameter           RXD_STATE_BIT_0 = 2;
parameter           RXD_STATE_BIT_1 = 3;
parameter           RXD_STATE_BIT_2 = 4;
parameter           RXD_STATE_BIT_3 = 5;
parameter           RXD_STATE_BIT_4 = 6;
parameter           RXD_STATE_BIT_5 = 7;
parameter           RXD_STATE_BIT_6 = 8;
parameter           RXD_STATE_BIT_7 = 9;
parameter           RXD_STATE_END   = 10;

always @(posedge clk)
if(~rst_n)  
    ti <= 1'b0;
else 
    ti <= ((uart_tx_cnt == uart_baud_rate_cnt) & (uart_tx_bit_cnt == uart_tx_bit_number));

always @(posedge clk)
if(~rst_n)  
    txd <= 1'b1;
else if (uart_send_trigger)
    txd <= 1'b0;
else if (uart_tx_cnt == uart_baud_rate_cnt)
begin
    case (uart_tx_bit_cnt)
        4'd0: txd <= data_to_send[0];
        4'd1: txd <= data_to_send[1];
        4'd2: txd <= data_to_send[2];
        4'd3: txd <= data_to_send[3];
        4'd4: txd <= data_to_send[4];
        4'd5: txd <= data_to_send[5];
        4'd6: txd <= data_to_send[6];
        4'd7: txd <= data_to_send[7];
        4'd8: txd <= 1'b1;
        default: ;
        endcase
end

always @(posedge clk)
if (~rst_n)
    uart_tx_bit_cnt <= 'd0;
else if (uart_tx_state & (uart_tx_cnt == uart_baud_rate_cnt))
begin
    if (uart_tx_bit_cnt == uart_tx_bit_number)
        uart_tx_bit_cnt <= 'd0;
    else
        uart_tx_bit_cnt <= uart_tx_bit_cnt + 'd1;
end

always @(posedge clk)
if (~rst_n)
    uart_tx_cnt <= 'd0;
else if (uart_tx_state)
begin
    if (uart_tx_cnt == uart_baud_rate_cnt)
        uart_tx_cnt <= 'd0;
    else
        uart_tx_cnt <= uart_tx_cnt + 'd1;
end

always @(posedge clk)
if (~rst_n)
    uart_tx_state <= 1'b0;
else if (uart_send_trigger)
    uart_tx_state <= 1'b1;
else if (uart_tx_state & (uart_tx_cnt == uart_baud_rate_cnt) & (uart_tx_bit_cnt == uart_tx_bit_number))
    uart_tx_state <= 1'b0;

filter_rxd filter_rxd(
    .clk                (clk            ),
    .pin_in             (rxdi           ),
    .filtered_out       (rxdi_fil       )
);

always @(posedge clk)
if (~rst_n)  
    ri <= 1'b0;
else 
    ri <= ((uart_rx_cnt == uart_baud_rate_cnt[15:1]) & (uart_rx_state == RXD_STATE_END));

always @(posedge clk)
if (~rst_n)
    sbuf_rec <= 8'd0;
else if ((uart_rx_cnt == uart_baud_rate_cnt[15:1]) & (uart_rx_state == RXD_STATE_END))
    sbuf_rec <= sbuf_shfit;

always @(posedge clk)
if (~rst_n)  
    sbuf_shfit <= 'd0;
else if (uart_rx_cnt == uart_baud_rate_cnt[15:1])
begin
    case (uart_rx_state)
    RXD_STATE_BIT_0 : sbuf_shfit[0] <= rxdi_fil;
    RXD_STATE_BIT_1 : sbuf_shfit[1] <= rxdi_fil;
    RXD_STATE_BIT_2 : sbuf_shfit[2] <= rxdi_fil;
    RXD_STATE_BIT_3 : sbuf_shfit[3] <= rxdi_fil;
    RXD_STATE_BIT_4 : sbuf_shfit[4] <= rxdi_fil;
    RXD_STATE_BIT_5 : sbuf_shfit[5] <= rxdi_fil;
    RXD_STATE_BIT_6 : sbuf_shfit[6] <= rxdi_fil;
    RXD_STATE_BIT_7 : sbuf_shfit[7] <= rxdi_fil;
    default: ;
    endcase
end

always @(posedge clk)
if (~rst_n)
    uart_rx_cnt <= 'd0;
else if (uart_rx_state != RXD_STATE_IDLE)
begin
    if (uart_rx_cnt == uart_baud_rate_cnt)
        uart_rx_cnt <= 'd0;
    else
        uart_rx_cnt <= uart_rx_cnt + 'd1;
end
else
begin
    uart_rx_cnt <= 'd0;
end

always @(posedge clk)
if (~rst_n)  
    uart_rx_state <= RXD_STATE_IDLE;
else  
    uart_rx_state <= uart_rx_state_next;

always @(*)
begin
    uart_rx_state_next <= RXD_STATE_IDLE;
    
    case(uart_rx_state)
    RXD_STATE_IDLE: 
        if (~rxdi_fil)
            uart_rx_state_next <= RXD_STATE_START;
        else
            uart_rx_state_next <= RXD_STATE_IDLE;

    RXD_STATE_START:
        if (uart_rx_cnt == uart_baud_rate_cnt)
            uart_rx_state_next <= RXD_STATE_BIT_0;
        else
            uart_rx_state_next <= RXD_STATE_START;

    RXD_STATE_BIT_0:
        if (uart_rx_cnt == uart_baud_rate_cnt)
            uart_rx_state_next <= RXD_STATE_BIT_1;
        else
            uart_rx_state_next <= RXD_STATE_BIT_0;

    RXD_STATE_BIT_1:
        if (uart_rx_cnt == uart_baud_rate_cnt)
            uart_rx_state_next <= RXD_STATE_BIT_2;
        else
            uart_rx_state_next <= RXD_STATE_BIT_1;

    RXD_STATE_BIT_2:
        if (uart_rx_cnt == uart_baud_rate_cnt)
            uart_rx_state_next <= RXD_STATE_BIT_3;
        else
            uart_rx_state_next <= RXD_STATE_BIT_2;

    RXD_STATE_BIT_3:
        if (uart_rx_cnt == uart_baud_rate_cnt)
            uart_rx_state_next <= RXD_STATE_BIT_4;
        else
            uart_rx_state_next <= RXD_STATE_BIT_3;

    RXD_STATE_BIT_4:
        if (uart_rx_cnt == uart_baud_rate_cnt)
            uart_rx_state_next <= RXD_STATE_BIT_5;
        else
            uart_rx_state_next <= RXD_STATE_BIT_4;

    RXD_STATE_BIT_5:
        if (uart_rx_cnt == uart_baud_rate_cnt)
            uart_rx_state_next <= RXD_STATE_BIT_6;
        else
            uart_rx_state_next <= RXD_STATE_BIT_5;

    RXD_STATE_BIT_6:
        if (uart_rx_cnt == uart_baud_rate_cnt)
            uart_rx_state_next <= RXD_STATE_BIT_7;
        else
            uart_rx_state_next <= RXD_STATE_BIT_6;

    RXD_STATE_BIT_7:
        if (uart_rx_cnt == uart_baud_rate_cnt)
            uart_rx_state_next <= RXD_STATE_END;
        else
            uart_rx_state_next <= RXD_STATE_BIT_7;

    RXD_STATE_END:
        if (((uart_rx_cnt > uart_baud_rate_cnt[15:1]) & (~rxdi_fil)) | (uart_rx_cnt == uart_baud_rate_cnt))
            uart_rx_state_next <= RXD_STATE_IDLE;
        else
            uart_rx_state_next <= RXD_STATE_END;

    default: uart_rx_state_next <= RXD_STATE_IDLE;
    endcase
end






endmodule
