----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 19.01.2024 17:02:04
-- Design Name: 
-- Module Name: Rom_combinatoria - Structural
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
use IEEE.std_logic_unsigned.ALL;
use IEEE.math_real.ALL;

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



entity Rom_combinatoria is
     Generic(
            N: natural range 1 to 256:=8;
            M: natural range 1 to 256:=8);
    Port ( 
            addr: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
            y: out std_logic_vector(M-1 downto 0)
         );
end Rom_combinatoria;

architecture Dataflow of Rom_combinatoria is
type rom_type is array (0 to N-1) of std_logic_vector(M-1 downto 0);

signal ROM : rom_type := (
x"01", 
x"02", 
x"03", 
x"04", 
x"05",
x"06",
x"07", 
x"08");

attribute rom_style: string;
attribute rom_style of ROM: signal is "block";

begin 
y <= ROM(conv_integer(addr));
    
    
end Dataflow;
