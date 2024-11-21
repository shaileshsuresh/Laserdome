
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity debouncing_ext is
port(
 reset : in std_logic;
 button: in std_logic;
 clk: in std_logic;
 debounced_button: out std_logic
);
end debouncing_ext;

architecture behavioral of debouncing_ext is

component slower_trig
generic(
	countermax : integer
);
Port(
	reset : in std_logic;
	clk : in std_logic;
	slower_trig_enable : out std_logic
);
end component;

component FF
Port(
	clk : in std_logic;
	clk_enable : in std_logic;
	D : in std_logic;
	Q : out std_logic
);
end component;

constant countermax : integer := 250000; --10ns * 250000 = 40/3Hz
--constant countermax : integer := 25000; --used for simulation

signal slower_trig_enable : std_logic;
signal Q0, Q1, Q2 : std_logic;

begin

Inst_Slower_trig : Slower_trig
generic map( countermax => countermax)
Port map(
	reset => reset,
	clk => clk,
	slower_trig_enable => slower_trig_enable
);

--Inst_FF0 : FF
--Port map(
--	clk => clk,
--	clk_enable => slower_clk_enable,
--	D => button,
--	Q => Q0
--);

Inst_FF1 : FF
Port map(
	clk => clk,
	clk_enable => slower_trig_enable,
	D => button,
	Q => Q1
);

Inst_FF2 : FF
Port map(
	clk => clk,
	clk_enable => slower_trig_enable,
	D => Q1,
	Q => Q2
);

--Q1_inv <= not Q1;
debounced_button <= Q1 AND not Q2;

end behavioral;
