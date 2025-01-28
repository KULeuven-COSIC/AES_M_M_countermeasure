library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
 use work.MPC_globals.all;

entity Aff_with_tag is
  port (
    clk : in std_logic;
    x : in shared_value_tag;
    alpha : in shared_value;
    M : in shared_matrix;
    r : in random;
    x_Aff : out shared_value_tag
  );
end Aff_with_tag;

architecture Behavioral of Aff_with_tag is 

  component Lin_unshared 
    Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
           x_Lin : out  STD_LOGIC_VECTOR (7 downto 0)
           );
  end component;
  
  component Aff_unshared 
    Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
           x_Aff : out  STD_LOGIC_VECTOR (7 downto 0)
           );
  end component;
  
  component shared_matmult_3 is
      Port ( clk : in std_logic;
             x : in  shared_value;
             M : in  shared_matrix;
             r : in random;
             z : out  shared_value 
             );
  end component;
  
  component GF_mult_8
  	port(
  		poly_a 	 : in  std_logic_vector(7 downto 0);
  		poly_b 	 : in  std_logic_vector(7 downto 0);
  		mult_poly : out std_logic_vector(7 downto 0)	
  	);
  end component;

  component alpha_constant
  port ( alpha : in std_logic_vector(7 downto 0);
       const_tag : out  std_logic_vector(7 downto 0) 
  ) ;
  end component ;
  
  signal x_Lin_tag : shared_value;
  
  signal x_Aff_value_next, x_Aff_value_reg : shared_value;
  
  signal aff_alpha : shared_value;

begin 
  
  -- Apply affine transform to values (affine to share 0 and linear to the rest) (no registers)
  share_0 : Aff_unshared port map( x => x.v(0), x_Aff => x_Aff_value_next(0));
  genshares : for I in 1 to D-1 generate 
    share_i : Lin_unshared port map( x=> x.v(I), x_Lin => x_Aff_value_next(I));
  end generate;
  
  -- Perform matrix multiplication for tags  (takes one cycle)
  lin_tag : shared_matmult_3 port map(clk => clk, x => x.t, M => M, r => r, z => x_Lin_tag ); 

  -- multiply affine constant with alpha 
  get_aff_alph : for I in 0 to D-1 generate 
    aff_alph_i : alpha_constant port map(alpha => alpha(I), const_tag => aff_alpha(I));
  end generate;

  -- add affine constant 
  gentags : for I in 0 to D-1 generate 
    x_Aff.t(I) <= x_Lin_tag(I) xor aff_alpha(I);
  end generate;
  
  x_Aff.v <= x_Aff_value_reg;
  
  sequential : process(clk)
	begin
		if (rising_edge(clk)) then
			x_Aff_value_reg <= x_Aff_value_next;
		end if;
	end process;

end Behavioral;