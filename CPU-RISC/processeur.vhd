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
			  --sortie : out  STD_LOGIC ;
			  Test_ip : in  STD_LOGIC_VECTOR (7 downto 0)
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
					OUT_port : out  STD_LOGIC_VECTOR(7 downto 0);
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
	signal EX_MEM_LC_MEM_RE: std_logic;
	--MUX
	signal LI_DI_MUX_DI_EX: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal DI_EX_MUX_EX_MEM: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal MemD_OUT_MUX_MEM_RE: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal EX_MEM_MUX_MemD_IN: STD_LOGIC_VECTOR(7 DOWNTO 0);
	--Instruction Memory
	signal INPUT_ADDR : STD_LOGIC_VECTOR (7 downto 0):=x"00";
	signal INSTR : STD_LOGIC_VECTOR(31 DOWNTO 0);
	--Register Bank
	signal REG_QA, REG_QB : STD_LOGIC_VECTOR (7 downto 0);
	
	--ALU
	signal ALU_CTRL : STD_LOGIC_VECTOR(2 downto 0);
	signal ALU_N, ALU_O, ALU_Z, ALU_C : STD_LOGIC;
	signal ALU_S : STD_LOGIC_VECTOR (7 downto 0);
	
	
	signal MemD_OUT: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	signal IP: STD_LOGIC_VECTOR(7 downto 0) := (others=>'0');--current line

	
	
	
begin
	--MUX 
	LI_DI_MUX_DI_EX <= LI_DI_DI_EX.B when LI_DI_DI_EX.OP = x"06" or LI_DI_DI_EX.OP = x"07" else REG_QA;
	DI_EX_MUX_EX_MEM <= ALU_S when DI_EX_EX_MEM.OP = x"01" or DI_EX_EX_MEM.OP = x"02" or DI_EX_EX_MEM.OP = x"03" else DI_EX_EX_MEM.B;
	--Store
	EX_MEM_MUX_MemD_IN <= EX_MEM_MEM_RE.A when EX_MEM_MEM_RE.OP = x"08" else EX_MEM_MEM_RE.B;
	MemD_OUT_MUX_MEM_RE <= MemD_OUT when EX_MEM_MEM_RE.OP = x"07" else EX_MEM_MEM_RE.B;
	--LC
	DI_EX_LC_EX_MEM <= DI_EX_EX_MEM.OP(2 DOWNTO 0);
	EX_MEM_LC_MEM_RE <= '0' when EX_MEM_MEM_RE.OP = x"08" else '1';
	MEM_RE_LC_OUT  <= '1' when MEM_RE_OUT.OP = x"06" or  MEM_RE_OUT.OP = x"05"or MEM_RE_OUT.OP = x"07"or MEM_RE_OUT.OP=x"01" or MEM_RE_OUT.OP=x"02" or MEM_RE_OUT.OP=x"03" else '0';
	QA<= REG_QA;
	QB<= REG_QB;
	--use to do the test
	INPUT_ADDR <= Test_ip ; 
	
	
	
	
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
			inOP => INSTR(31 downto 24),
			outOP => LI_DI_DI_EX.OP,
			outA => LI_DI_DI_EX.A,
			outB => LI_DI_DI_EX.B,
			outC => LI_DI_DI_EX.C
	);
	
	DI_EX :  Pipeline PORT MAP (
			CLK => CLK_PROC,
			inA => LI_DI_DI_EX.A,
			inB => LI_DI_MUX_DI_EX,
			inC => REG_QB,
			inOP => LI_DI_DI_EX.OP,
			outOP => DI_EX_EX_MEM.OP,
			outA => DI_EX_EX_MEM.A,
			outB => DI_EX_EX_MEM.B,
			outC => DI_EX_EX_MEM.C
	);
	
	EX_Mem :  Pipeline PORT MAP (
			CLK => CLK_PROC,
			inA => DI_EX_EX_MEM.A,
			inB => DI_EX_MUX_EX_MEM,
			--bien peut etre vide
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
			--inB => EX_MEM_MEM_RE.B,
			inB => MemD_OUT_MUX_MEM_RE,
			inC => EX_MEM_MEM_RE.C,
			inOP =>  EX_MEM_MEM_RE.OP,
			outOP => MEM_RE_OUT.OP,
			outA => MEM_RE_OUT.A,
			outB => MEM_RE_OUT.B,
			outC => MEM_RE_OUT.C
	);
	
	RB : Register_bank PORT MAP (
			A_adr => LI_DI_DI_EX.B(3 downto 0),
			B_adr => LI_DI_DI_EX.C(3 downto 0),		
			W_adr => MEM_RE_OUT.A(3 downto 0),
			W => MEM_RE_LC_OUT,
			DATA => MEM_RE_OUT.B,
			RST => RST_PROC,
			CLK=> CLK_PROC,
			QA =>REG_QA,
			QB => REG_QB
	);	
	
	mALU : ALU PORT MAP (
			A => DI_EX_EX_MEM.B,
			B => DI_EX_EX_MEM.C,
			N => ALU_N,
			O => ALU_O,
			Z => ALU_Z,
			C => ALU_C,
			S => ALU_S,
			CTRL_ALU => DI_EX_LC_EX_MEM
	);	
	
	DataM : Data_Memory PORT MAP (
		adr => EX_MEM_MUX_MemD_IN,
		IN_port => EX_MEM_MEM_RE.B,
		OUT_port => MemD_OUT,
		RW => EX_MEM_LC_MEM_RE,
		RST => RST_PROC,
		CLK => CLK_PROC
	
	);
	
	Gest_Alea: process
   begin		
      wait until CLK_Proc'event and CLK_Proc ='1';
			if LI_DI_DI_EX.OP = x"06" and INSTR(31 downto 24) = x"05" and LI_DI_DI_EX.A = INSTR(15 downto 8)
			then 
			end if;
   end process Gest_Alea;
	
	

end Behavioral;

