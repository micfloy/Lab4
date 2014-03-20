----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:22:15 03/20/2014 
-- Design Name: 
-- Module Name:    ascii_to_nibble - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ascii_to_nibble is
    Port ( ascii : in  STD_LOGIC_VECTOR (7 downto 0);
           nibble : out  STD_LOGIC_VECTOR (3 downto 0));
end ascii_to_nibble;

architecture Behavioral of ascii_to_nibble is

begin

	process(ascii)
	begin
		case ascii is
			when x"30" =>
				nibble <= x"0";
			when x"31" =>
				nibble <= x"1";
			when x"32" =>
				nibble <= x"2";
			when x"33" =>
				nibble <= x"3";
			when x"34" =>
				nibble <= x"4";
			when x"35" =>
				nibble <= x"5";
			when x"36" =>
				nibble <= x"6";
			when x"37" =>
				nibble <= x"7";
			when x"38" =>
				nibble <= x"8";
			when x"39" =>
				nibble <= x"9";
			when x"41" =>
				nibble <= x"A";
			when x"42" =>
				nibble <= x"B";
			when x"43" =>
				nibble <= x"C";
			when x"44" =>
				nibble <= x"D";
			when x"45" =>
				nibble <= x"E";
			when x"46" =>
				nibble <= x"F";
			when others =>
				nibble <= x"0";
		end case;
		
	end process;

end Behavioral;

