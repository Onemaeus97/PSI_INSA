----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:20:19 04/16/2021 
-- Design Name: 
-- Module Name:    Instr_Memory - Behavioral 
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

entity Instr_Memory is
    Port ( adr : in  STD_LOGIC_VECTOR (7 downto 0);
				OUT_port : out  STD_LOGIC_VECTOR(31 downto 0);
           CLK : in  STD_LOGIC);
end Instr_Memory;

architecture Behavioral of Instr_Memory is
type banc_instr is array(0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
signal instructions : banc_instr;
begin
P : process
	begin 
		wait until CLK'event and CLK='1';
			OUT_port <= instructions(conv_integer(adr));
	end process P;
end Behavioral;
