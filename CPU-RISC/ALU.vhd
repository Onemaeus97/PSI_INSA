----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:50:13 04/23/2021 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

entity ALU is
    Port ( A : in  STD_LOGIC_VECTOR (7 downto 0);
           B : in  STD_LOGIC_VECTOR (7 downto 0);
           N : out  STD_LOGIC;
           O : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           C : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (7 downto 0);
           Ctrl_ALU : in  STD_LOGIC_VECTOR (2 downto 0));
end ALU;

architecture Behavioral of ALU is
	signal result :STD_LOGIC_VECTOR (15 downto 0);
	signal A_ext:STD_LOGIC_VECTOR (15 downto 0);
	signal B_ext:STD_LOGIC_VECTOR (15 downto 0);
begin
	A_ext<="00000000"&A;
	B_ext<="00000000"&B;
	S <= result(7 downto 0) ;
	result <= A_ext + B_ext when Ctrl_ALU = "001" else
				 A_ext * B_ext when Ctrl_ALU = "010" else
				 A_ext - B_ext when Ctrl_ALU = "011" ;
	C <= '1' when result > x"00FF" and Ctrl_ALU = "001" else '0';
	O <= '1' when result > x"00FF" and Ctrl_ALU = "001" else '1' when result > x"FF" and Ctrl_ALU = "010" else '0' ;
	Z <= '1' when result = x"0000" else '0';
	N <= '1' when A_ext < B_ext and Ctrl_ALU = "011" else '0';
		  
  
end Behavioral;

