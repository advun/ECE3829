`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/05/2025 12:24:28 AM
// Design Name: CW
// Module Name: seven_seg
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// turns on displays and updates displays
// Dependencies: 
// seven_seg_decoder
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module seven_seg(
    input [3:0] displayD,
    input [3:0] displayC,
    input [3:0] displayB,
    input [3:0] displayA,
    input clk_25MHz,
    input reset_n,
    output reg [3:0] an,
    output reg [6:0] seg
    );
    
    parameter MAX_COUNT = 50000 - 1; 
    
    
    reg [3:0] dispHolder;
    reg [20:0] count_value;
    reg [3:0] ledselect;
    wire [6:0] seghold;
       
    assign update = (count_value == MAX_COUNT);
    
    //100Hz counter
    always @ (posedge clk_25MHz or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            count_value <= 21'b0;
        end
        else if (count_value == (MAX_COUNT)) begin
            count_value <= 21'b0;
        end
        else begin
            count_value <= count_value + 21'b1;
        end
    end
    
    
    
        //25Hz counter (cycles through seven segment display)
    always @ (posedge clk_25MHz or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            ledselect <= 4'b0001; //on reset, start with display 4 on
        end
        else if (update) begin
            ledselect[3:0] <= {ledselect[2:0], ledselect[3]};  //changes which anode is low
        end
    end
    
    
    //update 7 seg display
    always @ (posedge clk_25MHz) begin
    
           if (reset_n == 1'b0) begin
               an <= 4'b1111; 
               dispHolder <= 4'b1111;
           end
           
            else if (update) begin
            
                case(ledselect)//turns on display according to button press                    
                    4'b0001: begin //if button D pressed
                                an <= 4'b1110;  //anode 0 low (D)
                                dispHolder <= displayD; //display values for D
                             end
                             
                    4'b0010: begin //if button U pressed
                                an <= 4'b1101;  //anode 1 low (C)
                                dispHolder <= displayC; //display values for C
                             end
                
                    4'b0100: begin //if button R pressed
                                an <= 4'b1011;  //anode 2 low (B)
                                dispHolder <= displayB; //display values for B
                             end
                         
                    4'b1000: begin //if button L pressed
                                an <= 4'b0111;  //anode 3 low (A)
                                dispHolder <= displayA; //display values for A
                            end
                    endcase 
                end
                
        end
            
    seven_seg_decoder cath_decoder (dispHolder, seghold);  //convert displayed value to seven segment cathodes
    
    
    //for some reason, this does not work.  I have literally no idea why, but during reset, one number is still displayed
    always @ (posedge clk_25MHz) begin
        if (reset_n == 1'b0) begin
           seg <= 7'b1111111; 
        end
        else begin
            seg <= seghold;
        end
        
    end

endmodule 