`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/04/2025 11:53:51 PM
// Design Name: cw
// Module Name: lab2_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// top level of lab 2, outputs vga signals and seven seg signals
// Dependencies: 
// debouncer, clk_mmcm_wiz, seven_seg, vga_controller_640_60, vgadisplay_select
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lab2_top(
    input clk,  //100MHz clock
    input btnC, //center button for reset
    input btnL,
    input [1:0] sw,
    output [3:0] an,
    output [6:0] seg,
    output [3:0] vgaRed,
    output [3:0] vgaGreen,
    output [3:0] vgaBlue,
    output Hsync,
    output Vsync
    );
    
    parameter SEVEN = 4'b0111;
    parameter FOUR = 4'b0100;
    parameter ONE = 4'b0001;
   
    wire clk_25MHz, reset_n;
    wire [1:0] sw_db;
    wire btnL_db;
    
    debouncer d0 (.in (sw[0]), .clk_25MHz(clk_25MHz), .reset_n(reset_n), .out(sw_db[0]));
    debouncer d1 (.in (sw[1]), .clk_25MHz(clk_25MHz), .reset_n(reset_n), .out(sw_db[1]));
    debouncer d2 (.in (btnL), .clk_25MHz(clk_25MHz), .reset_n(reset_n), .out(btnL_db));
    
    //25 Mhz clock module
     clk_mmcm_wiz clk_mmcm_wiz1
   (
    // Clock out ports
    .clk_25MHz(clk_25MHz),     // output clk_25MHz
    // Status and control signals
    .reset(btnC), // input reset
    .locked(reset_n),       // output locked
   // Clock in ports
    .clk_in1(clk));      // input btnC
    
     //seven segment display
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
    
    wire [10:0] hcount; //11 bits, horizontal count of the currently displayed pixel 
    wire [10:0] vcount; //11 bits, vertical count of the currently displayed pixel 
    wire blank; //active when pixel is not in visible area
    
    //VGA Controller
     vga_controller_640_60 vga1
   (
    .rst(btnC),
    .pixel_clk(clk_25MHz),
    .HS(Hsync),
    .VS(Vsync),
    .hcount(hcount),
    .vcount(vcount),
    .blank(blank));
    
    
    vgadisplay_select select1
   (
    //Clock and Control signals (Inputs)
    .sw(sw),
    .btnL(btnL_db),
    .clk_25MHz(clk_25MHz),
    .reset_n(reset_n),
    //VGA Controller Signals (Inputs)
    .blank(blank),
    .hcount(hcount),
    .vcount(vcount),
    //VGA Color Signals (Outputs)
    .vgaRed(vgaRed),
    .vgaBlue(vgaBlue),
    .vgaGreen(vgaGreen));
    
endmodule
