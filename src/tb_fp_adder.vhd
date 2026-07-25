library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fp_adder is
    -- Um testbench não possui portas
end tb_fp_adder;

architecture behavior of tb_fp_adder is
    -- Sinais para conectar ao fp_adder
    signal sign1, sign2 : std_logic := '0';
    signal exp1, exp2 : std_logic_vector(3 downto 0) := (others => '0');
    signal frac1, frac2 : std_logic_vector(7 downto 0) := (others => '0');
    
    signal sign_out : std_logic;
    signal exp_out : std_logic_vector(3 downto 0);
    signal frac_out : std_logic_vector(7 downto 0);

begin
    -- Instancia o circuito matemático puro
    uut: entity work.fp_adder
        port map (
            sign1 => sign1, sign2 => sign2,
            exp1 => exp1, exp2 => exp2,
            frac1 => frac1, frac2 => frac2,
            sign_out => sign_out, exp_out => exp_out, frac_out => frac_out
        );

    -- Processo para injetar os estímulos (casos de teste)
    stim_proc: process
    begin
        -- Caso de Teste 1: Soma simples
        sign1 <= '0'; exp1 <= "1000"; frac1 <= "10101010"; 
        sign2 <= '0'; exp2 <= "1000"; frac2 <= "10000000";
        wait for 20 ns;
        
        -- Caso de Teste 2: Subtração que exige normalização (deslocamento à esquerda)
        -- Ideal para observar o sinal "leado" contando os zeros
        sign1 <= '0'; exp1 <= "1000"; frac1 <= "11110000";
        sign2 <= '1'; exp2 <= "1000"; frac2 <= "11100000";
        wait for 20 ns;

        -- Caso de Teste 3: Diferentes expoentes (exige alinhamento)
        sign1 <= '0'; exp1 <= "1010"; frac1 <= "11000000";
        sign2 <= '0'; exp2 <= "1001"; frac2 <= "10000000";
        wait for 20 ns;

        -- Finaliza a simulação
        wait;
    end process;
end behavior;