----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.01.2024 14:29:32
-- Design Name: 
-- Module Name: contatore modulo M - Structural
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity contatore_modM is
Generic(M: natural range 2 to 256:=8);
    Port ( clk,rst: in std_logic;
            en,set: in std_logic;
            data_in: in std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            out_p: out std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            out_c: out std_logic
     );
end contatore_modM;

architecture Structural of contatore_modM is
 signal coll,a: std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
 signal rst_in,en1: std_logic:='0';
    component contatore_mod2 is
    Port ( clk: in std_logic;
           rst,en:in std_logic;
           set: in std_logic;
           data_in: in std_logic;
           out_s: out std_logic
     );
    end component;
begin
  
    MOD2:FOR i in 0 to integer(ceil(log2(real(M))))-1 GENERATE       
            cont: contatore_mod2 
                port map(
                    clk=>clk,
                    rst=>rst,
                    set=>set,
                    data_in=>data_in(i),
                    en=>a(i),
                    out_s=>coll(i)
                );        
    end generate MOD2;
 -- out_p<=coll;
  --rst_in<=rst;
    a(0)<=en;     
    a(1)<=a(0) and coll(0);
  a(2)<=a(1) and coll(1);
 -- a(3)<=a(2) and coll(2);

end Structural;


--architecture Behevoral of contatore_modM is
--    begin
--        process(clk)
--        variable count : std_logic_vector(out_p'range) := (others => '0');
--        begin
--            if rising_edge(clk) then
--                if rst='1' then count:=(others=>'0');
--                elsif load='1' then count:=data_in;
--                elsif en='1' then
--                    if to_integer(unsigned(count)) = M-1  then
--                        out_c<='1';
--                        count:=(others=>'0');
--                    else
--                        count:=std_logic_vector(unsigned(count)+1);
--                    end if;
--                else
--                end if;
--                 out_p<=count;
--            else
           
--            end if;
--        end process;
    
--end Behevoral;