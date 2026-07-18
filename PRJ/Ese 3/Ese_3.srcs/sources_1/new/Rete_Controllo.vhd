----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.02.2024 00:06:52
-- Design Name: 
-- Module Name: Rete_Controllo - Behavioral
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

entity Rete_Controllo is
    Port (
         clk: in std_logic;
         rst: in std_logic;
         b1,b2: in std_logic;
         sw0,sw1: in std_logic;
         d,m,enable: out std_logic         
         );
end Rete_Controllo;

architecture Behavioral of Rete_Controllo is

begin
     process(clk)
    begin
        if rising_edge(clk) then
         if rst = '1' then
            d <= '0';
            m <= '0';
            enable<='0';
         else
            enable<='0'; 
            if b1='1' then d <= sw0;enable<='1'; 
            elsif b2='1' then m <= sw1; end if;
        end if;
        end if;
    end process;


end Behavioral;
