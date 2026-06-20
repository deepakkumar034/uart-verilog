module uart_TX(
    input clk, reset, 
    input tx_start, 
    input baud_tick,
    input [7:0] tx_data,
    output reg tx,
    output reg tx_busy,
    output reg tx_done 
);

    parameter idle_state = 2'b00;
    parameter start_state = 2'b01;
    parameter data_state = 2'b10;
    parameter stop_state = 2'b11;

    reg [1:0] curr_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    always @(posedge clk)
        begin
            if(reset)
                begin
                    curr_state <= idle_state;
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    tx_done <= 1'b0;
                    shift_reg <= 8'b00000000;
                    bit_count <= 3'b000;
                end
            else
                begin
                    tx_done <= 1'b0;
                    case(curr_state)
                    
                        idle_state : begin
                                        tx <= 1'b1;
                                        tx_busy <= 1'b0; 

                                        if(tx_start)
                                            begin
                                                curr_state <= start_state;
                                                shift_reg <= tx_data;
                                                bit_count <= 3'b000;
                                                tx_busy <= 1'b1;
                                            end
                                        else
                                            begin
                                                curr_state <= idle_state;
                                            end
                                    end
                        
                        start_state : begin
                                        tx <= 1'b0;

                                        if(baud_tick)
                                            begin
                                                curr_state <= data_state;
                                            end
                                        else
                                            begin
                                                curr_state <= start_state;
                                            end
                                    end

                        data_state : begin
                                        tx <= shift_reg[0];

                                        if(baud_tick)
                                            begin                                             
                                                shift_reg <= shift_reg >> 1;
                                            
                                                if(bit_count == 3'd7) begin
                                                    
                                                    bit_count <= 3'd0;
                                                    curr_state <= stop_state;
                                                end
                                                else
                                                    bit_count <= bit_count + 1;
                                            end
                                        else 
                                            begin 
                                                curr_state <= data_state;
                                            end
                                    end

                        stop_state : begin
                                        tx <= 1'b1;

                                        if(baud_tick)
                                            begin
                                                curr_state <= idle_state;
                                                tx_done <= 1'b1;
                                                tx_busy <= 1'b0;
                                            end
                                     end

                            default: begin
                                        curr_state     <= idle_state;
                                        tx        <= 1'b1;
                                        tx_busy   <= 1'b0;
                                        tx_done   <= 1'b0;
                                    end
                    endcase
                end
            end
endmodule