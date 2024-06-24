`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.03.2023 17:25:33
// Design Name: 
// Module Name: Switches
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

module Switches(
    //standard signals
    input CLK,
    input RESET,
    //BUS signals
    inout [7:0] BUS_DATA,
    input [7:0] BUS_ADDR,
    input BUS_WE,     
    // switches
    input [1:0] SWITCH
    );
    
    reg TransmitSwitchValue, select_switch;
    
    initial begin 
        TransmitSwitchValue = 0;
    end 
    
    always@(posedge CLK) begin
        if (BUS_ADDR == 8'hE0) begin 
            TransmitSwitchValue <= 1;
            select_switch <= 0;
        end
        else if (BUS_ADDR == 8'hE1) begin
            TransmitSwitchValue <= 1;
            select_switch <= 1;
        end
        else 
            TransmitSwitchValue <= 0;
    end
    
    assign BUS_DATA = (TransmitSwitchValue) ? {7'b0000000, SWITCH[select_switch]} : 8'hZZ;

endmodule

