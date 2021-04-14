----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:16:09 04/14/2021 
-- Design Name: 
-- Module Name:    UAL - Behavioral 
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
use IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UAL is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           flags : out  STD_LOGIC_VECTOR (3 downto 0);
           Ctrl_Alu : in  STD_LOGIC_VECTOR (1 downto 0);
           S : out  STD_LOGIC_VECTOR (7 downto 0));
end UAL;

architecture Behavioral of UAL is
	signal sortie:STD_LOGIC_VECTOR (7 downto 0);
	signal A_ext:STD_LOGIC_VECTOR (15 downto 0);
	signal B_ext:STD_LOGIC_VECTOR (15 downto 0);
	signal S_ext:STD_LOGIC_VECTOR (15 downto 0);
begin

	
	
		S<=sortie;
		A_ext<="00000000"&A;
		B_ext<="00000000"&B;
		P: process (A,B,Ctrl_Alu, s_ext)
		begin
			flags <= "0000";
			if Ctrl_Alu = "01" --addition
			then 
					S_ext <= A_ext + B_ext;
					sortie <= S_ext (7 downto 0);
					if S_ext > "0000000011111111" 
					then 
						flags<= "0100";
						if S_ext < "0000000111111111"
						then
							flags<= "0101";
						else
							flags<= "0100";
						end if;
					end if;
			end if;
			if Ctrl_Alu = "11" --soustraction
			then 
				sortie <= A - B;
				if A = B
				then
					flags <= "0010";	
				elsif A<B
				then
					flags <= "1000";
				end if;
			end if;
			if Ctrl_Alu = "10" --multiplication
			then
				S_ext <= A * B;
				sortie <= S_ext (7 downto 0);
				if S_ext > "0000000011111111"
				then
					flags <= "0100";
				elsif S_ext = "0000000000000000"
				then
					flags <= "0010";
				end if;
			end if;

				
						
							
			
		end process P;

end Behavioral;

