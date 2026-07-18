----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2024 14:14:13
-- Design Name: 
-- Module Name: Control_Unit_B - Behavioral
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

entity Control_Unit_B is
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        STOP_COUNT: in std_logic;
        PRONTO: in std_logic;
        PRELEVATO: out std_logic;
        STOP: out std_logic;
        READ: out std_logic;
        WRITE: out std_logic;
        COUNT: out std_logic
    );
end Control_Unit_B;

--architecture Behavioral_Mealy of Control_Unit_B is

--type stato is (IDLE,RICEVI,SUM,RICEVUTO);

--signal stato_corrente : stato := IDLE;
--signal stato_prossimo : stato;

--signal count_tmp,prelevato_tmp,read_tmp,write_tmp,stop_tmp: std_logic:='0';

--begin

--    process(clk)
--    begin
--        if rising_edge(clk) then
--            if rst = '1' then
--                stato_corrente <= IDLE;               
--            else
--                stato_corrente <= stato_prossimo;  
--                count<=count_tmp;
--                write<=write_tmp;
--                read<=read_tmp;
--                stop<=stop_tmp;
--                prelevato<=prelevato_tmp;
--            end if;
--        end if;
--    end process;
    
--cu_process:   process(stato_corrente,stop_count,pronto)
--        begin
--        count_tmp<='0';
--        write_tmp<='0';
--        read_tmp<='0';
--        stop_tmp<='0';
--        prelevato_tmp<='0';
--    case stato_corrente is
--        when IDLE=>
--            if pronto='1' then
--                stato_prossimo<=RICEVI;
--                read_tmp<='1';
--            else
--                stato_prossimo<=IDLE;       
--            end if;
--        WHEN RICEVI=>
--            read_tmp<='1';
--            stato_prossimo<=SUM;
--        WHEN SUM=>
--            write_tmp<='1';
--            prelevato_tmp<='1';
--            stato_prossimo<=RICEVUTO;
--        WHEN RICEVUTO=>
--            if pronto='1' then
--                prelevato_tmp<='1';
--                stato_prossimo<=RICEVUTO;
--            else
--                stato_prossimo<=IDLE;
--                count_tmp<='1';
--                if stop_count='1' then
--                   stop_tmp<='1';
--                else
--                end if;
--            end if;
--    end case;
--   end process;

--end Behavioral_Mealy;

architecture Behavioral_Moore of Control_Unit_B is
type stato is (IDLE,RICEVI,SUM,RICEVUTO,COUNT_INC,FINISH);

signal stato_corrente : stato := IDLE;
signal stato_prossimo : stato;


begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stato_corrente <= IDLE;               
            else
                stato_corrente <= stato_prossimo;
            end if;
        end if;
    end process;
    
cu_process:   process(stato_corrente,stop_count,pronto)
        begin
    read<='0';
    count<='0';
    stop<='0';
    prelevato<='0';
    write<='0';
    case stato_corrente is
        when IDLE=>
                if pronto='1' then
                    stato_prossimo<=RICEVI;
                else
                    stato_prossimo<=IDLE;       
                end if;
            
        when RICEVI=>
            prelevato<='1'; --questo fa da ack
            read<='1';
            stato_prossimo<=SUM;
            
        when SUM=>
            prelevato<='1';
            write<='1';
            stato_prossimo<=RICEVUTO;
        when RICEVUTO=>
            prelevato<='1';
            if pronto='1' then        
                stato_prossimo<=RICEVUTO;
            else        --abbasso prelevato -> mando il segnale DONE
                if stop_count='1' then
                   stato_prossimo<=FINISH;
                else  stato_prossimo<=COUNT_INC;
                end if;
            end if;
       when COUNT_INC=>
                count<='1';
                stato_prossimo<=IDLE;
       when FINISH=>
                count<='1';
                stato_prossimo<=IDLE;
                stop<='1';
    end case;
   end process;

end Behavioral_Moore;



