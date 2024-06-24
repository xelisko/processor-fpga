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
//      this module binds together the IR Trasmitter SM module and the 10Hz counter, so a single packet is generated at the start of each 100ms
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IRTransmitter(
    input CLK,
    input RESET,
    output IR_LED,
    //BUS Signals
    inout [7:0] BUS_DATA,
    output [7:0] BUS_ADDR,
    output BUS_WE
    );
    
    reg [3:0] current_command, next_command;           //stores the command for the given packet generate at the time
    initial current_command = 4'h0;
    wire send_new;                           // from counter - send new packet
    
    // IR transmitter module instanitiated
    IRTransmitterSM IR_SM (
        .CLK(CLK),
        .RESET(RESET),
        .COMMAND(current_command), // for now
        .SEND_PACKET(send_new),
        .IR_LED(IR_LED)
        );
    
    // counter for generating SEND_PACKET signal with frequency of 10Hz
      TenHZ_cnt Counter_10Hz( 
          .CLK(CLK),  
          .RESET(RESET), 
          .SEND_PACKET(send_new) 
          );          
     
    // synchronous logic for getting new command from the buttons   
    always@(posedge CLK) begin 
        if ((BUS_ADDR == 8'h90))
            next_command <= BUS_DATA[3:0];
        else
            next_command <= next_command;
        
        if (RESET || send_new)
            current_command <= next_command;
        else 
            current_command <= current_command;
    end   
    
//    ila_2 testing (
//        .clk(CLK),
//        .probe0({3'b000, next_command}), //7
//        .probe1({3'b000, current_command}), //7
//        .probe2(IR_LED) //1
//    );
    
endmodule
