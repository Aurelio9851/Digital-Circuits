----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2024 12:14:09
-- Design Name: 
-- Module Name: Nodo_B - Structural
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

entity Nodo_B is
generic (N: natural:=3;
         M: natural range 1 to 256:=8);
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        PRONTO: in std_logic;
        DATO: in std_logic_vector(M-1 downto 0);
        PRELEVATO: out std_logic;
        STOP: out std_logic
     );
end Nodo_B;

architecture Structural of Nodo_B is

component Control_Unit_B is
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
end component;


component Parte_Operativa_B is
generic (N: natural:=3;
         M: natural range 1 to 256:=8);
Port (  clk: in std_logic;
        rst: in std_logic; 
        read: in std_logic;
        write: in std_logic;
        count: in std_logic;
        dato:  in std_logic_vector(M-1 downto 0);
        stato: out std_logic        
        );
end component;
signal read,write,count: std_logic:='0';
signal stats: std_logic:='0';

begin

cu: Control_Unit_B
    port map(
        clk=>clk,
        rst=>rst,
        stop_count=>stats,
        prelevato=>prelevato,
        stop=>stop,
        read=>read,
        write=>write,
        count=>count,
        pronto=>pronto    
    );
    
po: Parte_Operativa_B
    generic map(N=>N,
                M=>M)
    port map(
        clk=>clk,
        rst=>rst,
        read=>read,
        write=>write,
        count=>count,
        stato=>stats,
        dato=>dato    
    );

end Structural;
