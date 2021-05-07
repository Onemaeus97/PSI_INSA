-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          COMPONENT Processeur
          PORT(
                  CLK_Proc : in  STD_LOGIC;
					  RST_Proc : in  STD_LOGIC;
					  QA: out STD_LOGIC_VECTOR (7 downto 0);
					  QB: out STD_LOGIC_VECTOR (7 downto 0);
					  sortie : out  STD_LOGIC
                  );
          END COMPONENT;
  --Inputs
   signal CLK_Proc : STD_LOGIC := '0';
   signal RST_Proc : STD_LOGIC := '1';

 	--Outputs
   signal QB : std_logic_vector(7 downto 0) ;
	signal QA : std_logic_vector(7 downto 0) ;
   signal sortie : STD_LOGIC ;
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
	-- Clock period definitions
   constant CLK_Proc_period : time := 10 ns;

  BEGIN

  -- Component Instantiation
           uut: Processeur PORT MAP (
         CLK_Proc => CLK_Proc,
			RST_Proc => RST_Proc,
			QA => QA,
			QB => QB
			--sortie => sortie
        );


  --  Test Bench Statements
     tb : PROCESS
     BEGIN

        wait for 100 ns; -- wait until global set/reset completes

        -- Add user defined stimulus here

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
