-- Copyright (C) 2025  Altera Corporation. All rights reserved.
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, the Altera Quartus Prime License Agreement,
-- the Altera IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Altera and sold by Altera or its authorized distributors.  Please
-- refer to the Altera Software License Subscription Agreements 
-- on the Quartus Prime software download page.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "07/29/2026 02:00:55"
                                                            
-- Vhdl Test Bench template for design  :  fp_adder_test
-- 
-- Simulation tool : Questa Altera FPGA (VHDL)
-- 

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fp_adder_test_vhd_tst IS
END fp_adder_test_vhd_tst;

ARCHITECTURE fp_adder_test_arch OF fp_adder_test_vhd_tst IS

    SIGNAL hex0 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL hex1 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL hex2 : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL hex3 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	 SIGNAL hex4 : STD_LOGIC_VECTOR(7 DOWNTO 0);
	 SIGNAL hex5 : STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL key : STD_LOGIC_VECTOR(1 DOWNTO 0);
    SIGNAL sw  : STD_LOGIC_VECTOR(9 DOWNTO 0);

    COMPONENT fp_adder_test
        PORT(
            hex0 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            hex1 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            hex2 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            hex3 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				hex4 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				hex5 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            key  : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
            sw   : IN  STD_LOGIC_VECTOR(9 DOWNTO 0)
        );
    END COMPONENT;

BEGIN

    uut : fp_adder_test
    PORT MAP(
        hex0 => hex0,
        hex1 => hex1,
        hex2 => hex2,
        hex3 => hex3,
		  hex4 => hex4,
		  hex5 => hex5,
        key  => key,
        sw   => sw
    );

    stim_proc : PROCESS
    BEGIN
	     -- caso 1 documentacao
        sw  <= "1110010100";
        key <= "10";        -- not key = 01
        wait for 20 ns;
		  
        -- caso 2 documentacao
        sw  <= "1111100001";
        key <= "11";        -- not key = 00
        wait for 20 ns;
	 
        -- caso 3 documentacao 
        sw  <= "1111000001";
        key <= "11";        -- not key = 00
        wait for 20 ns;
	 
        -- caso 4 
        sw  <= "1010010001";
        key <= "01";        -- not key = 10
        wait for 20 ns;

        -- caso 5 
        sw  <= "0111101111";
        key <= "10";        -- not key = 01
        wait for 20 ns; 

        -- caso 6
        sw  <= "0111011110";
        key <= "00";        -- not key = 11
        wait for 20 ns;

        -- caso 7
        sw  <= "0111111110";
        key <= "00";        -- not key = 11
        wait for 20 ns;

        -- caso 8
        sw  <= "0000000000";
        key <= "11";        -- not key = 00
        wait for 20 ns;

        -- caso 9
        sw  <= "0000100000";
        key <= "11";        -- not key = 00
        wait for 20 ns;

        -- caso 10
        sw  <= "0001011111";
        key <= "01";        -- not key = 10
        wait for 20 ns;

        -- caso 11
        sw  <= "0001111111";
        key <= "01";        -- not key = 10
        wait for 20 ns;

        wait;

    END PROCESS;

END fp_adder_test_arch;