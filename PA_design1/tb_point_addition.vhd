library ieee;
use ieee.std_logic_1164.all;

library work;
use work.constants.all;

entity tb_MMALU is
end tb_MMALU;

architecture tb of tb_MMALU is
    component point_addition
        generic(integer n := log2primeM + 2);
   	port(  rst, clk:   in  std_logic;
               load:       in  std_logic;
               en:	   in  std_logic;
	       X1, Y1, Z1: in  std_logic_vector(n-1 downto 0);
	       X2, Y2:     in  std_logic_vector(n-1 downto 0);
       	       done:	   out std_logic;
	       X3, Y3, Z3: out std_logic_vector(n-1 downto 0));
    end component;

    signal rst      : std_logic;
    signal clk      : std_logic := '0';
    signal load     : std_logic;
    signal en       : std_logic;
    signal X1       : std_logic_vector (log2primeM+1 downto 0);
    signal Y1       : std_logic_vector (log2primeM+1 downto 0);
    signal Z1       : std_logic_vector (log2primeM+1 downto 0);
    signal X2       : std_logic_vector (log2primeM+1 downto 0);
    signal Y2       : std_logic_vector (log2primeM+1 downto 0);
    signal done     : std_logic;
    signal X3       : std_logic_vector (log2primeM+1 downto 0);
    signal Y3       : std_logic_vector (log2primeM+1 downto 0);
    signal Z3       : std_logic_vector (log2primeM+1 downto 0);

    constant clk_period : time := 1000 us; -- EDIT Put right period here
    signal TbSimEnded : std_logic := '0';

begin

    dut : point_addition
    port map (rst  => rst, 
              clk  => clk,
              load => load,
              en   => en,
	      X1   => X1,
	      Y1   => Y1, 
	      Z1   => Z1,
	      X2   => X2, 
	      Y2   => Y2,
       	      done => done,
	      X3   => X3,
	      Y3   => Y3, 
	      Z3   => Y3);

    -- Clock generation
    clk <= not clk after clk_period/2 when TbSimEnded /= '1' else '0';

    stimuli : process
    begin
        -- EDIT Adapt initialization as needed
        rst <= '0';
        load <= '0';

	en <= '0';
        cmd <= '0';
        sub <= '0';
        
	-- General test
	-- Testing with the 3 bit prime 7 --> "111"
	-- Therefore we have a 5 bit datapath
	
	-- Generating test data with magma:
	 
	X1 <= "00101";
        Y1 <= "00110";
        Z1 <= "00000";
        X2 <= "00000";
        Y2 <= "00000";

        wait for 10 * clk_period;
        
        -- Starting test process
        	rst <= '1';
		load <= '1';
		wait for clk_period;
		load <= '0';
		wait for clk_period*10;
		en <= '1';
		
        -- Wait until test is finished

	wait on done;
	
	-- End of simulation

    end process;

end tb;
