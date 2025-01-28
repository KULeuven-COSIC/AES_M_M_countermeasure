----------------------------------------------------------------------------------
-- Company: 
-- Engineer: COSIC
-- 
-- Create Date:    17:33:44 11/07/2015 
-- Design Name: 
-- Module Name:    S_box_AES_3_9 - Behavioral 
-- Project Name: d+1 Sbox 2nd Order
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity S_box_AES_3_9 is
   Port (	clk : in std_logic;
				Randomness : in std_logic_vector(161 downto 0);
				Is1, Is2, Is3 : in  std_logic_vector(7 downto 0);
				Os1, Os2, Os3 : out std_logic_vector(7 downto 0)
	);
end S_box_AES_3_9;

architecture Behavioral of S_box_AES_3_9 is
	-- Randomness
	signal St2_Randomness : std_logic_vector(35 downto 0);
	signal St3_Randomness : std_logic_vector(17 downto 0);
	signal St4_Randomness : std_logic_vector(35 downto 0);
	signal St5_Randomness : std_logic_vector(71 downto 0);
	
	-- Output Signals
	signal St1_Os1, St1_Os2, St1_Os3 : std_logic_vector(7 downto 0);
	signal St2_Os1, St2_Os2, St2_Os3, St2_Os4, St2_Os5, St2_Os6, St2_Os7, St2_Os8, St2_Os9 : std_logic_vector(3 downto 0);
	signal St3_Os1, St3_Os2, St3_Os3, St3_Os4, St3_Os5, St3_Os6, St3_Os7, St3_Os8, St3_Os9 : std_logic_vector(1 downto 0);
	signal St4_Os1, St4_Os2, St4_Os3, St4_Os4, St4_Os5, St4_Os6, St4_Os7, St4_Os8, St4_Os9 : std_logic_vector(3 downto 0);
	signal St5_Os1, St5_Os2, St5_Os3, St5_Os4, St5_Os5, St5_Os6, St5_Os7, St5_Os8, St5_Os9 : std_logic_vector(7 downto 0);
	
	-- Register Output Signals
	signal St2_Is1, St2_Is2, St2_Is3 : std_logic_vector(7 downto 0);
	signal St3_Is1, St3_Is2, St3_Is3, St3_Is4, St3_Is5, St3_Is6, St3_Is7, St3_Is8, St3_Is9 : std_logic_vector(3 downto 0);
	signal St4_Is1, St4_Is2, St4_Is3, St4_Is4, St4_Is5, St4_Is6, St4_Is7, St4_Is8, St4_Is9 : std_logic_vector(1 downto 0);
	signal St5_Is1, St5_Is2, St5_Is3, St5_Is4, St5_Is5, St5_Is6, St5_Is7, St5_Is8, St5_Is9 : std_logic_vector(3 downto 0);
	signal St6_Is1, St6_Is2, St6_Is3, St6_Is4, St6_Is5, St6_Is6, St6_Is7, St6_Is8, St6_Is9 : std_logic_vector(7 downto 0);
	-- Hull Registers
	signal St3_Is_Top1, St3_Is_Top2, St3_Is_Top3, St3_Is_Bottom1, St3_Is_Bottom2, St3_Is_Bottom3 : std_logic_vector(3 downto 0);  
	signal St4_Is_Top1, St4_Is_Top2, St4_Is_Top3, St4_Is_Bottom1, St4_Is_Bottom2, St4_Is_Bottom3 : std_logic_vector(3 downto 0);
	signal St4_Is_Top_lvl2_1, St4_Is_Top_lvl2_2, St4_Is_Top_lvl2_3 : std_logic_vector(1 downto 0); 
	signal St4_Is_Bottom_lvl2_1, St4_Is_Bottom_lvl2_2, St4_Is_Bottom_lvl2_3 : std_logic_vector(1 downto 0);
	signal St5_Is_Top1, St5_Is_Top2, St5_Is_Top3, St5_Is_Bottom1, St5_Is_Bottom2, St5_Is_Bottom3 : std_logic_vector(3 downto 0); 
	
	-- Recombined Signals
	signal St3_Recombined_Is1, St3_Recombined_Is2, St3_Recombined_Is3 : std_logic_vector(3 downto 0);
	signal St4_Recombined_Is1, St4_Recombined_Is2, St4_Recombined_Is3 : std_logic_vector(1 downto 0);
	signal St4_Recombined_Is1_Inv, St4_Recombined_Is2_Inv, St4_Recombined_Is3_Inv : std_logic_vector(1 downto 0);
	signal St5_Recombined_Is1, St5_Recombined_Is2, St5_Recombined_Is3 : std_logic_vector(3 downto 0);
	signal St6_Recombined_Is1, St6_Recombined_Is2, St6_Recombined_Is3 : std_logic_vector(7 downto 0);
	
	-- Multiplier Inputs
	signal St5_Is1_Top, St5_Is2_Top, St5_Is3_Top, St5_Is1_Bot, St5_Is2_Bot, St5_Is3_Bot : std_logic_vector(7 downto 0);
	signal St4_Recombined_Is_Top1, St4_Recombined_Is_Top2, St4_Recombined_Is_Top3, St4_Recombined_Is_Bottom1, St4_Recombined_Is_Bottom2, St4_Recombined_Is_Bottom3 : std_logic_vector(3 downto 0);
	
	component St4_Concat
		port(
			St4_Is_Top_lvl2_1, St4_Recombined_Is1_Inv : in std_logic_vector(1 downto 0);
			St4_Recombined_Is_Top1 : out std_logic_vector(3 downto 0)
		);
	end component;
	
	component St5_Concat
		port(
			St5_Is_Top1, St5_Recombined_Is1 : in std_logic_vector(3 downto 0);
			St5_Is1_Top : out std_logic_vector(7 downto 0)
		);
	end component;
	
	component Recomb_St3
		port(
			St3_Is1, St3_Is2, St3_Is3 : in std_logic_vector(3 downto 0);
			St3_Recombined_Is1 : out std_logic_vector(3 downto 0)
		);
	end component;
	
	component Recomb_St4
		port(
			St4_Is1, St4_Is2, St4_Is3 : in std_logic_vector(1 downto 0);
			St4_Recombined_Is1 : out std_logic_vector(1 downto 0)
		);
	end component;
	
	component Recomb_St5
		port(
			St5_Is1, St5_Is2, St5_Is3 : in std_logic_vector(3 downto 0);
			St5_Recombined_Is1 : out std_logic_vector(3 downto 0)
		);
	end component;
	
	component Recomb_St6
		port(
			St6_Is1, St6_Is2, St6_Is3 : in std_logic_vector(7 downto 0);
			St6_Recombined_Is1 : out std_logic_vector(7 downto 0)
		);
	end component;
	
	-- 8 bit register
	component Regs_Shares1
		port(
			clk : in std_logic;
			St1_Os1 : in std_logic_vector(7 downto 0);
			St2_Is1 : out std_logic_vector(7 downto 0)
		);
	end component Regs_Shares1;
	-- 4 bit register
	component Regs_Shares2
		port(
			clk : in std_logic;
			St1_Os1 : in std_logic_vector(3 downto 0);
			St2_Is1 : out std_logic_vector(3 downto 0)
		);
	end component Regs_Shares2;
	-- 2 bit register
	component Regs_Shares3
		port(
			clk : in std_logic;
			St1_Os1 : in std_logic_vector(1 downto 0);
			St2_Is1 : out std_logic_vector(1 downto 0)
		);
	end component Regs_Shares3;
	
	component sbox_ph1
		port(	Is1, Is2, Is3  : in std_logic_vector(7 downto 0);
				Os1, Os2, Os3 	: out std_logic_vector(7 downto 0) 
		);
	end component sbox_ph1;
	
	component sbox_ph2
		port(	Randomness : in std_logic_vector(35 downto 0);
				Is1, Is2, Is3 : in std_logic_vector(7 downto 0);
				Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)	
		);
	end component sbox_ph2;
	
	component sbox_ph3
		port(	
		Randomness : in std_logic_vector( 17 downto 0);
		Is1, Is2, Is3 : in std_logic_vector(3 downto 0);
		Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(1 downto 0)
		);
	end component sbox_ph3;
	
	component sbox_ph4
		port(	
		Randomness : in std_logic_vector(35 downto 0);
		Is1_Top, Is2_Top, Is3_Top : in std_logic_vector(3 downto 0);
		Is1_Bot, Is2_Bot, Is3_Bot : in std_logic_vector(3 downto 0);
		Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(3 downto 0)
		);
	end component sbox_ph4;
	
	component sbox_ph5
		port(	
		Randomness : in std_logic_vector(71 downto 0);
		Is1_Top, Is2_Top, Is3_Top : in std_logic_vector(7 downto 0);
		Is1_Bot, Is2_Bot, Is3_Bot : in std_logic_vector(7 downto 0);
		Os1, Os2, Os3, Os4, Os5, Os6, Os7, Os8, Os9 : out std_logic_vector(7 downto 0)
		);
	end component sbox_ph5;
	
	component sbox_ph6
		port(	
		Is1, Is2, Is3	: in std_logic_vector(7 downto 0);
		Os1, Os2, Os3	: out std_logic_vector(7 downto 0)
		);
	end component sbox_ph6;
	
	component Inv_St4
		port( 
		e1 :	in std_logic_vector(1 downto 0);
		f1 :	out std_logic_vector(1 downto 0)
		);		
	end component Inv_St4;
	
