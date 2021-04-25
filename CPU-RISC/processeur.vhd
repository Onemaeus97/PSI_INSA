----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:26:41 04/25/2021 
-- Design Name: 
-- Module Name:    processeur - Behavioral 
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


entity Processeur is
    Port ( CLK_Proc : in  STD_LOGIC;
           RST_Proc : in  STD_LOGIC;
			  QA: out STD_LOGIC_VECTOR (7 downto 0);
			  QB: out STD_LOGIC_VECTOR (7 downto 0)
			  );
end Processeur;

architecture Behavioral of processeur is

begin


end Behavioral;

