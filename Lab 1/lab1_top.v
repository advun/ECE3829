`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/21/2025 11:49:50 PM
// Design Name: CW
// Module Name: lab1_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Top level of Lab 1.  Interacts with hardware, links input_select and seven_seg together
// Dependencies: 
// input_select and seven_seg
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lab1_top(
    input [15:0] sw,
    input btnL,
    input btnR,
    input btnU,
    input btnD,
    output [3:0] an,
    output [6:0] seg,
    output reg [15:0] led
    );
    
    wire [3:0] displayA;
    wire [3:0] displayB; 
    wire [3:0] displayC; 
    wire [3:0] displayD;
    wire [3:0] buttonsLRUD;
    
    assign buttonsLRUD[3] = btnL;
    assign buttonsLRUD[2] = btnR;
    assign buttonsLRUD[1] = btnU;
    assign buttonsLRUD[0] = btnD;
    
    input_select dispEncoder(.sw(sw), .displayA(displayA), .displayB(displayB), .displayC(displayC), .displayD(displayD));
    
    seven_seg d1 (.displayA(displayA), .displayB(displayB), .displayC(displayC), .displayD(displayD), 
        .buttonsLRUD(buttonsLRUD), .an(an), .seg(seg));
    
    
    always @ (sw) begin
        led = sw;
    end
    
    
endmodule
