library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Slower_trig is
generic( countermax : integer);
port(reset : in std_logic;
     clk : in std_logic;
     slower_trig_enable : out std_logic);
end Slower_trig;

architecture behavioral of Slower_trig is
signal counter : integer range 0 to countermax;
begin

clk_count : process(reset, clk)
begin
	if reset = '0' then
		counter <= 0;
	elsif rising_edge(clk) then
		counter <= counter + 1;
		if counter = countermax-1 then
			counter <= 0;
			slower_trig_enable <= '1';
		else
			slower_trig_enable <= '0';
		end if;
	end if;
end process clk_count;

end behavioral;
