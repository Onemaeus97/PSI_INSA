--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   14:35:33 04/16/2021
-- Design Name:   
-- Module Name:   /home/karaoud/Documents/4-ir/sysinfo/compilo3/PSI_INSA/CPU-RISC/Data_Memory_TEST.vhd
-- Project Name:  CPU-RISC
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Data_Memory
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
 
ENTITY Data_Memory_TEST IS
END Data_Memory_TEST;
 
ARCHITECTURE behavior OF Data_Memory_TEST IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Data_Memory
    PORT(
         adr : IN  std_logic_vector(7 downto 0);
         IN_port : IN  std_logic_vector(7 downto 0);
         OUT_port : OUT  std_logic_vector(31 downto 0);
         RW : IN  std_logic;
         RST : IN  std_logic;
         CLK : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal adr : std_logic_vector(7 downto 0) := (others => '0');
   signal IN_port : std_logic_vector(7 downto 0) := (others => '0');
   signal RW : std_logic := '0';
   signal RST : std_logic := '0';
   signal CLK : std_logic := '0';

 	--Outputs
   signal OUT_port : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Data_Memory PORT MAP (
          adr => adr,
          IN_port => IN_port,
          OUT_port => OUT_port,
          RW => RW,
          RST => RST,
          CLK => CLK
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

     
          adr <= "11100001";
          IN_port <="11110000", "00001111" after 250 ns;
          RW <='0', '1' after 250 ns;
          DATA<="11111111", "01010101" after 300 ns;
          RST <= '0', '1' after 20 ns;
	   

      wait;
   end process;

END;
