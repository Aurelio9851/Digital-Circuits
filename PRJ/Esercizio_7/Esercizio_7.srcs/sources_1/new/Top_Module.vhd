----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.02.2024 13:16:01
-- Design Name: 
-- Module Name: Top_Module - Structural
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

entity Top_Module is
Generic (N: natural range 1 to 256:=8);
Port (
        CLK: in std_logic;
        RST: in std_logic;
        START: in std_logic;
        STOP: out std_logic;
        X,Y: in std_logic_vector(N-1 downto 0);
        P: out std_logic_vector(2*N-1 downto 0)
         );
end Top_Module;

architecture Structural of Top_Module is

component Unita_Operativa is
Generic(N: natural range 1 to 256:=8);
Port (
    CLK: in std_logic;
    RST: in std_logic;
    SUBTRACT: in std_logic;
    SHIFT: in std_logic;
    COUNT_IN: in std_logic;
    SELECT_LOAD: in std_logic;
    LOAD_AQ,LOAD_M: in std_logic;
    X: in std_logic_vector(N-1 downto 0);
    M: in std_logic_vector(N-1 downto 0);
    COUNT_OUT: out std_logic;
    Q_1: out std_logic;
    RESULT: out std_logic_vector(2*N-1 downto 0)
 );
end component;


component Control_Unit is
    Port ( 
        CLK: in std_logic;
        RST: in std_logic;
        START: in std_logic;
        STATS: in std_logic;
        Q0Q1: in std_logic_vector(1 downto 0);
        SUBTRACT: out std_logic;
        SHIFT: out std_logic;
        SELECTOR: out std_logic;
        STOP: out std_logic;
        COUNT: out std_logic;
        LOAD_AQ,LOAD_M: out std_logic    
    );
end component;

signal subtract,shift,count,selector,load_aq,load_m,stato: std_logic:='0';
signal result: std_logic_vector(P'range);
signal q_1: std_logic:='0';
signal q0q1:std_logic_vector(1 downto 0):=(others=>'0');
begin

U_O: Unita_Operativa
    generic map(N=>N)
    port map(
        clk=>clk,
        rst=>rst,
        subtract=>subtract,
        shift=>shift,
        count_in=>count,
        select_load=>selector,
        q_1=>q_1,
        load_aq=>load_aq,
        load_m=>load_m,
        x=>x,
        m=>y,
        result=>result,
        count_out=>stato        
    );
    
    
C_U: Control_Unit
    port map(
        clk=>clk,
        rst=>rst,
        start=>start,
        stats=>stato,
        q0q1=>q0q1,
        subtract=>subtract,
        stop=>stop,
        shift=>shift,
        count=>count,
        selector=>selector,
        load_aq=>load_aq,
        load_m=>load_m
    );
    
    q0q1<=result(0 downto 0) &q_1;
    P<=result;
end Structural;
