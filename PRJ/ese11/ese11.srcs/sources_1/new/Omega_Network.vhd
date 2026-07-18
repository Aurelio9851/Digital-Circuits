----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.02.2024 14:22:23
-- Design Name: 
-- Module Name: Omega_Network - Structural
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

entity Omega_Network is
Generic(N: natural range 1 to 256:=1);
Port ( 
    a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
    a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
    a_2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
    a_3 : in  STD_LOGIC_VECTOR (N-1 downto 0);
    sel_sorg:  in  STD_LOGIC_VECTOR(1 downto 0);
    sel_dest:  in  STD_LOGIC_VECTOR(1 downto 0);
    y_0 : out  STD_LOGIC_VECTOR (N-1 downto 0);
    y_1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
    y_2 : out  STD_LOGIC_VECTOR (N-1 downto 0);
    y_3 : out  STD_LOGIC_VECTOR (N-1 downto 0)
    
);
end Omega_Network;

architecture Structural of Omega_Network is
component Switch_elementare is
Generic(N: natural range 1 to 256:=1);
Port ( 
    a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
    a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
    sel:  in  STD_LOGIC_VECTOR(1 downto 0);
    y_0 : out  STD_LOGIC_VECTOR (N-1 downto 0);
    y_1 : out  STD_LOGIC_VECTOR (N-1 downto 0)
);
end component;

signal connect1,connect2: std_logic_vector(N-1 downto 0):=(others=>'0');
signal connect3,connect4: std_logic_vector(N-1 downto 0):=(others=>'0');
signal sel_1, sel_2: std_logic_vector(1 downto 0):=(others=>'0');
begin

sel_1<=sel_sorg(0)&sel_dest(1);
sel_2<=sel_sorg(1) & sel_dest(0);

sw_s1: Switch_elementare
    generic map(N=>N)
    port map(
        a_0=>a_0,
        a_1=>a_1,
        sel=>sel_1,
        y_0=>connect1,
        y_1=>connect2
    );
    
sw_s2: Switch_elementare
    generic map(N=>N)
    port map(
        a_0=>a_2,
        a_1=>a_3,
        sel=>sel_1,
        y_0=>connect3,
        y_1=>connect4
    );
    
sw_d1: Switch_elementare
    generic map(N=>N)
    port map(
        a_0=>connect1,
        a_1=>connect3,
        sel=>sel_2,
        y_0=>y_0,
        y_1=>y_1
    ); 

sw_d2: Switch_elementare
    generic map(N=>N)
    port map(
        a_0=>connect2,
        a_1=>connect4,
        sel=>sel_2,
        y_0=>y_2,
        y_1=>y_3
    ); 

end Structural;
