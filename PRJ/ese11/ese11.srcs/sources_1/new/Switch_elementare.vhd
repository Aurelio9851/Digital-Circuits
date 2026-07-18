----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2024 14:10:20
-- Design Name: 
-- Module Name: Switch_elementare - Structural
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

entity Switch_elementare is
Generic(N: natural range 1 to 256:=1);
Port ( 
    a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
    a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
    sel:  in  STD_LOGIC_VECTOR(1 downto 0);
    y_0 : out  STD_LOGIC_VECTOR (N-1 downto 0);
    y_1 : out  STD_LOGIC_VECTOR (N-1 downto 0)
);
end Switch_elementare;

architecture Structural of Switch_elementare is

component mux_2_1_generic is
Generic(N: natural range 1 to 256:=1);
    port(   a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            s:  in  std_logic;
            y:  out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end component;

component demux_1_2_generic is
Generic(N: natural range 1 to 256:=1);
    Port ( 
        a : in  STD_LOGIC_VECTOR (N-1 downto 0);
        sel:  in  STD_LOGIC;
        y_0:  out STD_LOGIC_VECTOR (N-1 downto 0);
        y_1:  out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end component;
signal temp: std_logic_vector(N-1 downto 0):=(others=>'0');
begin

mux: mux_2_1_generic
    generic map(N=>N)
    port map(
        a_0=>a_0,
        a_1=>a_1,
        s=>sel(1),
        y=>temp    
    );

demux: demux_1_2_generic
    generic map(N=>N)
    port map(
        a=>temp,
        sel=>sel(0),
        y_0=>y_0,
        y_1=>y_1
    );    



end Structural;
