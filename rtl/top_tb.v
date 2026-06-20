`timescale 1ns/1ps

module top_tb;

    reg clk;
    reg reset;
    reg tx_start;
    reg [7:0] tx_data;

    wire tx;
    wire tx_busy;
    wire tx_done;

    wire [7:0] rx_data;
    wire rx_done;

    // DUT
    top dut (
        .clk(clk),
        .reset(reset),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy),
        .tx_done(tx_done),
        .rx(tx),          // UART loopback
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // 50 MHz Clock
    initial begin
        clk = 1;
        forever #10 clk = ~clk;
    end

    // Timeout
    initial begin
        #15000000;
        $display("TIMEOUT");
        $finish;
    end

    initial begin

        $display("Simulation Started");

        $dumpfile("uart_top.vcd");
        $dumpvars(0, top_tb);
        $dumpvars(0, dut);

        reset    = 1'b1;
        tx_start = 1'b0;
        tx_data  = 8'h00;

        #100;
        reset = 1'b0;

       
        //  Send 0x55

        #100;

        tx_data  = 8'h55;
        tx_start = 1'b1;

        #20;
        tx_start = 1'b0;

        @(posedge rx_done);

        $display("Received = %h", rx_data);

        if(rx_data == 8'h55)
            $display("TEST1 PASSED");
        else
            $display("TEST1 FAILED");

        //  Send 0xA3

        #100000;

        tx_data  = 8'hA3;
        tx_start = 1'b1;

        #20;
        tx_start = 1'b0;

        @(posedge rx_done);

        $display("Received = %h", rx_data);

        if(rx_data == 8'hA3)
            $display("TEST2 PASSED");
        else
            $display("TEST2 FAILED");

        #10000;

        $display("Simulation Finished");
        $finish;
    end

    // Debug Messages
    always @(posedge tx_done)
        $display("[%0t] TX_DONE", $time);

    always @(posedge rx_done)
        $display("[%0t] RX_DONE Data = %h", $time, rx_data);

endmodule