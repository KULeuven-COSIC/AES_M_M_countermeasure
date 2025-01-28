library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.NUMERIC_STD.ALL;
 
 
 library work;
  use work.MPC_globals.all;


 entity shared_reg is
   port ( clk : in std_logic;
         d : in shared_value;
         q : out shared_value
   ) ;
 end entity ;
  
 architecture Behavioral of shared_reg is

 	component rreg 
 		port ( clk : in std_logic;
          d : in std_logic_vector(7 downto 0);
          q : out std_logic_vector(7 downto 0)
  		) ;
 	end component;
 
 begin

 	--regshares : for I in 0 to D-1 generate 
 	--	share_i : rreg port map(clk => clk, d => d(I), q => q(I));
 	--end generate;
	
	share_0 : rreg port map(clk => clk, d => d(0), q => q(0));
	share_1 : rreg port map(clk => clk, d => d(1), q => q(1));
 	share_2 : rreg port map(clk => clk, d => d(2), q => q(2));
 	
 
 
 end Behavioral ;