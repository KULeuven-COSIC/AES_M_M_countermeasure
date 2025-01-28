
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RConst is 
  port(clk, rst, enable : in  std_logic; 
        Rcon : out std_logic_vector(7 downto 0)); 
end RConst; 

architecture archi of RConst is 
  signal lfsr_reg: std_logic_vector(7 downto 0); 
  signal lfsr_next : std_logic_vector(7 downto 0);
  
  begin 
    lfsr_next(0) <= lfsr_reg(7);
    lfsr_next(1) <= lfsr_reg(0) xor lfsr_reg(7);
    lfsr_next(2) <= lfsr_reg(1);
    lfsr_next(3) <= lfsr_reg(2) xor lfsr_reg(7);
    lfsr_next(4) <= lfsr_reg(3) xor lfsr_reg(7);
    lfsr_next(5) <= lfsr_reg(4);
    lfsr_next(6) <= lfsr_reg(5);
    lfsr_next(7) <= lfsr_reg(6);
	 
    process (clk) 
      begin 
			if (rising_edge(clk)) then
				if(rst = '1') then 
					lfsr_reg <= x"8d"; 
				elsif (enable = '1') then
					lfsr_reg <= lfsr_next;
				end if;
        end if; 
	 end process; 
	 
	 RCon <= lfsr_reg;
	 
end archi;

