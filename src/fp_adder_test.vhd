library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.all;

entity fp_adder_test is
    port (
        sw : in  std_logic_vector(9 downto 0);  -- os switches da FPGA
        key : in  std_logic_vector(1 downto 0);  -- as chaves
        hex0 : out std_logic_vector(7 downto 0);  -- expoente do resultado
        hex1 : out std_logic_vector(7 downto 0);  -- letra E fixa 
        hex2 : out std_logic_vector(7 downto 0);  -- fracao, 4 LSBs
        hex3 : out std_logic_vector(7 downto 0);  -- fracao, 4 MSBs
	hex4 : out std_logic_vector(7 downto 0);  -- digito zero
        hex5 : out std_logic_vector(7 downto 0)   -- sinal do resultado
    );
end fp_adder_test;

architecture arch of fp_adder_test is
    signal sign1, sign2 : std_logic;
    signal exp1, exp2 : std_logic_vector(3 downto 0);
    signal frac1, frac2 : std_logic_vector(7 downto 0);
    signal sign_out : std_logic;
    signal exp_out : std_logic_vector(3 downto 0);
    signal frac_out : std_logic_vector(7 downto 0);
begin
    -- set up the fp adder input signals
    sign1 <= '0';
    exp1  <= "1000";
    frac1 <= '1' & sw(1) & sw(0) & "10101";

    sign2 <= sw(7);
    exp2  <= sw(9) & sw(8) & (not key(1)) & (not key(0));
    frac2 <= '1' & sw(6 downto 0);

    -- instantiate fp adder
    fp_add_unit : entity work.fp_adder
        port map (
            sign1 => sign1, sign2 => sign2, exp1 => exp1, exp2 => exp2,
            frac1 => frac1, frac2 => frac2,
            sign_out => sign_out, exp_out => exp_out,
            frac_out => frac_out
        );

    -- instantiate three instances of hex decoders
    -- exponent -> HEX0
    sseg_unit_0 : entity work.hex_to_sseg
        port map (hex => exp_out, dp => '1', sseg => hex0);

	 hex1 <= "10110000";
		  
    -- 4 LSBs of fraction -> HEX1
    sseg_unit_1 : entity work.hex_to_sseg
        port map (hex => frac_out(3 downto 0), dp => '1', sseg => hex2);

    -- 4 MSBs of fraction -> HEX2
    sseg_unit_2 : entity work.hex_to_sseg
        port map (hex => frac_out(7 downto 4), dp => '1', sseg => hex3);

	 hex4 <= "00000001";
		  
    -- sign
    hex5 <= "11111110" when sign_out = '1' else -- negativo
            "11111111"; -- positivo
end arch;
