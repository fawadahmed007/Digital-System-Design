`timescale 1ns / 1ps
module uart_tx (
    input  logic clk,
    input  logic reset,
    input  logic bclk,
    input  logic [7:0] tx_data,
    input  logic tx_valid,
    output logic tx_ready,
    output logic tx_busy,
    output logic tx_out
);

    typedef enum logic [1:0] {IDLE, START_BIT, DATA_BITS, STOP_BIT} tx_state_t;

    tx_state_t state;
    logic [2:0] bit_count;
    logic [7:0] shift_reg;
    logic bclk_prev;

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            state <= IDLE;
            tx_out <= 1;
            tx_ready <= 1;
            tx_busy <= 0;
            bit_count <= 0;
            shift_reg <= 0;
            bclk_prev <= 0;
        end else begin
            bclk_prev <= bclk;
            tx_ready <= (state == IDLE);
            tx_busy  <= (state != IDLE);

            if (bclk && !bclk_prev) begin
                case (state)
                    IDLE: begin
                        tx_out <= 1;
                        if (tx_valid) begin
                            state <= START_BIT;
                            shift_reg <= tx_data;
                            tx_out <= 0;  // Start bit
                            bit_count <= 0;
                        end
                    end

                    START_BIT: begin
                        state <= DATA_BITS;
                        tx_out <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                    end

                    DATA_BITS: begin
                        tx_out <= shift_reg[0];
                        shift_reg <= shift_reg >> 1;
                        if (bit_count == 6) begin
                            bit_count <= bit_count + 1;
                            state <= STOP_BIT;
                        end else begin
                            bit_count <= bit_count + 1;
                        end
                    end

                    STOP_BIT: begin
                        if (tx_valid == 0) begin
                            tx_out <= 1;
                            state <= IDLE;
                        end
                    end
                endcase
            end
        end
    end
endmodule
