
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity message is
generic( countermax : integer := 120048);
port(reset : in std_logic;
     clk : in std_logic;
     shoot : in std_logic;
     message_in : in std_logic_vector(3 downto 0);
     weapon_off : in std_logic;
     noise : out std_logic;
     message_out : out std_logic);
end message;

architecture behavioral of message is

component debouncing_ext
Port( 
	reset : in std_logic;
	button : in std_logic;
	clk :in std_logic;
	debounced_button : out std_logic
);
end component;

component gun_noise
Port( 
	 clk : in STD_LOGIC;
         reset : in std_logic;
         gun_fired : in std_logic;
         weapon_off : in std_logic;
         noise : out std_logic );
end component;

signal counter : natural range 0 to countermax;
signal full_message : std_logic_vector(12 downto 0);
signal debounced_shot_ext : std_logic;

begin

Inst_speaker : gun_noise
port map(
	clk => clk,
	reset => reset,
	gun_fired => debounced_shot_ext,
	weapon_off => weapon_off,
	noise => noise
);

Inst_shootButton : debouncing_ext
Port map(
	reset => reset,
	button => shoot,
	clk => clk,
	debounced_button => debounced_shot_ext
);

clk_count : process(reset, clk)
variable i : natural range 0 to 12 := 0;
variable load_message : natural range 0 to 1 := 0;
begin
	if reset= '0' then
		message_out <= '1';
		counter <= 0;
		i := 0;
		load_message := 0;
	else
		if rising_edge(clk) then
		  if weapon_off /= '1' then
			if debounced_shot_ext = '1' then
				if load_message < 1 then
					full_message(7 downto 0) <= "00111010"; --x"5C" 

					full_message(12) <= '1';
					full_message(11 downto 8) <= message_in;
					load_message := load_message + 1;
				end if;
			end if;
		  end if;
			counter <= counter + 1;
			if counter = countermax/2-1 then
				counter <= 0;
				if load_message = 1 then
					message_out <= full_message(i);
					if i = 12 then
						i := 0;
						load_message := 0;
					else
						i := i+1;
					end if;
				end if;
			end if;
		end if;
	end if;
end process clk_count;

end behavioral;

