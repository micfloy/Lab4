----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:49:00 03/18/2014 
-- Design Name: 
-- Module Name:    clk_to_baud - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity clk_to_baud is
    port ( clk         : in std_logic;
           reset       : in std_logic;
           baud_16x_en : out std_logic
        );
end clk_to_baud;

architecture Behavioral of clk_to_baud is

signal baud_count : integer range 0 to 651 := 0;
signal en_16_x_baud : std_logic := '0';

begin

baud_rate: process(clk)
begin
	if clk'event and clk = '1' then
		if baud_count = 651 then
			baud_count <= 0;
			en_16_x_baud <= '1';
		else
			baud_count <= baud_count + 1;
			en_16_x_baud <= '0';
		end if;
	end if;
end process baud_rate;

baud_16x_en <= en_16_x_baud;


end Behavioral;

