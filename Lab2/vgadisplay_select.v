`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/07/2025 02:49:58 PM
// Design Name: 
// Module Name: vgadisplay_select
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


module vgadisplay_select(
    input [1:0] sw,
    input clk_25MHz, //25Mhz Clock
    input reset_n,  //active low reset
    output reg [3:0] vgaRed,
    output reg [3:0] vgaGreen,
    output reg [3:0] vgaBlue,
    output Hsync,
    output Vsync,
    output reg [11:0] led
    );
    
    parameter colorRED = 12'b111100000000;
    parameter colorGREEN = 12'b000011110000;
    parameter colorBLUE = 12'b000000001111;
    parameter colorWHITE = 12'b111111111111;
    parameter colorBLACK = 12'b000000000000;
    parameter colorYELLOW = 12'b111111110000;
    
    
    
    wire [10:0] hcount; //11 bits, horizontal count of the currently displayed pixel 
    wire [10:0] vcount; //11 bits, vertical count of the currently displayed pixel 
    wire blank; //active when pixel is not in visible area
    
    reg [11:0] vgaColor; //Starting at MSB: Red, Green, Blue each 4 bits
    
    wire [11:0] state0;
    wire [11:0] state1;
    wire [11:0] state2;
    wire [11:0] state3;
    
    assign state1 = 12'b000000000000;
    
    drawFullscreen yellowscreen (colorYELLOW, hcount, vcount, blank, state0);
    
    always @ (hcount or vcount) begin
        case (sw)
            2'b00 : begin  //all yellow
            vgaColor <= state0;
            end
            
            2'b01 : begin //red and white stripes
            vgaColor <= state1;
            end
            
            2'b10 : begin //black screen, green block
            vgaColor <= state2;
            end
            
            2'b11 : begin //black screen, blue stripe
            vgaColor <= state3;
            end
            
            endcase
            led <= vgaColor;
            //assign colors to proper outputs
            vgaRed <= vgaColor[11:8];
            vgaGreen <= vgaColor[7:4];
            vgaBlue <= vgaColor[3:0];
    end
    
    
    vga_controller_640_60 vga1
   (
    .rst(reset_n),
    .pixel_clk(clk_25MHz),
    .HS(Hsync),
    .VS(Vsync),
    .hcount(hcount),
    .vcount(vcount),
    .blank(blank));
    
    
    
    
    
endmodule
