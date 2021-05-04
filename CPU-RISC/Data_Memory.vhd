----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:19:49 04/16/2021 
-- Design Name: 
-- Module Name:    Data_Memory - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Data_Memory is
    Port ( adr : in  STD_LOGIC_VECTOR (7 downto 0);
           IN_port : in  STD_LOGIC_VECTOR (7 downto 0);
			  OUT_port : out  STD_LOGIC_VECTOR(31 downto 0);
           RW : in  STD_LOGIC;
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC);
end Data_Memory;

architecture Behavioral of Data_Memory is
type banc_mem is array(0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
signal mem : banc_mem; 
begin




P : process
	begin 
		wait until CLK'event and CLK='1';
	 
		if RST='0'
		then
			mem <= (others =>x"00000000");
		end if;
		if RW='1'
		then
			OUT_port <= mem(conv_integer(adr));
		elsif RW = '0'
		then
			mem(conv_integer(adr)) <= IN_port;
		end if;
		

		
	end process P;

end Behavioral;

