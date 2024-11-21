library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity Player_Switch is
   -- generic( counter_1600 :integer := 62499); --10ns * 62499 = 1600Hz  
		-- counter_1600: integer :=4999);    --10ns * 5000 = 20000Hz This is used for simulation
    Port ( 
           clk : in STD_LOGIC;
           reset : in STD_LOGIC;
	   go_Left : in STD_LOGIC;
  	   go_Right : in STD_LOGIC;
	   select_player : in STD_LOGIC;
           SEG : out STD_LOGIC_VECTOR(7 downto 0);
           AN : out STD_LOGIC_VECTOR(7 downto 0);
	   player_ID : out STD_LOGIC_VECTOR(3 downto 0)
);
end Player_Switch;

architecture Logic of Player_Switch is

constant Hz_1600 : integer := 62500;

component Slower_trig
generic(
	countermax : integer := Hz_1600
);
Port(
	reset : in std_logic;
	clk : in std_logic;
	slower_trig_enable : out std_logic
);
end component;

component debouncing
Port( 
	reset : in std_logic;
	button : in std_logic;
	clk :in std_logic;
	debounced_button : out std_logic
);
end component;


signal slower_trig_enable : std_logic;

signal debounced_left : std_logic;
signal debounced_right : std_logic;
signal debounced_select : std_logic;
signal select_signal : std_logic;

signal player : std_logic_vector(3 downto 0);

signal SEG0: STD_LOGIC_VECTOR(7 downto 0);
signal SEG1: STD_LOGIC_VECTOR(7 downto 0);
signal SEG2: STD_LOGIC_VECTOR(7 downto 0);
signal SEG3: STD_LOGIC_VECTOR(7 downto 0);
signal SEG4: STD_LOGIC_VECTOR(7 downto 0);
signal SEG5: STD_LOGIC_VECTOR(7 downto 0);
signal SEG6: STD_LOGIC_VECTOR(7 downto 0);
signal SEG7: STD_LOGIC_VECTOR(7 downto 0);

begin

Hz_1600_clk : Slower_trig
generic map( countermax => Hz_1600)
Port map(
	reset => reset,
	clk => clk,
	slower_trig_enable => slower_trig_enable
);

debouncer_select : debouncing
Port map(
	reset => reset,
	button => select_player,
	clk => clk,
	debounced_button => debounced_select
);
	
debouncer_left : debouncing
Port map(
	reset => reset,
	button => go_Left,
	clk => clk,
	debounced_button => debounced_left
);

debouncer_right : debouncing
Port map(
	reset => reset,
	button => go_Right,
	clk => clk,
	debounced_button => debounced_right
);
       
 
Switch_player : process (reset, clk, debounced_select)
variable i : natural range 0 to 1 := 0;
 begin
 	if reset = '0' then
		player <= "0000";
	 	select_signal <= '0';
    else
	        if rising_edge(clk) then
			if debounced_select = '0' AND player /= "0000" then
				select_signal <= '1';
			end if;
			if select_signal = '0' then
				if debounced_right = '0' then
					if i < 1 then
						if player = "1111" then
							player <= "0001";
						else 
							player <= player +1;
						end if;
						i := i + 1;
					end if;
				elsif debounced_left = '0' then
					if i < 1 then
						if player = "0001" then
							player <= "1111";
						else
							player <= player -1;
						end if;
						i := i + 1;
					end if;
				else i := 0;
				end if;
			  end if;
		end if;
	end if;
		
end process Switch_player;
		
