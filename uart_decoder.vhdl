library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity uart_decoder is

port ( bitstream : in std_logic_vector(7 downto 0);
      characters : out std_logic_vector(7 downto 0));

end uart_decoder;

architecture arch_decoder of uart_decoder is

signal i : integer := 0;

begin

Display : process(bitstream)
    begin

    CASE bitstream IS 
        WHEN "00000000" => --Moses
	      characters <= x"30";	
             
        WHEN "00000001" => --Oskar
              characters <= x"31";

        WHEN "00000010" => --Luc@z
              characters <= x"32";

        WHEN "00000011" => --Ammar
              characters <= x"33";

        WHEN "00000100" => --Shailu
              characters <= x"34";
 
        WHEN "00000101" => --Max
              characters <= x"35";
	      
	WHEN "00000110" =>  --BOT1
	      characters <= x"36"; 	      

	WHEN "00000111" =>  --BOT2
	      characters <= x"37";

	WHEN "00001000" =>  --Moa
	      characters <= x"38"; 

	WHEN "00001001" =>  --BOT3
	      characters <= x"39";


	WHEN "00001010" =>  --BOT4
	      characters <= x"41"; 


	WHEN "00001011" =>  --BOT5
	      characters <= x"42";


	WHEN "00001100" =>  --BOT5
	      characters <= x"43";
	      

	WHEN "00001101" =>  --BOT6
	     characters <= x"44"; 


        WHEN "00001110" => --No User
            characters <= x"45";

        WHEN "00001111" => --Moa
              characters <= x"46"; 

        WHEN others => --
              characters <= x"2E";

    END CASE;
 end process Display;

end arch_decoder;
