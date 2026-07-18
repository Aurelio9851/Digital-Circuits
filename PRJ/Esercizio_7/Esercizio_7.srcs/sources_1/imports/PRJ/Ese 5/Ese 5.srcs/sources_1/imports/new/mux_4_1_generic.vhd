----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2023 15:22:40
-- Design Name: 
-- Module Name: mux_4_1 - dataflow
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

entity mux_4_1_generic is
    Generic(N: natural range 1 to 256:=1);
    port(   a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            a_2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            a_3 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            s:  in  STD_LOGIC_VECTOR (1 downto 0);
            y:  out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end mux_4_1_generic;

architecture dataflow of mux_4_1_generic is

    begin
    y   <=  a_0 when s="00" else
                a_1 when s="01" else
                a_2 when s="10" else
                a_3 when s="11" else
		        (others=>'-');
end dataflow;
