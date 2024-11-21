library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FF is
port(
 clk: in std_logic;
 clk_enable: in std_logic;
 D: in std_logic;
 Q: out std_logic:='0');

end FF;

architecture behavioral of FF is
begin
process(clk)
begin
 if(rising_edge(clk)) then
  if(clk_enable='1') then
   Q <= D;
  end if;
 end if;
end process;
end behavioral;
