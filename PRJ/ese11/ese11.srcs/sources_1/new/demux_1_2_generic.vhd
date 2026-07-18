----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2024 14:14:12
-- Design Name: 
-- Module Name: demux_1_2_generic - Dataflow
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

entity demux_1_2_generic is
Generic(N: natural range 1 to 256:=1);
    Port ( 
        a : in  STD_LOGIC_VECTOR (N-1 downto 0);
        sel:  in  STD_LOGIC;
        y_0:  out STD_LOGIC_VECTOR (N-1 downto 0);
        y_1:  out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end demux_1_2_generic;

architecture Dataflow of demux_1_2_generic is

begin
    y_0 <=a when sel='0' else (others=>'0');
    y_1 <=a when sel='1' else (others=>'0');

end Dataflow;
