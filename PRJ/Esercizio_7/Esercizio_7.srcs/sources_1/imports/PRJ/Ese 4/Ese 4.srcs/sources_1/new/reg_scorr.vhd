----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 24.01.2024 18:48:40
-- Design Name: 
-- Module Name: reg_scorr - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_scorr is
    Generic(N: natural range 4 to 256:=4);
    Port ( input: in std_logic_vector(1 downto 0):=(others=>'0');
           mode: in std_logic:='0';
           n_bit: in std_logic:='0';
           load: in std_logic:='0';
           in_parallelo: in std_logic_vector(N-1 downto 0):=(others=>'0');
           out_seriale: out std_logic;
           out_parallelo: out std_logic_vector(N-1 downto 0);
           rst,clk: in std_logic;
           en: in std_logic
    );
end reg_scorr;

architecture Behavioral of reg_scorr is
signal mem: std_logic_vector(N-1 downto 0):=(others=>'0');
signal out_temp: std_logic:='0';
begin

shift_reg_process: process(clk)
    begin
        if rising_edge(clk) then
            if rst='1' then
                mem<=(others=>'0');
            elsif load='1' then
                    mem<=in_parallelo;    
            elsif en='1' then               
                if mode='0' then  --shift right
                    if n_bit='0' then --shift right 1 bit
                        mem<=mem(mem'high-1 downto mem'low) & input(input'low);
                    elsif n_bit='1' then --shift right 2 bit
                        mem<=mem(mem'high-2 downto mem'low) & input;    
                    else 
                    end if;
                elsif mode ='1' then   --shift left
                    if n_bit='0' then   -- shift left 1 bit
                        mem <= input(input'low) & mem(mem'high downto mem'low+1);
                    elsif n_bit='1' then  -- shift left 2 bit
                        mem <= input & mem(mem'high downto mem'low+2);
                    else 
                    end if;  
                end if;
            else
            end if;
       end if;
end process;
out_parallelo<=mem;
out_seriale<=mem(N-1) when mode='0' else
             mem(0)   when mode='1' else
             '-';           
end Behavioral;


architecture Structural_v1 of reg_scorr is
component flip_flop is
    Port ( D: in std_logic;
           clk,rst,en: in std_logic;
           Q: out std_logic );    
end component;

component mux_4_1 is
    port(   a : in  STD_LOGIC_VECTOR (3 downto 0);
            s:  in  STD_LOGIC_VECTOR (1 downto 0);
            y:  out STD_LOGIC
    );
end component;

component mux_2_1_generic is
Generic(N: natural range 1 to 256:=1);
    port(   a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            s:  in  std_logic;
            y:  out STD_LOGIC_VECTOR (N-1 downto 0)
    );

end component;

signal mux: std_logic_vector(N-1 downto 0):=(others=>'0'); --uscita di ogni mux
signal ff_out: std_logic_vector(N-1 downto 0):=(others=>'0'); --uscita del flip_flop
signal ff_in: std_logic_vector(N-1 downto 0):=(others=>'0'); --ingresso del flip flop 
signal selector: std_logic_vector(1 downto 0):=mode&n_bit; --bit di selezione dei mux
signal enable_in: std_logic:='0'; --load 
    begin
    
    FA_0_to_N_1: for i in 0 to N-1 generate
	
	    IF_CLAUSE_1: if i=0 generate
	    
	        MUX4_0: mux_4_1 port map(
	           a(1 downto 0)=>input,
	           a(2)=>ff_out(i+1),
	           a(3)=>ff_out(i+2),           
	           s=>selector,
	           y=>mux(0)
	        );
	    
            F_F0: flip_flop port map(
                D=>ff_in(0),
                clk=>clk,
                rst=>rst,
                en=>enable_in,
                Q=>ff_out(0)
            );
            
            MUX2_0: mux_2_1_generic 
               generic map(N=>1)
               port map(
	           a_0=>mux(i downto i),
	           a_1=>in_parallelo(i downto i),           
	           s=>load,
	           y=>ff_in(i downto i)
	        );
            

     	end generate IF_CLAUSE_1;
     	
     	IF_CLAUSE_2: if i=1 generate
	    
	        MUX4_1: mux_4_1 port map(
	           a(0)=>ff_out(0),
	           a(1)=> input(0),
	           a(2)=>ff_out(i+1),
	           a(3)=>ff_out(i+2),
	           s=>selector,
	           y=>mux(1)
	        );
	    
            F_F1: flip_flop port map(
                D=>ff_in(1),
                clk=>clk,
                rst=>rst,
                en=>enable_in,
                Q=>ff_out(1)
            );
            
            MUX2_1: mux_2_1_generic 
               generic map(N=>1)
               port map(
	           a_0=>mux(i downto i),
	           a_1=>in_parallelo(i downto i),           
	           s=>load,
	           y=>ff_in(i downto i)
	        );

     	end generate IF_CLAUSE_2;
     	
     	IF_CLAUSE_N1: if i= N-2 generate 
	    
	 		MUX4_N1: mux_4_1 port map(
	           a(0)=>ff_out(i-1),
	           a(1)=>ff_out(i-2),
	           a(2)=>ff_out(i+1),
	           a(3)=>input(0),
	           s=>selector,
	           y=>mux(N-2)
	        );
	    
            F_FN1: flip_flop port map(
                D=>ff_in(N-2),
                clk=>clk,
                rst=>rst,
                en=>enable_in,
                Q=>ff_out(N-2)
            );
            
            MUX2_N1: mux_2_1_generic 
               generic map(N=>1)
               port map(
	           a_0=>mux(i downto i),
	           a_1=>in_parallelo(i downto i),           
	           s=>load,
	           y=>ff_in(i downto i)
	        );

	    end generate IF_CLAUSE_N1;
        
        IF_CLAUSE_N: if i= N-1 generate 
	    
	 		MUX4_N: mux_4_1 port map(
	           a(0)=>ff_out(i-1),
	           a(1)=>ff_out(i-2),
	           a(2)=>input(0),
	           a(3)=>input(1),
	           s=>selector,
	           y=>mux(N-1)
	        );
	    
            F_FN: flip_flop port map(
                D=>ff_in(N-1),
                clk=>clk,
                rst=>rst,
                en=>enable_in,
                Q=>ff_out(N-1)
            );
            
            MUX2_N: mux_2_1_generic 
               generic map(N=>1)
               port map(
	           a_0=>mux(i downto i),
	           a_1=>in_parallelo(i downto i),           
	           s=>load,
	           y=>ff_in(i downto i)
	        );
     	
	    end generate IF_CLAUSE_N;
	    
	    
	    ELSE_CLAUSE: if i/= 0 and i/=1 and i/=N-2 and i/=N-1 generate --non uso ELSIF perchè è supportato in VHDL2008 
     	                               --che non è la versione di default usata in vivado
	    
	 	MUX_i: mux_4_1 port map(
	           a(0)=>ff_out(i-1),
	           a(1)=>ff_out(i-2),
	           a(2)=>ff_out(i+1),
	           a(3)=>ff_out(i+2),
	           s=>selector,
	           y=>mux(i)
	        );
	    
            F_F_i: flip_flop port map(
                D=>ff_in(i),
                clk=>clk,
                rst=>rst,
                en=>enable_in,
                Q=>ff_out(i)
            );
            
            MUX2_i: mux_2_1_generic 
               generic map(N=>1)
               port map(
	           a_0=>mux(i downto i),
	           a_1=>in_parallelo(i downto i),           
	           s=>load,
	           y=>ff_in(i downto i)
	        );

	     end generate ELSE_CLAUSE;
     end generate FA_0_to_N_1;
 
    MUX_SERIALE: mux_2_1_generic 
               generic map(N=>1)
               port map(
	           a_0=>ff_out(N-1 downto N-1),
	           a_1=>ff_out(0 downto 0),           
	           s=>mode,
	           y(0)=>out_seriale
	           );
	           
    enable_in<=load or en;
    selector<=mode&n_bit;
    out_parallelo<=ff_out;
end Structural_v1;



architecture Structural_v2 of reg_scorr is
component flip_flop is
    Port ( D: in std_logic;
           clk,rst,en: in std_logic;
           Q: out std_logic );    
end component;

component mux_2_1_generic is
Generic(N: natural range 1 to 256:=1);
    port(   a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            s:  in  std_logic;
            y:  out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end component;

component mux_4_1_generic is
    Generic(N: natural range 1 to 256:=1);
    port(   a_0 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            a_1 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            a_2 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            a_3 : in  STD_LOGIC_VECTOR (N-1 downto 0);
            s:  in  STD_LOGIC_VECTOR (1 downto 0);
            y:  out STD_LOGIC_VECTOR (N-1 downto 0)
    );
end component;
signal ff_in, shift: std_logic_vector(N-1 downto 0):=(others=>'0');
signal ff_out: std_logic_vector(N-1 downto 0):=(others=>'0');
signal r_1: std_logic_vector(N-1 downto 0):=(others=>'0');
signal r_2: std_logic_vector(N-1 downto 0):=(others=>'0');
signal l_1: std_logic_vector(N-1 downto 0):=(others=>'0');
signal l_2: std_logic_vector(N-1 downto 0):=(others=>'0');
signal selector: std_logic_vector(1 downto 0):=mode&n_bit;
signal enable_in: std_logic:='0';
begin

    FA_0_to_N_1: for i in 0 to N-1 generate
        F_FN: flip_flop port map(
                    D=>ff_in(i),
                    clk=>clk,
                    rst=>rst,
                    en=>enable_in,
                    Q=>ff_out(i)
                );
    end generate FA_0_to_N_1;
    
    MUX_SERIALE: mux_2_1_generic 
               generic map(N=>1)
               port map(
	           a_0=>ff_out(N-1 downto N-1),
	           a_1=>ff_out(0 downto 0),           
	           s=>mode,
	           y(0)=>out_seriale
	           );
	           
    MUXO: mux_4_1_generic generic map( N=> N)
        port map(
            a_0=>r_1,
            a_1=>r_2,
            a_2=>l_1,
            a_3=>l_2,
            s=>selector,
            y=>shift
        );
    MUX_LOAD: mux_2_1_generic 
               generic map(N=>N)
               port map(
	           a_0=>shift,
	           a_1=>in_parallelo,           
	           s=>load,
	           y=>ff_in
	           );

enable_in<=load or en;
r_1<=ff_out(N-2 downto 0)&input(0);
r_2<=ff_out(N-3 downto 0)&input;
l_1<=input(0)&ff_out(N-1 downto 1);
l_2<=input&ff_out(N-1 downto 2);
selector<=mode&n_bit;
out_parallelo<=ff_out;

end Structural_v2;