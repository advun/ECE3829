`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 11:53:51 PM
// Design Name: 
// Module Name: lab2_top
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


module lab2_top(
    input clk,  //100MHz clock
    input btnC, //center button for reset
    input [1:0] sw,
    output [3:0] an,
    output [6:0] seg,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output Hsync,
    output Vsync,
    output [11:0] led
    );
    
    parameter SEVEN = 4'b0111;
    parameter FOUR = 4'b0100;
    parameter ONE = 4'b0001;
     
       
    wire clk_25MHz, reset_n;
    
     clk_mmcm_wiz clk_mmcm_wiz1
   (
    // Clock out ports
    .clk_25MHz(clk_25MHz),     // output clk_25MHz
    // Status and control signals
    .reset(btnC), // input reset
    .locked(reset_n),       // output locked
   // Clock in ports
    .clk_in1(clk));      // input btnC
    
     
     seven_seg seven_seg1
   (
    //info to be displayed on each 7 seg display
    .displayD(ONE),
    .displayC(FOUR),
    .displayB(FOUR),
    .displayA(SEVEN),
    //Clock and Control signals
    .clk_25MHz(clk_25MHz),
    .reset_n(reset_n),
    //LED outputs
    .an(an),
    .seg(seg));
    
    vgadisplay_select select1
   (
    //Clock and Control signals
    .sw(sw),
    .clk_25MHz(clk_25MHz),
    .reset_n(reset_n),
    //VGA Color Signals
    .vgaRed(vgaRed),
    .vgaBlue(vgaBlue),
    .vgaGreen(vgaGreen),
    //Sync Signals
    .Hsync(Hsync),
    .Vsync(Vsync),
    .led(led));
    
endmodule
