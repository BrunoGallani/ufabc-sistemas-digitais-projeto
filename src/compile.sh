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
 
# 2. Analyze the top-level design
echo "Analyzing fp_adder_test.vhd..."
ghdl -a fp_adder_test.vhd

# 3. Elaborate the top-level entity
echo "Elaborating the top-level entity (fp_adder_test)..."
ghdl -e fp_adder_test

echo "Compilation successful! Executable 'fp_adder_test' has been generated."

# 4. Run the simulation and generate a VCD waveform file
echo "Running simulation..."
ghdl -r fp_adder_test --vcd=wave.vcd

# 5. Open GTKWave in the background
echo "Opening GTKWave..."
gtkwave wave.vcd &