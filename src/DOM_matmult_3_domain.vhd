----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:53:42 02/13/2017 
-- Design Name: 
-- Module Name:    TI_mult_3 - Behavioral 
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


library work;
 use work.MPC_globals.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

--DOM multiplier
--z = (x1+x2+x3)(y1+y2+y3) = x1y1 + x1y2 + x1y3 + x2y1 + x2y2 + x2y3 + x3y1 + x3y2 + x3y3
--z1 = x1y1 + x1y2 + x1y3
--z2 = x2y1 + x2y2 + x2y3
--z3 = x3y1 + x3y2 + x3y3

entity DOM_matmult_3_domain is
    Port ( clk : in std_logic;
           v0 : in  std_logic_vector(7 downto 0);
           M0 : in matrix;
           M1 : in matrix;
           M2 : in matrix;
           r0 : in std_logic_vector(7 downto 0);
           r1 : in std_logic_vector(7 downto 0);
           z0 : out  std_logic_vector(7 downto 0)
           );
end DOM_matmult_3_domain;

architecture Behavioral of DOM_matmult_3_domain is
	
  component matmult_xor_reg
    port ( clk : in std_logic;
          v : in std_logic_vector(7 downto 0);
          M : in matrix;
          r : in std_logic_vector(7 downto 0);
          z : out std_logic_vector(7 downto 0)
   ) ;
  end component;

  signal M1v1, M2v1, M3v1 : std_logic_vector(7 downto 0);

begin
  

  get_M1v1 : matmult_xor_reg port map(clk => clk, v => v0, M => M0, r => (others => '0'), z => M1v1);
  get_M1v2 : matmult_xor_reg port map(clk => clk, v => v0, M => M1, r => r0, z => M2v1);
  get_M1v3 : matmult_xor_reg port map(clk => clk, v => v0, M => M2, r => r1, z => M3v1);

  z0 <= M1v1 xor M2v1 xor M3v1;
	

	
end Behavioral;