begin
	-- Assign Randomness
	St2_Randomness <= Randomness(161 downto 126);
	St3_Randomness <= Randomness(125 downto 108);
	St4_Randomness <= Randomness(107 downto  72);
	St5_Randomness <= Randomness( 71 downto   0);
	
	--
	-- Stage 1
	--
	Stage1_Register_S1 : Regs_Shares1
		port map (clk, St1_Os1, St2_Is1);
	Stage1_Register_S2 : Regs_Shares1
		port map (clk, St1_Os2, St2_Is2);
	Stage1_Register_S3 : Regs_Shares1
		port map (clk, St1_Os3, St2_Is3);	
	Stage1 : sbox_ph1
		port map ( Is1, Is2, Is3, St1_Os1, St1_Os2, St1_Os3 );
	--
	-- Stage 2
	--
	Stage2 : sbox_ph2
		port map ( St2_Randomness, St2_Is1, St2_Is2, St2_Is3, St2_Os1, St2_Os2, St2_Os3, St2_Os4, St2_Os5, St2_Os6, St2_Os7, St2_Os8, St2_Os9 );
	Stage2_Register_S1 : Regs_Shares2
		port map (clk, St2_Os1, St3_Is1);
	Stage2_Register_S2 : Regs_Shares2
		port map (clk, St2_Os2, St3_Is2);
	Stage2_Register_S3 : Regs_Shares2
		port map (clk, St2_Os3, St3_Is3);
	Stage2_Register_S4 : Regs_Shares2
		port map (clk, St2_Os4, St3_Is4);
	Stage2_Register_S5 : Regs_Shares2
		port map (clk, St2_Os5, St3_Is5);
	Stage2_Register_S6 : Regs_Shares2
		port map (clk, St2_Os6, St3_Is6);
	Stage2_Register_S7 : Regs_Shares2
		port map (clk, St2_Os7, St3_Is7);
	Stage2_Register_S8 : Regs_Shares2
		port map (clk, St2_Os8, St3_Is8);
	Stage2_Register_S9 : Regs_Shares2
		port map (clk, St2_Os9, St3_Is9);
	Stage2_Register_S_Top1 : Regs_Shares2
		port map (clk, St2_Is1(7 downto 4), St3_Is_Top1);
	Stage2_Register_S_Top2 : Regs_Shares2
		port map (clk, St2_Is2(7 downto 4), St3_Is_Top2);
	Stage2_Register_S_Top3 : Regs_Shares2
		port map (clk, St2_Is3(7 downto 4), St3_Is_Top3);
	Stage2_Register_S_Bot1 : Regs_Shares2
		port map (clk, St2_Is1(3 downto 0), St3_Is_Bottom1);
	Stage2_Register_S_Bot2 : Regs_Shares2
		port map (clk, St2_Is2(3 downto 0), St3_Is_Bottom2);
	Stage2_Register_S_Bot3 : Regs_Shares2
		port map (clk, St2_Is3(3 downto 0), St3_Is_Bottom3);
	--
	-- Stage 3
	--
	Stage3_Recombination1 : Recomb_St3
		port map (St3_Is1, St3_Is2, St3_Is3, St3_Recombined_Is1);
	Stage3_Recombination2 : Recomb_St3
		port map (St3_Is4, St3_Is5, St3_Is6, St3_Recombined_Is2);
	Stage3_Recombination3 : Recomb_St3
		port map (St3_Is7, St3_Is8, St3_Is9, St3_Recombined_Is3);
	
	Stage3 : sbox_ph3
		port map ( St3_Randomness, St3_Recombined_Is1, St3_Recombined_Is2, St3_Recombined_Is3, St3_Os1, St3_Os2, St3_Os3, St3_Os4, St3_Os5, St3_Os6, St3_Os7, St3_Os8, St3_Os9);
	Stage3_Register_S1 : Regs_Shares3
		port map (clk, St3_Os1, St4_Is1);
	Stage3_Register_S2 : Regs_Shares3
		port map (clk, St3_Os2, St4_Is2);
	Stage3_Register_S3 : Regs_Shares3
		port map (clk, St3_Os3, St4_Is3);
	Stage3_Register_S4 : Regs_Shares3
		port map (clk, St3_Os4, St4_Is4);
	Stage3_Register_S5 : Regs_Shares3
		port map (clk, St3_Os5, St4_Is5);
	Stage3_Register_S6 : Regs_Shares3
		port map (clk, St3_Os6, St4_Is6);
	Stage3_Register_S7 : Regs_Shares3
		port map (clk, St3_Os7, St4_Is7);
	Stage3_Register_S8 : Regs_Shares3
		port map (clk, St3_Os8, St4_Is8);
	Stage3_Register_S9 : Regs_Shares3
		port map (clk, St3_Os9, St4_Is9);

	Stage3_Register_S_Top1 : Regs_Shares2
		port map (clk, St3_Is_Top1, St4_Is_Top1);
	Stage3_Register_S_Top2 : Regs_Shares2
		port map (clk, St3_Is_Top2, St4_Is_Top2);
	Stage3_Register_S_Top3 : Regs_Shares2
		port map (clk, St3_Is_Top3, St4_Is_Top3);
	Stage3_Register_S_Bot1 : Regs_Shares2
		port map (clk, St3_Is_Bottom1, St4_Is_Bottom1);
	Stage3_Register_S_Bot2 : Regs_Shares2
		port map (clk, St3_Is_Bottom2, St4_Is_Bottom2);
	Stage3_Register_S_Bot3 : Regs_Shares2
		port map (clk, St3_Is_Bottom3, St4_Is_Bottom3);

	Stage3_Register_S_Top_lvl2_1 : Regs_Shares3
		port map (clk, St3_Recombined_Is1(3 downto 2), St4_Is_Top_lvl2_1);
	Stage3_Register_S_Top_lvl2_2 : Regs_Shares3
		port map (clk, St3_Recombined_Is2(3 downto 2), St4_Is_Top_lvl2_2);
	Stage3_Register_S_Top_lvl2_3 : Regs_Shares3
		port map (clk, St3_Recombined_Is3(3 downto 2), St4_Is_Top_lvl2_3);
	Stage3_Register_S_Bot_lvl2_1 : Regs_Shares3
		port map (clk, St3_Recombined_Is1(1 downto 0), St4_Is_Bottom_lvl2_1);
	Stage3_Register_S_Bot_lvl2_2 : Regs_Shares3
		port map (clk, St3_Recombined_Is2(1 downto 0), St4_Is_Bottom_lvl2_2);
	Stage3_Register_S_Bot_lvl2_3 : Regs_Shares3
		port map (clk, St3_Recombined_Is3(1 downto 0), St4_Is_Bottom_lvl2_3);
	--
	-- Stage 4
	--
