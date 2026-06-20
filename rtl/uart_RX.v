module uart_RX(
    input clk, 
    input reset, 
    input sample_tick, 
    input rx, 
    output reg [7:0] rx_data,
    output reg rx_done
);

    parameter idle_state  = 2'b00;
    parameter start_state = 2'b01;
    parameter data_state  = 2'b10;
    parameter stop_state = 2'b11;

    reg [1:0] curr_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;
    reg [3:0] sample_count;

    always @(posedge clk) 
        begin
            if(reset)
                begin
                    curr_state  <= idle_state;
                    bit_count   <= 3'b000;
                    shift_reg   <= 8'b00000000;
                    sample_count <= 4'b0000;
                end
            else
                begin
                    rx_done <= 1'b0;
                    case(curr_state)

                        idle_state : begin
                                        sample_count <= 4'd0;

                                        if(rx == 1'b0) begin                                          
                                                curr_state <= start_state;
                                        end
                                        else begin
                                                curr_state <= idle_state;
                                        end
                                    end
                        
                        start_state : begin
                                        if(sample_tick) begin
                                            
                                            if(sample_count == 4'd7) begin
                                                
                                                if(rx == 0) begin
                                                    sample_count <= 4'd0;
                                                    curr_state <= data_state;
                                                end
                                                else begin
                                                    curr_state <= idle_state;
                                                end
                                            end

                                            else begin
                                                sample_count <= sample_count + 1;
                                            
                                           end
                                        end
                                    end

                        data_state : begin
                                        if(sample_tick) begin
                                            
                                            if(sample_count == 4'd15) begin
                                                
                                                sample_count <= 4'd0;
                                                shift_reg <= (shift_reg >> 1);
                                                shift_reg[7] <= rx;
                                                
                                                if(bit_count == 3'd7) begin
                                                    
                                                    curr_state <= stop_state;
                                                    bit_count <= 3'd0;
                                                end
                                                else begin
                                                    bit_count <= bit_count + 1; 

                                                end
                                            end

                                            else begin
                                                sample_count <= sample_count + 1;
                                            end
                                        
                                    end
                                end

                         stop_state : begin
                                        if(sample_tick) begin

                                            if(sample_count == 4'd15) begin

                                                if(rx == 1'b1) begin
                                                    rx_data <= shift_reg;
                                                    rx_done <= 1'b1;
                                                end

                                                sample_count <= 4'd0;
                                                curr_state <= idle_state;
                                            end
                                            else begin
                                                sample_count <= sample_count + 1;
                                            end
                                        end
                                    end
                        default : curr_state <= idle_state;
                    endcase
                end
        end
endmodule





                                        









