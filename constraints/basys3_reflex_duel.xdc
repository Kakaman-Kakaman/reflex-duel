## Clock
set_property PACKAGE_PIN W5 [get_ports clk_100mhz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100mhz]
create_clock -add -name sys_clk_pin -period 10.00 [get_ports clk_100mhz]

## Reset (center button)
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## Start (left button)
set_property PACKAGE_PIN W19 [get_ports start]
set_property IOSTANDARD LVCMOS33 [get_ports start]

## VGA Red
set_property PACKAGE_PIN G19 [get_ports {vga_r[0]}]
set_property PACKAGE_PIN H19 [get_ports {vga_r[1]}]
set_property PACKAGE_PIN J19 [get_ports {vga_r[2]}]
set_property PACKAGE_PIN N19 [get_ports {vga_r[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_r[*]}]

## VGA Green
set_property PACKAGE_PIN J17 [get_ports {vga_g[0]}]
set_property PACKAGE_PIN H17 [get_ports {vga_g[1]}]
set_property PACKAGE_PIN G17 [get_ports {vga_g[2]}]
set_property PACKAGE_PIN D17 [get_ports {vga_g[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_g[*]}]

## VGA Blue
set_property PACKAGE_PIN N18 [get_ports {vga_b[0]}]
set_property PACKAGE_PIN L18 [get_ports {vga_b[1]}]
set_property PACKAGE_PIN K18 [get_ports {vga_b[2]}]
set_property PACKAGE_PIN J18 [get_ports {vga_b[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {vga_b[*]}]

## VGA Sync
set_property PACKAGE_PIN P19 [get_ports hsync]
set_property PACKAGE_PIN R19 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]

## Player 1 LDR inputs - Pmod JA pins 0-3
set_property PACKAGE_PIN J1 [get_ports {p1_ldr[0]}]
set_property PACKAGE_PIN L2 [get_ports {p1_ldr[1]}]
set_property PACKAGE_PIN J2 [get_ports {p1_ldr[2]}]
set_property PACKAGE_PIN G2 [get_ports {p1_ldr[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p1_ldr[*]}]

## Player 2 LDR inputs - Pmod JB pins 0-3
set_property PACKAGE_PIN A14 [get_ports {p2_ldr[0]}]
set_property PACKAGE_PIN A16 [get_ports {p2_ldr[1]}]
set_property PACKAGE_PIN B15 [get_ports {p2_ldr[2]}]
set_property PACKAGE_PIN B16 [get_ports {p2_ldr[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p2_ldr[*]}]

## LED outputs - Pmod JC pins 0-3
set_property PACKAGE_PIN K17 [get_ports {led_out[0]}]
set_property PACKAGE_PIN M18 [get_ports {led_out[1]}]
set_property PACKAGE_PIN N17 [get_ports {led_out[2]}]
set_property PACKAGE_PIN P18 [get_ports {led_out[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_out[*]}]

## Debug - onboard LEDs
## LD[2:0] = FSM state  LD[6:3] = led_out  LD[7] = game_over
set_property PACKAGE_PIN U16 [get_ports {debug_led[0]}]
set_property PACKAGE_PIN E19 [get_ports {debug_led[1]}]
set_property PACKAGE_PIN U19 [get_ports {debug_led[2]}]
set_property PACKAGE_PIN V19 [get_ports {debug_led[3]}]
set_property PACKAGE_PIN W18 [get_ports {debug_led[4]}]
set_property PACKAGE_PIN U15 [get_ports {debug_led[5]}]
set_property PACKAGE_PIN U14 [get_ports {debug_led[6]}]
set_property PACKAGE_PIN V14 [get_ports {debug_led[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {debug_led[*]}]

## Config
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property PULLDOWN true [get_ports {p1_ldr[1]}]
set_property PULLDOWN true [get_ports {p1_ldr[2]}]
set_property PULLDOWN true [get_ports {p1_ldr[3]}]
set_property PULLDOWN true [get_ports {p2_ldr[0]}]
set_property PULLDOWN true [get_ports {p2_ldr[1]}]
set_property PULLDOWN true [get_ports {p2_ldr[2]}]
set_property PULLDOWN true [get_ports {p2_ldr[3]}]