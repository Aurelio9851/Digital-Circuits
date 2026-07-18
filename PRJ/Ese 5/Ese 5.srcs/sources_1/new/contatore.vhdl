----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.01.2024 13:56:24
-- Design Name: 
-- Module Name: contatore - Behavioral
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

entity contatore is
    Port ( clk: in std_logic;
           rst,en:in std_logic;
           set,data_in: in std_logic;
           out_s: out std_logic
     );
end contatore;

architecture Behavioral of contatore is
signal count: std_logic:='0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                count<='0';
            elsif en='1' then
                if set='1' then
                    count<=data_in;
                else
                    count<=NOT count;
                end if;
            else
            end if;
        end if;
    end process;

out_s<=count;

end Behavioral;
