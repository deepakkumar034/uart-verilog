# uart-verilog

UART communication protocol implemented in Verilog RTL with transmitter, receiver, baud rate generator, and testbench verification.
<pre>
UART in Verilog

A UART (Universal Asynchronous Receiver Transmitter) communication protocol implemented in Verilog RTL. The design includes a transmitter, receiver, and baud rate generator suitable for FPGA-based embedded systems and digital design projects.

Features

* UART Transmitter (TX)
* UART Receiver (RX)
* Baud Rate Generator
* 9600 Baud Communication
* FPGA-Synthesizable RTL
* Icarus Verilog Testbench Verification

Design Specifications

* Input Clock: 50 MHz
* Baud Rate: 9600 bps
* Data Bits: 8
* Stop Bits: 1
* Parity: None
* Receiver Oversampling: 16x

Verification

The design is verified using an Icarus Verilog testbench. Simulation results confirm correct transmission and reception of UART data bytes. Current verification focuses on byte-level communication and does not include testing of varying inter-byte spacing.

Tools Used

* Verilog HDL
* Icarus Verilog
* GTKWave
* Yosys
* Netlistsvg
<pre>