Display : process(player)
    begin
    CASE player IS 
              WHEN "0000" => --PICk Id
              SEG0 <="10001100"; --P
	      SEG1 <="11001111"; --I
	      SEG2 <="11000110"; --C
	      SEG3 <="10001010"; --K
	      SEG4 <="11111111"; --
	      SEG5 <="11001111"; --I
	      SEG6 <="10100001"; --d
	      SEG7 <="11111111"; --
        WHEN "0001" => --Oskar
          SEG0 <="11000000"; --O 
	      SEG1 <="10010010"; --S 
	      SEG2 <="10001010"; --K
	      SEG3 <="10001000"; --A
	      SEG4 <="11001100"; --R
	      SEG5 <="11111111"; --
	      SEG6 <="11111111"; --
	      SEG7 <="11111111"; --
        WHEN "0010" => --Lulle
          SEG0 <="11000111"; --L 
	      SEG1 <="11000001"; --U 
	      SEG2 <="11000110"; --C
	      SEG3 <="10001000"; --A
	      SEG4 <="10010010"; --S
	      SEG5 <="11111111"; --
	      SEG6 <="11111111"; --
	      SEG7 <="11111111"; --
        WHEN "0011" => --Ammar
            SEG0 <="10001000"; --A 
	      SEG1 <="11101010"; --M 
	      SEG2 <="11101010"; --M
	      SEG3 <="10001000"; --A
	      SEG4 <="11001100"; --R
	      SEG5 <="11111111"; --
	      SEG6 <="11111111"; --
	      SEG7 <="11111111"; --
        WHEN "0100" => --Shailesh
            SEG0 <="10010010"; --S 
	      SEG1 <="10001011"; --H 
	      SEG2 <="10001000"; --A
	      SEG3 <="11001111"; --I
	      SEG4 <="11000111"; --L
	      SEG5 <="10000110"; --E
	      SEG6 <="10010010"; --S
	      SEG7 <="10001011"; --H 
        WHEN "0101" => --Max
            SEG0 <="11101010"; --M 
	      SEG1 <="10001000"; --A 
	      SEG2 <="10001001"; --X
	      SEG3 <="11111111"; --
	      SEG4 <="11111111"; --
	      SEG5 <="11111111"; --
	      SEG6 <="11111111"; --
	      SEG7 <="11111111"; --
        WHEN "0110" => --Moses
              SEG0 <="11101010"; --M  
	      SEG1 <="11000000"; --O 
	      SEG2 <="10010010"; --S
	      SEG3 <="10000110"; --E
	      SEG4 <="10010010"; --S
	      SEG5 <="11111111"; --
	      SEG6 <="11111111"; --
	      SEG7 <="11111111"; --
	WHEN  "0111" => --Arne
	      SEG0 <="10001000"; --A 
	      SEG1 <="11001100"; --R
	      SEG2 <="11001000"; --n
	      SEG3 <="10000110"; --E
	      SEG4 <="11111111"; --
	      SEG5 <="11111111"; --
	      SEG6 <="11111111"; --
	      SEG7 <="11111111"; --
        WHEN "1000" => --Moa
            SEG0 <="11101010"; --M 
	      SEG1 <="11000000"; --O 
	      SEG2 <="10001000"; --A
	      SEG3 <="11111111"; --
	      SEG4 <="11111111"; --
	      SEG5 <="11111111"; --
	      SEG6 <="11111111"; --
	      SEG7 <="11111111"; --
        WHEN "1001" => --Sven
	      SEG0 <="10010010"; --S 
	      SEG1 <="11010101"; --v
	      SEG2 <="10000110"; --E
	      SEG3 <="11001000"; --n
	      SEG4 <="11111111"; --
	      SEG5 <="11111111"; --
	      SEG6 <="11111111"; --
	      SEG7 <="11111111"; --
        WHEN "1010" => --Erik
	      SEG0 <="10000110"; --E  
	      SEG1 <="11001100"; --R
	      SEG2 <="11001111"; --I
	      SEG3 <="10001010"; --K
	      SEG4 <="11111111"; --
	      SEG5 <="11111111"; --
	      SEG6 <="11111111"; --
	      SEG7 <="11111111"; --
        WHEN "1011" => --Player 11
	      SEG0 <="10001100"; --P  
	      SEG1 <="11000111"; --L
	      SEG2 <="10001000"; --A
	      SEG3 <="10010001"; --y
	      SEG4 <="10000110"; --E
	      SEG5 <="11001100"; --R
	      SEG6 <="11111001"; --1
	      SEG7 <="11111001"; --1
        WHEN "1100" => --Player 12
	      SEG0 <="10001100"; --P  
	      SEG1 <="11000111"; --L
	      SEG2 <="10001000"; --A
	      SEG3 <="10010001"; --y
	      SEG4 <="10000110"; --E
	      SEG5 <="11001100"; --R
	      SEG6 <="11111001"; --1
	      SEG7 <="10100100"; --2
        WHEN "1101" => --Player 13
	      SEG0 <="10001100"; --P  
	      SEG1 <="11000111"; --L
	      SEG2 <="10001000"; --A
	      SEG3 <="10010001"; --y
	      SEG4 <="10000110"; --E
	      SEG5 <="11001100"; --R
	      SEG6 <="11111001"; --1
	      SEG7 <="10110000"; --3
        WHEN "1110" => --Player 14
	      SEG0 <="10001100"; --P  
	      SEG1 <="11000111"; --L
	      SEG2 <="10001000"; --A
	      SEG3 <="10010001"; --y
	      SEG4 <="10000110"; --E
	      SEG5 <="11001100"; --R
	      SEG6 <="11111001"; --1
	      SEG7 <="10011001"; --4
        WHEN "1111" => --Player 15
	      SEG0 <="10001100"; --P  
	      SEG1 <="11000111"; --L
	      SEG2 <="10001000"; --A
	      SEG3 <="10010001"; --y
	      SEG4 <="10000110"; --E
	      SEG5 <="11001100"; --R
	      SEG6 <="11111001"; --1
	      SEG7 <="10010010"; --5
       WHEN others =>
            SEG0 <="00000110"; --E.
    END CASE; 
 end process Display;

player_ID <= player;

switch_SEG_1600Hz : process(clk, reset)
variable shift: STD_LOGIC_VECTOR(7 downto 0);
begin
	if reset ='0' then
		shift(7 downto 0) := "11111111";
		AN(7 downto 0) <= shift(7 downto 0);
	else
	 if rising_edge(clk) then
		if slower_trig_enable ='1' then 
			shift(6 downto 0) := shift(7 downto 1);
			if shift(7 downto 0) = "11111111" then
				shift(7) := '0';
			else shift(7) := '1';
			end if;
			AN <= shift(7 downto 0);
			CASE shift IS
				WHEN "01111111" => 
					SEG <= SEG0;
				WHEN "10111111" => 
					SEG <= SEG1;
				WHEN "11011111" => 
					SEG <= SEG2;
				WHEN "11101111" => 
					SEG <= SEG3;
				WHEN "11110111" => 
					SEG <= SEG4;
				WHEN "11111011" => 
					SEG <= SEG5;
				WHEN "11111101" => 
					SEG <= SEG6;
				WHEN "11111110" => 
					SEG <= SEG7;
				WHEN others => 
					SEG <= "00000000"; --Turn on all lights if noone
			END CASE;
			end if;
		end if;
	end if;
end process switch_SEG_1600Hz;

end Logic;
