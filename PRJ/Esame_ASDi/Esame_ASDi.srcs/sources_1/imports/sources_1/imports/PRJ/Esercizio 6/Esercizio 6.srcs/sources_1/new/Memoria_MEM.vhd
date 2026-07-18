----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2024 13:15:47
-- Design Name: 
-- Module Name: Memoria_MEM - Behavioral
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
use IEEE.math_real.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Memoria_MEM is
    Generic(N: natural range 1 to 256:=3);
    Port ( clk,rst: in std_logic;
           addr: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
           write: in std_logic;
           data_in: in std_logic_vector(31 downto 0);
           read: in std_logic;
           data_out: out std_logic_vector(31 downto 0)    
    );
end Memoria_MEM;

architecture Behavioral of Memoria_MEM is

begin


end Behavioral;
