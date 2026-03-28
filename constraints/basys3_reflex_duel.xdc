## Clock
set_property PACKAGE_PIN W5 [get_ports clk_100mhz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_100mhz]
create_clock -add -name sys_clk_pin -period 10.00 [get_ports clk_100mhz]

## Reset (center button)
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

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

## Config
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]

## Start button (BTNL)
set_property PACKAGE_PIN W19 [get_ports start]
set_property IOSTANDARD LVCMOS33 [get_ports start]

## Player 1 LDR inputs - Pmod JA
set_property PACKAGE_PIN J1 [get_ports {p1_ldr[0]}]
set_property PACKAGE_PIN L2 [get_ports {p1_ldr[1]}]
set_property PACKAGE_PIN J2 [get_ports {p1_ldr[2]}]
set_property PACKAGE_PIN G2 [get_ports {p1_ldr[3]}]
set_property PACKAGE_PIN H1 [get_ports {p1_ldr[4]}]
set_property PACKAGE_PIN K2 [get_ports {p1_ldr[5]}]
set_property PACKAGE_PIN H2 [get_ports {p1_ldr[6]}]
set_property PACKAGE_PIN G3 [get_ports {p1_ldr[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p1_ldr[*]}]

## Player 1 LDR[8] + Player 2 LDR inputs - Pmod JB
set_property PACKAGE_PIN A14 [get_ports {p1_ldr[8]}]
set_property PACKAGE_PIN A16 [get_ports {p2_ldr[0]}]
set_property PACKAGE_PIN B15 [get_ports {p2_ldr[1]}]
set_property PACKAGE_PIN B16 [get_ports {p2_ldr[2]}]
set_property PACKAGE_PIN A15 [get_ports {p2_ldr[3]}]
set_property PACKAGE_PIN A17 [get_ports {p2_ldr[4]}]
set_property PACKAGE_PIN C15 [get_ports {p2_ldr[5]}]
set_property PACKAGE_PIN C16 [get_ports {p2_ldr[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p2_ldr[*]}]

## Player 2 LDR[7..8] - Pmod JC
set_property PACKAGE_PIN K17 [get_ports {p2_ldr[7]}]
set_property PACKAGE_PIN M18 [get_ports {p2_ldr[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p2_ldr[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {p2_ldr[8]}]

## LED outputs - Pmod JC + JD
set_property PACKAGE_PIN N17 [get_ports {led_out[0]}]
set_property PACKAGE_PIN P18 [get_ports {led_out[1]}]
set_property PACKAGE_PIN L17 [get_ports {led_out[2]}]
set_property PACKAGE_PIN M19 [get_ports {led_out[3]}]
set_property PACKAGE_PIN P17 [get_ports {led_out[4]}]
set_property PACKAGE_PIN R18 [get_ports {led_out[5]}]
set_property PACKAGE_PIN V15 [get_ports {led_out[6]}]
set_property PACKAGE_PIN V13 [get_ports {led_out[7]}]
set_property PACKAGE_PIN V14 [get_ports {led_out[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_out[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_out[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_out[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led_out[*]}]