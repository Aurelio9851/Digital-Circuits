----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.01.2024 20:12:31
-- Design Name: 
-- Module Name: demux_1_4 - Behavioral
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

entity demux_1_4 is
 Port (     a : in  STD_LOGIC;
            s:  in  STD_LOGIC_VECTOR (1 downto 0);
            y:  out STD_LOGIC_VECTOR (3 downto 0) );
end demux_1_4;

architecture Behavioral of demux_1_4 is
    
begin
       
    process(s,a)
    begin 
        y<="0000";
        case s is 
            when "00"=>y(0)<=a;
            when "01"=>y(1)<=a;
            when "10"=>y(2)<=a;
            when "11"=>y(3)<=a;
            when others => y<="0000";
         end case;
    end process;
      
    
        
end Behavioral;
