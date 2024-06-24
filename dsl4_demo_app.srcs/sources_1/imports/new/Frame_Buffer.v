`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: University of Edinburgh
// Engineer: Yi Ding
// 
// Create Date: 24.01.2023 09:20:39
// Design Name: 
// Module Name: Frame_Buffer
// Project Name: 
// Target Devices: Basys 3
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


module Frame_Buffer(
    input A_CLK,
    input [14:0] A_ADDR,    // 8 + 7 bits = 15 bits hence [14:0]
    input A_DATA_IN,        // Pixel Data In
    output reg A_DATA_OUT,
    input A_WE,             // Write Enable
    input B_CLK,
    input [14:0] B_ADDR,    // Pixel Data Out
    output reg B_DATA
    );
    
    // A 256 x 128 1-bit memory to hold frame data
    //The LSBs of the address correspond to the X axis, and the MSBs to the Y axis
    reg [0:0] Mem [2**15-1:0];
    
    initial $readmemb("C:/DSL4/dsl4_demo_app/dsl4_demo_app.srcs/InitialVGAFrameBuffer.txt", Mem);
    
     // Port A - Read/Write e.g. to be used by microprocessor
    always@(posedge A_CLK) begin
        if(A_WE)
            Mem[A_ADDR] <= A_DATA_IN;
            
        A_DATA_OUT <= Mem[A_ADDR];  // Always enable
    end
     // Port B - Read Only e.g. to be read from the VGA signal generator module for display
    always@(posedge B_CLK)
        B_DATA <= Mem[B_ADDR];
endmodule
