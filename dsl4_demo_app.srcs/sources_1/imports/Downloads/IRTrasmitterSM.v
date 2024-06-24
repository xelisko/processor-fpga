`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: DSL4
// Engineer: Alexandra Geciova
// 
// Create Date: 02/22/2023 03:01:37 PM
// Design Name: State Machine for IR Trasnmitter
// Module Name: IR_Transmitter_SM
// Project Name: IR_Transmitter
// Target Devices: 
// Tool Versions: 
// Description: 
//      this module generates IR LED digital signal packet given the COMMNAD and SEND_PACKET information
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module IRTransmitterSM(
    CLK,
    RESET,
    COMMAND, 
    SEND_PACKET,
    IR_LED
    );
    
    // parameters & local parameters
    parameter [7:0] StartBurstSize = 191; //192
    parameter [7:0] CarSelectBurstSize = 23; //24
    parameter [7:0] GapSize = 23; //24
    parameter [7:0] AsserBurstSize = 47; //48
    parameter [7:0] DeAssertBurstSize = 23; //24  
    localparam [16:0] CLK_per_pulse = 1388;//1389  
    
    input CLK;
    input RESET;
    input [3:0] COMMAND;
    input SEND_PACKET;
    output reg IR_LED;
                   
    // pulse generation
    reg pulse;
    initial pulse = 1;
    
    // states
    reg [3:0] curr_state;   // current stat of the SM
    reg [3:0] next;         // next state after the gap
    reg [3:0] next_gap;     // next state - gap right away
    reg prev_send;    
       
   initial curr_state = 4'b1111;


	// for counter of pulses
    wire Trig_change_pulse;  // from counter - change the level of pulse
    wire [7:0] Count_Pulses;
    
    // end of pulse's period
    wire end_pulse;
    assign end_pulse = Trig_change_pulse && !(pulse);
    
   	// posedge of SEND_PACKET or generation of new PACKAGE
    wire send;    
    assign send = (!prev_send && SEND_PACKET);

    reg reset_count;    //resets the counter when there is a state change
    wire reset_manual;  // STATE CHANGE or NEW PACKAGE
    assign reset_manual = send || reset_count;
  
    // the signals control that command is correct - not right and left at the same time
    reg hor;
    reg ver;
    initial begin 
        hor = 0;
        ver = 0;
    end
   
   
   
   
   /* Generate the pulse signal here from the main clock running at 50MHz to generate the right frequency for 
      the car in question e.g. 40KHz for BLUE coded cars     */
    
    // pulse generator
    generic_counter # (.COUNTER_WIDTH(17),
                       .COUNTER_MAX(CLK_per_pulse)  
                       )
                       Pulse_Generator (
                       .CLK(CLK),
                       .RESET(RESET || reset_manual),
                       .ENABLE(1'b1),
                       .TRIG_OUT(Trig_change_pulse)
    );
    
   // pulse counter
    generic_counter # (.COUNTER_WIDTH(8),
                      .COUNTER_MAX(254)
                      )
                      Pulse_Counter (
                      .CLK(CLK),
                      .RESET(RESET || reset_manual),
                      .ENABLE(end_pulse),
                      .COUNT(Count_Pulses)
                   );
    
    
    always@(posedge CLK) begin
           // pulse generation
           if (RESET || reset_manual)
               pulse <= 1;
           else if (Trig_change_pulse)
               pulse <= ~pulse;
           else  
               pulse <= pulse;
    end




    /*  Simple state machine to generate the states of the packet i.e. Start, Gaps, Right Assert or De-Assert, Left 
        Assert or De-Assert, Backward Assert or De-Assert, and Forward Assert or De-Assert */
   
   // combinational logic for the State Machine
    always@(posedge CLK) begin 
        case (curr_state)
           //start
           4'b0100: begin
               if (Count_Pulses == StartBurstSize) begin
                   next <= 4'b0101;
                   next_gap <= 4'b0111;
               end
               else next_gap <= 4'b0100;
           end
           //car select
           4'b0101: begin 
               if (Count_Pulses == CarSelectBurstSize) begin
                   next <= 4'b0000;
                   next_gap <= 4'b0111;
               end
               else next_gap <= 4'b0101;
           end 
           // right
           4'b0000: begin 
               if (COMMAND[3]) begin // Assert
                   hor <= 1;
                   if (Count_Pulses == AsserBurstSize) begin
                       next <= 4'b0001;
                       next_gap <= 4'b0111;
                   end
                   else
                       next_gap <= 4'b0000;               
               end 
               else begin       //Deassert
                   hor <= 0;
                   if (Count_Pulses == DeAssertBurstSize) begin
                       next <= 4'b0001;
                       next_gap <= 4'b0111;
                   end
                   else 
                         next_gap <= 4'b0000;               
               end
           end
           //left
            4'b0001: begin 
                if (COMMAND[2] && !hor) begin // Assert
                    if (Count_Pulses == AsserBurstSize) begin
                      next <= 4'b0010;
                      next_gap <= 4'b0111;
                    end
                    else
                        next_gap <= 4'b0001;               
                end
                else begin // Deassert
                    if (Count_Pulses == DeAssertBurstSize) begin
                      next <= 4'b0010;
                      next_gap <= 4'b0111;
                    end
                    else 
                        next_gap <= 4'b0001;               
                end
           end
           //backwards
           4'b0010: begin
                if (COMMAND[1]) begin       //Assert
                    ver <= 1;
                    if (Count_Pulses == AsserBurstSize) begin
                         next <= 4'b0011;
                         next_gap <= 4'b0111;
                    end
                    else
                       next_gap <= 4'b0010;               
                end
                else begin          // Deassert
                    ver <= 0;
                   if (Count_Pulses == DeAssertBurstSize) begin
                         next <= 4'b0011;
                         next_gap <= 4'b0111;
                   end
                   else 
                     next_gap <= 4'b0010;               
                end
            end
            //forwards              // Assert
            4'b0011: begin 
                if (COMMAND[0] && !ver) begin
                    if (Count_Pulses == AsserBurstSize) begin
                        next <= 4'b1111;
                        next_gap <= 4'b0111;
                    end
                    else
                        next_gap <= 4'b0011;               
                end
                else begin          // Deassert
                    if (Count_Pulses == DeAssertBurstSize) begin
                        next <= 4'b1111;
                        next_gap <= 4'b0111;
                    end
                else 
                    next_gap <= 4'b0011;               
                end
            end

           // Gap
           4'b0111: begin 
               if (Count_Pulses == GapSize)
                   next_gap <= next; //4'b1111;
               else next_gap <= 4'b0111;
           end               
           // Idle state
           4'b1111: begin 
               if (Count_Pulses == 3)
                   next_gap <= 4'b1111;
               else next_gap <= 4'b1111;
           end    
           default:
                next_gap <= 4'b1111;            
        endcase
    end

    // sequentail logic for different registers
    always@(posedge CLK) begin 
        
        // state transitions
        if (RESET) 
          curr_state <= 4'b1111;
        else if (send)
          curr_state <= 4'b0100;
        else if (end_pulse)  //// tutoooo
           curr_state <= next_gap;
        else 
           curr_state <= curr_state;
        
        // reset counter due to new state
        if (RESET)
            reset_count <= 0;
        else if (end_pulse && (curr_state != next_gap)) /// tutooo
            reset_count <= 1;
        else
            reset_count <= 0;

        prev_send <= SEND_PACKET;
    end

    // Finally, tie the pulse generator with the packet state to generate IR_LED
    always@(posedge CLK)begin
        // ir_led out signal 
        if (RESET)
            IR_LED <= 0;
        else if (send)
            IR_LED <= 1;
        else if (end_pulse && (curr_state != next_gap)) begin// && (next_gap != 4'b1111) && (next_gap != 4'b0111) && 
            if ((next_gap != 4'b1111) && (next_gap != 4'b0111))  
               IR_LED <= ~pulse;
            else 
                IR_LED <= 0;
        end
        else if ((curr_state != 4'b1111) && (curr_state != 4'b0111)) begin
            if (Trig_change_pulse)
                IR_LED <= ~pulse;
            else
                IR_LED <= pulse;
        end
        else
            IR_LED <= 0;
    end


    // ILA Debugging
//    ila_0 (
//        .clk(CLK),
//        .probe0(Count_Pulses), //8 bits
//        .probe1(COMMAND),  //4 bits
//        .probe2(pulse),
//        .probe3(IR_LED),
//        .probe4(curr_state), // 4 bits
//        .probe5(RESET),
//        .probe6(send)
//    );
    
endmodule
