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
			  QB: out STD_LOGIC_VECTOR (7 downto 0);
			  sortie : out  STD_LOGIC
			  
			  );
end Processeur;

architecture Behavioral of processeur is

	component ALU
		Port (	A : in  STD_LOGIC_VECTOR (7 downto 0):= "00000000";
           B : in  STD_LOGIC_VECTOR (7 downto 0):= "00000000";
           N : out  STD_LOGIC;
           O : out  STD_LOGIC;
           Z : out  STD_LOGIC;
           C : out  STD_LOGIC;
           S : out  STD_LOGIC_VECTOR (7 downto 0):="00000000";
           Ctrl_ALU : in  STD_LOGIC_VECTOR (2 downto 0) := "000");
	end component;


	component Data_Memory
		 Port (	adr : in  STD_LOGIC_VECTOR (7 downto 0) := "00000000";
					IN_port : in  STD_LOGIC_VECTOR (7 downto 0):= "00000000";
					OUT_port : out  STD_LOGIC_VECTOR(31 downto 0);
					RW : in  STD_LOGIC :='0';
					RST : in  STD_LOGIC ;
					CLK : in  STD_LOGIC);
	end component;
	
	component Instr_Memory
		 Port ( 	adr : in  STD_LOGIC_VECTOR (7 downto 0);
				   OUT_port : out  STD_LOGIC_VECTOR(31 downto 0);
               CLK : in  STD_LOGIC);
	end component;
	
	component Pipeline
		 Port ( CLK : in  STD_LOGIC;
				  inA : in  STD_LOGIC_VECTOR (7 downto 0);
				  inB : in  STD_LOGIC_VECTOR (7 downto 0);
				  inC : in  STD_LOGIC_VECTOR (7 downto 0);
				  inOP : in  STD_LOGIC_VECTOR (7 downto 0);
				  outOP : out  STD_LOGIC_VECTOR (7 downto 0);
				  outA : out  STD_LOGIC_VECTOR (7 downto 0);
				  outB : out  STD_LOGIC_VECTOR (7 downto 0);
				  outC : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	component Register_bank
		Port (  A_adr : in  STD_LOGIC_VECTOR(3 downto 0) := "0000";
				  B_adr : in  STD_LOGIC_VECTOR (3 downto 0) := "0000";
				  W_adr : in  STD_LOGIC_VECTOR (3 downto 0);
				  W : in  STD_LOGIC;
				  DATA : in  STD_LOGIC_VECTOR (7 downto 0);
				  RST : in  STD_LOGIC;
				  CLK : in  STD_LOGIC;
				  QA : out  STD_LOGIC_VECTOR (7 downto 0);
				  QB : out  STD_LOGIC_VECTOR (7 downto 0));
	end component;
	
	
---------------signaux------------------

	--Pipeline
	type PL is record
		OP: STD_LOGIC_VECTOR(7 downto 0);
		A: STD_LOGIC_VECTOR(7 downto 0);
		B: STD_LOGIC_VECTOR(7 downto 0);
		C: STD_LOGIC_VECTOR(7 downto 0);
	end record;
	signal LI_DI_DI_EX: PL;
	signal DI_EX_EX_MEM: PL;
	signal EX_MEM_MEM_RE: PL;
	signal MEM_RE_OUT: PL;
	
	-- LC
	signal DI_EX_LC_EX_MEM: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal MEM_RE_LC_OUT: std_logic;
	
		--MemoireInstruction
	signal INPUT_ADDR : STD_LOGIC_VECTOR (7 downto 0):=x"00";
	signal INSTR : STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	--BancDeRegistre
	signal REG_QA, REG_QB : STD_LOGIC_VECTOR (7 downto 0);
	
	--ALU
	signal ALU_CTRL : STD_LOGIC_VECTOR(2 downto 0);
	signal ALU_N, ALU_O, ALU_Z, ALU_C : STD_LOGIC;
	signal ALU_S : STD_LOGIC_VECTOR (7 downto 0);
	
	
	signal MemD_OUT: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	signal IP: STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');--current line

	
	
	
begin
	QA<= REG_QA;
	QB<= REG_QB;
	
	
	IM : Instr_Memory PORT MAP (
		adr => INPUT_ADDR,
		CLK => CLK_PROC,
		OUT_port => INSTR
	);
	
	LI_DI :  Pipeline PORT MAP (
			CLK => CLK_PROC,
			inA => INSTR(23 downto 16),
			inB => INSTR(15 downto 8),
			inC => INSTR(7 downto 0),
			--inC => open,
			inOP => INSTR(31 downto 24),
			outOP => LI_DI_DI_EX.OP,
			outA => LI_DI_DI_EX.A,
			outB => LI_DI_DI_EX.B,
			outC => LI_DI_DI_EX.C
	);
	
	DI_EX :  Pipeline PORT MAP (
			CLK => CLK_PROC,
			inA => LI_DI_DI_EX.A,
			inB => LI_DI_DI_EX.B,
			inC => LI_DI_DI_EX.C,
			inOP => LI_DI_DI_EX.OP,
			outOP => DI_EX_EX_MEM.OP,
			outA => DI_EX_EX_MEM.A,
			outB => DI_EX_EX_MEM.B,
			outC => DI_EX_EX_MEM.C
	);
	
	EX_Mem :  Pipeline PORT MAP (
			CLK => CLK_PROC,
			inA => DI_EX_EX_MEM.A,
			inB => DI_EX_EX_MEM.B,
			inC => DI_EX_EX_MEM.C,
			inOP => DI_EX_EX_MEM.OP,
			outOP => EX_MEM_MEM_RE.OP,
			outA => EX_MEM_MEM_RE.A,
			outB => EX_MEM_MEM_RE.B,
			outC => EX_MEM_MEM_RE.C
	);
	
	Mem_RE :  Pipeline PORT MAP (
			CLK => CLK_PROC,
			inA => EX_MEM_MEM_RE.A,
			inB => EX_MEM_MEM_RE.B,
			inC => EX_MEM_MEM_RE.C,
			inOP =>  EX_MEM_MEM_RE.OP,
			outOP => MEM_RE_OUT.OP,
			outA => MEM_RE_OUT.A,
			outB => MEM_RE_OUT.B,
			outC => MEM_RE_OUT.C
	);
	
	BdR : Register_bank PORT MAP (
			A_adr => open,
			B_adr => open,		
			W_adr => MEM_RE_OUT.A(3 downto 0),
			W => MEM_RE_LC_OUT,
			DATA => MEM_RE_OUT.B,
			RST => RST_PROC,
			CLK=> CLK_PROC,
			QA =>open,
			QB => open
	);	
	
	ALU_Map : ALU PORT MAP (
			A => open,
			B => open,
			N => open,
			O => open,
			Z => open,
			C => open,
			S => open,
			CTRL_ALU => open
	);	
	
	MemD : Data_Memory PORT MAP (
		adr => open,
		IN_port => open,
		OUT_port => open,
		RW => open,
		RST => RST_PROC,
		CLK => CLK_PROC
	
	);
	

end Behavioral;

