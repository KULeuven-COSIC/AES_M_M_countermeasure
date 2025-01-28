--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:49:42 03/01/2017
-- Design Name:   
-- Module Name:   
-- Project Name:  M&M
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: AES_128_SPDZ
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
library work;
 use work.MPC_globals.all;
 
ENTITY tb_AES_128_CAPA IS
END tb_AES_128_CAPA;
 
ARCHITECTURE behavior OF tb_AES_128_CAPA IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT AES_128_CAPA
			port(
			clk,load	: in  std_logic; 
		rst,start 	: in  std_logic; 
		clk_prng 	: in  std_logic; 
		rst_prng 	: in  std_logic; 
		alpha		: in  shared_value;
    	alpha_inv 	: in  shared_value;
   		M_alpha 	: in  shared_matrix;
		data_in 	: in  shared_value_tag;
		key			: in  shared_value_tag;
    	PRNG_seed 	: in  STD_LOGIC_VECTOR (39 downto 0);
		data_out 	: out shared_value;
    	ready_bits 	: out shared_bit
			);
    END COMPONENT;
    
    component Lin_unshared 
        Port ( x : in  STD_LOGIC_VECTOR (7 downto 0);
               x_Lin : out  STD_LOGIC_VECTOR (7 downto 0)
        );
    end component;
    
    component GF_mult_8
    	port(
    		poly_a 	 : in  std_logic_vector(7 downto 0);
    		poly_b 	 : in  std_logic_vector(7 downto 0);
    		mult_poly : out std_logic_vector(7 downto 0)	
    	);
    end component;
    

   --Inputs
   signal clk, clk_prng : std_logic := '0';
   signal load : std_logic := '0';
   signal rst, rst_prng : std_logic := '0';
   signal start : std_logic := '0';
	signal alpha, alpha_inv : shared_value := (others => (others => '0'));
   signal data_in : shared_value_tag := (others => (others => (others => '0')));
   signal key : shared_value_tag := (others => (others => (others => '0')));
   signal M_alpha : shared_matrix := (others => (others => (others => '0')));
   signal L_input, L_output : matrix;
   signal seed : std_logic_vector(39 downto 0) := (others => '0');
   
   
 	--Outputs
   signal data_out : shared_value;
   signal unsh_out : std_logic_vector(7 downto 0);
   signal ready : shared_bit;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
  unsh_out <= data_out(0) xor data_out(1) xor data_out(2);
  
  -- mac key = 0x05
  alpha(0) <= x"01" xor x"00" xor x"00";
  alpha(1) <= x"00";
  alpha(2) <= x"00";
  
  alpha_inv(0) <= x"01" xor x"00" xor x"00";
  alpha_inv(1) <= x"00";
  alpha_inv(2) <= x"00";
  
  -- generate tag matrix 
  L_input(0) <= alpha_inv(0);
  gen_mult: for I in 1 to 7 generate 
    gen_mult_i: GF_mult_8 port map(poly_a => L_input(I-1), poly_b => x"02", mult_poly => L_input(I) );
  end generate;
  
  lin : for I in 0 to 7 generate 
    lin_i : Lin_unshared port map(x => L_input(I), x_Lin => L_output(I));
  end generate; 
  
  mult_alpha : for I in 0 to 7 generate 
    mult_alpha_i :GF_mult_8 port map(poly_a => L_output(I), poly_b => alpha(0), mult_poly => M_alpha(0)(I));
    M_alpha(1)(I) <= x"00";
    M_alpha(2)(I) <= x"00";
  end generate;
  
  
		
	-- Instantiate the Unit Under Test (UUT)
   uut: AES_128_CAPA PORT MAP (
          clk => clk,
          load => load,
          rst => rst,
			 clk_prng 	=> clk, 
		rst_prng 	=> rst,
			    alpha => alpha,
          alpha_inv => alpha_inv,
          M_alpha => M_alpha,
          start => start,
          data_in => data_in,
          key => key,
          PRNG_seed => seed,
          data_out => data_out,
          ready_bits => ready
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      rst <= '1';
      wait for 100 ns;	
		  rst <= '0';

		-- insert stimulus here 
		load <= '1';
		data_in.v(0) <= x"32";
		key.v(0) <= x"2b";
		data_in.t(0) <= x"32";
		key.t(0) <= x"2b";
		wait for clk_period;
		data_in.v(0) <= x"43";
		key.v(0) <= x"7e";
		data_in.t(0) <= x"43";
		key.t(0) <= x"7e";
		wait for clk_period;
		data_in.v(0) <= x"f6";
		key.v(0) <= x"15";
		data_in.t(0) <= x"f6";
		key.t(0) <= x"15";
		wait for clk_period;
		data_in.v(0) <= x"a8";
		key.v(0) <= x"16";
		data_in.t(0) <= x"a8";
		key.t(0) <= x"16";
		wait for clk_period;
		data_in.v(0) <= x"88";
		key.v(0) <= x"28";
		data_in.t(0) <= x"88";
		key.t(0) <= x"28";
		wait for clk_period;
		data_in.v(0) <= x"5a";
		key.v(0) <= x"ae";
		data_in.t(0) <= x"5a";
		key.t(0) <= x"ae";
		wait for clk_period;
		data_in.v(0) <= x"30";
		key.v(0) <= x"d2";
		data_in.t(0) <= x"30";
		key.t(0) <= x"d2";
		wait for clk_period;
		data_in.v(0) <= x"8d";
		key.v(0) <= x"a6";
		data_in.t(0) <= x"8d";
		key.t(0) <= x"a6";
		wait for clk_period;
		data_in.v(0) <= x"31";
		key.v(0) <= x"ab";
		data_in.t(0) <= x"31";
		key.t(0) <= x"ab";
		wait for clk_period;
		data_in.v(0) <= x"31";
		key.v(0) <= x"f7";
		data_in.t(0) <= x"31";
		key.t(0) <= x"f7";
		wait for clk_period;
		data_in.v(0) <= x"98";
		key.v(0) <= x"15";
		data_in.t(0) <= x"98";
		key.t(0) <= x"15";
		wait for clk_period;
		data_in.v(0) <= x"a2";
		key.v(0) <= x"88";
		data_in.t(0) <= x"a2";
		key.t(0) <= x"88";
		wait for clk_period;
		data_in.v(0) <= x"e0";
		key.v(0) <= x"09";
		data_in.t(0) <= x"e0";
		key.t(0) <= x"09";
		wait for clk_period;
		data_in.v(0) <= x"37";
		key.v(0) <= x"cf";
		data_in.t(0) <= x"37";
		key.t(0) <= x"cf";
		wait for clk_period;
		data_in.v(0) <= x"07";
		key.v(0) <= x"4f";
		data_in.t(0) <= x"07";
		key.t(0) <= x"4f";
		wait for clk_period;
		data_in.v(0) <= x"34";
		key.v(0) <= x"3c";
		data_in.t(0) <= x"34";
		key.t(0) <= x"3c";
		wait for clk_period;
		load <= '0';
		start <= '1';

      wait for 400*clk_period;
		start <= '0';
		wait for 4*clk_period;
      -- insert stimulus here 
		load <= '1';
		data_in.v(0) <= x"00";
		key.v(0) <= x"00";
		data_in.t(0) <= x"00";
		key.t(0) <= x"00";
		wait for clk_period;
--		data_in.v(0) <= x"43";
--		key.v(0) <= x"7e";
--		data_in.t(0) <= x"54";
--		key.t(0) <= x"9d";
		wait for clk_period;
--		data_in.v(0) <= x"f6";
--		key.v(0) <= x"15";
--		data_in.t(0) <= x"03";
--		key.t(0) <= x"41";
		wait for clk_period;
--		data_in.v(0) <= x"a8";
--		key.v(0) <= x"16";
--		data_in.t(0) <= x"3e";
--		key.t(0) <= x"4e";
		wait for clk_period;
--		data_in.v(0) <= x"88";
--		key.v(0) <= x"28";
--		data_in.t(0) <= x"9e";
--		key.t(0) <= x"88";
		wait for clk_period;
--		data_in.v(0) <= x"5a";
--		key.v(0) <= x"ae";
--		data_in.t(0) <= x"29";
--		key.t(0) <= x"20";
		wait for clk_period;
--		data_in.v(0) <= x"30";
--		key.v(0) <= x"d2";
--		data_in.t(0) <= x"f0";
--		key.t(0) <= x"b7";
		wait for clk_period;
--		data_in.v(0) <= x"8d";
--		key.v(0) <= x"a6";
--		data_in.t(0) <= x"8f";
--		key.t(0) <= x"08";
		wait for clk_period;
--		data_in.v(0) <= x"31";
--		key.v(0) <= x"ab";
--		data_in.t(0) <= x"f5";
--		key.t(0) <= x"31";
		wait for clk_period;
--		data_in.v(0) <= x"31";
--		key.v(0) <= x"f7";
--		data_in.t(0) <= x"f5";
--		key.t(0) <= x"06";
		wait for clk_period;
--		data_in.v(0) <= x"98";
--		key.v(0) <= x"15";
--		data_in.t(0) <= x"ce";
--		key.t(0) <= x"41";
		wait for clk_period;
--		data_in.v(0) <= x"a2";
--		key.v(0) <= x"88";
--		data_in.t(0) <= x"1c";
--		key.t(0) <= x"9e";
		wait for clk_period;
--		data_in.v(0) <= x"e0";
--		key.v(0) <= x"09";
--		data_in.t(0) <= x"4d";
--		key.t(0) <= x"2d";
		wait for clk_period;
--		data_in.v(0) <= x"37";
--		key.v(0) <= x"cf";
--		data_in.t(0) <= x"eb";
--		key.t(0) <= x"de";
		wait for clk_period;
--		data_in.v(0) <= x"07";
--		key.v(0) <= x"4f";
--		data_in.t(0) <= x"1b";
--		key.t(0) <= x"68";
		wait for clk_period;
--		data_in.v(0) <= x"34";
--		key.v(0) <= x"3c";
--		data_in.t(0) <= x"e4";
--		key.t(0) <= x"cc";
		wait for clk_period;
		load <= '0';
		start <= '1';

      wait;
   end process;

END;
