# Verilog Ethernet VCU118 + HTG 6x QSFP28 FMC+ Example Design

## Introduction

This example design targets the Xilinx VCU118 FPGA board with the HiTech Global HTG-FMC-X6QSFP28 FMC+ board installed on J22.

The design by default listens to UDP port 1234 at IP address 192.168.1.128 and will echo back any packets received.  The design will also respond correctly to ARP requests.  The design also enables the gigabit Ethernet interface for testing with a QSFP loopback adapter.

The design is configured to run all 8 QSFP28 modules synchronous to the QSFP Si570 (U38) on the VCU118.  This is done by forwarding the MGT reference clock for QSFP1 through the FPGA to the SYNC_C2M pins on the FMC+, which is connected as a reference input to the Si5341 PLL (U7) on the FMC+.

*  FPGA: xcvu9p-flga2104-2L-e
*  PHY: 25G BASE-R PHY IP core and internal GTY transceiver

## How to build

Run make to build.  Ensure that the Xilinx Vivado toolchain components are in PATH.

## How to test

Run make program to program the VCU118 board with Vivado.  Then run

    netcat -u 192.168.1.128 1234

to open a UDP connection to port 1234.  Any text entered into netcat will be echoed back after pressing enter.

It is also possible to use hping to test the design by running

    hping 192.168.1.128 -2 -p 1234 -d 1024

Note that the gigabit PHY is also enabled for debugging.  The gigabit port can be inserted into the 25G data path between the 25G MAC and 25G PHY so that the 25G interface can be tested with a QSFP loopback adapter.  Turn on SW12.1 to insert the gigabit port into the 25G data path, or off to bypass the gigabit port.  Turn on SW12.2 to place the port in the TX path or off to place the port in the RX path.
