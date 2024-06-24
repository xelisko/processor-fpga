`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.01.2023 09:23:55
// Design Name: 
// Module Name: VGA_Sig_Gen
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


module VGA_Sig_Gen(
    input CLK,
    input RESET,
    //Colour Configuration Interface
    input [15:0] CONFIG_COLOURS,
    // Frame Buffer (Dual Port memory) Interface
    output DPR_CLK,
    output [14:0] VGA_ADDR,
    input VGA_DATA,
    //VGA Port Interface
    output reg VGA_HS,
    output reg VGA_VS,
    output reg [7:0] VGA_COLOUR
    );
    
    //Halve the clock to 25MHz to drive the VGA display
    wire VGA_CLK;
    Generic_counter # (.COUNTER_WIDTH(4),
                   .COUNTER_MAX(3)
                   )
                   FCounter (
                   .CLK(CLK),
                   .RESET(RESET),
                   .ENABLE(1'b1),
                   .TRIG_OUT(VGA_CLK)
                   ); 
    /*
    Define VGA signal parameters e.g. Horizontal and Vertical display time, pulse widths, front and back
    porch widths etc.
    */
     // Use the following signal parameters
    parameter HTs = 800; // Total Horizontal Sync Pulse Time
    parameter HTpw = 96; // Horizontal Pulse Width Time
    parameter HTDisp = 640; // Horizontal Display Time
    parameter Hbp = 48; // Horizontal Back Porch Time
    parameter Hfp = 16; // Horizontal Front Porch Time
    parameter VTs = 521; // Total Vertical Sync Pulse Time
    parameter VTpw = 2; // Vertical Pulse Width Time
    parameter VTDisp = 480; // Vertical Display Time
    parameter Vbp = 29; // Vertical Back Porch Time
    parameter Vfp = 10; // Vertical Front Porch Time
    
    // Fill in this area
    
    //Time is Front Horizontel Lines
    parameter HorzTimeToPulseWidthEnd = HTpw; //10'd96;
    parameter HorzTimeToBackPorchEnd = HTs-HTDisp-Hfp; //10'd144 
    parameter HorzTimeToDisplayTimeEnd = HTs-Hfp; //10'd784;
    parameter HorzTimeToFrontPorchEnd = HTs; //10'd800;    
    //Time is Vertical Lines
    parameter VertTimeToPulseWidthEnd = VTpw; //10'd2;
    parameter VertTimeToBackPorchEnd = VTs-VTDisp-Vfp; //10'd31;
    parameter VertTimeToDisplayTimeEnd = HTs-Hfp; //10'd511;
    parameter VertTimeToFrontPorchEnd = VTs; //10'd521;
    
    wire HCTriggOut;
    
    // Define Horizontal and Vertical Counters to generate the VGA signals
    wire [9:0] HCounter;
    wire [9:0] VCounter;
    
    /*
    Create a process that assigns the proper horizontal and vertical counter values for raster scan of the
    display.
    */
    
    // Fill in this area
    //Horizontial Counter
    Generic_counter # (.COUNTER_WIDTH(10),
                       .COUNTER_MAX(799)
                       )
                       HorizontialCounter (
                       .CLK(CLK),
                       .ENABLE(VGA_CLK),
                       .RESET(RESET),
                       .TRIG_OUT(HCTriggOut),
                       .COUNT(HCounter)
                       ); 
    
    //Vertical Counter
    Generic_counter # (.COUNTER_WIDTH(10),
                       .COUNTER_MAX(520)
                       )
                       VerticalCounter (
                       .CLK(CLK),
                       .ENABLE(HCTriggOut),
                       .RESET(RESET),
                       .COUNT(VCounter)
                       ); 
                    
    reg [9:0] HHCounter;
    reg [8:0] VVCounter;               
                       
    always@(posedge CLK) begin           
       if((HCounter >= HorzTimeToBackPorchEnd) && (HCounter <= HorzTimeToDisplayTimeEnd)) 
           HHCounter <= HCounter - HorzTimeToBackPorchEnd;
       else    
           HHCounter <= 0;
    end
                       
    always@(posedge CLK) begin           
       if((VCounter >= VertTimeToBackPorchEnd) && (VCounter <= VertTimeToDisplayTimeEnd)) 
           VVCounter <= VCounter - VertTimeToBackPorchEnd;
       else
           VVCounter <= 0;   
    end 
    
    /*  
    Need to create the address of the next pixel. Concatenate and tie the look ahead address to the frame
    buffer address.
    */
    assign DPR_CLK = VGA_CLK;
    assign VGA_ADDR = {VVCounter[8:2], HHCounter[9:2]};   // Two bits are removed to get lower resolution.
    /*
    Create a process that generates the horizontal and vertical synchronisation signals, as well as the pixel
    colour information, using HCounter and VCounter. Do not forget to use CONFIG_COLOURS input to
    display the right foreground and background colours.
    */

    // Fill in this area
    always@(posedge CLK) begin   
        if(HCounter < HorzTimeToPulseWidthEnd)
            VGA_HS <= 0;
        else
            VGA_HS <= 1;
            
        if(VCounter < VertTimeToPulseWidthEnd)
            VGA_VS <= 0;
        else
            VGA_VS <= 1;
    end

    /*
    Finally, tie the output of the frame buffer to the colour output VGA_COLOUR.
    */
    
    // Fill in this area
    always@(posedge CLK) begin           
        if((HCounter > HorzTimeToBackPorchEnd && HCounter < HorzTimeToDisplayTimeEnd) && (VCounter > VertTimeToBackPorchEnd && VCounter < VertTimeToDisplayTimeEnd)) 
            if(VGA_DATA == 1)
                VGA_COLOUR <= CONFIG_COLOURS[7:0];
            else
                VGA_COLOUR <= CONFIG_COLOURS[15:8];
        else
            VGA_COLOUR <= 16'h0000;
    end    
endmodule

module Generic_counter(
        CLK,
        RESET,
        ENABLE,
        TRIG_OUT,
        COUNT
    );
    
    //parameters that contrrol the variability of each module
    parameter COUNTER_WIDTH = 4;
    parameter COUNTER_MAX   = 9;
    
    input       CLK;
    input       RESET;
    input       ENABLE;
    output      TRIG_OUT;
    output  [COUNTER_WIDTH-1:0] COUNT;
    
    //Declkare registers that hole the current count value and trigger out 
    //between clock cycles
    
    reg [COUNTER_WIDTH-1:0] count_value;
    reg Trigger_out;
    
    //symchronous logic for valkue of count_value
    always@(posedge CLK) begin
       if(RESET)
           count_value <= 0;
       else begin
           if(ENABLE) begin //only increment 1 when the last counter output 1
               if(count_value == COUNTER_MAX)
                   count_value <= 0;
               else
                   count_value <= count_value + 1;
           end
       end
    end
    
    
    //synchronous logic for Trigger_out
    always@(posedge CLK) begin
       if(RESET)
           Trigger_out <= 0;     
       else begin
           if(ENABLE && (count_value == COUNTER_MAX))
               Trigger_out <= 1;
           else
               Trigger_out <= 0;
       end
    end
    //assignment that tile the count_value and Trigger_out to COUNT and TRIG_OUT repectively
    
    assign COUNT        = count_value;
    assign TRIG_OUT     = Trigger_out;
    
endmodule