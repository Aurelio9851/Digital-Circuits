----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.02.2024 12:48:35
-- Design Name: 
-- Module Name: Top_module - Structural
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

entity Top_module is
Port ( sw0: in std_logic;
           rst,clk: in std_logic;
           sw1: in std_logic;
           b1,b2: in std_logic;
           y: out std_logic 
           );
end Top_module;

architecture Structural of Top_module is
component Riconoscitore
        Port ( d: in std_logic;
               rst, clk,en: in std_logic;
               m: in std_logic;
               y: out std_logic );
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
    signal en: std_logic:='0';
begin

ric: Riconoscitore
        PORT MAP(
            d => d_sync,
            rst => rst,
            clk => clk,
            m => m_sync,
            en=>en,
            y => y
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
            enable=>en
        );       
        
        
end Structural;
