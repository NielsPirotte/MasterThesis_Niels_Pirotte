----------------------------------------------------------------------------------
-- Authors: Niels Pirotte
--  
-- Project Name: Masterthesis Niels Pirotte
-- Module Name: modmultn
-- Description: n-bit modular multiplier (through the Montgomery ladder algorithm)
-- Remarks: This module assumes that the multiplier's (m) msb is '1' 
----------------------------------------------------------------------------------

-- include the STD_LOGIC_1164 package in the IEEE library for basic functionality
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- include the STD_LOGIC_UNSIGNED package for arithmetic operations
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- describe the interface of the module
-- pointmultiplication = m.Q
entity pointmult is
    generic(n: integer := 8;
	    s: integer := 8;
            log2s: integer := 3);
    port(   Q, p: in std_logic_vector(n-1 downto 0);
	    m: in std_logic_vector(s-1 downto 0);
            rst, clk, start: in std_logic;
            product: out std_logic_vector(n-1 downto 0);
            done: out std_logic);
end pointmult;

-- describe the behavior of the module in the architecture
architecture behavioral of pointmult is
    -- declare state
    type my_state is (s_idle, s_init, s_add, s_double, s_shift, s_done);

    -- declare internal signals
    signal Q_reg, p_reg: std_logic_vector(n-1 downto 0);
    signal m_reg: std_logic_vector(s-2 downto 0);
    signal p1_reg, p2_reg: std_logic_vector(n-1 downto 0);
    signal a, b, pa_out: std_logic_vector(n-1 downto 0);
    signal shift, m_left: std_logic;
    signal sel: std_logic_vector(1 downto 0);
    signal write_p1, write_p2: std_logic;
    signal pa_done: std_logic;

    signal state: my_state;
    signal cntr, cntr_next: std_logic_vector(log2s-1 downto 0);

    -- declare the modaddsubn component
    -- replace with point addition component(in: P1, P2, p; out: done, product) 
    component modaddsubn
        generic(n: integer := 8);
        port(   a, b, p: in std_logic_vector(n-1 downto 0);
                as: in std_logic;
                sum: out std_logic_vector(n-1 downto 0));
    end component;

    component RCadder
	generic(q: integer);
	port(   a:       in  std_logic_vector(q downto 0);
		b:       in  std_logic_vector(q downto 0);
		output:  out std_logic_vector(q downto 0)
            );
    end component;
begin
    --Testing
    pa_done <= '1';
    
    inst_modaddsubn: modaddsubn
        generic map(n => n)
        port map(   a => a,
                    b => b,
                    p => p_reg, 
                    as => '0',
                    sum => pa_out);
   ------
   inst_cntr: RCadder
	generic map(q=>log2s-1)
	port map(   cntr, (0=> '1', others => '0'), cntr_next);

   reg_p1: process(rst, clk)
   begin
	if rst = '1' then
	   p1_reg <= (others => '0');
	elsif clk'event and clk = '1' then
	   if start = '1' then
		p1_reg <= Q;
	   elsif (write_p1 = '1') and (pa_done = '1') then
		p1_reg <= pa_out;
	   end if;
	end if;
   end process;

   reg_p2: process(rst, clk)
   begin
	if rst = '1' then
	   p2_reg <= (others => '0');
	elsif clk'event and clk = '1' then
	   if start = '1' then
		p2_reg <= (others => '0');
	   elsif (write_p2 = '1') and (pa_done = '1') then
		p2_reg <= pa_out;
	   end if;
	end if;
   end process;

    -- store the inputs 'm', 'Q' and 'p' in the registers 'm_reg', 'Q_reg' and 'p_reg', respectively, if start = '1'
    -- the registers have an asynchronous reset
    -- shift the content of 'm_reg' one position to the left if shift = '1'
    reg_m_Q_p: process(rst, clk)
    begin
        if rst = '1' then
            Q_reg <= (others => '0');
            m_reg <= (others => '0');
            p_reg <= (others => '0');
        elsif clk'event and clk = '1' then
            if start = '1' then
                Q_reg <= Q;
                m_reg <= m(s-2 downto 0);
                p_reg <= p;
            elsif shift = '1' then
               m_reg <= m_reg(s-3 downto 0) & '0';
            end if;
        end if;
    end process;

    -- create a counter that increments when enable = '1'
    m_counter: process(rst, clk)
    begin
        if rst = '1' then
            cntr <= (others => '0');
        elsif clk'event and clk = '1' then
            if start = '1' then
                cntr <= (others => '0');
            elsif shift = '1' then
                cntr <= cntr_next;
            end if;
        end if;
    end process;

    FSM: process (clk, rst)
    begin
	if rst = '1' then
		state <= s_idle;
	elsif clk'event and clk = '1' then
	   case state is
		when s_idle =>
			if start = '1' then
			   state <= s_init;
			end if;
		when s_init =>
			if pa_done = '1' then
				state <= s_add;
			end if;
		when s_add =>
			if pa_done = '1' then
				state <= s_double;
			end if;
		when s_double =>
			if pa_done = '1' then
				state <= s_shift;
			end if;
		when s_shift =>
			if cntr = s-2 then
				state <= s_done;
			else
				state <= s_add;
			end if;
		when s_done =>
			state <= s_idle;
	   end case;
	end if;
    end process;

    Output_FSM: process (state, m_left)
    begin
	done <= '0'; write_p1 <= '0'; write_p2 <= '0'; sel <= "00"; shift <= '0'; 
	case state is
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
	   when s_done =>
		done <= '1';
	   when others =>
	end case;
    end process;

    select_input: process (sel, p1_reg, p2_reg)
    begin
	case sel is
	   when "00" =>
		--Double p1
		a <= p1_reg;
		b <= p1_reg;
	   when "11"=>
		--Double p2
		a <= p2_reg;
		b <= p2_reg;
	   when others =>
		a <= p1_reg;
		b <= p2_reg;
	end case;
    end process;
    
    product <= p1_reg;
    m_left <= m_reg(s-2);
end behavioral;
