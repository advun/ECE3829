`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/20/2025 04:34:58 PM
// Design Name: 
// Module Name: light_sensor
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


module light_sensor #(parameter capture_rate = 100000)(
    input clk_10Mhz, 
    input reset_n,
    input SDATA, //data from sensor
    output reg CS_N, //chip select, active low
    output reg SCLK, //SClock, 1 Mhz clock
    output reg [7:0] data_out //8 bit output data from sensor
    );
    
    localparam max_updatecount = (10000000 / capture_rate) - 1; //determine how often to get data
    reg [23:0] updatecount_value;  //count value
    
    wire get_data;
    
    assign get_data = (updatecount_value == max_updatecount); //get data at max count
    
    //counter for capture rate
    always @ (posedge clk_10Mhz or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            updatecount_value <= 24'b0;
        end
        else if (updatecount_value == (max_updatecount)) begin
            updatecount_value <= 24'b0;
        end
        else begin
            updatecount_value <= updatecount_value + 24'b1;
        end
    end
    
    //states
    localparam STATE_IDLE = 3'b000;
    localparam STATE_WAIT = 3'b001;
    localparam STATE_READ0 = 3'b010;
    localparam STATE_READ1 = 3'b011;
    localparam STATE_READ2 = 3'b100;
    localparam STATE_READ3 = 3'b101;
    localparam STATE_DONE = 3'b110;
    
    reg [2:0] current_state;
    reg [14:0] hold_data; //holder for all output data from SDATA
    reg [3:0] data_counter; //counter, to keep track of where in hold_data I am
    

    
    always @ (posedge clk_10Mhz) begin
    
        if (!reset_n) begin  //when reset, clear data_out and set CS_N to high
            CS_N <= 1'b1;
            data_out <= 8'b00000000;
        end
        
        else begin
            case (current_state)
            
                STATE_IDLE: begin              
                    if (get_data == 1'b1) begin  //wait 1 second
                        current_state <= STATE_WAIT;
                        data_counter <= 4'b0; //clear data counter
                    end
                end
                
                STATE_WAIT: begin //gives 1 clock tick between setting CS_N low and beginning SCLK
                    CS_N <= 1'b0;  //Chip select low
                    current_state <= STATE_READ0;
                end
                
                
                STATE_READ0: begin //SDATA changes (neg edge)
                    current_state <= STATE_READ1; //wait 1 clock cycle, so not reading on same cycle as SDO changes
                    SCLK <= 1'b0;  //set SCLK to 0 (neg edge of sclk)
                    
                end
                
                STATE_READ1: begin //read in SDATA
                    hold_data <= {hold_data[13:0], SDATA}; //shift in SDATA
                    data_counter <= data_counter + 1;  //tick up data counter
                    
                    current_state <= STATE_READ2;
                end
                
                STATE_READ2: begin //wait 1 cycle (posedge)
                     current_state <= STATE_READ3;
                     SCLK <= 1'b1; //set SCLK to 1 (pos edge of sclk)
                end
                
                STATE_READ3: begin //wait 1 cycle
                    
                    if (data_counter == 15)begin //when SDATA is fully shifted through, exit to state done
                        current_state <= STATE_DONE;
                    end
                    else begin //else, shift in another SDATA
                        current_state <= STATE_READ0;
                    end
                
                end
                
                STATE_DONE: begin
                    CS_N <= 1'b1; //Chip select high
                    data_out <= hold_data[11:4];  //only output data, avoiding 3 leading 0s and 4 lagging 0s
                    current_state <= STATE_IDLE;  //goes back to idle
                end
                
                default: begin
                current_state <= STATE_IDLE;
                end
                
            endcase
         end
    end
    
    
    
    
    
    
endmodule
