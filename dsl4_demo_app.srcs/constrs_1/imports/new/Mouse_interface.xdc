#CLK

set_property PACKAGE_PIN W5 [get_ports {CLK}]
    set_property IOSTANDARD LVCMOS33 [get_ports {CLK}]
#Reset 

set_property PACKAGE_PIN U18 [get_ports {RESET}]
    set_property IOSTANDARD LVCMOS33 [get_ports {RESET}]

        
#7 Segments Display
         
set_property PACKAGE_PIN U2 [get_ports {SEG_SELECT_OUT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT_OUT[0]}]

set_property PACKAGE_PIN U4 [get_ports {SEG_SELECT_OUT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT_OUT[1]}]
  
set_property PACKAGE_PIN V4 [get_ports {SEG_SELECT_OUT[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT_OUT[2]}]
      
set_property PACKAGE_PIN W4 [get_ports {SEG_SELECT_OUT[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {SEG_SELECT_OUT[3]}]  

set_property PACKAGE_PIN W7 [get_ports {HEX_OUT[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[0]}]  

set_property PACKAGE_PIN W6 [get_ports {HEX_OUT[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[1]}]  

set_property PACKAGE_PIN U8 [get_ports {HEX_OUT[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[2]}]  
    
set_property PACKAGE_PIN V8 [get_ports {HEX_OUT[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[3]}]  
        
set_property PACKAGE_PIN U5 [get_ports {HEX_OUT[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[4]}]  
            
set_property PACKAGE_PIN V5 [get_ports {HEX_OUT[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[5]}]  
                
set_property PACKAGE_PIN U7 [get_ports {HEX_OUT[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[6]}] 
                    
set_property PACKAGE_PIN V7 [get_ports {HEX_OUT[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {HEX_OUT[7]}]  



        
#PS/2 Data ports
set_property PACKAGE_PIN C17 [get_ports {CLK_MOUSE}]
    set_property IOSTANDARD LVCMOS33 [get_ports {CLK_MOUSE}]
set_property PACKAGE_PIN B17 [get_ports {DATA_MOUSE}]
    set_property IOSTANDARD LVCMOS33 [get_ports {DATA_MOUSE}]
set_property PULLUP true [get_ports CLK_MOUSE]    
    
# LEDs
set_property PACKAGE_PIN U16 [get_ports {LEDL[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDL[0]}]

set_property PACKAGE_PIN E19 [get_ports {LEDL[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDL[1]}]

set_property PACKAGE_PIN U19 [get_ports {LEDL[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDL[2]}]

set_property PACKAGE_PIN V19 [get_ports {LEDL[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDL[3]}]

set_property PACKAGE_PIN W18 [get_ports {LEDL[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDL[4]}]

set_property PACKAGE_PIN U15 [get_ports {LEDL[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDL[5]}]

set_property PACKAGE_PIN U14 [get_ports {LEDL[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDL[6]}]

set_property PACKAGE_PIN V14 [get_ports {LEDL[7]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDL[7]}]

set_property PACKAGE_PIN V13 [get_ports {LEDH[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDH[0]}]

set_property PACKAGE_PIN V3 [get_ports {LEDH[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDH[1]}]

set_property PACKAGE_PIN W3 [get_ports {LEDH[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDH[2]}]

set_property PACKAGE_PIN U3 [get_ports {LEDH[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDH[3]}]

set_property PACKAGE_PIN P3 [get_ports {LEDH[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDH[4]}]

set_property PACKAGE_PIN N3 [get_ports {LEDH[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDH[5]}]

set_property PACKAGE_PIN P1 [get_ports {LEDH[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDH[6]}]

set_property PACKAGE_PIN L1 [get_ports {LEDH[7]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {LEDH[7]}]
    
# TRANSMITTER DIGITAL PIN
set_property PACKAGE_PIN G2 [get_ports {IR_LED}]  
    set_property IOSTANDARD LVCMOS33 [get_ports {IR_LED}]  

# BUTTONS
set_property PACKAGE_PIN T18 [get_ports {COMMAND[0]}]   
    set_property IOSTANDARD LVCMOS33 [get_ports {COMMAND[0]}]  
set_property PACKAGE_PIN U17 [get_ports {COMMAND[1]}]  
    set_property IOSTANDARD LVCMOS33 [get_ports {COMMAND[1]}]      
set_property PACKAGE_PIN W19 [get_ports {COMMAND[2]}]  
    set_property IOSTANDARD LVCMOS33 [get_ports {COMMAND[2]}]        
set_property PACKAGE_PIN T17 [get_ports {COMMAND[3]}]  
    set_property IOSTANDARD LVCMOS33 [get_ports {COMMAND[3]}]  

# SWITCH
set_property PACKAGE_PIN V16 [get_ports {SWITCH[0]}]  
    set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[0]}]  
set_property PACKAGE_PIN W16 [get_ports {SWITCH[1]}]  
    set_property IOSTANDARD LVCMOS33 [get_ports {SWITCH[1]}] 

#COLOUR_OUT
#Red
set_property PACKAGE_PIN G19 [get_ports {VGA_COLOUR[0]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[0]}]

set_property PACKAGE_PIN H19 [get_ports {VGA_COLOUR[1]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[1]}]

set_property PACKAGE_PIN J19 [get_ports {VGA_COLOUR[2]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[2]}]

#Green
set_property PACKAGE_PIN J17 [get_ports {VGA_COLOUR[3]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[3]}]

set_property PACKAGE_PIN H17 [get_ports {VGA_COLOUR[4]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[4]}]

set_property PACKAGE_PIN G17 [get_ports {VGA_COLOUR[5]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[5]}]

#Blue
set_property PACKAGE_PIN N17 [get_ports {VGA_COLOUR[6]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[6]}]

set_property PACKAGE_PIN L17 [get_ports {VGA_COLOUR[7]}]
    set_property IOSTANDARD LVCMOS33 [get_ports {VGA_COLOUR[7]}]

#HS and VS
set_property PACKAGE_PIN P19 [get_ports VGA_HS]
    set_property IOSTANDARD LVCMOS33 [get_ports VGA_HS]
set_property PACKAGE_PIN R19 [get_ports VGA_VS]
    set_property IOSTANDARD LVCMOS33 [get_ports VGA_VS]
