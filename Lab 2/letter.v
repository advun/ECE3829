`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/10/2025 01:03:59 AM
// Design Name: 
// Module Name: letter
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


module letter(
    input [4:0] order,
    input [10:0] hcount,
    input [10:0] vcount,
    input blank,
    output reg [11:0] colorOut
    );
    
    
    // Define the 5x7 pattern for character "A" (could be stored in ROM)
    wire [6:0] char_pattern [6:0];  // 7 rows for a 5x7 font
    assign char_pattern[0] = 7'b01110;  // Row 1 of "A"
    assign char_pattern[1] = 7'b10001;  // Row 2 of "A"
    assign char_pattern[2] = 7'b10001;  // Row 3 of "A"
    assign char_pattern[3] = 7'b11111;  // Row 4 of "A"
    assign char_pattern[4] = 7'b10001;  // Row 5 of "A"
    assign char_pattern[5] = 7'b10001;  // Row 6 of "A"
    assign char_pattern[6] = 7'b10001;  // Row 7 of "A"
    
    
    parameter colorBLACK = 12'b000000000000;
    parameter colorWHITE = 12'b111111111111;
    parameter startingX = 5;
    parameter startingY = 10;
    
    
    reg row;
    
    always @ (hcount or vcount)
    begin   
        if (hcount >= (startingX + 6*order) && hcount < (startingX + 5 + 6*order)&& vcount >= startingY && vcount < startingY + 7) begin
                    
                    row = vcount - startingY;
                    // Get the corresponding row of the character based on vcount
                    if (row >= 0 && row < 7) begin
                        // Check if the current pixel (hcount) is part of the character's pattern
                        if (hcount - startingX < (5 + 6*order) && char_pattern[row][hcount - (startingX + 6*order)]) begin
                            colorOut <= colorWHITE; // Red color for character pixel
                        end else begin
                            colorOut <= colorBLACK; // Black (background color)
                        end
                    end
                end 
            end
endmodule
