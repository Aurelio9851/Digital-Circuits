library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity D_FlipFlop is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           d : in STD_LOGIC;
           q : out STD_LOGIC);
end D_FlipFlop;

architecture Behavioral of D_FlipFlop is
    signal internal_q : STD_LOGIC;
begin
    process (clk, reset)
    begin
        if reset = '1' then
            internal_q <= '0';
        elsif rising_edge(clk) then
            internal_q <= d;
        end if;
    end process;

    q <= internal_q;

end Behavioral;
