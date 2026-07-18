----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2024 12:12:36
-- Design Name: 
-- Module Name: TB_OmegaNetwork - Behavioral
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

entity TB_OmegaNetwork is
end TB_OmegaNetwork;

architecture Behavioral of TB_OmegaNetwork is
signal A,B,C,D: STD_LOGIC_VECTOR  (1 downto 0):=(others=>'0');
signal d_0,d_1,d_2,d_3: STD_LOGIC_VECTOR (1 downto 0):=(others=>'0');
signal eA,eB,eC,eD: std_logic:='0';
signal y_0,y_1,y_2,y_3 : STD_LOGIC_VECTOR (1 downto 0);
begin


uut: entity work.Top_Module
    port map(
        a=>a,
        b=>b,
        c=>c,
        d=>d,
        dest_0=>d_0,
        dest_1=>d_1,
        dest_2=>d_2,
        dest_3=>d_3,
        en_a=>eA,
        en_b=>eB,
        en_c=>eC,
        en_d=>eD,
        y_0=>y_0,
        y_1=>y_1,
        y_2=>y_2,
        y_3=>y_3
    );
    A<="10";
    B<="11";
    C<="01";
    D<="10";
 
stimuli: process
begin 
    wait for 55 ns;
    eD<='1';
    d_3<="00";
    eB<='1';
    d_1<="10";
    wait for 30ns;
    eA<='1';
    d_0<="11";
    wait for 30 ns;
    eC<='1';
    d_2<="00";
    wait for 30 ns;
    d_0<="10";
    d_1<="01";
    wait for 30 ns;
    eA<='0';
    wait for 30 ns;
    eB<='0';
    wait for 30 ns;
    eC<='0';
    wait for 30 ns;
    eD<='0';
    
    wait;
end process;


end Behavioral;
