library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
  port (
    reset :      in STD_LOGIC;
    clock :      in STD_LOGIC;

    -- INPUT
    ce :         in STD_LOGIC;
    MMALU_done : in STD_LOGIC;

   -- OUTPUT
    opcode : 	 out STD_LOGIC_VECTOR(1 downto 0);
    Asel : 	 out STD_LOGIC_VECTOR(2 downto 0);
    Bsel : 	 out STD_LOGIC_VECTOR(2 downto 0);
    Csel : 	 out STD_LOGIC_VECTOR(2 downto 0);
    load_MMALU:  out STD_LOGIC;
    done: 	 out STD_LOGIC
  );
end FSM;

architecture Behavioural of FSM is
  type Tstates is (sIdle, sOp_0000, sOp_0001, sOp_0002, sOp_003, sOp_004, sOp_0005, sOp_006, sOp_007, sOp_008, sOp_009, sOp_0010, sOp_011, sOp_012, sOp_013, sOp_014, sOp_0015, sOp_016, sOp_017, sOp_018, sOp_019, sOp_0020, sOp_021, sOp_022, sOp_0023, sOp_0024, sOp_0025, sOp_026, sOp_0027, sOp_0028, sOp_029, sOp_0030, sOp_0031, sOp_032, sOp_033, sOp_034, sOp_035, sDone);
  signal curState, nxtState : Tstates;
