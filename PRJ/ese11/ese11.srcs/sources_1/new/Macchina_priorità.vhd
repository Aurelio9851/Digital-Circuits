----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2024 14:36:00
-- Design Name: 
-- Module Name: Macchina_priorita - Dataflow
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

entity Macchina_priorita is
    port(   a : in  STD_LOGIC_VECTOR(3 downto 0);
            dest_0:  in  STD_LOGIC_VECTOR (1 downto 0);
            dest_1:  in  STD_LOGIC_VECTOR (1 downto 0);
            dest_2:  in  STD_LOGIC_VECTOR (1 downto 0);
            dest_3:  in  STD_LOGIC_VECTOR (1 downto 0);
            y:  out STD_LOGIC_VECTOR(1 downto 0);
            z:  out STD_LOGIC_VECTOR(1 downto 0)
    );
end Macchina_priorita;

architecture Dataflow of Macchina_priorita is

begin

y<= "00" when a(3)='1' else
    "01" when a(2)='1' else
    "10" when a(1)='1' else
    "11" when a(0)='1' else  
    (others=>'-');
    
z<=  dest_0 when a(3)='1' else
     dest_1 when a(2)='1' else
     dest_2 when a(1)='1' else
     dest_3 when a(0)='1' else  
    (others=>'-');
end Dataflow;
