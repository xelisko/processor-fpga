`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2021 03:01:37 PM
// Design Name: 
// Module Name: TopWrapper
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
//      this module generates a signal with 10Hz frequency that is used to start a generation of a new packet
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module TenHZ_cnt(
    input CLK,
    input RESET,
    output SEND_PACKET
    );
    
   localparam [23:0] CLK_per_packet = 9999999; 
    
    // counter for generating SEND_PACKET signal with frequency of 10Hz
    generic_counter # (.COUNTER_WIDTH(24), // change
                     .COUNTER_MAX(CLK_per_packet)  // change
                     )
                     Counter_10Hz (
                     .CLK(CLK),
                     .RESET(RESET),
                     .ENABLE(1'b1),
                     .TRIG_OUT(SEND_PACKET)//,
                     //.COUNT(DecCount1)
                  );

endmodule
