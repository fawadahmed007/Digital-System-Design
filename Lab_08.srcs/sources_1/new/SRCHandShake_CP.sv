`timescale 1ns / 1ps
module SRCHandShake_CP(
    input  logic clk,
    input  logic reset,
    input  logic ack_sync,
    output logic valid_data,
    output logic load_data,
    output logic count_enable
    );
    
    typedef enum logic [1:0] {IDLE, SEND, WAIT_ACK} state_t;
    state_t curr_st, next_st;
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) curr_st <= IDLE;
        else curr_st <= next_st;
    end
    
    always_comb begin
        next_st = curr_st;
        case (curr_st)
            IDLE: next_st = SEND;
            SEND: next_st = WAIT_ACK;
            WAIT_ACK: if (ack_sync) next_st = IDLE;
        endcase
    end
    
    always_comb begin
        valid_data = 0;
        load_data = 0;
        count_enable = 0;
        
        case (curr_st)
            IDLE: begin
                  valid_data = 1;
                  load_data = 1;
                  count_enable = 0;
                  end
            
            SEND: valid_data = 1;
            WAIT_ACK: begin
                      valid_data = 1;
                      if (ack_sync) count_enable = 1;
                      end
        endcase
    end
endmodule