begin

  --Experimental
  process(reset, clock)
  begin
     if reset = '0' then
        load_MMALU <= '0'; 
     elsif rising_edge(clock) then
        if (curState /= nxtState) then
           load_MMALU <= '1';
        else 
           load_MMALU <= '0';
        end if;
     end if;
  end process;

  P_FSM_SREG: process(reset, clock)
  begin
    if reset = '0' then 
      curState <= sIdle;
    elsif rising_edge(clock) then
      curState <= nxtState;
    end if;
  end process P_FSM_SREG;

  P_FSM_OF: process(curState)
  begin
    done <= '0';
    case curState is
      when sOp_0000 =>
        opcode <= "00";
        Csel <= "100";
        Asel <= "001";
        Bsel <= "001";
      when sOp_0001 =>
        opcode <= "00";
        Csel <= "100";
        Asel <= "011";
        Bsel <= "010";
      when sOp_0002 =>
        opcode <= "00";
        Csel <= "101";
        Asel <= "100";
        Bsel <= "100";
      when sOp_003 =>
        opcode <= "01";
        Csel <= "110";
        Asel <= "000";
        Bsel <= "010";
      when sOp_004 =>
        opcode <= "01";
        Csel <= "111";
        Asel <= "001";
        Bsel <= "011";
      when sOp_0005 =>
        opcode <= "00";
        Csel <= "110";
        Asel <= "111";
        Bsel <= "111";
      when sOp_006 =>
        opcode <= "01";
        Csel <= "111";
        Asel <= "101";
        Bsel <= "110";
      when sOp_007 =>
        opcode <= "10";
        Csel <= "110";
        Asel <= "111";
        Bsel <= "111";
      when sOp_008 =>
        opcode <= "01";
        Csel <= "111";
        Asel <= "100";
        Bsel <= "010";
      when sOp_009 =>
        opcode <= "01";
        Csel <= "010";
        Asel <= "011";
        Bsel <= "100";
      when sOp_0010 =>
        opcode <= "00";
        Csel <= "001";
        Asel <= "011";
        Bsel <= "111";
      when sOp_011 =>
        opcode <= "01";
        Csel <= "010";
        Asel <= "110";
        Bsel <= "110";
      when sOp_012 =>
        opcode <= "10";
        Csel <= "111";
        Asel <= "010";
        Bsel <= "011";
      when sOp_013 =>
        opcode <= "01";
        Csel <= "010";
        Asel <= "100";
        Bsel <= "001";
      when sOp_014 =>
        opcode <= "01";
        Csel <= "011";
        Asel <= "001";
        Bsel <= "100";
      when sOp_0015 =>
        opcode <= "00";
        Csel <= "011";
        Asel <= "100";
        Bsel <= "011";
      when sOp_016 =>
        opcode <= "01";
        Csel <= "001";
        Asel <= "110";
        Bsel <= "101";
      when sOp_017 =>
        opcode <= "10";
        Csel <= "001";
        Asel <= "100";
        Bsel <= "010";
      when sOp_018 =>
        opcode <= "01";
        Csel <= "000";
        Asel <= "101";
        Bsel <= "101";
      when sOp_019 =>
        opcode <= "01";
        Csel <= "100";
        Asel <= "000";
        Bsel <= "101";
      when sOp_0020 =>
        opcode <= "00";
        Csel <= "010";
        Asel <= "110";
        Bsel <= "000";
      when sOp_021 =>
        opcode <= "01";
        Csel <= "011";
        Asel <= "101";
        Bsel <= "011";
      when sOp_022 =>
        opcode <= "10";
        Csel <= "100";
        Asel <= "101";
        Bsel <= "011";
      when sOp_0023 =>
        opcode <= "00";
        Csel <= "001";
        Asel <= "010";
        Bsel <= "000";
      when sOp_0024 =>
        opcode <= "00";
        Csel <= "000";
        Asel <= "010";
        Bsel <= "111";
      when sOp_0025 =>
        opcode <= "00";
        Csel <= "010";
        Asel <= "111";
        Bsel <= "110";
      when sOp_026 =>
        opcode <= "10";
        Csel <= "000";
        Asel <= "011";
        Bsel <= "001";
      when sOp_0027 =>
        opcode <= "00";
        Csel <= "001";
        Asel <= "010";
        Bsel <= "101";
      when sOp_0028 =>
        opcode <= "00";
        Csel <= "010";
        Asel <= "100";
        Bsel <= "110";
      when sOp_029 =>
        opcode <= "01";
        Csel <= "001";
        Asel <= "010";
        Bsel <= "011";
      when sOp_0030 =>
        opcode <= "00";
        Csel <= "100";
        Asel <= "111";
        Bsel <= "101";
      when sOp_0031 =>
        opcode <= "00";
        Csel <= "011";
        Asel <= "100";
        Bsel <= "111";
      when sOp_032 =>
        opcode <= "01";
        Csel <= "011";
        Asel <= "100";
        Bsel <= "110";
      when sOp_033 =>
        opcode <= "11";
        Csel <= "000";
        Asel <= "000";
        Bsel <= "101";
      when sOp_034 =>
        opcode <= "11";
        Csel <= "001";
        Asel <= "010";
        Bsel <= "000";
      when sOp_035 =>
        opcode <= "11";
        Csel <= "011";
        Asel <= "100";
        Bsel <= "100";
      when sDone =>
	done <= '1';
	opcode <= "00";
        Csel <= "000";
        Asel <= "000";
        Bsel <= "000";
      when others =>
        opcode <= "00";
        Csel <= "000";
        Asel <= "000";
        Bsel <= "000";
    end case;
  end process P_FSM_OF;

  P_FSM_NSF: process(curState, ce, MMALU_done)
  begin
    case curState is
      when sIdle =>
        if ce = '1' then
          nxtState <= sOp_0000;
        else
          nxtState <= sIdle;
        end if;
      when sOp_0000 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0001;
        else
          nxtState <= sOp_0000;
        end if;
      when sOp_0001 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0002;
        else
          nxtState <= sOp_0001;
        end if;
      when sOp_0002 =>
        if MMALU_done = '1' then
          nxtState <= sOp_003;
        else
          nxtState <= sOp_0002;
        end if;
      when sOp_003 =>
        if MMALU_done = '1' then
          nxtState <= sOp_004;
        else
          nxtState <= sOp_003;
        end if;
      when sOp_004 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0005;
        else
          nxtState <= sOp_004;
        end if;
      when sOp_0005 =>
        if MMALU_done = '1' then
          nxtState <= sOp_006;
        else
          nxtState <= sOp_0005;
        end if;
      when sOp_006 =>
        if MMALU_done = '1' then
          nxtState <= sOp_007;
        else
          nxtState <= sOp_006;
        end if;
      when sOp_007 =>
        if MMALU_done = '1' then
          nxtState <= sOp_008;
        else
          nxtState <= sOp_007;
        end if;
      when sOp_008 =>
        if MMALU_done = '1' then
          nxtState <= sOp_009;
        else
          nxtState <= sOp_008;
        end if;
      when sOp_009 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0010;
        else
          nxtState <= sOp_009;
        end if;
      when sOp_0010 =>
        if MMALU_done = '1' then
          nxtState <= sOp_011;
        else
          nxtState <= sOp_0010;
        end if;
      when sOp_011 =>
        if MMALU_done = '1' then
          nxtState <= sOp_012;
        else
          nxtState <= sOp_011;
        end if;
      when sOp_012 =>
        if MMALU_done = '1' then
          nxtState <= sOp_013;
        else
          nxtState <= sOp_012;
        end if;
      when sOp_013 =>
        if MMALU_done = '1' then
          nxtState <= sOp_014;
        else
          nxtState <= sOp_013;
        end if;
      when sOp_014 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0015;
        else
          nxtState <= sOp_014;
        end if;
      when sOp_0015 =>
        if MMALU_done = '1' then
          nxtState <= sOp_016;
        else
          nxtState <= sOp_0015;
        end if;
      when sOp_016 =>
        if MMALU_done = '1' then
          nxtState <= sOp_017;
        else
          nxtState <= sOp_016;
        end if;
      when sOp_017 =>
        if MMALU_done = '1' then
          nxtState <= sOp_018;
        else
          nxtState <= sOp_017;
        end if;
      when sOp_018 =>
        if MMALU_done = '1' then
          nxtState <= sOp_019;
        else
          nxtState <= sOp_018;
        end if;
      when sOp_019 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0020;
        else
          nxtState <= sOp_019;
        end if;
      when sOp_0020 =>
        if MMALU_done = '1' then
          nxtState <= sOp_021;
        else
          nxtState <= sOp_0020;
        end if;
      when sOp_021 =>
        if MMALU_done = '1' then
          nxtState <= sOp_022;
        else
          nxtState <= sOp_021;
        end if;
      when sOp_022 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0023;
        else
          nxtState <= sOp_022;
        end if;
      when sOp_0023 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0024;
        else
          nxtState <= sOp_0023;
        end if;
      when sOp_0024 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0025;
        else
          nxtState <= sOp_0024;
        end if;
      when sOp_0025 =>
        if MMALU_done = '1' then
          nxtState <= sOp_026;
        else
          nxtState <= sOp_0025;
        end if;
      when sOp_026 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0027;
        else
          nxtState <= sOp_026;
        end if;
      when sOp_0027 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0028;
        else
          nxtState <= sOp_0027;
        end if;
      when sOp_0028 =>
        if MMALU_done = '1' then
          nxtState <= sOp_029;
        else
          nxtState <= sOp_0028;
        end if;
      when sOp_029 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0030;
        else
          nxtState <= sOp_029;
        end if;
      when sOp_0030 =>
        if MMALU_done = '1' then
          nxtState <= sOp_0031;
        else
          nxtState <= sOp_0030;
        end if;
      when sOp_0031 =>
        if MMALU_done = '1' then
          nxtState <= sOp_032;
        else
          nxtState <= sOp_0031;
        end if;
      when sOp_032 =>
        if MMALU_done = '1' then
          nxtState <= sOp_033;
        else
          nxtState <= sOp_032;
        end if;
      when sOp_033 =>
        if MMALU_done = '1' then
          nxtState <= sOp_034;
        else
          nxtState <= sOp_033;
        end if;
      when sOp_034 =>
        if MMALU_done = '1' then
          nxtState <= sOp_035;
        else
          nxtState <= sOp_034;
        end if;
      when sOp_035 =>
        if MMALU_done = '1' then
          nxtState <= sDone;
        else
          nxtState <= sOp_035;
        end if;
      when sDone =>
	nxtState <= sIdle;
      when others => 
        nxtState <= sIdle;
      end case;
  end process P_FSM_NSF;

end Behavioural;
