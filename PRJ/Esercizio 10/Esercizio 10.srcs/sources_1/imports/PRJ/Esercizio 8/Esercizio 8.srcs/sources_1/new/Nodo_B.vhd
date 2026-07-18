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
        RXD: in std_logic
     );
end Nodo_B;

architecture Structural of Nodo_B is

component Control_Unit_B is
Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        RDA: in std_logic;
        RD: out std_logic;
        WRITE: out std_logic;
        COUNT: out std_logic
    );
end component;


component Parte_Operativa_B is
generic (N: natural:=3;
         M: natural range 1 to 256:=8);
Port ( clk: in std_logic;
        rst: in std_logic; 
        RXD: in std_logic;
        RD: in std_logic;
        write: in std_logic;
        count: in std_logic;
        RDA: inout std_logic        
        );
end component;
signal rd,write,count: std_logic:='0';
signal rda: std_logic:='0';

begin

cu: Control_Unit_B
    port map(
        clk=>clk,
        rst=>rst,
        write=>write,
        count=>count,
        rd=>rd,
        rda=>rda
    );
    
po: Parte_Operativa_B
    generic map(N=>N,
                M=>M)
    port map(
        clk=>clk,
        rst=>rst,
        rxd=>rxd,
        rd=>rd,
        write=>write,
        count=>count,
        rda=>rda   
    );

end Structural;
