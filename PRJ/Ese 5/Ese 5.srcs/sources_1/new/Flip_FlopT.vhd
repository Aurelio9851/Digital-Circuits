----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.01.2024 13:17:07
-- Design Name: 
-- Module Name: Flip_FlopT - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Flip_FlopT is
    port( T: in std_logic;
    Clock,rst: in std_logic;
    set: in std_logic:='0';
    data_in: in std_logic:='0';
    Q: out std_logic);

end Flip_FlopT;

architecture Behavioral of Flip_FlopT is
signal tmp: std_logic;
begin

process (Clock)
    begin
    if Clock'event and Clock='0' then
    if rst='1' then tmp<='0';
    else
        if set='1' then tmp<=data_in;
        else
            if T='0' then
            tmp <= tmp;
            elsif T='1' then
            tmp <= not (tmp);
            end if;
        end if;
    end if;
    end if;
end process;
    Q <= tmp;

end Behavioral;
