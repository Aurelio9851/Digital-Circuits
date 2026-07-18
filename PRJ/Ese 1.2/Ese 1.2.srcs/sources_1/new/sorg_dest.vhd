----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 21.01.2024 20:12:32
-- Design Name: 
-- Module Name: sorg_dest - Structural
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

entity sorg_dest is
    Port (  sorgenti : in  STD_LOGIC_VECTOR (15 downto 0);
            selezione: in std_logic_vector (5 downto 0);
            destinazioni: out STD_LOGIC_VECTOR (3 downto 0)
           );
end sorg_dest;

architecture Structural of sorg_dest is
    signal u0 : STD_LOGIC := '0';

    component mux_16_1    
            port(   b : in  STD_LOGIC_VECTOR (15 downto 0);
                    s:  in  STD_LOGIC_VECTOR (3 downto 0);
                    y:  out STD_LOGIC
            ); 
        end component;
        
    component demux_1_4
        port (     a : in  STD_LOGIC;
            s:  in  STD_LOGIC_VECTOR (1 downto 0);
            y:  out STD_LOGIC_VECTOR (3 downto 0) 
         );
         end component;        
        
begin
    mux: mux_16_1
            port map(
                b => sorgenti,
                s => selezione (3 downto 0),
                y => u0
            );
     demux: demux_1_4
            port map(
                a => u0,
                s => selezione (5 downto 4),
                y => destinazioni
            );

end Structural;
