----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2024 21:43:06
-- Design Name: 
-- Module Name: Top_module - Behavioral
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

entity Top_module is
    Port ( addr : in std_logic_vector(3 downto 0);
           y : out std_logic_vector(3 downto 0));
end Top_module;

architecture Structural of Top_module is
    component Rom_combinatoria 
        Port ( addr: in std_logic_vector(3 downto 0);
                y: out std_logic_vector(7 downto 0 ));
    end component;

    component Macchina_M 
       Port (   addr : in std_logic_vector(7 downto 0);
                y : out std_logic_vector(3 downto 0));
    end component;

    signal u1 : std_logic_vector(7 downto 0);
   
   begin
     rom: Rom_combinatoria PORT MAP(
        addr => addr,
        y => u1
    );
        
    comb: Macchina_M PORT MAP(
        addr=> u1,
        y=>y
    );
    
end Structural;