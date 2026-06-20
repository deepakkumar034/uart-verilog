module top(
    input clk,
    input reset,

    input tx_start,
    input [7:0] tx_data,

    output tx,
    output tx_busy,
    output tx_done,

    input rx,
    output [7:0] rx_data,
    output rx_done
);

    wire tx_enb;
    wire rx_enb;

    baud_rate_generator #(
        .CLK_FREQ(50_000_000),
        .BAUD_RATE(9600)
    ) baud_gen (
        .clk(clk),
        .reset(reset),
        .tx_enb(tx_enb),
        .rx_enb(rx_enb)
    );

    uart_TX tx_inst (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .baud_tick(tx_enb),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done)
    );

    uart_RX rx_inst (
        .clk(clk),
        .reset(reset),
        .sample_tick(rx_enb),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

endmodule