--	St4_Concat1_S1 : St4_Concat
--		port map (St4_Is_Top_lvl2_1, St4_Recombined_Is1_Inv, St4_Recombined_Is_Top1);
--	St4_Concat2_S1 : St4_Concat
--		port map (St4_Is_Bottom_lvl2_1, St4_Recombined_Is1_Inv, St4_Recombined_Is_Bottom1);
--	St4_Concat1_S2 : St4_Concat
--		port map (St4_Is_Top_lvl2_2, St4_Recombined_Is2_Inv, St4_Recombined_Is_Top2);
--	St4_Concat2_S2 : St4_Concat
--		port map (St4_Is_Bottom_lvl2_2, St4_Recombined_Is2_Inv, St4_Recombined_Is_Bottom2);
--	St4_Concat1_S3 : St4_Concat
--		port map (St4_Is_Top_lvl2_3, St4_Recombined_Is3_Inv, St4_Recombined_Is_Top3);
--	St4_Concat2_S3 : St4_Concat
--		port map (St4_Is_Bottom_lvl2_3, St4_Recombined_Is3_Inv, St4_Recombined_Is_Bottom3);
	St4_Recombined_Is_Top1 <= St4_Is_Top_lvl2_1 & St4_Recombined_Is1_Inv;
	St4_Recombined_Is_Bottom1 <= St4_Is_Bottom_lvl2_1 & St4_Recombined_Is1_Inv;
	
	St4_Recombined_Is_Top2 <= St4_Is_Top_lvl2_2 & St4_Recombined_Is2_Inv;
	St4_Recombined_Is_Bottom2 <= St4_Is_Bottom_lvl2_2 & St4_Recombined_Is2_Inv;
	
	St4_Recombined_Is_Top3 <= St4_Is_Top_lvl2_3 & St4_Recombined_Is3_Inv;
	St4_Recombined_Is_Bottom3 <= St4_Is_Bottom_lvl2_3 & St4_Recombined_Is3_Inv;
	
	
	Stage4_Recombination1 : Recomb_St4
		port map (St4_Is1, St4_Is2, St4_Is3, St4_Recombined_Is1);
	Stage4_Recombination2 : Recomb_St4
		port map (St4_Is4, St4_Is5, St4_Is6, St4_Recombined_Is2);
	Stage4_Recombination3 : Recomb_St4
		port map (St4_Is7, St4_Is8, St4_Is9, St4_Recombined_Is3);
