----------------------------------------------------------------------------------
-- Authors: Niels Pirotte
--  
-- Project Name: Masterthesis Niels Pirotte
-- Module Name: pointmult
-- Description: n-bit modular multiplier (through the Montgomery ladder algorithm)
-- Remarks: This module assumes that the multiplier's (m) msb is '1' 
----------------------------------------------------------------------------------

-- include the STD_LOGIC_1164 package in the IEEE library for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the STD_LOGIC_UNSIGNED package for arithmetic operations
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- include the library constants
use work.constants.all;

-- describe the interface of the module
-- pointmultiplication = m.Q
entity pointmult is
    generic(n: integer := log2primeM + 2;
    	    --key parameters yet to be added 
	    s: integer := 8;
            log2s: integer := 3);
    port(   X, Y, Z: 		in  std_logic_vector(n-1 downto 0);
	    m: 			in  std_logic_vector(s-1 downto 0);
            rst, clk:	 	in  std_logic;
            ce:			in  std_logic;
            load:		in  std_logic;
            r:			in  std_logic; --random bit for random order excecution
            resX, resY, resZ: 	out std_logic_vector(n-1 downto 0);
            done: 		out std_logic);
end pointmult;

-- describe the behavior of the module in the architecture
architecture behavioral of pointmult is
    -- declare state
    type my_state is (s_idle, s_init, s_add, s_double, s_shift, s_done);

    -- declare internal signals
    signal m_reg: 			std_logic_vector(s-2 downto 0);
    signal p1_regX, p1_regY, p1_regZ: 	std_logic_vector(n-1 downto 0);
    signal p2_regX, p2_regY, p2_regZ: 	std_logic_vector(n-1 downto 0);
    
    signal a_x, a_y, a_z:		std_logic_vector(n-1 downto 0);
    signal b_x, b_y, b_z:		std_logic_vector(n-1 downto 0);
    signal out_x, out_y, out_z:		std_logic_vector(n-1 downto 0);
    signal shift, m_left: 		std_logic;
    signal sel: 			std_logic_vector(1 downto 0);
    signal write_p1, write_p2: 		std_logic;
    signal pa_done: 			std_logic;
    signal sm_done:			std_logic;
    signal load_ops:			std_logic;
    signal start_point_addition:	std_logic;
    signal cntr, cntr_next: 		std_logic_vector(log2s-1 downto 0);
    
    signal state, nxt_state: 		my_state;
    

    -- declare the point addition component
    component point_addition
        generic(n: integer);
   	port( 	rst, clk:   in  std_logic;
          	load_op1:   in  std_logic;
          	load_op2:   in  std_logic;
          	en:	    in  std_logic;
	  	X1, Y1, Z1: in  std_logic_vector(n-1 downto 0);
	  	X2, Y2, Z2: in  std_logic_vector(n-1 downto 0);
	  	done:	    out std_logic;
	  	X3, Y3, Z3: out std_logic_vector(n-1 downto 0)
	    );
    end component;

    component counter
      generic(q: integer);
      port(   input:  in  std_logic_vector(q-1 downto 0);  
	      output: out std_logic_vector(q-1 downto 0)
          );
   end component;
