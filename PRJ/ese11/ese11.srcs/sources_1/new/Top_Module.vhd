----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.02.2024 11:56:23
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
    Port ( 
            A,B,C,D: in  STD_LOGIC_VECTOR  (1 downto 0);   --nodi
            dest_0:  in  STD_LOGIC_VECTOR (1 downto 0);   --destinazioni A
            dest_1:  in  STD_LOGIC_VECTOR (1 downto 0);   --destinazioni B
            dest_2:  in  STD_LOGIC_VECTOR (1 downto 0);   --destinazioni C
            dest_3:  in  STD_LOGIC_VECTOR (1 downto 0);   --destinazioni D
            en_A,en_B:  in STD_LOGIC;
            en_C,en_D:  in STD_LOGIC;
            y_0,y_1 : out  STD_LOGIC_VECTOR (1 downto 0); --uscite A,B
            y_2,y_3 :  out  STD_LOGIC_VECTOR (1 downto 0)   --uscite C,D
    );
end Top_Module;

architecture Structural of Top_Module is
component Omega_Network is
Generic(N: natural range 1 to 256:=1);
Port ( 
    a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
    a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
    a_2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
    a_3 : in  STD_LOGIC_VECTOR (N-1 downto 0);
    sel_sorg:  in  STD_LOGIC_VECTOR(1 downto 0);
    sel_dest:  in  STD_LOGIC_VECTOR(1 downto 0);
    y_0 : out  STD_LOGIC_VECTOR (N-1 downto 0);
    y_1 : out  STD_LOGIC_VECTOR (N-1 downto 0);
    y_2 : out  STD_LOGIC_VECTOR (N-1 downto 0);
    y_3 : out  STD_LOGIC_VECTOR (N-1 downto 0)
);
end component;

component Macchina_priorita is
    port(   a : in   STD_LOGIC_VECTOR(3 downto 0);
            dest_0:  in  STD_LOGIC_VECTOR (1 downto 0);
            dest_1:  in  STD_LOGIC_VECTOR (1 downto 0);
            dest_2:  in  STD_LOGIC_VECTOR (1 downto 0);
            dest_3:  in  STD_LOGIC_VECTOR (1 downto 0);
            y:  out STD_LOGIC_VECTOR(1 downto 0);
            z:  out STD_LOGIC_VECTOR(1 downto 0)
    );

end component;
signal enable: STD_LOGIC_VECTOR(3 downto 0);
signal sorg,dest: STD_LOGIC_VECTOR(1 downto 0);
begin

enable<=en_A&en_B&en_C&en_D;
priority: Macchina_priorita
    port map(
        a=>enable,
        dest_0=>dest_0,
        dest_1=>dest_1,
        dest_2=>dest_2,
        dest_3=>dest_3,
        y=>sorg,
        z=>dest
    );
    
omega: Omega_Network
    generic map(N=>2)
    port map(
        a_0=>A,
        a_1=>B,
        a_2=>C,
        a_3=>D,
        sel_sorg=>sorg,
        sel_dest=>dest,
        y_0=>y_0,
        y_1=>y_1,
        y_2=>y_2,
        y_3=>y_3
    );

end Structural;
