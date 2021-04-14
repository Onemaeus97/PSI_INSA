--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:16:20 04/14/2021
-- Design Name:   
-- Module Name:   /home/karaoud/Documents/4-ir/sysinfo/compilo3/PSI_INSA/CPU-RISC/UAL_test.vhd
-- Project Name:  CPU-RISC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: UAL
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY UAL_test IS
END UAL_test;
 
ARCHITECTURE behavior OF UAL_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT UAL
    PORT(
         A : IN  std_logic_vector(7 downto 0);
         B : IN  std_logic_vector(7 downto 0);
         flags : OUT  std_logic_vector(3 downto 0);
         Ctrl_Alu : IN  std_logic_vector(1 downto 0);
         S : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A : std_logic_vector(7 downto 0) := (others => '0');
   signal B : std_logic_vector(7 downto 0) := (others => '0');
   signal Ctrl_Alu : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal flags : std_logic_vector(3 downto 0);
   signal S : std_logic_vector(7 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 

 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: UAL PORT MAP (
          A => A,
          B => B,
          flags => flags,
          Ctrl_Alu => Ctrl_Alu,
          S => S
        );


 


	
	   A <= "00000000","11111111" after 100 ns;
		B <= "00000000" , "11111111" after 100 ns;
		Ctrl_Alu <= "00" , "01" after 100 ns;



END;
