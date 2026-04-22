`timescale 1ns / 1ps

module morse_decoder_tb();

reg clk_in;
reg enable;
// Input
reg [1:0] in_vec;
// Output
wire clk_out;
wire [3:0] letter;       // 扩展为 4 bits
wire [3:0] state_probe;  // 扩展为 4 bits

initial begin
    clk_in = 1'b0;
    enable = 1'b0;
    in_vec = 2'b00;

    // Enable Decoder
    #10 enable = 1'b1;
    #10 in_vec = 2'b00; // Blank

    // Test D (-..)
    #10 in_vec = 2'b10;
    #10 in_vec = 2'b01;
    #10 in_vec = 2'b01;
    #10 in_vec = 2'b00; // output D

    // Test G (--.)
    #10 in_vec = 2'b10;
    #10 in_vec = 2'b10;
    #10 in_vec = 2'b01;
    #10 in_vec = 2'b00; // output G

    // Test K (-.-)
    #10 in_vec = 2'b10;
    #10 in_vec = 2'b01;
    #10 in_vec = 2'b10;
    #10 in_vec = 2'b00; // output K

    // Test O (---)
    #10 in_vec = 2'b10;
    #10 in_vec = 2'b10;
    #10 in_vec = 2'b10;
    #10 in_vec = 2'b00; // output O

    // Test R (.-.)
    #10 in_vec = 2'b01;
    #10 in_vec = 2'b10;
    #10 in_vec = 2'b01;
    #10 in_vec = 2'b00; // output R

    // Test S (...)
    #10 in_vec = 2'b01;
    #10 in_vec = 2'b01;
    #10 in_vec = 2'b01;
    #10 in_vec = 2'b00; // output S

    // Test U (..-)
    #10 in_vec = 2'b01;
    #10 in_vec = 2'b01;
    #10 in_vec = 2'b10;
    #10 in_vec = 2'b00; // output U

    // Test W (.--)
    #10 in_vec = 2'b01;
    #10 in_vec = 2'b10;
    #10 in_vec = 2'b10;
    #10 in_vec = 2'b00; // output W

    // Disable Decoder
    #10 enable = 1'b0;

    #20 $stop;
end

always #5 clk_in = ~clk_in;

morse_decoder m1 (
    .clk_in(clk_in),
    .enable(enable),
    .in_vec(in_vec),
    .clk_out(clk_out),
    .letter(letter),
    .state_probe(state_probe)
);

endmodule