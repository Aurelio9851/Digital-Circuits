----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2024 12:00:18
-- Design Name: 
-- Module Name: ROM - Dataflow
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




-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.math_real.ALL;
use ieee.std_logic_unsigned.all;


entity ROM is
    Generic(
            N: natural range 1 to 256:=8;
            M: natural range 1 to 256:=8);
    Port ( 
    CLK:  in std_logic;
    RST:  in std_logic;
    READ: in std_logic;  
    ADDR : in  std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);                                           
    DATA : out std_logic_vector(M-1 downto 0) 
    );
end ROM;

architecture behavioral of ROM is 
type rom_type is array (0 to N-1) of std_logic_vector(M-1 downto 0);


signal ROM : rom_type := (
x"B7", 
x"45", 
x"31", 
x"01", 
x"20",
x"05",
x"C1", 
x"FF");


begin

process(clk)
  begin
    if rising_edge(clk) then
        if rst='1' then
            DATA <=ROM(0);
        elsif read='1' then
            DATA <= ROM(conv_integer(ADDR));
        else
        end if;
    end if;
    
end process;
end behavioral;