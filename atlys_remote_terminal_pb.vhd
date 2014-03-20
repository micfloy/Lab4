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
	
	component kcpsm6
	generic( hwbuild : std_logic_vector(7 downto 0) := X"00";
		interrupt_vector : std_logic_vector(11 downto 0) := X"3FF";
		scratch_pad_memory_size : integer := 64);
	port ( address : out std_logic_vector(11 downto 0);
		instruction : in std_logic_vector(17 downto 0);
		bram_enable : out std_logic;
		in_port : in std_logic_vector(7 downto 0);
		out_port : out std_logic_vector(7 downto 0);
		port_id : out std_logic_vector(7 downto 0);
		write_strobe : out std_logic;
		k_write_strobe : out std_logic;
		read_strobe : out std_logic;
		interrupt : in std_logic;
		interrupt_ack : out std_logic;
		sleep : in std_logic;
		reset : in std_logic;
		clk : in std_logic);
	end component;
	
	COMPONENT lab4PicoBlaze
	generic( 				C_FAMILY : string  := "S6";
					C_RAM_SIZE_KWORDS : integer := 1;
				C_JTAG_LOADER_ENABLE : integer := 0);
	PORT(
		address : IN std_logic_vector(11 downto 0);
		enable : IN std_logic;
		clk : IN std_logic;          
		instruction : OUT std_logic_vector(17 downto 0);
		rdl : OUT std_logic
		);
	END COMPONENT;
	
	signal data_in_pico, data_out_pico : std_logic_vector(7 downto 0);
	signal en_sig, buffer_write_sig, buffer_data_sig : std_logic; 
	signal half_full_sig, full_sig, buffer_reset_sig : std_logic;
	
	signal address : std_logic_vector(11 downto 0);
	signal instruction : std_logic_vector(17 downto 0);
	signal bram_enable : std_logic;
	signal in_port : std_logic_vector(7 downto 0);
	signal out_port : std_logic_vector(7 downto 0);
	Signal port_id : std_logic_vector(7 downto 0);
	Signal write_strobe : std_logic;
	Signal k_write_strobe : std_logic;
	Signal read_strobe : std_logic;
	Signal interrupt : std_logic;
	Signal interrupt_ack : std_logic;
	Signal kcpsm6_sleep : std_logic;
	Signal kcpsm6_reset : std_logic;
	
begin

	

				 
	Inst_clk_to_baud: clk_to_baud PORT MAP(
			clk => clk,
			reset => reset,
			baud_16x_en => en_sig
			);

	Inst_uart_tx6: uart_tx6 PORT MAP(
			data_in => data_out_pico,
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
			data_out => data_in_pico,
			buffer_read => buffer_data_sig,
			buffer_data_present => buffer_write_sig,
			buffer_half_full => half_full_sig,
			buffer_full => full_sig,
			buffer_reset => buffer_reset_sig,
			clk => clk
		);
		
	processor: kcpsm6
		GENERIC MAP( hwbuild => X"00",
			interrupt_vector => X"3FF",
			scratch_pad_memory_size => 64)
		PORT MAP( address => address,
			instruction => instruction,
			bram_enable => bram_enable,
			port_id => port_id,
			write_strobe => write_strobe,
			k_write_strobe => k_write_strobe,
			out_port => out_port,
			read_strobe => read_strobe,
			in_port => in_port,
			interrupt => interrupt,
			interrupt_ack => interrupt_ack,
			sleep => kcpsm6_sleep,
			reset => kcpsm6_reset,
			clk => clk );

	Inst_lab4PicoBlaze: lab4PicoBlaze 
		generic map( C_FAMILY => "S6",
			C_RAM_SIZE_KWORDS => 1,
			C_JTAG_LOADER_ENABLE => 1)
		port map( address => address,
			instruction => instruction,
			enable => bram_enable,
			rdl => kcpsm6_reset,
			clk => clk);
			
	process(clk, reset)
	begin
		if(rising_edge(clk)) then
			case port_id
				when x"AF" =>
					port_in <= data_in_pico;
				when x"0A" =>
					port_out <= data_out_pico;
			end case;
		end if;
	end process;




end Behavioral;

