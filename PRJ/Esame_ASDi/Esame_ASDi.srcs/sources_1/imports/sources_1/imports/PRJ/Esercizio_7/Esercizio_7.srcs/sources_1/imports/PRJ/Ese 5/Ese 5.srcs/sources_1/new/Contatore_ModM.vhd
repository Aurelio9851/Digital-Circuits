----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.01.2024 21:33:51
-- Design Name: 
-- Module Name: Contatore_ModM - Structural
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

entity Contatore_ModM is
Generic(M: natural range 2 to 256:=8);
    Port (  clk: in std_logic;
            rst: in std_logic:='0';
            en,set: in std_logic:='0';
            data_in: in std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0):=(others=>'0');
            out_p: out std_logic_vector(integer(ceil(log2(real(M))))-1 downto 0);
            out_c: out std_logic
     );
end contatore_modM;




architecture Structural of contatore_modM is
     
   component Flip_FlopT is
        port( T: in std_logic;
        Clock,rst: in std_logic;
        set: in std_logic;
        data_in: in std_logic;
        Q: out std_logic);
    end component;
    
  signal enable_in, out_in:std_logic_vector(data_in'range):=(others=>'0');
  signal rst_in: std_logic:=rst;
  
begin

    MOD2:FOR i in data_in'range GENERATE   
         IF_CLAUSE: if i=0 generate
         cont0: Flip_FlopT 
             port map(
                clock=>clk,
                rst=>rst_in,
                T=>enable_in(0),
                set=>set,
                data_in=>data_in(0),
                Q=>out_in(0)
            );
         
         
         end generate IF_CLAUSE;
        ELSE_CLAUSE: if i/=0 generate
        cont: Flip_FlopT 
            port map(
                clock=>clk,
                rst=>rst_in,
                T=>enable_in(i),
                set=>set,
                data_in=>data_in(i),
                Q=>out_in(i)
            );
        end generate ELSE_CLAUSE;
        END GENERATE MOD2;
    
     out_p<=out_in;
     
     out_c<= '1' when (TO_INTEGER(Unsigned(out_in))=(M-1)) else '0';
     rst_in<='1' when ((TO_INTEGER(Unsigned(out_in))=(M-1)) and en='1') else rst;
         
     enable_in(0)<= en;
    
     enable_in(enable_in'high downto 1)<= enable_in(enable_in'high-1 downto 0) and out_in(out_in'high-1 downto 0);
     


end Structural;



architecture Behavioral of contatore_modM is
signal count: unsigned(data_in'range):=(others=>'0');

begin 
    process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then count<=(others=>'0');
            
            elsif set='1' then count<=Unsigned(data_in); 
            elsif en='1' then 
                    if TO_integer(count)=M-1 then
                        count<=(others=>'0');
                    else count<=count+1;
                    end  if;
            else
            end if;
                
            end if;
     end process;

out_p<=std_logic_vector(count);

process(count)
begin
    if count=M-1 then out_c<='1'; 
    else out_c<='0';end if;
end process;

end Behavioral;