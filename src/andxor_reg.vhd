library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.NUMERIC_STD.ALL;
 
 
 library work;
  use work.MPC_globals.all;


 entity andxor_reg is
   port ( clk : in std_logic;
          x : in std_logic_vector(7 downto 0);
          y : in std_logic_vector(7 downto 0);
          r : in std_logic_vector(7 downto 0);
          z : out std_logic_vector(7 downto 0)
   ) ;
 end entity ;
  
 architecture Behavioral of andxor_reg is

  component GF_mult_8
    port(
      poly_a   : in  std_logic_vector(7 downto 0);
      poly_b   : in  std_logic_vector(7 downto 0);
      mult_poly : out std_logic_vector(7 downto 0)  
    );
  end component;

  signal xy : std_logic_vector(7 downto 0);
 	signal z_next, z_reg : std_logic_vector(7 downto 0);
 
 
 begin

  get_xy : GF_mult_8 port map(poly_a => x, poly_b => y, mult_poly => xy);
 	z_next <= xy xor r;

 	z <= z_reg;


 	seq : process(clk)
	begin 
		if(rising_edge(clk)) then 
			z_reg <= z_next;
		end if;
	end process;
 
 
 end Behavioral ;