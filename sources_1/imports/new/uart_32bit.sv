`timescale 1ns / 1ps
module uart_32bit(
    input logic clk, reset,
    input logic rx_in,
    input logic tx_valid, 
    input logic [2:0] rx_count,
    input logic [31:0] tx_data,
    output logic tx_ready,
    output logic tx_out,
    output logic rx_valid,
    output logic tx_led,
    output logic [7:0] rx_data,
    output logic [63:0] rx_shift_reg
    );
    
    logic [7:0] uart_tx_data;
    logic       uart_tx_valid, uart_tx_ready, tx_busy;
    logic [7:0] uart_rx_data;
    logic       uart_rx_valid, rx_error;
    
    
    uart u1(
        .clk(clk),
        .reset(reset),
        .tx_data(uart_tx_data),
        .tx_valid(uart_tx_valid),
        .tx_ready(uart_tx_ready),
        .tx_busy(tx_busy),
        .tx_out(tx_out),
        .rx_in(rx_in),
        .rx_data(uart_rx_data),
        .rx_valid(uart_rx_valid),
        .rx_error(rx_error)
    );
    
    logic [1:0] tx_byte_count;
    logic [2:0] rx_byte_count;
    logic [31:0] tx_shift_reg;
    logic tx_32active, rx_done;
    logic sending_byte;
    
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            tx_shift_reg   <= 0;
            uart_tx_valid  <= 0;
            tx_led         <= 0;
            tx_ready       <= 1;
            tx_byte_count  <= 0;
            tx_32active    <= 0;
            sending_byte   <= 0;
        end else begin
            tx_led <= 0;
            if (tx_valid && tx_ready == 1) begin
                tx_shift_reg <= tx_data;
                tx_32active  <= 1;
                tx_ready     <= 0;
                tx_byte_count <= 0;
                sending_byte <= 0;
            end
    
            if (tx_32active) begin
                if (!sending_byte && uart_tx_ready) begin
                    case (tx_byte_count)
                        2'd0: uart_tx_data <= tx_shift_reg[31:24];
                        2'd1: uart_tx_data <= tx_shift_reg[23:16];
                        2'd2: uart_tx_data <= tx_shift_reg[15:8];
                        2'd3: uart_tx_data <= tx_shift_reg[7:0];
                    endcase
                    uart_tx_valid <= 1;
                    sending_byte  <= 1;  // latch this state
                end
                // Once accepted (tx_ready goes low), clear valid
                if (sending_byte && !uart_tx_ready) begin
                    uart_tx_valid <= 0;
                end
                // Once tx_ready goes high again, move to next byte
                if (sending_byte && uart_tx_ready && uart_tx_valid == 0) begin
                    tx_led <= 1;
                    sending_byte <= 0;
                    if (tx_byte_count == 2'd3) begin
                        tx_32active <= 0;
                        tx_ready <= 1;
                    end else begin
                        tx_byte_count <= tx_byte_count + 1;
                    end
                end
            end
        end
    end
    
    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            rx_byte_count <= 0;
            rx_data <= 0;
            rx_valid <= 0;
            rx_shift_reg <= 0;
            rx_done <= 0;
        end else begin
            rx_valid <= 0;
            if (uart_rx_valid) begin
                case (rx_byte_count)
                    3'd0: rx_shift_reg[63:56] <= uart_rx_data;
                    3'd1: rx_shift_reg[55:48] <= uart_rx_data;
                    3'd2: rx_shift_reg[47:40] <= uart_rx_data;
                    3'd3: rx_shift_reg[39:32] <= uart_rx_data;
                    3'd4: rx_shift_reg[31:24] <= uart_rx_data;
                    3'd5: rx_shift_reg[23:16] <= uart_rx_data;
                    3'd6: rx_shift_reg[15:8] <= uart_rx_data;
                    3'd7: begin
                            rx_shift_reg[7:0] <= uart_rx_data;
                            rx_done <= 1;
                          end  
                endcase
                if (rx_byte_count != 3'd7) rx_byte_count <= rx_byte_count + 1;
                else rx_byte_count <= 0;
            end
            
            if (rx_done) begin
                case(rx_count)
                    3'd0: rx_data <= rx_shift_reg[63:56];
                    3'd1: rx_data <= rx_shift_reg[55:48];
                    3'd2: rx_data <= rx_shift_reg[47:40];
                    3'd3: rx_data <= rx_shift_reg[39:32];
                    3'd4: rx_data <= rx_shift_reg[31:24];
                    3'd5: rx_data <= rx_shift_reg[23:16];
                    3'd6: rx_data <= rx_shift_reg[15:8];
                    3'd7: rx_data <= rx_shift_reg[7:0];
                endcase
                rx_valid <= 1;
            end
        end
    end  
endmodule