library IEEE;
 use IEEE.STD_LOGIC_1164.ALL;
 use IEEE.NUMERIC_STD.ALL;
 
 
 library work;
  use work.MPC_globals.all;



entity rreg is
  port ( clk : in std_logic;
          d : in std_logic_vector(7 downto 0);
          q : out std_logic_vector(7 downto 0)
  		) ;
end entity ;
 
architecture Behavioral of rreg is
 
	signal d_reg : std_logic_vector(7 downto 0);

begin

	q <= d_reg;

	seq : process(clk)
		begin 
			if(rising_edge(clk)) then 
				d_reg <= d;
			end if;
		end process;


end Behavioral ;