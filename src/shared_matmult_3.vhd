library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


library work;
 use work.MPC_globals.all;



 entity shared_matmult_3 is
   Port ( clk : in std_logic;
           x : in  shared_value;
           M : in  shared_matrix;
           r : in random;
           z : out  shared_value 
           );
 end entity ;
  
 architecture Behavioral of shared_matmult_3 is
  
 	component DOM_matmult_3
 		 Port ( clk : in std_logic;
           x : in  shared_value;
           M : in  shared_matrix;
           r : in random;
           z : out  shared_value 
           );
 	end component;

 	component TI_matmult_3_blocks
 		 Port ( clk : in std_logic;
           x : in  shared_value;
           M : in  shared_matrix;
           r : in random;
           z : out  shared_value 
           );
 	end component;
 
 begin
 
 	--ti_mul : TI_matmult_3_blocks port map(clk => clk, x => x, M => M, r => r, z => z);
 	dom_mult : DOM_matmult_3 port map(clk => clk, x => x, M => M, r => r, z => z);
 
 end Behavioral ;