`timescale 1ns / 1ps
module DESTHandShake_CP(
    input  logic clk,
    input  logic reset,
    input  logic valid_sync,
    output logic ack_out,
    output logic latch_en
    );
    
    typedef enum logic [1:0] {IDLE, LATCH, WAIT_VALID_LOW} state_t;
    state_t curr_st, next_st;
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) curr_st <= IDLE;
        else curr_st <= next_st;
    end
    
    always_comb begin
        next_st = curr_st;
        case (curr_st)
            IDLE: if (valid_sync) next_st = LATCH;
            LATCH: next_st = WAIT_VALID_LOW;
            WAIT_VALID_LOW: if (!valid_sync) next_st = IDLE;
        endcase
    end
    
    always_comb begin
        ack_out = 0;
        latch_en = 0;
        
        case (curr_st)
            LATCH: begin
                   ack_out = 1;
                   latch_en = 1;
                   end
            
            WAIT_VALID_LOW: begin
                            ack_out = 1;
                            latch_en = 1;
                            end
        endcase
    end
endmodule