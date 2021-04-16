--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:22:11 04/16/2021
-- Design Name:   
-- Module Name:   /home/karaoud/Documents/4-ir/sysinfo/compilo3/PSI_INSA/CPU-RISC/Register_bank_TEST.vhd
-- Project Name:  CPU-RISC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Register_bank
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
 
ENTITY Register_bank_TEST IS
END Register_bank_TEST;
 
ARCHITECTURE behavior OF Register_bank_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Register_bank
    PORT(
         A_adr : IN  std_logic_vector(3 downto 0);
         B_adr : IN  std_logic_vector(3 downto 0);
         W_adr : IN  std_logic_vector(3 downto 0);
         W : IN  std_logic;
         DATA : IN  std_logic_vector(7 downto 0);
         RST : IN  std_logic;
         CLK : IN  std_logic;
         QA : OUT  std_logic_vector(7 downto 0);
         QB : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal A_adr : std_logic_vector(3 downto 0) := (others => '0');
   signal B_adr : std_logic_vector(3 downto 0) := (others => '0');
   signal W_adr : std_logic_vector(3 downto 0) := (others => '0');
   signal W : std_logic := '0';
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal QA : std_logic_vector(7 downto 0);
   signal QB : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Register_bank PORT MAP (
          A_adr => A_adr,
          B_adr => B_adr,
          W_adr => W_adr,
          W => W,
          DATA => DATA,
          RST => RST,
          CLK => CLK,
          QA => QA,
          QB => QB
        );

   -- Clock process definitions
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_period*10;


          A_adr <= "1111";
          B_adr <="0000";
          W_adr <="1111";
          W <='0', '1' after 250 ns;
          DATA<="11111111", "01010101" after 300 ns;
          RST <= '0' ;--,'1' after 20 ns;
	   

      wait;
   end process;

END;
