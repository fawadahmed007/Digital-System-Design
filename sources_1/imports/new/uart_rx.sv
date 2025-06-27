module uart_rx (
    input  logic clk,
    input  logic reset,
    input  logic bclk_x8,
    input  logic rx_in,
    output logic [7:0] rx_data,
    output logic rx_valid,
    output logic rx_error
);
    typedef enum logic [2:0] {
        IDLE, START, DATA, STOP
    } state_t;

    state_t state;
    logic [2:0] sample_count, bit_index;
    logic [7:0] shift_reg;
    logic rx_sync1, rx_sync2;
    logic rx_sample;
    logic bclk_x8_prev;

    always_ff @(posedge clk) begin
        // Double sync rx_in to prevent metastability
        rx_sync1 <= rx_in;
        rx_sync2 <= rx_sync1;
        rx_sample <= rx_sync2;
        bclk_x8_prev <= bclk_x8;
    end

    always_ff @(posedge clk or negedge reset) begin
        if (!reset) begin
            state <= IDLE;
            sample_count <= 0;
            bit_index <= 0;
            shift_reg <= 0;
            rx_data <= 0;
            rx_valid <= 0;
            rx_error <= 0;
        end else begin
            // Clear one-cycle signals
            rx_valid <= 0;
            rx_error <= 0;

            // Only change state on rising edge of bclk_x8
            if (bclk_x8 && !bclk_x8_prev) begin
                case (state)
                    IDLE: begin
                        if (!rx_sample) begin // Start bit detected
                            state <= START;
                            sample_count <= 1; // First sample
                        end
                    end

                    START: begin
                        if (sample_count == 3) begin // Middle of start bit
                            if (!rx_sample) begin
                                state <= DATA;
                                sample_count <= 0;
                                bit_index <= 0;
                            end else begin
                                state <= IDLE;
                                rx_error <= 1;
                            end
                        end else begin
                            sample_count <= sample_count + 1;
                        end
                    end

                    DATA: begin
                        if (sample_count == 7) begin // Sample center of bit
                            shift_reg <= {rx_sample, shift_reg[7:1]};
                            bit_index <= bit_index + 1;
                            sample_count <= 0;
                            
                            if (bit_index == 7) begin
                                state <= STOP;
                            end
                        end else begin
                            sample_count <= sample_count + 1;
                        end
                    end

                    STOP: begin
                        if (sample_count == 7) begin // Middle of stop bit
                            if (rx_sample) begin // Valid stop bit
                                rx_data <= shift_reg;
                                rx_valid <= 1;
                            end else begin
                                rx_error <= 1;
                            end
                            state <= IDLE;
                        end else begin
                            sample_count <= sample_count + 1;
                        end
                    end
                endcase
            end
        end
    end
endmodule