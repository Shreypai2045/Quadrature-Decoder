`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.11.2024 22:49:12
// Design Name: 
// Module Name: quadra_decod
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



module quad (
    input logic clk, 
    input logic reset, 
    input logic quadA, 
    input logic quadB, 
    output logic [7:0] count, 
    output logic count_enable, 
    output logic count_direction,
    output logic [2:0] quadA_delayed,  // Expose delayed signals
    output logic [2:0] quadB_delayed
);

    // Shift registers for quadA and quadB
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            quadA_delayed <= 3'b000;
            quadB_delayed <= 3'b000;
        end else begin
            quadA_delayed <= {quadA_delayed[1:0], quadA};
            quadB_delayed <= {quadB_delayed[1:0], quadB};
        end
    end

    // Generate count enable and direction signals
    always_comb begin
        count_enable = quadA_delayed[1] ^ quadA_delayed[2] ^ quadB_delayed[1] ^ quadB_delayed[2];
        count_direction = quadA_delayed[1] ^ quadB_delayed[2];
    end

    // Count logic with reset
    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'd0;
        end else if (count_enable) begin
            if (count_direction) 
                count <= count + 1;
            else 
                count <= count - 1;
        end
    end

endmodule