--	Stage4_Inversion1 : Inv_St4
--		port map (St4_Recombined_Is1, St4_Recombined_Is1_Inv);
--	Stage4_Inversion2 : Inv_St4
--		port map (St4_Recombined_Is2, St4_Recombined_Is2_Inv);
--	Stage4_Inversion3 : Inv_St4
--		port map (St4_Recombined_Is3, St4_Recombined_Is3_Inv);
	St4_Recombined_Is1_Inv <= St4_Recombined_Is1(0) & St4_Recombined_Is1(1);
	St4_Recombined_Is2_Inv <= St4_Recombined_Is2(0) & St4_Recombined_Is2(1);
	St4_Recombined_Is3_Inv <= St4_Recombined_Is3(0) & St4_Recombined_Is3(1);
	
	Stage4 : sbox_ph4
		port map ( St4_Randomness, 
						St4_Recombined_Is_Top1, St4_Recombined_Is_Top2, St4_Recombined_Is_Top3, 
						St4_Recombined_Is_Bottom1, St4_Recombined_Is_Bottom2, St4_Recombined_Is_Bottom3, 
						St4_Os1, St4_Os2, St4_Os3, 
						St4_Os4, St4_Os5, St4_Os6, 
						St4_Os7, St4_Os8, St4_Os9);
	Stage4_Register_S1 : Regs_Shares2
		port map (clk, St4_Os1, St5_Is1);
	Stage4_Register_S2 : Regs_Shares2
		port map (clk, St4_Os2, St5_Is2);
	Stage4_Register_S3 : Regs_Shares2
		port map (clk, St4_Os3, St5_Is3);
	Stage4_Register_S4 : Regs_Shares2
		port map (clk, St4_Os4, St5_Is4);
	Stage4_Register_S5 : Regs_Shares2
		port map (clk, St4_Os5, St5_Is5);
	Stage4_Register_S6 : Regs_Shares2
		port map (clk, St4_Os6, St5_Is6);
	Stage4_Register_S7 : Regs_Shares2
		port map (clk, St4_Os7, St5_Is7);
	Stage4_Register_S8 : Regs_Shares2
		port map (clk, St4_Os8, St5_Is8);
	Stage4_Register_S9 : Regs_Shares2
		port map (clk, St4_Os9, St5_Is9);
	
	Stage4_Register_S_Top1 : Regs_Shares2
		port map (clk, St4_Is_Top1, St5_Is_Top1);
	Stage4_Register_S_Top2 : Regs_Shares2
		port map (clk, St4_Is_Top2, St5_Is_Top2);
	Stage4_Register_S_Top3 : Regs_Shares2
		port map (clk, St4_Is_Top3, St5_Is_Top3);
	Stage4_Register_S_Bot1 : Regs_Shares2
		port map (clk, St4_Is_Bottom1, St5_Is_Bottom1);
	Stage4_Register_S_Bot2 : Regs_Shares2
		port map (clk, St4_Is_Bottom2, St5_Is_Bottom2);
	Stage4_Register_S_Bot3 : Regs_Shares2
		port map (clk, St4_Is_Bottom3, St5_Is_Bottom3);
	--
	-- Stage 5
	--
