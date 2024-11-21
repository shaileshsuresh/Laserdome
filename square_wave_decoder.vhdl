
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity square_wave_decoder is
    Port ( clk : in std_logic;
           reset : in std_logic;
           voltage : in std_logic;
           trigger_hit_noise : out std_logic;
           bitstream : out std_logic_vector (7 downto 0));
end ;

architecture Behavioral of square_wave_decoder is

type state is (ready, start, stop);
signal present_state : state := ready;
--signal clk_counter : integer range 0 to
signal temp_bitstream : std_logic_vector(7 downto 0);
signal i : integer := 0;

begin

--temp_bitstream(7 downto 4) <= "0000";

process(clk, reset)

--variable i : integer := 0;

begin

  if rising_edge(clk) then

    if present_state = ready then
      bitstream <= "00000000";
      trigger_hit_noise <= '0';
      if voltage = '1' then        -- start(0)
        present_state <= start;
      else
        present_state <= ready;
      end if;
    end if;
    
    if present_state = start then
      i <= i + 1;
      
      if i = 90000 then             -- start(1)
        if voltage = '1' then
          present_state <= ready;
          i <= 0;
        end if;
      end if;
      
      if i = 150000 then             -- start(2)
        if voltage = '0' then
          present_state <= ready;
          i <= 0;
        end if;
      end if;
      
      if i = 210000 then             -- start(3)
        if voltage = '1' then
          present_state <= ready;
          i <= 0;
        end if;
      end if;
      
      if i = 270000 then             -- start(4)
        if voltage = '1' then
          present_state <= ready;
          i <= 0;
        end if;
      end if;
      
       if i = 330000 then             -- start(5)
        if voltage = '1' then
          present_state <= ready;
          i <= 0;
        end if;
      end if;
      
      if i = 390000 then             -- start(6)
        if voltage = '0' then
          present_state <= ready;
          i <= 0;
        end if;
      end if;
      
      if i = 450000 then             -- start(7)
        if voltage = '0' then
          present_state <= ready;
          i <= 0;
        end if;
      end if;
      
      if i = 510000 then              -- D(0)
        if voltage = '0' then
          temp_bitstream(0) <= '1';
          --bitstream(0) <= '1';
        else 
          temp_bitstream(0) <= '0';
          --bitstream(0) <= '0';
        end if;
      end if;

      if i = 570000 then            -- D(1)
        if voltage = '0' then
          temp_bitstream(1) <= '1';
          --bitstream(1) <= '1';
        else 
          temp_bitstream(1) <= '0';
          --bitstream(1) <= '0';
        end if;
      end if;

      if i = 630000 then           -- D(2)
        if voltage = '0' then
          temp_bitstream(2) <= '1';
          --bitstream(2) <= '1';
        else 
          temp_bitstream(2) <= '0';
          --bitstream(2) <= '0';
        end if;
      end if;

      if i = 690000 then           -- D(3)
        if voltage = '0' then
          temp_bitstream(3) <= '1';
          --bitstream(3) <= '1';
        else 
          temp_bitstream(3) <= '0';
          --bitstream(3) <= '0';
        end if;
      end if;

      if i = 750000 then           -- Stop
        if voltage = '0' then
            bitstream(3 downto 0) <= temp_bitstream(3 downto 0);
            trigger_hit_noise <= '1';
          else
            present_state <= ready;
            temp_bitstream <= "00000000";
            i <= 0;
          end if;
        end if;
      --end if;
      if i = 750652 then
          present_state <= ready;
          trigger_hit_noise <= '0';
          i <= 0;
      end if;
    end if;
  end if;
end process;
       
end Behavioral;
