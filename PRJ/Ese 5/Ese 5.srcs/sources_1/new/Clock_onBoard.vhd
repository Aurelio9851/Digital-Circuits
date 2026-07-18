----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02.02.2024 18:44:20
-- Design Name: 
-- Module Name: Clock_onBoard - Structural
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

entity Clock_onBoard is
 Generic(N: natural range 2 to 256:=3);
 Port ( clk,rst,set: in std_logic;
           start: in std_logic;
           view: in std_logic;
           laps: in std_logic;
           value_in: in std_logic_vector(15 downto 0);
           
           
           anodes_out : out  STD_LOGIC_VECTOR (7 downto 0); --anodi e catodi delle cifre, sono un output del topmodule
		   cathodes_out : out  STD_LOGIC_VECTOR (7 downto 0)         
    );
end Clock_onBoard;

architecture Structural of Clock_onBoard is 
   
    component Control_Unit is
        Port ( clk,rst,set_in,start: in std_logic;
               view_in: in std_logic;
               laps: in std_logic;
               count_in: in std_logic;
               toggle,set_out,write_en,view_out,read_en: out std_logic ;    
               mux: out std_logic_vector(1 downto 0)        
    );
    end component;
    
    
    component Unita_Operativa is
    Generic(N: natural range 2 to 256:=3);
    Port ( clk,rst,set: in std_logic;
           start: in std_logic;
           value_in: in std_logic_vector(15 downto 0);
           mux_in: in std_logic_vector(1 downto 0);
           view: in std_logic;
           read: in std_logic;
           mem_en: in std_logic;
           cont_sts: out std_logic;   --contatore celle memoria visualizzazione
           anodes_out : out  STD_LOGIC_VECTOR (7 downto 0); --anodi e catodi delle cifre, sono un output del topmodule
		   cathodes_out : out  STD_LOGIC_VECTOR (7 downto 0)         
    );
    end component;
    
    COMPONENT ButtonDebouncer 
    GENERIC (                       
        CLK_period: integer := 10;  
        btn_noise_time: integer := 10000000                                                           
    );
    PORT ( RST : in STD_LOGIC;
           CLK : in STD_LOGIC;
           BTN : in STD_LOGIC;
           CLEARED_BTN : out STD_LOGIC);
    END COMPONENT;
    
       
signal start_clock,set_clock,mem_en,ff_en,view_en,cont_sts,read: std_logic:='0';
signal mux_in: std_logic_vector(1 downto 0):=(others=>'0');
signal start_cln,view_cln,set_cln,laps_cln: std_logic:='0';

begin

    cu: Control_Unit PORT MAP(
        clk=>clk,
        RST => rst,
        set_in=>set_cln,
        start=>start_cln,
        view_in=>view_cln,
        count_in=>cont_sts, --count qui
        laps=>laps_cln,
        view_out=>view_en,
        read_en=>read,
        toggle=>ff_en,
        set_out=>set_clock,
        write_en=>mem_en,
        mux=>mux_in                
    );
    
    po: Unita_Operativa PORT MAP(
        clk=>clk,
        rst=>rst,
        set=>set_clock,
        start=>ff_en,
        value_in=>value_in,
        mux_in=>mux_in,
        view=>view_en,
        read=>read,
        mem_en=>mem_en,
        cont_sts=>cont_sts,
        anodes_out=>anodes_out,
        cathodes_out=>cathodes_out
    );


    set_btn: ButtonDebouncer GENERIC MAP( 
        CLK_period => 10, 
        btn_noise_time => 10000000 
                                    
        )
        PORT MAP ( RST => rst,
                   CLK => clk, 
                   BTN => set,
                   CLEARED_BTN => set_cln
        );
        
    start_btn: ButtonDebouncer GENERIC MAP( 
        CLK_period => 10,  
        btn_noise_time => 10000000                                   
        )
        PORT MAP ( RST => rst,
                   CLK => clk, 
                   BTN => start,
                   CLEARED_BTN => start_cln
        );
        
     view_btn: ButtonDebouncer GENERIC MAP( 
        CLK_period => 10,  
        btn_noise_time => 10000000 
        )
        PORT MAP ( RST => rst,
                   CLK => clk, 
                   BTN => view,
                   CLEARED_BTN => view_cln
        );

    laps_btn: ButtonDebouncer GENERIC MAP( 
        CLK_period => 10, 
        btn_noise_time => 10000000 )
        PORT MAP ( RST => rst,
                   CLK => clk, 
                   BTN => laps,
                   CLEARED_BTN => laps_cln
        );
        
        
        
end Structural;
