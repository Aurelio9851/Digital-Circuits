----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 23.01.2024 23:03:55
-- Design Name: 
-- Module Name: Impl - Structural
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

entity Impl is
    Port (  temp_sorg : in  STD_LOGIC_VECTOR (7 downto 0);
            selezione: in std_logic_vector (5 downto 0);
            destinazioni: out STD_LOGIC_VECTOR (3 downto 0);
            BTNC: in std_logic;
            BTNU: in std_logic;
            clk:  in std_logic
           );
end Impl;

architecture Structural of Impl is
    signal sorg : STD_LOGIC_VECTOR (15 downto 0):= (others => '0');
    component sorg_dest    
            Port (  sorgenti : in  STD_LOGIC_VECTOR (15 downto 0);
                    selezione: in std_logic_vector (5 downto 0);
                    destinazioni: out STD_LOGIC_VECTOR (3 downto 0)
           );
        end component;
begin
    device: sorg_dest
        port map (  sorgenti => sorg,
                    selezione => selezione,
                    destinazioni => destinazioni
           );
           
    process(clk)
    begin 
        if rising_edge(clk) then
        if BTNC='1' then sorg(7 downto 0) <= temp_sorg; 
        elsif BTNU='1' then sorg(15 downto 8) <= temp_sorg; 
        else 
        end if;
        end if;
    end process;
    
    
end Structural;
