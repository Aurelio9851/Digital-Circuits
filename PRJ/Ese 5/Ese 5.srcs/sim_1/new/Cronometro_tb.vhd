library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity tb_Cronometro is
end tb_Cronometro;

architecture testbench of tb_Cronometro is
    signal clk, rst, set,input,output : std_logic := '0';
    signal value_in : std_logic_vector(23 downto 0) := (others => '1');
    signal ANODES, CATHODES : std_logic_vector(7 downto 0);
begin
    
    uut_Cronometro: entity work.Clock_onBoard
        port map (
            clk => clk,
            rst => rst,
            start=> input,
            view=>output,
            set=> set,
            laps=>output,
            value_in => value_in(15 downto 0),
            ANODES_out => ANODES,
            CATHODES_out => CATHODES
        );
        

    -- Clock process
    process
    begin
        clk <= '0';
        wait for 5 ns;
        clk <= '1';
        wait for 5 ns;
    end process;

    -- Stimulus process
    process
    begin
        rst <= '1';  -- Reset initially
        
        wait for 50 ns;
        rst <= '0';  -- Release reset
        input<='1';
        wait for 15 ms;
        input<='0';
        
        wait for 20 ms;
        rst <= '1'; 
        wait for 1 ms;
        rst <= '0'; 
        set<='1'; --set conf
        wait for 15 ms;
        set<='0';
        wait for 15 ms;
        set<='1';  --set1
        wait for 15 ms;
        set<='0';
        wait for 15 ms;
        set<='1';  --set2
        wait for 15 ms;
        set<='0';
        input<='1';
        
        wait;
    end process;
end testbench;
