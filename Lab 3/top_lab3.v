`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2025 03:53:43 PM
// Design Name: 
// Module Name: top_lab3
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Top of Lab 3
// Dependencies: 
// clk_mmcm_wiz, light_sensor, seven_seg
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_lab3(
    input clk,  //100MHz clock
    input btnC, //center button for reset
    output [3:0] an,
    output [6:0] seg,
    output JA0, //CS_N
    input JA2,  //SDO
    output JA3 //SCL
    );
    
    parameter SEVEN = 4'b0111; //value for ID display
    parameter FOUR = 4'b0100; //value for ID display
    
    wire clk_10Mhz, lock;
    reg reset_intermediate; //intermediate holder for reset in flip flops
    reg reset_n; //active low reset
    
     //10 Mhz clock module
     clk_mmcm_wiz clk_mmcm_wiz1
   (
    // Clock out ports
    .clk_10Mhz(clk_10Mhz),     // output clk_10Mhz
    // Status and control signals
    .reset(btnC), // input reset
    .locked(lock),       // output locked
   // Clock in ports
    .clk_in1(clk));      // input btnC
    
    
    //Sycnhronization Logic (two flip flops)
    always @(posedge clk_10Mhz) begin
    reset_intermediate <= lock;
    reset_n <= reset_intermediate;
    end
    
    wire [7:0] data_out;  //light sensor value
    
    light_sensor sensor1
   (
    .clk_10Mhz(clk_10Mhz),
    .reset_n(reset_n),
    .SDATA(JA2), //data from sensor
    .CS_N(JA0),  //chip select, active low
    .SCLK(JA3), //SClock
    .data_out(data_out)); //8 bit output data from sensor
    
    
    //seven segment display
     seven_seg seven_seg1
   (
    //info to be displayed on each 7 seg display
    .displayD(data_out[3:0]),
    .displayC(data_out[7:4]),
    .displayB(FOUR),
    .displayA(SEVEN),
    //Clock and Control signals
    .clk_10Mhz(clk_10Mhz),
    .reset_n(reset_n),
    //LED outputs
    .an(an),
    .seg(seg));
    
    
    
endmodule
