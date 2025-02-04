library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity VolumeDispenser_TB is
end VolumeDispenser_TB;

architecture Behavioral of VolumeDispenser_TB is
      constant W          : integer := 4;
      signal reset        : std_logic := '0';
		signal clock        : std_logic := '0';
		signal config       : std_logic := '0';
		signal quantidade   : std_logic_vector (3 downto 0) := "0000";
		signal quantidadeMin: std_logic_vector (3 downto 0) := "0000";
		signal bebidaSel    : std_logic_vector(0 downto 0)   := "0";
		signal start        : std_logic := '0';
		signal fill         : std_logic := '0';
		
		signal critAlarm  : std_logic;
		signal QA         : std_logic_vector (3 downto 0);
		signal QB         : std_logic_vector (3 downto 0);
    
    -- Período do clock
    constant clk_period : time := 10 ns;

begin
    -- Instância do Datapath
    uut: entity work.VolumeDispenser
        Port map (
            clock        => clock,
            reset      => reset,
            start      => start,
				quantidadeMin => quantidadeMin,
				config => config,
				quantidade => quantidade,
				bebidaSel  => bebidaSel,
				fill       => fill,
				critAlarm  => critAlarm,
				QA         => QA,
				QB         => QB
        );

    -- Geração de clock
    process
    begin
        while now < 400 ns loop
            clock <= '0';
            wait for clk_period / 2;
            clock <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process;

        -- Processo de estimulação
    process
    begin
        -- Reset
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 20 ns;
		  
		  -- Definir quantidade critica
		  config <= '1';
		  wait for 20ns;
		  quantidadeMin <= "0011";
		  wait for 20ns;
		  config <= '0';

        -- Definir quantidade a subtrair
        quantidade <= "0001";
        bebidaSel <= "0";
		  start     <= '1';
        wait for 20 ns;
        start <= '0';
        wait for 40 ns;
		  
		  -- Definir quantidade a subtrair
        quantidade <= "1100";
        bebidaSel <= "1";
		  start     <= '1';
        wait for 20 ns;
        start <= '0';
        wait for 30 ns;
		  
		  -- Definir quantidade a subtrair
        quantidade <= "0001";
        bebidaSel <= "1";
		  start     <= '1';
        wait for 20 ns;
        start <= '0';
        wait for 20 ns;

        wait;
    end process;

end Behavioral;
