module baud_rate_generator #(
    parameter CLK_FREQ  = 50_000_000,
    parameter BAUD_RATE = 9600
)(
    input  clk,
    input  reset,
    output tx_enb,
    output rx_enb
);

localparam TX_cycles = CLK_FREQ / BAUD_RATE;         // 5208
localparam RX_cycles = CLK_FREQ / (BAUD_RATE * 16);  // 325

reg [12:0] counter_tx;
reg [9:0] counter_rx;

always @(posedge clk) begin
    if (reset)
        counter_tx <= 0;
    else if (counter_tx == TX_cycles - 1)
        counter_tx <= 0;
    else
        counter_tx <= counter_tx + 1;
end

always @(posedge clk) begin
    if (reset)
        counter_rx <= 0;
    else if (counter_rx == RX_cycles - 1)
        counter_rx <= 0;
    else
        counter_rx <= counter_rx + 1;
end

assign tx_enb = (counter_tx == TX_cycles - 1);
assign rx_enb = (counter_rx == RX_cycles - 1);

endmodule




