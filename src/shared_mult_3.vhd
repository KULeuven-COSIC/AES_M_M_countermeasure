library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library work;
 use work.MPC_globals.all;


entity shared_mult_3 is
  port ( clk : in std_logic;
           x : in  shared_value;
           y : in  shared_value;
           r : in random;
           z : out  shared_value 
  ) ;
end entity ;
 
architecture Behavioral of shared_mult_3 is
 
	component TI_mult_3_blocks 
		Port ( clk : in std_logic;
           x : in  shared_value;
           y : in  shared_value;
           r : in random;
           z : out  shared_value 
           );
	end component;

	component DOM_mult_3
		Port ( clk : in std_logic;
           x : in  shared_value;
           y : in  shared_value;
           r : in random;
           z : out  shared_value 
           );
	end component;

begin

	--ti_mult : TI_mult_3_blocks port map(clk => clk, x => x, y => y, r => r, z => z);
	dom_mult : DOM_mult_3 port map(clk => clk, x => x, y => y, r => r, z => z);


end Behavioral ;