----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:58:42 03/13/2014 
-- Design Name: 
-- Module Name:    atlys_remote_terminal_pb - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity atlys_remote_terminal_pb is
    port (
             clk        : in  std_logic;
             reset      : in  std_logic;
             serial_in  : in  std_logic;
             serial_out : out std_logic;
             switch     : in  std_logic_vector(7 downto 0);
             led        : out std_logic_vector(7 downto 0)
         );
end atlys_remote_terminal_pb;

architecture Behavioral of atlys_remote_terminal_pb is

	COMPONENT uart_rx6
	PORT(
		serial_in : IN std_logic;
		en_16_x_baud : IN std_logic;
		buffer_read : IN std_logic;
		buffer_reset : IN std_logic;
		clk : IN std_logic;          
		data_out : OUT std_logic_vector(7 downto 0);
		buffer_data_present : OUT std_logic;
		buffer_half_full : OUT std_logic;
		buffer_full : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT uart_tx6
	PORT(
		data_in : IN std_logic_vector(7 downto 0);
		en_16_x_baud : IN std_logic;
		buffer_write : IN std_logic;
		buffer_reset : IN std_logic;
		clk : IN std_logic;          
		serial_out : OUT std_logic;
		buffer_data_present : OUT std_logic;
		buffer_half_full : OUT std_logic;
		buffer_full : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT clk_to_baud
	PORT(
		clk : IN std_logic;
		reset : IN std_logic;          
		baud_16x_en : OUT std_logic
		);
	END COMPONENT;
	
	signal data : std_logic_vector(7 downto 0);
	signal en_sig, buffer_write_sig, buffer_data_sig : std_logic; 
	signal half_full_sig, full_sig, buffer_reset_sig : std_logic;
	
begin

				 
	Inst_clk_to_baud: clk_to_baud PORT MAP(
			clk => clk,
			reset => reset,
			baud_16x_en => en_sig
			);

	Inst_uart_tx6: uart_tx6 PORT MAP(
			data_in => data,
			en_16_x_baud => en_sig,
			serial_out => serial_out,
			buffer_write => buffer_write_sig,
			buffer_data_present => buffer_data_sig,
			buffer_half_full => half_full_sig,
			buffer_full => full_sig,
			buffer_reset => buffer_reset_sig,
			clk => clk
		);
		
	Inst_uart_rx6: uart_rx6 PORT MAP(
			serial_in => serial_in,
			en_16_x_baud => en_sig,
			data_out => data,
			buffer_read => buffer_data_sig,
			buffer_data_present => buffer_write_sig,
			buffer_half_full => half_full_sig,
			buffer_full => full_sig,
			buffer_reset => buffer_reset_sig,
			clk => clk
		);





end Behavioral;

