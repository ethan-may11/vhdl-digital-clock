# Digital Clock (VHDL, Basys 3 FPGA)

A digital clock implemented in VHDL on a Xilinx Basys 3 FPGA. It divides the board's 100 MHz system clock down to a 1 Hz tick and displays minutes and seconds (MM:SS) across the four-digit seven-segment display, with correct 00-59 rollover and flicker-free output.

> Final project for CMPE 240 (Digital Systems). The design integrates three building blocks developed in earlier labs - a counter-based clock divider, a time-multiplexed display driver, and a hex-to-seven-segment decoder - into one complete working system.

## How it works
The design is four processes working together:

- **1 Hz tick generator** - a 27-bit counter increments every clock cycle and pulses a one-cycle `tick` when it reaches 99,999,999, producing an exact one-second pulse from the 100 MHz clock.
- **Timekeeping** - four BCD digits (seconds ones/tens, minutes ones/tens) advance on each tick, with cascading rollover: seconds roll 00-59 and carry into minutes, which roll the same way.
- **Display multiplexer** - an 18-bit free-running counter drives the digit select; its top two bits choose which of the four digits is active, refreshing fast enough (~381 Hz) that all four appear continuously lit.
- **Hex-to-seven-segment decoder** - maps each BCD digit to its active-low GFEDCBA segment pattern.

## Design note
The 1 Hz tick uses a **27-bit** counter (counting to 99,999,999 for a full-second pulse), one bit wider than the 26-bit divider used in the earlier LED-blink lab. That lab toggled its output at the half-period; generating a true one-second pulse requires counting the full period, which needs the extra bit.

## Hardware
- **Board:** Digilent Basys 3 (Xilinx Artix-7)
- **Clock:** 100 MHz system clock
- **Display:** four-digit seven-segment (active-low segments and anodes)

Pin assignments for the segments, anodes, and clock are in `DigitalClock.xdc`.

## Build and run
Open the project in Vivado, add `DigitalClock.vhd` and `DigitalClock.xdc`, then synthesize, implement, generate the bitstream, and program the Basys 3. The clock starts at 00:00 and counts up.

## Files
- `DigitalClock.vhd` - the full design (tick generator, timekeeping, display mux, decoder)
- `DigitalClock.xdc` - Basys 3 pin constraints

## Concepts
Clock division, synchronous sequential logic, BCD counters with cascading carry, time-multiplexed display driving, combinational decoding, and FPGA I/O constraints.
