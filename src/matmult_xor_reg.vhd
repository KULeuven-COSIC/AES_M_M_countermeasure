library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.NUMERIC_STD.ALL;
 
 
 library work;
  use work.MPC_globals.all;


 entity matmult_xor_reg is
   port ( clk : in std_logic;
          v : in std_logic_vector(7 downto 0);
          M : in matrix;
          r : in std_logic_vector(7 downto 0);
          z : out std_logic_vector(7 downto 0)
   ) ;
 end entity ;
  
 architecture Behavioral of matmult_xor_reg is

  component MatMult
    port (
      v : in std_logic_vector(7 downto 0);
      M : in matrix;
      Mv : out std_logic_vector(7 downto 0)
    );
  end component;

  signal Mv : std_logic_vector(7 downto 0);
 	signal z_next, z_reg : std_logic_vector(7 downto 0);
 
 
 begin

  get_xy : MatMult port map(v => v, M => M, Mv => Mv);
 	z_next <= Mv xor r;

 	z <= z_reg;


 	seq : process(clk)
	begin 
		if(rising_edge(clk)) then 
			z_reg <= z_next;
		end if;
	end process;
 
 
 end Behavioral ;