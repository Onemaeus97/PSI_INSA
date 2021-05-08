--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:35:59 05/07/2021
-- Design Name:   
-- Module Name:   /home/ywang4/Bureau/PSI_INSA/CPU-RISC/rff.vhd
-- Project Name:  CPU-RISC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Processeur
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.ALL;
use IEEE.std_logic_arith.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY rff IS
END rff;
 
                                        ARCHITECTURE behavior OF rff IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Processeur
    PORT(
         CLK_Proc : IN  std_logic;
         RST_Proc : IN  std_logic;
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0);
         --sortie : OUT  std_logic ;
			Test_ip : IN std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_Proc : std_logic := '0';
   signal RST_Proc : std_logic := '0';
	signal Test_ip : std_logic_vector(7 downto 0) := x"00";
 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);
   --signal sortie : std_logic;

   -- Clock period definitions
   constant CLK_Proc_period : time := 10 ns;
	
	
BEGIN

  
	-- Instantiate the Unit Under Test (UUT)
   uut: Processeur PORT MAP (
          CLK_Proc => CLK_Proc,
          RST_Proc => RST_Proc,
          QA => QA,
          QB => QB,
          --sortie => sortie,
			 Test_ip => Test_ip
        );

   -- Clock process definitions
   CLK_Proc_process :process
   begin
		CLK_Proc <= '0';
		wait for CLK_Proc_period/2;
		CLK_Proc <= '1';
		wait for CLK_Proc_period/2;
   end process;
		


   -- Stimulus process
   stim_proc: process
   begin		

      wait for 100 ns;	
		RST_Proc <= '1' after 20 ns ;
		Test_ip<= x"01" after 200 ns , x"02" after 300 ns , x"03" after 400 ns , x"04" after 500 ns , x"05" after 600 ns;
      

      wait;
   end process;

END;
