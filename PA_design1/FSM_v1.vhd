library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FSM is
  port (
    reset : in STD_LOGIC;
    clock : in STD_LOGIC;

    -- INPUT
    ce : in STD_LOGIC;
    done : in STD_LOGIC;

   -- OUTPUT
    opcode : out STD_LOGIC_VECTOR(2 downto 0);
    Asel : out STD_LOGIC_VECTOR(2 downto 0);
    Bsel : out STD_LOGIC_VECTOR(2 downto 0);
    Csel : out STD_LOGIC_VECTOR(2 downto 0);
    load_MMALU: out STD_LOGIC
  );
end FSM;

architecture Behavioural of FSM is
  type Tstates is (sIdle, sOp_0000, sOp_0001, sOp_0002, sOp_0003, sOp_004, sOp_0005, sOp_006, sOp_0007, sOp_008, sOp_009, sOp_010, sOp_0011, sOp_012, sOp_013, sOp_0014, sOp_0015, sOp_0016, sOp_017, sOp_0018, sOp_0019, sOp_020, sOp_0021, sOp_0022, sOp_023, sOp_0024, sOp_0025, sOp_0026);
  signal curState, nxtState : Tstates;
begin
  
  --Experimental
  process(curState, nxtState)
  begin
     if (curState /= nxtState) then
        load_MMALU <= '1';
     else 
        load_MMALU <= '0';
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
    case curState is
      when sOp_0000 =>
        opcode <= "000";
        Csel <= "100";
        Asel <= "000";
        Bsel <= "000";
      when sOp_0001 =>
        opcode <= "000";
        Csel <= "101";
        Asel <= "010";
        Bsel <= "001";
      when sOp_0002 =>
        opcode <= "000";
        Csel <= "111";
        Asel <= "000";
        Bsel <= "001";
      when sOp_0003 =>
        opcode <= "000";
        Csel <= "110";
        Asel <= "010";
        Bsel <= "000";
      when sOp_004 =>
        opcode <= "001";
        Csel <= "110";
        Asel <= "101";
        Bsel <= "101";
      when sOp_0005 =>
        opcode <= "000";
        Csel <= "111";
        Asel <= "010";
        Bsel <= "010";
      when sOp_006 =>
        opcode <= "001";
        Csel <= "111";
        Asel <= "101";
        Bsel <= "001";
      when sOp_0007 =>
        opcode <= "000";
        Csel <= "001";
        Asel <= "000";
        Bsel <= "010";
      when sOp_008 =>
        opcode <= "001";
        Csel <= "001";
        Asel <= "001";
        Bsel <= "000";
      when sOp_009 =>
        opcode <= "001";
        Csel <= "000";
        Asel <= "011";
        Bsel <= "100";
      when sOp_010 =>
        opcode <= "001";
        Csel <= "100";
        Asel <= "011";
        Bsel <= "000";
      when sOp_0011 =>
        opcode <= "000";
        Csel <= "011";
        Asel <= "110";
        Bsel <= "010";
      when sOp_012 =>
        opcode <= "001";
        Csel <= "010";
        Asel <= "100";
        Bsel <= "011";
      when sOp_013 =>
        opcode <= "010";
        Csel <= "101";
        Asel <= "100";
        Bsel <= "011";
      when sOp_0014 =>
        opcode <= "000";
        Csel <= "001";
        Asel <= "110";
        Bsel <= "001";
      when sOp_0015 =>
        opcode <= "000";
        Csel <= "000";
        Asel <= "101";
        Bsel <= "001";
      when sOp_0016 =>
        opcode <= "000";
        Csel <= "011";
        Asel <= "100";
        Bsel <= "101";
      when sOp_017 =>
        opcode <= "010";
        Csel <= "000";
        Asel <= "000";
        Bsel <= "000";
      when sOp_0018 =>
        opcode <= "000";
        Csel <= "001";
        Asel <= "011";
        Bsel <= "001";
      when sOp_0019 =>
        opcode <= "000";
        Csel <= "101";
        Asel <= "100";
        Bsel <= "010";
      when sOp_020 =>
        opcode <= "001";
        Csel <= "001";
        Asel <= "100";
        Bsel <= "001";
      when sOp_0021 =>
        opcode <= "000";
        Csel <= "100";
        Asel <= "011";
        Bsel <= "101";
      when sOp_0022 =>
        opcode <= "000";
        Csel <= "010";
        Asel <= "101";
        Bsel <= "010";
      when sOp_023 =>
        opcode <= "001";
        Csel <= "010";
        Asel <= "011";
        Bsel <= "010";
      when sOp_0024 =>
        opcode <= "000";
        Csel <= "000";
        Asel <= "111";
        Bsel <= "000";
      when sOp_0025 =>
        opcode <= "000";
        Csel <= "001";
        Asel <= "111";
        Bsel <= "001";
      when sOp_0026 =>
        opcode <= "000";
        Csel <= "010";
        Asel <= "111";
        Bsel <= "010";
      when others =>
        opcode <= "000";
        Csel <= "000";
        Asel <= "000";
        Bsel <= "000";
    end case;
  end process P_FSM_OF;

  P_FSM_NSF: process(curState, ce, done)
  begin
    case curState is
      when sIdle => 
        if ce = '1' then
          nxtState <= sOp_0000;
        else
          nxtState <= sIdle;
        end if;
      when sOp_0000 =>
        if done = '1' then
          nxtState <= sOp_0001;
        else
          nxtState <= sOp_0000;
        end if;
      when sOp_0001 =>
        if done = '1' then
          nxtState <= sOp_0002;
        else
          nxtState <= sOp_0001;
        end if;
      when sOp_0002 =>
        if done = '1' then
          nxtState <= sOp_0003;
        else
          nxtState <= sOp_0002;
        end if;
      when sOp_0003 =>
        if done = '1' then
          nxtState <= sOp_004;
        else
          nxtState <= sOp_0003;
        end if;
      when sOp_004 =>
        if done = '1' then
          nxtState <= sOp_0005;
        else
          nxtState <= sOp_004;
        end if;
      when sOp_0005 =>
        if done = '1' then
          nxtState <= sOp_006;
        else
          nxtState <= sOp_0005;
        end if;
      when sOp_006 =>
        if done = '1' then
          nxtState <= sOp_0007;
        else
          nxtState <= sOp_006;
        end if;
      when sOp_0007 =>
        if done = '1' then
          nxtState <= sOp_008;
        else
          nxtState <= sOp_0007;
        end if;
      when sOp_008 =>
        if done = '1' then
          nxtState <= sOp_009;
        else
          nxtState <= sOp_008;
        end if;
      when sOp_009 =>
        if done = '1' then
          nxtState <= sOp_010;
        else
          nxtState <= sOp_009;
        end if;
      when sOp_010 =>
        if done = '1' then
          nxtState <= sOp_0011;
        else
          nxtState <= sOp_010;
        end if;
      when sOp_0011 =>
        if done = '1' then
          nxtState <= sOp_012;
        else
          nxtState <= sOp_0011;
        end if;
      when sOp_012 =>
        if done = '1' then
          nxtState <= sOp_013;
        else
          nxtState <= sOp_012;
        end if;
      when sOp_013 =>
        if done = '1' then
          nxtState <= sOp_0014;
        else
          nxtState <= sOp_013;
        end if;
      when sOp_0014 =>
        if done = '1' then
          nxtState <= sOp_0015;
        else
          nxtState <= sOp_0014;
        end if;
      when sOp_0015 =>
        if done = '1' then
          nxtState <= sOp_0016;
        else
          nxtState <= sOp_0015;
        end if;
      when sOp_0016 =>
        if done = '1' then
          nxtState <= sOp_017;
        else
          nxtState <= sOp_0016;
        end if;
      when sOp_017 =>
        if done = '1' then
          nxtState <= sOp_0018;
        else
          nxtState <= sOp_017;
        end if;
      when sOp_0018 =>
        if done = '1' then
          nxtState <= sOp_0019;
        else
          nxtState <= sOp_0018;
        end if;
      when sOp_0019 =>
        if done = '1' then
          nxtState <= sOp_020;
        else
          nxtState <= sOp_0019;
        end if;
      when sOp_020 =>
        if done = '1' then
          nxtState <= sOp_0021;
        else
          nxtState <= sOp_020;
        end if;
      when sOp_0021 =>
        if done = '1' then
          nxtState <= sOp_0022;
        else
          nxtState <= sOp_0021;
        end if;
      when sOp_0022 =>
        if done = '1' then
          nxtState <= sOp_023;
        else
          nxtState <= sOp_0022;
        end if;
      when sOp_023 =>
        if done = '1' then
          nxtState <= sOp_0024;
        else
          nxtState <= sOp_023;
        end if;
      when sOp_0024 =>
        if done = '1' then
          nxtState <= sOp_0025;
        else
          nxtState <= sOp_0024;
        end if;
      when sOp_0025 =>
        if done = '1' then
          nxtState <= sOp_0026;
        else
          nxtState <= sOp_0025;
        end if;
      when sOp_0026 =>
        if done = '1' then
          nxtState <= sIdle;
        else
          nxtState <= sOp_0026;
        end if;
      when others => 
        nxtState <= sIdle;
      end case;
  end process P_FSM_NSF;

end Behavioural;
