`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.10.2021 13:36:23
// Design Name: 
// Module Name: Generic_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      this is a generic counter through that can be custamised to the necessary bit lenght and count-up-to value
//      adds value of one every single time when the ENABLE signal is 1 (synchronous)
//        - outputs a 1 value as a trigger before reaching the maximum value 
//        - outputs the count value
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module generic_counter(
        CLK,
        RESET,
        ENABLE,
        TRIG_OUT,
        COUNT
);
    parameter COUNTER_WIDTH = 17;
    parameter COUNTER_MAX = 999999;
    
    input   CLK;
    input   RESET;
    input   ENABLE;
    output  TRIG_OUT;
    output  [COUNTER_WIDTH-1:0] COUNT;
    
    reg [COUNTER_WIDTH-1:0] count_value;
    reg Trigger_out;
    
    //initial count_value = 0;
    
    always@(posedge CLK) begin
        if(RESET)
            count_value <= 0;
        else begin
            if (ENABLE) begin
                if ((count_value <= COUNTER_MAX) )
                    count_value <= count_value + 1;
                else
                    count_value <= 0;
            end
            else 
                count_value <= count_value;
        end
    end
        
    always@(posedge CLK) begin
        if(RESET)
            Trigger_out <= 0;
        else begin
            if(ENABLE && (count_value == COUNTER_MAX) )
                Trigger_out <= 1;
            else
                Trigger_out <= 0;
        end
    end
    
    assign COUNT = count_value;
    assign TRIG_OUT = Trigger_out;

endmodule
