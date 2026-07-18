library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb is
end tb;

architecture topmodule_tb of tb is
    component Top_module
        Port ( addr : in std_logic_vector(3 downto 0);
               y : out std_logic_vector(3 downto 0));
    end component;

    signal input  : std_logic_vector(3 downto 0) := "0000"; 
    signal output : std_logic_vector(3 downto 0);

begin

    utt : Top_module port map(
        addr => input,
        y => output
    );

    stim_proc: process
    begin
        wait for 100 ns;
        
        input <= "0000";
        for i in 0 to 15 loop
            input <= std_logic_vector(to_unsigned(i, 4));
            wait for 20 ns;
        end loop;

        wait;
    end process;

end topmodule_tb;
