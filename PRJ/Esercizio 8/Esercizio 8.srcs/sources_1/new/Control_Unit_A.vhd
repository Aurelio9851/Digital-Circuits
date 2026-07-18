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

entity Control_Unit_A is
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        RUN: in std_logic;
        STOP_COUNT: in std_logic;
        PRELEVATO: in std_logic;
        STOP: out std_logic;
        READ: out std_logic;
        PRONTO: out std_logic;
        COUNT: out std_logic
     );
end Control_Unit_A;

architecture Behavioral_Mealy of Control_Unit_A is
type stato is (IDLE,READING,WAITING_1,WAITING_0);

signal stato_corrente : stato := IDLE;
signal stato_prossimo : stato;
signal count_tmp,pronto_tmp,read_tmp,stop_tmp: std_logic:='0';

begin

    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then
                stato_corrente <= IDLE;               
            else
                stato_corrente <= stato_prossimo;
                count<=  count_tmp;
                pronto<=pronto_tmp;
                read<=read_tmp;
                stop<=stop_tmp;
            end if;
        end if;
    end process;
    
cu_process:   process(stato_corrente,run,stop_count,prelevato)
        begin
        count_tmp<='0';
        pronto_tmp<='0';
        read_tmp<='0';
        stop_tmp<='0';
    case stato_corrente is
        when IDLE=>
                if run='1' then
                    stato_prossimo<=READING;
                    read_tmp<='1';
                else
                    stato_prossimo<=IDLE;       
                end if;
            
        when READING=>
            stato_prossimo<=WAITING_1;
            pronto_tmp<='1';
            
        when WAITING_1=>
            if prelevato='0' then
                stato_prossimo<=WAITING_1;
                pronto_tmp<='1';
            else
                stato_prossimo<=WAITING_0;

            end if;
        when WAITING_0=>
            if prelevato='1' then
                stato_prossimo<=WAITING_0;
            else
                count_tmp<='1';
                stato_prossimo<=IDLE;
                if stop_count='1' then
                   stop_tmp<='1';
                else
                end if;
            end if;
    end case;
   end process;

end Behavioral_Mealy;

architecture Behavioral_Moore of Control_Unit_A is
type stato is (IDLE,READING,WAITING_1,WAITING_0,COUNT_INC,FINISH);

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
    
cu_process:   process(stato_corrente,run,stop_count,prelevato)
        begin
    read<='0';
    pronto<='0';
    count<='0';
    stop<='0';
    case stato_corrente is
        when IDLE=>
                if run='1' then
                    stato_prossimo<=READING;
                else
                    stato_prossimo<=IDLE;       
                end if;
            
        when READING=>
            read<='1';
            stato_prossimo<=WAITING_1;
            
        when WAITING_1=>
            pronto<='1';    --req to send
            if prelevato='0' then
                stato_prossimo<=WAITING_1;
            else
                stato_prossimo<=WAITING_0;

            end if;
        when WAITING_0=>
            if prelevato='1' then
                stato_prossimo<=WAITING_0;
            else
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




