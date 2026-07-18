----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05.02.2024 13:28:32
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
use IEEE.math_real.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_Module is
    Port (
    CLK:  in std_logic;
    RST:  in std_logic;
    START: in std_logic;
    STOP: out std_logic;
    DATA:  out std_logic_vector(3 downto 0)
     );
end Top_Module;

architecture Structural of Top_Module is

    component Control_Unit is
    Port (
        CLK:  in std_logic;
        RST:  in std_logic;
        RUN: in std_logic;
        STOP_COUNT: in std_logic;
        STOP: out std_logic;
        READ: out std_logic;
        WRITE: out std_logic;
        COUNT: out std_logic
     );
    
    end component;
    
    
     component Parte_Operativa is
         Generic(
                N: natural range 1 to 256:=8;
                M: natural range 1 to 256:=8);
         Port (CLK:   in std_logic;
               RST:   in std_logic;
               START: in std_logic;
               READ:  in std_logic;
               WRITE: in std_logic;
               STOP:  out std_logic;
               DATA:  out std_logic_vector(3 downto 0)
          ); 
    end component;
    
    component ButtonDebouncer is
    generic (                       
        CLK_period: integer := 10; 
        btn_noise_time: integer := 10000000 
    );
    Port ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           BTN : in STD_LOGIC;
           CLEARED_BTN : out STD_LOGIC);
    end component;
    
signal read,write,enable_count,stop_signal : std_logic:='0';
signal start_cln:  std_logic:='0';
begin
    
    
   PO: Parte_Operativa
   port map(
        clk=>clk,
        rst=>rst,
        start=>enable_count,
        read=>read,
        write=>write,
        stop=>stop_signal,
        data=>data
   );
    
   
   PC: Control_Unit 
   port map(
    clk=>clk,
    rst=>rst,
    run=>start_cln,
    stop_count=>stop_signal,
    stop=>stop,
    read=>read,
    write=>write,
    count=>enable_count   
   );
   
   deb: ButtonDebouncer
   port map(
        clk=>clk,
        rst=>rst,
        btn=>start,
        cleared_btn=>start_cln
   );


end Structural;
