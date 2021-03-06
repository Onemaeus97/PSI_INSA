----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:35:08 04/16/2021 
-- Design Name: 
-- Module Name:    Register_bank - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register_bank is
    Port ( A_adr : in  STD_LOGIC_VECTOR(3 downto 0);
           B_adr : in  STD_LOGIC_VECTOR (3 downto 0);
           W_adr : in  STD_LOGIC_VECTOR (3 downto 0);
           W : in  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR (7 downto 0);
           RST : in  STD_LOGIC;
           CLK : in  STD_LOGIC;
           QA : out  STD_LOGIC_VECTOR (7 downto 0);
           QB : out  STD_LOGIC_VECTOR (7 downto 0));
			  
			  
			  
			  
end Register_bank;

architecture Behavioral of Register_bank is

type banc_reg is array(0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
signal reg : banc_reg;


begin


QA<= reg(conv_integer(A_adr)) ;
QB<= reg(conv_integer(B_adr)) ;



P : process
	begin 
		wait until CLK'event and CLK='1';
	 
		if RST='0' then reg<= (others => "00000000"); end if;
		if W='1' then reg(conv_integer(W_adr)) <= DATA; end if;

		
	end process P;

end Behavioral;

