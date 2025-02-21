`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/21/2025 12:33:29 PM
// Design Name: 
// Module Name: lightsim
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


module lightsim(

    );
    
    
    wire [7:0] data_out;  //light sensor value
    wire CS_N;
    wire SCLK;

    
    reg clk_10Mhz;
    reg reset_n;
    reg SDATA;
    
    
    light_sensor sensor1
   (
    .clk_10Mhz(clk_10Mhz),
    .reset_n(reset_n),
    .SDATA(SDATA), //data from sensor
    .CS_N(CS_N),  //chip select, active low
    .SCLK(SCLK), //SClock
    .data_out(data_out)); //8 bit output data from sensor
    
    initial begin
    forever #50 clk_10Mhz = ~clk_10Mhz;  //50ns *2 = 10Mhz
    end
    
    initial begin
    clk_10Mhz = 0;
    reset_n = 0;
    SDATA = 1;
    
    #500;
    
    reset_n = 1;
    
    end
    
endmodule
