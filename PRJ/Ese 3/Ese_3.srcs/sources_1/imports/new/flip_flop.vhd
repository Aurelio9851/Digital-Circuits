----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.01.2024 21:54:22
-- Design Name: 
-- Module Name: flip_flop - Behavioral
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

entity flip_flop is
    Port ( D: in std_logic;
           clk,rst,en: in std_logic;
           Q: out std_logic );
end flip_flop;

architecture Behavioral of flip_flop is
signal temp: std_logic:='0';
begin

process_dato:    process(clk)
        begin
        if rising_edge(clk) then
            if rst='1' then
                temp<='0';
             elsif en='1' then
                temp<=D;
             else
             end if;
        end if;
    end process;
  Q<=temp;

end Behavioral;
