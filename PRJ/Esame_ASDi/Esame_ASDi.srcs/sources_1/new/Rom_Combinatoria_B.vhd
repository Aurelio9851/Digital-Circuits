----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.02.2024 17:08:57
-- Design Name: 
-- Module Name: Rom_Combinatoria_B - Behavioral
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
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Rom_Combinatoria_B is
Generic(
            N: natural range 1 to 256:=16;
            M: natural range 1 to 256:=8);
    Port ( 
            addr: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
            y: out std_logic_vector(M-1 downto 0)
         );
end Rom_Combinatoria_B;

architecture Dataflow of Rom_combinatoria_B is
type rom_type is array (0 to N-1) of std_logic_vector(M-1 downto 0);

signal ROM : rom_type := (
x"09", 
x"0A", 
x"0B", 
x"0C", 
x"0D",
x"0E",
x"0F", 
x"10",
x"09", 
x"0A", 
x"0B", 
x"0C", 
x"0D",
x"0E",
x"0F", 
x"10"
);

attribute rom_style: string;
attribute rom_style of ROM: signal is "block";

begin 
y <= ROM(conv_integer(addr));
    
    
end Dataflow;
