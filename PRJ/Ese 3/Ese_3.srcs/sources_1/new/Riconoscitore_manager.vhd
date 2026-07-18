----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.01.2024 12:32:19
-- Design Name: 
-- Module Name: Riconoscitore_manager - Behavioral
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

entity Riconoscitore_manager is
    Port ( sw0: in std_logic;
           rst,clk: in std_logic;
           sw1: in std_logic;
           BTNC,BTNU: std_logic;
           y: out std_logic );
end Riconoscitore_manager;

----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.01.2024 12:32:19
-- Design Name: 
-- Module Name: Riconoscitore_manager - Behavioral
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

entity Riconoscitore_manager is
    Port ( sw0: in std_logic;
           rst,clk: in std_logic;
           sw1: in std_logic;
           BTNC,BTNU: std_logic;
           y: out std_logic 
           );
end Riconoscitore_manager;

architecture Behavioral of Riconoscitore_manager is
    component Riconoscitore
        Port ( d: in std_logic;
               rst, clk,en: in std_logic;
               m: in std_logic;
               y: out std_logic );
    end component;
    
    component ButtonDebouncer
        Port ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           BTN : in STD_LOGIC;
           CLEARED_BTN : out STD_LOGIC);
    end component;
    
    component flip_flop is
    Port ( D: in std_logic;
           clk,rst,en: in std_logic;
           Q: out std_logic );
    end component;
    
    
    component Rete_Controllo is
    Port (
         clk: in std_logic;
         rst: in std_logic;
         b1,b2: in std_logic;
         sw0,sw1: in std_logic;
         d,m,enable: out std_logic         
         );
    end component;
    
    signal d_sync, m_sync: std_logic := '0';
    signal b1, b2: std_logic := '0';
    signal enable,led: std_logic:='0';
    
begin

    ric: Riconoscitore
        PORT MAP(
            d => d_sync,
            rst => rst,
            clk => clk,
            m => m_sync,
            en=>enable,
            y => led
        );
    debd: ButtonDebouncer
        PORT MAP(
            rst => rst,
            clk => clk,
            btn=>BTNC,
            CLEARED_BTN=>b1
        );
    
    debu: ButtonDebouncer
        PORT MAP(
            rst => rst,
            clk => clk,
            btn=>BTNU,
            CLEARED_BTN=> b2
        );
    
    cu: Rete_Controllo
        port map(
            clk=>clk,
            rst=>rst,
            b1=>b1,
            b2=>b2,
            sw0=>sw0,
            sw1=>sw1,
            d=>d_sync,
            m=>m_sync,
            enable=>enable
        );
        
    led_ff: flip_flop
        port map(
            clk=>clk,
            rst=>rst,
            en=>enable,
            d=>led,
            q=>y
        );
   
end Behavioral;

