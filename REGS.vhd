library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity REGS is
	port ( 	clk	:	in		std_logic;
				SW0	:	in		std_logic;
				SW1	:	in		std_logic;
				SW2	:	in		std_logic;
				SW3	:	in		std_logic;
				rdout	:	out	std_logic_vector (7 downto 0));
end REGS;

architecture BEHAVIORAL of REGS is

	signal preg: std_logic_vector (7 downto 0);
	signal sreg: std_logic_vector (7 downto 0);
	signal creg: std_logic_vector(7 downto 0);
	
begin

psr:	process(clk)
		
		begin
		
			if (clk'event and clk = '1') then
			
				if (SW2 = '0' and SW3 = '0') then
						preg <= "00000000";
						
				elsif (SW2 = '1' and SW3 = '0') then
						preg <= sreg;
						
				elsif (SW2 = '0' and SW3 = '1') then
						preg <= creg;
						
				end if;
				
			end if;
			
		end process psr;


		
sr:	process(clk)

		begin
		
		if (clk'event and clk = '1') then
		
			if(SW3 = '0' and SW2 = '0') then
		
				sreg <= "00000000";
			
			elsif(SW3 = '0' and SW2 = '1') then
					
				sreg <= sreg(6 downto 0) & sreg(7);
				
			elsif(SW3 = '1') then
			
				sreg <= sreg(6 downto 0) & SW2;
				
			end if;
		
		end if;
		
		end process sr;

		
		
bcd: 	process(clk)

		begin
		
		if (clk'event and clk = '1') then
		
			if (SW3 = '0' and SW2 = '0') then
			
				creg <= "00000000";
				
			elsif (SW3 = '0' and SW2 = '1') then
			
				creg <= creg + 1;
				
			elsif	(SW3 = '1' and SW2 = '0') then
			
				creg <= creg - 1;
				
			elsif (SW3 = '1' and SW2 = '0') then
			
				creg <= sreg;
				
			end if;
			
		end if;
		
		
		end process bcd;

	
	rdout <= preg when SW0 = '0' and SW1 = '0' else
				sreg when SW0 = '0' and SW1 = '1' else
				creg when SW0 = '1' and SW0 = '0';

end BEHAVIORAL;

