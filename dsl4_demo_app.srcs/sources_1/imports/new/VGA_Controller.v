`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/20 19:21:28
// Design Name: 
// Module Name: VGA_Controller
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


module VGA_Controller(
    input CLK,
    input RESET,
    input [7:0] BUS_ADDR,
    inout [7:0] BUS_DATA,
    input BUS_WE,
    
    // VGA Port Interface
    output [7:0] VGA_COLOUR,
    output VGA_HS,
    output VGA_VS
    );
    
    wire B_DATA;
    wire B_CLK;                     // DPR_CLOCK
    wire [14:0] B_ADDR;             // VGA_ADDR
    
    reg BUFFER_WE;                  // Write enable for buffer
    reg BUFFER_DATA;                // PIXEL_DATA_IN
    wire A_DATA_OUT;                // PIXEL)DATA_OUT
    wire [14:0] BUFFER_ADDR;        // Frame_ADDR
    reg [7:0] BUFFER_ADDR_x = 0;    // x address from data bus
    reg [6:0] BUFFER_ADDR_y = 0;    // y address from data bus
    wire [15:0] CONFIG_COLOURS;     // Complete colour signal
    reg [7:0] COLOUR_IN;            // Colour input
    
    initial COLOUR_IN = 8'h04;
     
    assign BUFFER_ADDR = {BUFFER_ADDR_y, BUFFER_ADDR_x};
    assign CONFIG_COLOURS={COLOUR_IN,~COLOUR_IN};
    
    parameter VGABaseAddr = 8'hB0; 
    parameter VGAAddrWidth = 4; // 16 x 8-bits memory
    //Tristate
    wire [7:0] BufferedBusData;
    reg [7:0] Out;
    reg VGABusWE;
    //Only place data on the bus if the processor is NOT writing, and it is addressing this interface
    assign BUS_DATA = (VGABusWE) ? Out : 8'hZZ;
    assign BufferedBusData = BUS_DATA;
    //Memory
    reg [7:0] Mem [2**VGAAddrWidth-1:0]; 
    
    always@(posedge CLK) begin
        if((BUS_ADDR >= VGABaseAddr) & (BUS_ADDR < VGABaseAddr + 8'h03)) begin
            if(BUS_WE) begin 
                Mem[BUS_ADDR[3:0]] <= BufferedBusData;
                VGABusWE <= 1'b0;
            end
            else begin
                Mem[2] <= Mem[2];    // When BUS_WE is false, output Pixel data out to BUS_DATA
                VGABusWE <= 1'b1;
            end
        end
        else begin
            Mem[2] <= A_DATA_OUT;
            VGABusWE <= 1'b0;
        end
        Out <= Mem[BUS_ADDR[3:0]];
    end
  
    always@ (posedge CLK) begin     
        // if (X_ADDR)
        if (BUS_ADDR == 8'hB0) begin
            BUFFER_ADDR_x <= BUS_DATA;
        end
        else
            BUFFER_ADDR_x <= BUFFER_ADDR_x; // Refresh current x address
        
        // if (Y_ADDR)
        if (BUS_ADDR == 8'hB1) begin
            BUFFER_ADDR_y <= BUS_DATA[6:0];
        end
        else
            BUFFER_ADDR_y <= BUFFER_ADDR_y; // Refresh current y address
        
        // Pixel Data
        if (BUS_ADDR == 8'hB2) begin    
            BUFFER_DATA <= BUS_DATA[0];
            BUFFER_WE <= 1'b1;
        end          
        else begin
            BUFFER_DATA <= BUFFER_DATA;     // Refresh current Pixel data
            BUFFER_WE <= 1'b0;
        end
        
        // Color
        if(BUS_ADDR == 8'hB3 )
            COLOUR_IN <= BUS_DATA;
        else
            COLOUR_IN <= COLOUR_IN;         // Refresh current color input
        
        /*
        // Inverse Pixel Data
        if (BUS_ADDR == 8'hB4) begin    
            BUFFER_DATA <= ~A_DATA_OUT;
            BUFFER_WE <= 1'b1;
        end          
        else begin
            BUFFER_DATA <= BUFFER_DATA;     // Refresh current Pixel data
            BUFFER_WE <= 1'b0;
        end
        */
    end    
    
    Frame_Buffer FrameBuffer(
        // Standard signal
        .A_CLK(CLK), 
        // BUS signals
        .A_ADDR(BUFFER_ADDR),       // 8 + 7 bits = 15 bits hence [14:0]
        .A_DATA_IN(BUFFER_DATA),    // Pixel Data In from micro
        .A_DATA_OUT(A_DATA_OUT),    // Pixel Data Out 
        .A_WE(BUFFER_WE),           // Write Enable
        // VGA_Sig_Gen signals
        .B_CLK(CLK),
        .B_ADDR(B_ADDR),            // ADDR from VGA_Sig_Gen
        .B_DATA(B_DATA)             // Pixel Data send to VGA sig gen
        );
         
    VGA_Sig_Gen SignalGenerator(
        // Standard signal
        .CLK(CLK), 
        .RESET(RESET),
        // Colour Configuration Interface
        .CONFIG_COLOURS(CONFIG_COLOURS), 
        // Frame Buffer (Dual Port memory) Interface
        .DPR_CLK(B_CLK),            // DPR_CLK
        .VGA_ADDR(B_ADDR),          // Pixel Data out
        .VGA_DATA(B_DATA),          // Pixel Data from Frame buffer
        // VGA Port Interface
        .VGA_HS(VGA_HS), 
        .VGA_VS(VGA_VS), 
        .VGA_COLOUR(VGA_COLOUR)
        );
    
endmodule
