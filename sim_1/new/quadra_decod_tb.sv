`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2024 23:02:35
// Design Name: 
// Module Name: quadra_decod_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module quad_tb;

    // Testbench signals
    logic clk;
    logic reset;
    logic quadA;
    logic quadB;
    logic [7:0] count;
    logic count_enable, count_direction;
    logic [2:0] quadA_delayed, quadB_delayed;  // Added delayed signals

    // Instantiate the DUT (Device Under Test)
    quad dut (
        .clk(clk),
        .reset(reset),
        .quadA(quadA),
        .quadB(quadB),
        .count(count),
        .count_enable(count_enable),
        .count_direction(count_direction),
        .quadA_delayed(quadA_delayed),  // Connect delayed signals
        .quadB_delayed(quadB_delayed)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;  // 10ns clock period
    end

    // Stimulus generation
    initial begin
        // Initialize inputs
        reset = 1;  // Assert reset
        quadA = 0;
        quadB = 0;
        
        #20 reset = 0;  // Release reset after 20ns

        // Apply a sequence of inputs to simulate quadrature encoder
        // Simulate a forward rotation
        repeat (4) begin
            #10 quadA = ~quadA;  // Toggle quadA
            #10 quadB = ~quadB;  // Toggle quadB
        end

        // Simulate a reverse rotation
        repeat (4) begin
            #10 quadB = ~quadB;  // Toggle quadB
            #10 quadA = ~quadA;  // Toggle quadA
        end

        // Finish simulation
        #50 $finish;
    end

    // Monitor for debug purposes
    initial begin
        $monitor("Time: %0t | clk: %b | reset: %b | quadA: %b | quadB: %b | quadA_delayed: %b | quadB_delayed: %b | count_enable: %b | count_direction: %b | count: %d", 
                 $time, clk, reset, quadA, quadB, quadA_delayed, quadB_delayed, count_enable, count_direction, count);
    end

endmodule

