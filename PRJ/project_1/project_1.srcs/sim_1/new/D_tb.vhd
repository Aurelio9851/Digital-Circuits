library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity D_FlipFlop_Testbench is
end D_FlipFlop_Testbench;

architecture Behavioral of D_FlipFlop_Testbench is
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal d : STD_LOGIC := '0';
    signal q : STD_LOGIC;

    component D_FlipFlop
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               d : in STD_LOGIC;
               q : out STD_LOGIC);
    end component;

begin
    -- Instantiate the D_FlipFlop component
    DUT: D_FlipFlop port map (clk, reset, d, q);

    -- Clock process
    process
    begin
        wait for 5 ns;
        clk <= not clk;
    end process;

    -- Stimulus process
    process
    begin
        wait for 10 ns;
        reset <= '1';
        wait for 10 ns;
        reset <= '0';

        -- Test case 1
        d <= '0';
        wait for 10 ns;
        assert q = '0' report "Test Case 1 Failed" severity error;

        -- Test case 2
        d <= '1';
        wait for 10 ns;
        assert q = '1' report "Test Case 2 Failed" severity error;

        -- Add more test cases as needed

        wait;
    end process;

end Behavioral;
