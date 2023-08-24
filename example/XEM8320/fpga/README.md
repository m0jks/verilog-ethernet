# Verilog Ethernet XEM8320 10G Example Design. Dave Pegler {peglerd@gmail.com, dpegler@crfs.com}

## Introduction

This example design targets the Opal Kelly XEM8320 10G FPGA board.

	https://opalkelly.com/products/xem8320/

The design by default listens to UDP port 1234 at IP address 192.168.1.128 and will echo back any packets received.  The design will also respond correctly
to ARP requests.  

*  FPGA: xcau25p-ffvb676-2-e
*  PHY: 10G BASE-R PHY IP core and internal GTY transceiver

## How to build

Run make to build. Ensure that the Xilinx Vivado toolchain components are in PATH (e.g. source /opt/Xilinx/Vivado2023.1/settings64.sh)

## Background info - clocking

There are two versions of the XEM8320, one with and one without a 156.25MHz reference TCXO (CXX). This design uses the 156.25MHz as the reference for the 10G interface, so make sure you buy this version (i.e. revision CXX):

	https://docs.opalkelly.com/xem8320/clock-oscillators/

The schematics for the XEM8320 board can be downloaded from here:

	https://pins.opalkelly.com/downloads/374/download?category_id=3

These are the C04 schematics which has the 156.25MHz reference TCXO (U52) routed to a previously unused refclk input on Quad/Bank 224 (MGTREFCLK1P/N_224). Although the 156.25MHz reference is on the Quad/Bank used for PCIe (224) and the two 10G SFP+ transceiver SERDES lanes (SFP_1_RDP/N, SFP_1_TDP/N, SFP_2_RDP/N and SFP_2_TDP/N) are connected to Quad/Bank 226 (see page 5 in the above schematics), the constraints file and project files have been configured to ensure the SFP+ 156.25MHz reference is routed from Quad/Bank 224 to Quad/Bank 226 (GTNORTHREFCLK00).

## How to confgure FrontPanel correctly

Opal Kelly use a application called FrontPanel to configure various things on the XEM8320. This includes the supply voltage to banks. Normally when a SYZYGY peripheral is plugged into one of the 6 SYZYGY ports, a "ATiny" processor on the XEM8320 (which is not shown on the schematic) queries each port (A to F) to determine what supply voltage (e.g. 3v3,1v8 etc) the FPGA bank to which it is connected to should operate at:

	https://opalkelly.com/wp-content/uploads/XEM8320-Top-scaled.jpg

The 6 LEDs on the XEM8320 board (D1 to D6) are connected to Banks 66 and 67 (schematic page 6), and these banks are "mainly" connected to SYZYGY ports A, B, C . The two SFP+ cage strobes are connected to Bank 87 (schematic page 6), and these banks are "mainly" connected to SYZYGY port D. 

Bank 66 and 67 are supplied by rail VIO1, and Bank 87 is supplied by rail VIO2, so these rails need to be enabled "manually" to ensure that the FPGA can drive the LEDs and can read/write to the SFP cages strobes.  To do this one needs to install Opal Kelly's "FrontPanel" application, which can be downloaded from here:

	https://pins.opalkelly.com/downloads

Opal Kelly make you jump through a few hoops to register to download this application, but once it's up and running, plug in a USB-C cable (USB-C socket next to the slide switch) and then run FrontPanel on your Windows or Linux machine. As soon as the XEM8320 is powered up (using the slide switch), if all is well FrontPanel will begin displaying useful information about the XEM8320 (e.g. power rails, current draw, temperatures etc). Below is an example of FrontPanel running on a different Opal Kelly board (XEM7350-K70T), but it's similar to what you should see on the XEM8320 (except the power rails will be VDC, +3.3V, VIO1, VIO2 and VIO3):

	https://opalkelly.com/wp-content/uploads/FrontPanel-Screenshot.png

With FrontPanel up and running, click on the "Confgure device settings" icon (Spanner and Screwdriver crossed) and then use the right-hand vertical slider bar to get to the bottom of the list of "Device Settings". You should see lots of SYZYGY settings like "SYZYGY4_SERIAL_NUMBBER" etc. Next click the + icon to the right of the vertical slide bar, and then enter the following (you wil need to click the + icon each time you enter an option):

1. "XEM8320_SMARTVIO_MODE" and set the Value to "1"
2. "XEM8320_VIO1_VOLTAGE" and set the Value to 180
3. "XEM8320_VIO2_VOLTAGE" and set the Value to 180

The above options enables SMARTVIO mode - which configures the LDOs that supply VIO1 and VIO2 to operate at 1v8. Next click "Save" and "OK" and then power-cycle the XEM8320. FrontPanel should briefly complain about loosing conectivity to the XEM8320 but should then come back up displaying VIO1 and VIO2 as 1v8. If they do not, "DO NOT" proceed as the constraints file (and hence the FPGA design) has been configured so that banks 66, 67 and 87 expect to operate at 1v8. 

## How to program the XCAU25P-FFVB676-2-E (Artix Ultrascale+) on the XEM8320 board.

