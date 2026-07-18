----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.01.2024 00:22:42
-- Design Name: 
-- Module Name: Riconoscitore - Behavioral
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

entity Riconoscitore is
    Port ( d: in std_logic;
           rst,clk,en: in std_logic;
           m: in std_logic;
           y: out std_logic
        );
end Riconoscitore;

architecture Behavioral of Riconoscitore is
    type stato is (S0,S1,S2,S3,S4);
    
signal stato_corrente : stato := S0;
signal stato_prossimo : stato;

begin
        process(clk)
        begin
            if(clk'event and clk='1') then
                if(rst='1') then
                    stato_corrente<=S0;
                elsif en='1' then
                    stato_corrente<=stato_prossimo;
                 end if;
           end if;
        end process;
        
        process(stato_corrente,d,m)
        begin     
            Y<='0';      
            case stato_corrente is
                when S0 =>
                    if(d='1') then
                        stato_prossimo<=S1;
                    else
                        if(m='0') then
                        stato_prossimo<=S3;
                        else 
                            stato_prossimo<=S0;
                        end if;
                    end if;
                when S1 => 
                    if(d='1') then
                        if(m='1') then stato_prossimo<=S1;
                        else stato_prossimo<=S4;
                        end if;
                    else stato_prossimo<=S2;
                    end if;
                when S2 =>
                    stato_prossimo<=S0;
                    if(d='1') then Y<='1';
                    end if;   
                when S3 =>                   --1 bit errore
                    stato_prossimo<=S4;  
                when S4 =>                   -- 2 bit errore
                    stato_prossimo<=S0;                                       
            end case;
           
        end process;
      

end Behavioral;
