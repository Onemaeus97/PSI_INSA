-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY testbench IS
  END testbench;

  ARCHITECTURE behavior OF testbench IS 

  -- Component Declaration
          


COMPONENT Processeur is
    Port ( CLK_Proc : in  STD_LOGIC;
           RST_Proc : in  STD_LOGIC;
			  QA: out STD_LOGIC_VECTOR (7 downto 0);
			  QB: out STD_LOGIC_VECTOR (7 downto 0);
			  sortie : out  STD_LOGIC
			  
			  );
end COMPONENT;


  BEGIN

  

  --  Test Bench Statements
     tb : PROCESS
     BEGIN

        wait for 100 ns; -- wait until global set/reset completes

        -- Add user defined stimulus here

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
