
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Slower_clk is
generic( countermax : integer);
port(reset : in std_logic;
     clk : in std_logic;
     slower_clk_enable : out std_logic);
end Slower_clk;

architecture behavioral of Slower_clk is
signal counter : natural range 0 to countermax;
signal out_signal : std_logic := '0';

begin

clk_count : process(reset, clk)
begin
	if reset= '0' then
		counter <= 0;
	else
		if rising_edge(clk) then
			counter <= counter + 1;
			if counter = countermax/2 -1 then
				counter <= 0;
				out_signal <= not out_signal;
			end if;
		end if;
	end if;
end process clk_count;

slower_clk_enable  <= out_signal;

end behavioral;