Firstly connect a second USB-C cable between your Windows or Linux machine to the second USB-C port which resides between SYZYGY Port E and the xcau25p-ffvb676-2-e FPGA (which is the device with the fan on it if you hadn't already guessed this). At this point also make sure the XEM8320 is powered up. To ensure that Windows or Linux detects the XEM8320 board over JTAG, please endure you installed the Vivado JTAG driver correctly when you installed Vivado.

Once "make" (see above) has completed in the XEM8320/fpga/fpga directory, you should find a number of files have been created. Amongst the ditritus that Vivado spits out these days, you should find a file called fpga.bit (symbolic link) and a file called fpga.xpr. The former is the bistream file and the latter is the Vivado project file. At this point open Vivado and point it at fpga.xpr; like so (on Linux):

	dwp@chebyshev:$ vivado fpga.xpr 

Vivado will now fire up and you should be presented with a completely built XEM8320 project (everything in the "Design Runs" tab should display "Complete!" next to it). Click on Open Hardware Manager -> Open Target in the Flow Navigator (left-hand window) and then in the "HARDWARE MANAGER" window that appears click on "Program device". A "Program Device" window should appear asking you to enter a "Bitstream file" and a "Debug probes file". Ignore the latter and click on the three dots "..." to select a Bistream File. Select "fpga.bit". If "fpga.bit" doesn't exist then click on fpga.runs -> impl_1. It should now be avaiable. Finally click "Program" (highlighted in blue) and wait for Vivado to program the XCAU25P-FFVB676-2-E. 

## How to test

With a 10GBASE-SR (MMF) or 10GBASE-LR (SMF) SFP+ in one of the two SFP+ cages and the same plugged into a 10G switch or NIC, if all is working you should see one of the red LEDs next to the xcau25p-ffvb676-2-e FPGA illuminate indicating Sync/Block lock (i.e. the firmware is seeing 01 or 10 in bits 64 and 66 of the 64/66b encoded frame). You should also see the link LED on the switch port or NIC illunminate, indicatiing that it is seeing valid 64/66b sync frames coming from the XEM8320.

The LEDs are configured like so:

	LED1	SFP_1 LOS 				Illiminated when no SFP detected (i.e. no light) in SFP_1
	LED2	SFP_1 10GBASE-R Sync/Block Lock		Iilluninated when 64/66b Syncs (01 or 10) detected in bits 65 and 64 (SFP_1)
	LED3	SFP_2 LOS				Illiminated when no SFP detected (i.e. no light) in SFP_2
	LED4	SFP_2 10GBASE-R Sync/Block Lock		Iilluninated when 64/66b Syncs (01 or 10) detected in bits 65 and 64 (SFP_2)
	LED5	NC
	LED6	NC

LED1 is the closest to the xcau25p-ffvb676-2-e FPGA.

The above design has been designed so that UDP frames on port sent to IP address 192.168.1.128 port 1234 are looped back. To test this use netcat like so 

    netcat -u 192.168.1.128 1234

Any text entered into netcat will be echoed back after pressing enter. You should see something like this :

	root@chebyshev:# netcat -u 192.168.1.128 1234
	Don't Panic
	Don't Panic
	Knowing where one's towel is
	Knowing where one's towel is

It is possible to use hping3 to test the design by running

    hping3 192.168.1.128 -2 -p 1234 -d 1024

where you should see something like this:

	root@chebyshev:# hping3 192.168.1.128 -2 -p 1234 -d 1024
	HPING 192.168.1.128 (enp3s0f0 192.168.1.128): udp mode set, 28 headers + 1024 data bytes
	len=1052 ip=192.168.1.128 ttl=64 DF id=0 seq=0 rtt=7.8 ms
	len=1052 ip=192.168.1.128 ttl=64 DF id=0 seq=1 rtt=3.7 ms
	len=1052 ip=192.168.1.128 ttl=64 DF id=0 seq=2 rtt=7.6 ms
	len=1052 ip=192.168.1.128 ttl=64 DF id=0 seq=3 rtt=7.5 ms
	^C
	--- 192.168.1.128 hping statistic ---
	4 packets transmitted, 4 packets received, 0% packet loss
	round-trip min/avg/max = 3.7/6.7/7.8 ms
	root@chebyshev:# 

or use aping like so:

	arping 192.168.1.128 -W 0.1
	
where you should see something like this:

	root@chebyshev:# arping 192.168.1.128 -W 0.1
	ARPING 192.168.1.128
	60 bytes from 02:00:00:00:00:00 (192.168.1.128): index=0 time=30.165 usec
	60 bytes from 02:00:00:00:00:00 (192.168.1.128): index=6 time=31.116 use
	60 bytes from 02:00:00:00:00:00 (192.168.1.128): index=7 time=30.894 usec
	60 bytes from 02:00:00:00:00:00 (192.168.1.128): index=8 time=33.264 usec
	60 bytes from 02:00:00:00:00:00 (192.168.1.128): index=9 time=27.718 usec
	^C
	--- 192.168.1.128 statistics ---
	10 packets transmitted, 10 packets received,   0% unanswered (0 extra)
	rtt min/avg/max/std-dev = 0.028/0.031/0.035/0.002 ms
	root@chebyshev:# 


