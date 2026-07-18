----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11.02.2024 13:11:26
-- Design Name: 
-- Module Name: Parte_Operativa_B - Structural
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
use IEEE.math_real.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Parte_Operativa_B is
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
end Parte_Operativa_B;

architecture Structural of Parte_Operativa_B is

component Contatore_ModM is
Generic(M: natural range 2 to 256:=8);
    Port (  clk: in std_logic;
            rst: in std_logic:='0';
            en,set: in std_logic:='0';
            data_in: in std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0):=(others=>'0');
            out_p: out std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            out_c: out std_logic
     );
end component;

component MEM is
    Generic(N: natural range 1 to 256:=3;
            M: natural range 1 to 256:=3);
    Port ( clk,rst: in std_logic;
           addr: in std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0);
           write: in std_logic:='0';
           data_in: in std_logic_vector(M-1 downto 0):=(others=>'0');
           read: in std_logic:='0';
           data_out: out std_logic_vector(M-1 downto 0)    
    );
end component;

component Rs232RefComp is
    Port ( 
		TXD 	: out std_logic  	:= '1';
    	RXD 	: in  std_logic;					
    	CLK 	: in  std_logic;					
		DBIN 	: in  std_logic_vector (7 downto 0);
		DBOUT : out std_logic_vector (7 downto 0);	
		RDA	: inout std_logic;						
		TBE	: inout std_logic 	:= '1';				
		RD		: in  std_logic;					
		WR		: in  std_logic;					
		PE		: out std_logic;					
		FE		: out std_logic;					
		OE		: out std_logic;					
		RST		: in  std_logic	:= '0');			
end component;


signal addr: std_logic_vector(integer(ceil(log2(real(N))))-1 downto 0):=(others=>'0');

signal DBOUT: std_logic_vector(M-1 downto 0);
begin

   counter: Contatore_ModM 
   generic map(M=>N)
   port map(
    clk=>clk,
    rst=>rst,
    en=> count,
    out_p=>addr
   );
   
   memoria: MEM
    generic map(N=>N,
                M=>M)
    port map(
        clk=>clk,
        rst=>rst,
        addr=>addr,
        write=>write,
        data_in=>DBOUT
    );
    
   uart: Rs232RefComp
   port map(
    rxd=>rxd,
    clk=>clk,
    DBOUT=>DBOUT,
    DBIN=>(others=>'0'),
    WR=>'0',
    rd=>rd,
    rda=>rda,
    rst=>rst    
   );
   

   


end Structural;
