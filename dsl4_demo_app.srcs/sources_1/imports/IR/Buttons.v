`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2023 19:30:09
// Design Name:  
// Module Name: Buttons 
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


module Buttons(
    //standard signals
    input CLK,
    input RESET,
    //BUS signals
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE,
    // command from buttons
    input [3:0] COMMAND
    );
    
    reg TransmitCommandValue;
 
    initial begin 
        TransmitCommandValue = 0;
    end 
    
    // read the buttons when the microprocessor asks for it throught the data bus
    always@(posedge CLK) begin
        if (BUS_ADDR == 8'h95) begin 
            TransmitCommandValue <= 1;
        end
        else 
            TransmitCommandValue <= 0;
    end
    
    assign BUS_DATA = (TransmitCommandValue) ? {3'b000, COMMAND} : 8'hZZ;    // return the new command from the controller

endmodule