--	St5_Concat1_S1 : St5_Concat
--		port map (St5_Is_Top1, St5_Recombined_Is1, St5_Is1_Top);
--	St5_Concat2_S1 : St5_Concat
--		port map (St5_Is_Bottom1, St5_Recombined_Is1, St5_Is1_Bot);
--	St5_Concat1_S2 : St5_Concat
--		port map (St5_Is_Top2, St5_Recombined_Is2, St5_Is2_Top);
--	St5_Concat2_S2 : St5_Concat
--		port map (St5_Is_Bottom2, St5_Recombined_Is2, St5_Is2_Bot);
--	St5_Concat1_S3 : St5_Concat
--		port map (St5_Is_Top3, St5_Recombined_Is3, St5_Is3_Top);
--	St5_Concat2_S3 : St5_Concat
--		port map (St5_Is_Bottom3, St5_Recombined_Is3, St5_Is3_Bot);
		
		
	St5_Is1_Top <= St5_Is_Top1 & St5_Recombined_Is1;
	St5_Is1_Bot <= St5_Is_Bottom1 & St5_Recombined_Is1;	
	St5_Is2_Top <= St5_Is_Top2 & St5_Recombined_Is2;
	St5_Is2_Bot <= St5_Is_Bottom2 & St5_Recombined_Is2;	
	St5_Is3_Top <= St5_Is_Top3 & St5_Recombined_Is3;
	St5_Is3_Bot <= St5_Is_Bottom3 & St5_Recombined_Is3;	
		
	Stage5_Recombination1 : Recomb_St5
		port map (St5_Is1, St5_Is2, St5_Is3, St5_Recombined_Is1);
	Stage5_Recombination2 : Recomb_St5
		port map (St5_Is4, St5_Is5, St5_Is6, St5_Recombined_Is2);
	Stage5_Recombination3 : Recomb_St5
		port map (St5_Is7, St5_Is8, St5_Is9, St5_Recombined_Is3);
	Stage5 : sbox_ph5
		port map ( St5_Randomness, 
						St5_Is1_Top, St5_Is2_Top, St5_Is3_Top,
						St5_Is1_Bot, St5_Is2_Bot, St5_Is3_Bot,
						St5_Os1, St5_Os2, St5_Os3, 
						St5_Os4, St5_Os5, St5_Os6, 
						St5_Os7, St5_Os8, St5_Os9);
	Stage5_Register_S1 : Regs_Shares1
		port map (clk, St5_Os1, St6_Is1);
	Stage5_Register_S2 : Regs_Shares1
		port map (clk, St5_Os2, St6_Is2);
	Stage5_Register_S3 : Regs_Shares1
		port map (clk, St5_Os3, St6_Is3);
	Stage5_Register_S4 : Regs_Shares1
		port map (clk, St5_Os4, St6_Is4);
	Stage5_Register_S5 : Regs_Shares1
		port map (clk, St5_Os5, St6_Is5);
	Stage5_Register_S6 : Regs_Shares1
		port map (clk, St5_Os6, St6_Is6);
	Stage5_Register_S7 : Regs_Shares1
		port map (clk, St5_Os7, St6_Is7);
	Stage5_Register_S8 : Regs_Shares1
		port map (clk, St5_Os8, St6_Is8);
	Stage5_Register_S9 : Regs_Shares1
		port map (clk, St5_Os9, St6_Is9);
	--
	-- Stage 6
	--	No Affine calculation, just base changing		
	Stage6_Recombination1 : Recomb_St6
		port map (St6_Is1, St6_Is2, St6_Is3, St6_Recombined_Is1);
	Stage6_Recombination2 : Recomb_St6
		port map (St6_Is4, St6_Is5, St6_Is6, St6_Recombined_Is2);
	Stage6_Recombination3 : Recomb_St6
		port map (St6_Is7, St6_Is8, St6_Is9, St6_Recombined_Is3);
	Stage6 : sbox_ph6
		port map ( St6_Recombined_Is1, St6_Recombined_Is2, St6_Recombined_Is3, 
						Os1, Os2, Os3);
		




end Behavioral;

