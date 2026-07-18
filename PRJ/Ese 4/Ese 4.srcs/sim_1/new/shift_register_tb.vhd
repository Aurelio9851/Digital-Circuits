library ieee;
use ieee.std_logic_1164.all;

entity shift_register_tb is
end shift_register_tb;

architecture tb of shift_register_tb is

    signal clk_tb : std_logic;
    signal input  : std_logic_vector(1 downto 0) :=(others=>'0');
    signal in_paralleloB:  std_logic_vector(4 downto 0):=(others=>'0');
    signal in_paralleloS1:  std_logic_vector(3 downto 0):=(others=>'0');
    signal in_paralleloS2:  std_logic_vector(5 downto 0):=(others=>'0');    
    signal n_bit  : std_logic:='0';
    signal load  : std_logic;
    signal outB,outS1,outS2: std_logic;
    signal rst : std_logic;
    signal en,mode : std_logic;

    constant clk_period : time := 20 ns; 
    
    procedure generate_input_sequence(signal input_signal: out std_logic_vector(1 downto 0);
                                      signal en_signal: out std_logic) is
        begin
            en_signal <='1';
            input_signal <= "01";
            wait for clk_period;
            en_signal <= '0';
            wait for clk_period;
            
            input_signal <= "01";
            wait for clk_period;
            en_signal <= '1';
            wait for clk_period;
            
            input_signal <= "01";
            wait for clk_period;
            en_signal <= '0';
            wait for clk_period;
            
            input_signal <= "01";
            wait for clk_period;
            en_signal <= '1';
            wait for clk_period;
            
            en_signal <= '0';
        end procedure;
begin
    -- Clock generation
   clk_process : process
   begin
		clk_tb <= '0';
		wait for clk_period/2;
		clk_tb <= '1';
		wait for clk_period/2;
   end process;
   
   
   
    Beh : entity work.reg_scorr (Behavioral)
    generic map(N=>5)
    port map (CLK => clk_tb,
              RST => rst,
              input  => input,
              out_seriale  => outB,
              mode=> mode,
              in_parallelo=>in_paralleloB,
              n_bit=>n_bit,
              en=>en,
              load=>load
              );
              
    ST1 : entity work.reg_scorr (Structural_v1)
    port map (CLK => clk_tb,
              RST => rst,
              input  => input,
              out_seriale  => outS1,
              mode=> mode,
              in_parallelo=>in_paralleloS1,
              n_bit=>n_bit,
              en=>en,
              load=>load
              );       
    
    ST2 : entity work.reg_scorr (Structural_v2)
    generic map(N=>6)
    port map (CLK => clk_tb,
              RST => rst,
              input  => input,
              out_seriale  => outS2,
              mode=> mode,
              in_parallelo=>in_paralleloS2,
              n_bit=>n_bit,
              en=>en,
              load=>load
              );
              
    stimuli : process
    begin
        
        rst <= '1';
        wait for 100ns;  --global reset
        rst <='0';
        
       --right shift di 1

        n_bit<='0';
        mode<='0';
        load<='0';
        generate_input_sequence(input,en);
        
        rst <='1';
        wait for 20ns;
        rst <='0';
         
        --right shift di 2
        n_bit<='1';
        generate_input_sequence(input,en);
        
        rst <='1';
        wait for 20ns;
        rst <='0';
       --left shift di 1
        
        n_bit<='0';
        mode<='1';
        load<='0';
        generate_input_sequence(input,en);
        
        rst <='1';
        wait for 20ns;
        rst <='0';
        
        --left shift di 2
        n_bit<='1';
        generate_input_sequence(input,en);
        
        
        --load
         
         wait for 30ns;
         rst <= '0';
         in_paralleloB<="01011";
         in_paralleloS1<="1011";
         in_paralleloS2<="001011";
         wait for 100ns;
         en<='1';
         load<='1';
         wait for clk_period;
         en<='0';
         load<='0';
         rst <='1';
        wait for 20ms;
       
        
       
        wait;
    end process;

end tb;
