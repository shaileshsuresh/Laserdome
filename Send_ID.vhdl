

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.all;


entity Send_ID is
port(reset : in std_logic;
     clk : in std_logic;
     SW : in std_logic;	
     shoot : in std_logic;
     Player_ID : in std_logic_vector(3 downto 0);
     weapon_off : in std_logic;
     noise : out std_logic;
     Send : out std_logic);
end Send_ID; 

Architecture behaviour of Send_ID is

signal counter_38kHz : std_logic;
signal counter_833Hz : std_logic;

constant Hz_38k : natural := 2632;  --2632
constant Hz_833 : natural := 120048; --120048

component slower_clk 
generic( countermax : integer
);
Port(
	reset : in std_logic;
	clk : in std_logic;
	slower_clk_enable : out std_logic
);
end component;

component message
generic( countermax : integer
);
Port(
	reset : in std_logic;
	clk : in std_logic;
	shoot : in std_logic;
    	weapon_off : in std_logic;
	message_in : in std_logic_vector(3 downto 0);
	noise : out std_logic;
	message_out : out std_logic
);
end component;
begin

Inst_Slower_clk_38kHz : Slower_clk
generic map( countermax => Hz_38k)
Port map(
	reset => reset,
	clk => clk,
	slower_clk_enable => counter_38kHz
);


Inst_message_clk_833Hz : message
generic map( countermax => Hz_833)
Port map(
	reset => reset,
	clk => clk,
	shoot => shoot,
	message_in => Player_ID,
	weapon_off => weapon_off,
	noise => noise,
	message_out => counter_833Hz
);

Send_logic : process(counter_38kHz)
begin

if SW = '1'  AND weapon_off /= '1' then
	Send <= counter_38kHz AND counter_833Hz;
else Send <= '0';
end if;
end process;

end behaviour;
