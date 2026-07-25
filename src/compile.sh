#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting VHDL compilation using GHDL..."

# 1. Analyze the dependencies
echo "Analyzing fp_adder.vhd..."
ghdl -a fp_adder.vhd

echo "Analyzing hex_to_sseg.vhd..."
ghdl -a hex_to_sseg.vhd

echo "Analyzing disp_mux.vhd..."
ghdl -a disp_mux.vhd
 
# 2. Analyze the testbench
echo "Analyzing tb_fp_adder.vhd..."
ghdl -a tb_fp_adder.vhd

# 3. Elaborate the testbench entity
echo "Elaborating the testbench (tb_fp_adder)..."
ghdl -e tb_fp_adder

echo "Compilation successful! Executable 'tb_fp_adder' has been generated."

# 4. Run the simulation and generate a VCD waveform file
echo "Running simulation..."
ghdl -r tb_fp_adder --vcd=wave.vcd --stop-time=100ns

# 5. Open GTKWave in the background
echo "Opening GTKWave..."
gtkwave wave.vcd &