begin
    
    inst_point_addition: point_addition
        generic map(n => n)
        port map(   rst      => rst,
        	    clk      => clk,
        	    load_op1 => load_ops,
        	    load_op2 => load_ops,
        	    en       => start_point_addition, --needs to be reviewed
        	    X1	     => a_x,
        	    Y1       => a_y,
        	    Z1       => a_z,
        	    X2       => b_x,
        	    Y2       => b_y,
        	    Z2       => b_z,
        	    done     => pa_done,
                    X3       => out_x,
                    Y3	     => out_y,
                    Z3	     => out_z
               );
   ------
   
   --testing
   start_point_addition <= '0' when (state = s_idle) else '1';
   
   RCadder_counter: counter
      generic map(log2s)
      port map(cntr, cntr_next);

   reg_p1: process(rst, clk)
   begin
	if rst = '0' then
	   p1_regX <= (others => '0');
	   p1_regY <= (others => '0');
	   p1_regZ <= (others => '0');
	elsif clk'event and clk = '1' then
	   if load = '1' then
		p1_regX <= X;
		p1_regY <= Y;
		p1_regZ <= Z;
	   elsif (write_p1 = '1') and (pa_done = '1') then
		p1_regX <= out_x;
		p1_regY <= out_y;
		p1_regZ <= out_Z;
	   end if;
	end if;
   end process;

   reg_p2: process(rst, clk)
   begin
	if rst = '0' then
	   p2_regX <= (others => '0');
	   p2_regY <= (others => '0');
	   p2_regZ <= (others => '0');
	elsif clk'event and clk = '1' then
	   if load = '1' then
		p2_regX <= (others => '0');
	   	p2_regY <= (others => '0');
	   	p2_regZ <= (others => '0');
	   elsif (write_p2 = '1') and (pa_done = '1') then
		p2_regX <= out_x;
		p2_regY <= out_y;
		p2_regZ <= out_Z;
	   end if;
	end if;
   end process;

    -- store the inputs 'm', 'Q' and 'p' in the registers 'm_reg', 'Q_reg' and 'p_reg', respectively, if start = '1'
    -- the registers have an asynchronous reset
    -- shift the content of 'm_reg' one position to the left if shift = '1'
    reg_m: process(rst, clk)
    begin
        if rst = '0' then
            m_reg <= (others => '0');
        elsif clk'event and clk = '1' then
            if load = '1' then
                m_reg <= m(s-2 downto 0);
            elsif shift = '1' then
                m_reg <= m_reg(s-3 downto 0) & '0';
            end if;
        end if;
    end process;

    -- create a counter that increments when enable = '1'
    m_counter: process(rst, clk)
    begin
        if rst = '0' then
            cntr <= (others => '0');
        elsif clk'event and clk = '1' then
		if load = '1' then
		    cntr <= (others => '0');
		elsif shift = '1' then
		    cntr <= cntr_next;
		end if;
        end if;
    end process;

    switch_state: process (clk, rst)
    begin
	if rst = '0' then
		state <= s_idle;
	elsif clk'event and clk = '1' then
	   	state <= nxt_state;  
	end if;
    end process;
    
    loading: process (clk, rst)
    begin
	if rst = '0' then
		load_ops <= '0';
	elsif clk'event and clk = '1' then
		if (nxt_state /= state) then
	   	   load_ops <= '1';
	   	else
	   	   load_ops <= '0';
	   	end if;  
	end if;
    end process;


    FSM: process (state, cntr, ce, pa_done)
    begin
	case state is
	   when s_idle =>
	   	if ce = '1' then
		   nxt_state <= s_init;
		else 
		   nxt_state <= state;
		end if;
	   when s_init =>
	   	if pa_done = '1' then
		   nxt_state <= s_add;
		else 
		   nxt_state <= state;
		end if;
	   when s_add =>
		if pa_done = '1' then   
		   nxt_state <= s_double;
		else 
		   nxt_state <= state;
		end if;
	   when s_double =>
	   	if pa_done = '1' then
		   nxt_state <= s_shift;
		else 
		   nxt_state <= state;
		end if;
	   when s_shift =>
		if cntr = s-2 then
			nxt_state <= s_idle;
		else
			nxt_state <= s_add;
		end if;
	   when others => 
	   	nxt_state <= s_add;
       end case;
    end process;

    Output_FSM: process (state, m_left)
    begin
	done <= '0'; write_p1 <= '0'; write_p2 <= '0'; sel <= "00"; shift <= '0'; sm_done <= '0';
	case state is
	   when s_idle =>
	   	sm_done <= '1'; 
	   when s_shift =>
		shift <= '1';
	--We start from the assumption that the msb of m is 1
	   when s_init =>
		sel <= "00";
		write_p2 <= '1';
	   when s_add =>
		sel <= "10";
		if m_left = '1' then
		   write_p1 <= '1';
		else
		   write_p2 <= '1';
		end if;
	   when s_double =>
		if m_left = '1' then
		   write_p2 <= '1';
		   sel <= "11";
		else
		   write_p1 <= '1';
		   sel <= "00";
		end if;
	   when others =>
	end case;
    end process;

    select_input: process (sel, p1_regX, p1_regY, p1_regZ, p2_regX, p2_regY, p2_regZ)
    begin
	case sel is
	   when "00" =>
		--Double p1
		a_x <= p1_regX;
		a_y <= p1_regY;
		a_z <= p1_regZ;
		b_x <= p1_regX;
		b_y <= p1_regY;
		b_z <= p1_regZ;
	   when "11"=>
		--Double p2
		a_x <= p2_regX;
		a_y <= p2_regY;
		a_z <= p2_regZ;
		b_x <= p2_regX;
		b_y <= p2_regY;
		b_z <= p2_regZ;
	   when others =>
	   	-- add p1 and p2
		a_x <= p1_regX;
		a_y <= p1_regY;
		a_z <= p1_regZ;
		b_x <= p2_regX;
		b_y <= p2_regY;
		b_z <= p2_regZ;
	end case;
    end process;
    --done <= sm_done and pa_done;
    done <= '0';
    resX <= p1_regX;
    resY <= p1_regY;
    resZ <= p1_regZ;
    m_left <= m_reg(s-2);
end behavioral;
