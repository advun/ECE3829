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


module light_sensor #(parameter capture_rate = 1)(
    input clk_10Mhz, 
    input reset_n,
    input SDATA, //data from sensor
    output reg CS_N, //chip select, active low
    output reg SCLK, //SClock, 1 Mhz clock
    output reg [7:0] data_out //8 bit output data from sensor
    );
    
    localparam max_updatecount = 10_000_000 / capture_rate; //determine how often to get data
    reg [23:0] updatecount_value;
    
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
    
    //localparam max_sclkcount = 5-1; //1 Mhz clock for Sclk
    localparam max_flagcount = 10-1; //1 Mhz clock for Sclk
    //reg [23:0] sclkcount_value;
    reg [23:0] sclkflag_value;
    //reg sclk_flag;  //high if rising, low if falling
    
    /*
    //counter for SCLK
    always @ (posedge clk_10Mhz or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            sclkcount_value <= 24'b0;
            SCLK <= 1'b1;
        end
        else if (sclkcount_value == (max_sclkcount)) begin
            sclkcount_value <= 24'b0;
            SCLK <= ~SCLK; //NOT sclk every 50 ns
        end
        else begin
            sclkcount_value <= sclkcount_value + 24'b1;
        end
    end
    */
    
    wire rising_edge;
    wire falling_edge;
    
    assign rising_edge = ((sclkflag_value == 0) ? 1'b1 : 1'b0);
    assign falling_edge = ((sclkflag_value == 5) ? 1'b1 : 1'b0);
    
    //counter for SCLK Flag (high on falling edge of SCLK)
    always @ (posedge clk_10Mhz or negedge reset_n) begin
        if (reset_n == 1'b0) begin
            sclkflag_value <= 24'b0;
            //sclk_flag <= 1'b0;
        end
        else if (sclkflag_value == (max_flagcount)) begin
            sclkflag_value <= 24'b0;
            //sclk_flag <= 1'b1;  //set to high for one tick every 100 ns  
        end
        else begin
            sclkflag_value <= sclkflag_value + 24'b1;
            //sclk_flag <= 1'b0;
        end
    end
    
    always @(*) begin
        if (rising_edge == 1) begin
            SCLK <= 1'b1;
        end
        if (falling_edge == 1) begin
            SCLK <= 1'b0;
        end
    end
    
    
    localparam STATE_IDLE = 2'b00;
    localparam STATE_READ = 2'b10;
    localparam STATE_DONE = 2'b11;
    
    reg [1:0] current_state;
    reg [1:0] next_state;
    reg [14:0] hold_data;
    reg [3:0] data_counter;
    
    //state changing logic
    always @ (posedge clk_10Mhz) begin
    
        if (reset_n == 1'b0) begin
            current_state <= STATE_IDLE;
        end
        else begin
            current_state <= next_state;
        end
    
    end
    
    always @ (*) begin
        case (current_state)
        
            STATE_IDLE: begin
                CS_N <= 1'b1; //Chip select high
                
                if (get_data == 1'b1) begin
                    next_state <= STATE_READ;
                    data_counter <= 4'b0;
                end
            end
            
            
            STATE_READ: begin
                CS_N <= 1'b0; //Chip select low
                
                if(sclk_flag == 1) begin  //when sclk is falling
                    hold_data <= {hold_data[13:0], SDATA}; //shift
                    data_counter <= data_counter + 1;  //tick up data counter
                end
                
                if (data_counter == 15)begin 
                next_state <= STATE_DONE;
                end
            
            end
            
            STATE_DONE: begin
            
            data_out <= hold_data[11:4];  //8'b11111111;
            next_state <= STATE_IDLE;
            
            end
            
            default: begin
            next_state <= STATE_IDLE;
            end
            
        endcase
    end
    
    
    
    
    
    
endmodule
