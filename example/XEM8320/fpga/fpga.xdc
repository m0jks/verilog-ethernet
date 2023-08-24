# XDC constraints XEM8320 10G Example Design. Dave Pegler {peglerd@gmail.com, dpegler@crfs.com}

# part: xcau25p-ffvb676-2-e

## 100MHz reference from U42 (FABRIC_REFCLK)
#set_property -dict {LOC T24} [get_ports fabric_100mhz_refclk_p]
#set_property -dict {LOC U24} [get_ports fabric_100mhz_refclk_n]
#create_clock -period 10.000 -name clk_100mhz [get_ports fabric_100mhz_refclk_p]

# -- Bank 66 and 67 -- SFP and SMA LEDs (VIO1 1v8)
set_property -dict {LOC G19 IOSTANDARD LVCMOS18} [get_ports {sfp_1_led[0]}] ;# LED 1, Bank 67, VIO1, (SYZYGY mainly port C, but also port B)
set_property -dict {LOC B16 IOSTANDARD LVCMOS18} [get_ports {sfp_1_led[1]}] ;# LED 2, Bank 67, VIO1, (SYZYGY mainly port C, but also port B)
set_property -dict {LOC F22 IOSTANDARD LVCMOS18} [get_ports {sfp_2_led[0]}] ;# LED 3, Bank 66, VIO1, (SYZYGY mainly port A, but also port B)
set_property -dict {LOC E22 IOSTANDARD LVCMOS18} [get_ports {sfp_2_led[1]}] ;# LED 4, Bank 67, VIO1, (SYZYGY mainly port C, but also port B)
set_property -dict {LOC M24 IOSTANDARD LVCMOS18} [get_ports   {sma_led[0]}] ;# LED 5, Bank 66, VIO1, (SYZYGY mainly port A, but also port B)
set_property -dict {LOC G22 IOSTANDARD LVCMOS18} [get_ports   {sma_led[1]}] ;# LED 6, Bank 66, VIO1, (SYZYGY mainly port A, but also port B)

set_false_path -to [get_ports {sfp_1_led[*] sfp_2_led[*]}]
set_output_delay 0 [get_ports {sfp_1_led[*] sfp_2_led[*]}]

# -- Bank 226 -- SFP+ Interfaces
#set_property -dict {LOC P7 } [get_ports sfp_mgt_refclk_p] ;# MGTREFCLK0P_226 from U39 (125MHz)
#set_property -dict {LOC P6 } [get_ports sfp_mgt_refclk_n] ;# MGTREFCLK0N_226 from U39 (125MHz)
set_property -dict {LOC  Y7 } [get_ports sfp_mgt_refclk_p] ;# MGTREFCLK1P_224 (156.25MHz) (XEM8320 Rev CXX)
set_property -dict {LOC  Y6 } [get_ports sfp_mgt_refclk_n] ;# MGTREFCLK1N_224 (156.25MHz) (XEM8320 Rev CXX)
#
set_property -dict {LOC M2 } [get_ports sfp_1_rx_p] ;# MGTYRXP0_226 GTYE4_CHANNEL_X0Y08 / GTYE4_COMMON_X0Y2
set_property -dict {LOC M1 } [get_ports sfp_1_rx_n] ;# MGTYRXN0_226 GTYE4_CHANNEL_X0Y08 / GTYE4_COMMON_X0Y2
set_property -dict {LOC K2 } [get_ports sfp_2_rx_p] ;# MGTYRXP1_226 GTYE4_CHANNEL_X0Y09 / GTYE4_COMMON_X0Y2
set_property -dict {LOC K1 } [get_ports sfp_2_rx_n] ;# MGTYRXN1_226 GTYE4_CHANNEL_X0Y09 / GTYE4_COMMON_X0Y2
set_property -dict {LOC N5 } [get_ports sfp_1_tx_p] ;# MGTYTXP0_226 GTYE4_CHANNEL_X0Y08 / GTYE4_COMMON_X0Y2
set_property -dict {LOC N4 } [get_ports sfp_1_tx_n] ;# MGTYTXN0_226 GTYE4_CHANNEL_X0Y08 / GTYE4_COMMON_X0Y2
set_property -dict {LOC L5 } [get_ports sfp_2_tx_p] ;# MGTYTXP1_226 GTYE4_CHANNEL_X0Y09 / GTYE4_COMMON_X0Y2
set_property -dict {LOC L4 } [get_ports sfp_2_tx_n] ;# MGTYTXN1_226 GTYE4_CHANNEL_X0Y09 / GTYE4_COMMON_X0Y2

# -- Bank 87 -- SFP strobes (VIO2 1v8)
set_property -dict {LOC E13 IOSTANDARD LVCMOS18 PULLUP true} [get_ports sfp_1_los]; # Bank 87, VIO2, (SYZYGY port D)
set_property -dict {LOC A13 IOSTANDARD LVCMOS18 PULLUP true} [get_ports sfp_2_los]; # Bank 87, VIO2, (SYZYGY port D)
set_property -dict {LOC D13 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports {sfp_1_rs[0]}]; # Bank 87, VIO2, (SYZYGY port D)
set_property -dict {LOC E12 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports {sfp_1_rs[1]}]; # Bank 87, VIO2, (SYZYGY port D)
set_property -dict {LOC B14 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports {sfp_2_rs[0]}]; # Bank 87, VIO2, (SYZYGY port D)
set_property -dict {LOC A12 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports {sfp_2_rs[1]}]; # Bank 87, VIO2, (SYZYGY port D)
set_property -dict {LOC C13 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports sfp_1_tx_disable]; # Bank 87, VIO2, (SYZYGY port D)
set_property -dict {LOC F13 IOSTANDARD LVCMOS18 SLEW SLOW DRIVE 12} [get_ports sfp_2_tx_disable]; # Bank 87, VIO2, (SYZYGY port D)

# 156.25 MGT reference clock
create_clock -period 6.4 -name sfp_mgt_refclk [get_ports sfp_mgt_refclk_p]
#
set_false_path -to [get_ports {sfp_1_tx_disable sfp_2_tx_disable sfp_1_rs sfp_2_rs}]
set_output_delay 0 [get_ports {sfp_1_tx_disable sfp_2_tx_disable sfp_1_rs sfp_2_rs}]
#
set_false_path -from [get_ports {sfp_1_los sfp_2_los}]
set_input_delay 0 [get_ports {sfp_1_los sfp_2_los}]

#  Bistream configuration
set_property CFGBVS GND                                      [current_design]
set_property CONFIG_VOLTAGE 1.8                              [current_design]
set_property BITSTREAM.GENERAL.COMPRESS true                 [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup               [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 31.9                [current_design]
set_property BITSTREAM.CONFIG.BPI_PAGE_SIZE 8                [current_design]
set_property BITSTREAM.CONFIG.BPI_1ST_READ_CYCLE 4           [current_design]
set_property CONFIG_MODE BPI16                               [current_design]
set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN Enable        [current_design]
