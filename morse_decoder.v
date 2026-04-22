`timescale 1ns / 1ps

module morse_decoder(
    // Global input
    input wire clk_in,
    input wire enable,
    // Input
    input wire [1:0] in_vec,
    // Output
    output reg clk_out,
    output reg [3:0] letter,       // 扩展为 4 bits
    // Debug use
    output wire [3:0] state_probe  // 扩展为 4 bits
);

// Definitions of in_vec[1:0]
localparam [1:0] GAP  = 2'b00,
                 DOT  = 2'b01,
                 DASH = 2'b10;

// Definitions of letter / states (扩展到15个状态)
localparam [3:0] BLANK = 4'd0,
                 E = 4'd1,
                 T = 4'd2,
                 I = 4'd3,
                 A = 4'd4,
                 N = 4'd5,
                 M = 4'd6,
                 S = 4'd7,
                 U = 4'd8,
                 R = 4'd9,
                 W = 4'd10,
                 D = 4'd11,
                 K = 4'd12,
                 G = 4'd13,
                 O = 4'd14;

reg [3:0] state; // 扩展为 4 bits
assign state_probe = state;

initial begin
    clk_out = 1'b0;
    state = 4'b0000;
    letter = 4'b0000;
end

always @(posedge clk_in) begin
    if (~enable) begin
        clk_out <= 0;
        state <= BLANK;
    end else begin
        clk_out <= 0;
        case (state)
            BLANK: case (in_vec)
                DOT:  state <= E;
                DASH: state <= T;
                GAP:  begin clk_out <= 1'b1; state <= BLANK; end
            endcase
            E: case (in_vec)
                DOT:  state <= I;
                DASH: state <= A;
                GAP:  begin clk_out <= 1'b1; state <= BLANK; end
            endcase
            T: case (in_vec)
                DOT:  state <= N;
                DASH: state <= M;
                GAP:  begin clk_out <= 1'b1; state <= BLANK; end
            endcase
            // 补充 I, A, N, M 状态的下一层跳转
            I: case (in_vec)
                DOT:  state <= S;
                DASH: state <= U;
                GAP:  begin clk_out <= 1'b1; state <= BLANK; end
            endcase
            A: case (in_vec)
                DOT:  state <= R;
                DASH: state <= W;
                GAP:  begin clk_out <= 1'b1; state <= BLANK; end
            endcase
            N: case (in_vec)
                DOT:  state <= D;
                DASH: state <= K;
                GAP:  begin clk_out <= 1'b1; state <= BLANK; end
            endcase
            M: case (in_vec)
                DOT:  state <= G;
                DASH: state <= O;
                GAP:  begin clk_out <= 1'b1; state <= BLANK; end
            endcase
            // 对于最底层的叶子节点 S, U, R, W, D, K, G, O，接收到 GAP 就输出并回到顶层
            S, U, R, W, D, K, G, O: case (in_vec)
                GAP:  begin clk_out <= 1'b1; state <= BLANK; end
                default: begin clk_out <= 1'b1; state <= BLANK; end 
            endcase
            default: begin clk_out <= 1'b1; state <= BLANK; end
        endcase
    end
end

always @(posedge clk_in) begin
    if (~enable)
        letter <= BLANK;
    else
        letter <= state;
end

endmodule