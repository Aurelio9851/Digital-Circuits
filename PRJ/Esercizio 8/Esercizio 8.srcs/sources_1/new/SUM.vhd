----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2024 13:15:34
-- Design Name: 
-- Module Name: SUM - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SUM is
generic (N: natural:=8);
Port (  A: in std_logic_vector(N-1 downto 0);
        B: in std_logic_vector(N-1 downto 0);
        Y: out std_logic_vector(N-1 downto 0)
);
end SUM;

architecture Behavioral of SUM is

begin
    process(A,B)
        variable X, Z, sum: unsigned(N-1 downto 0);
    begin
        X := to_unsigned(to_integer(unsigned(A)), N);
        Z := to_unsigned(to_integer(unsigned(B)), N);
        sum := X + Z;
        Y <= std_logic_vector(sum);
        end process;

end Behavioral;
