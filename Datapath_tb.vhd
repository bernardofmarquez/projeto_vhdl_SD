library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Datapath_TB is
end Datapath_TB;

architecture Behavioral of Datapath_TB is
    constant W : integer := 4;
    
    -- Sinais de entrada
    signal clk        : STD_LOGIC := '0';
    signal reset      : STD_LOGIC := '0';
    signal start      : STD_LOGIC := '0';
    -- signal loadA      : STD_LOGIC := '0';
    -- signal loadB      : STD_LOGIC := '0';
	 signal loadSel    : STD_LOGIC := '0';
	 signal loadReg    : STD_LOGIC := '0';
    signal bebida_sel : STD_LOGIC_VECTOR(0 downto 0) := "0";
    signal quantidade : STD_LOGIC_VECTOR(W-1 downto 0) := (others => '0');
    
    -- Sinais de saída
    signal Q_A   : STD_LOGIC_VECTOR(W-1 downto 0);
    signal Q_B   : STD_LOGIC_VECTOR(W-1 downto 0);
    signal CMP_R : STD_LOGIC;
    signal done  : STD_LOGIC;
    
    -- Período do clock
    constant clk_period : time := 10 ns;

begin
    -- Instância do Datapath
    uut: entity work.Datapath
        Generic map (W => W)
        Port map (
            clk        => clk,
            reset      => reset,
            start      => start,
				loadSel    => loadSel,
				loadReg    => loadReg,
            bebida_sel => bebida_sel,
            quantidade => quantidade,
            Q_A        => Q_A,
            Q_B        => Q_B,
            CMP_R      => CMP_R,
            done       => done
        );

    -- Geração de clock
    process
    begin
        while now < 400 ns loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
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

        -- Definir quantidade a subtrair
        quantidade <= "0011";  -- Exemplo: subtrair 3

        -- Selecionar bebida A
        bebida_sel <= "0";
		  
		  loadSel <= '1';
        wait for 20 ns;
        loadSel <= '0';
        wait for 20 ns;
		  
        -- Iniciar a subtração
        start <= '1';
        wait for 20ns;
        start <= '0';
        -- Esperar 'done' indicar que a subtração foi concluída
        wait for 10ns;
        -- Agora carregar o novo valor em A
        loadReg <= '1';
        wait for clk_period;
        loadReg <= '0';
		  
		  wait for 20ns;
		  
		  -- Selecionar bebida B
        bebida_sel <= "1";
		  
		  loadSel <= '1';
        wait for 20 ns;
        loadSel <= '0';
        wait for 20 ns;
		  
        -- Iniciar a subtração
        start <= '1';
        wait for 20ns;
        start <= '0';
        -- Esperar 'done' indicar que a subtração foi concluída
        wait for 10ns;
        -- Agora carregar o novo valor em B
        loadReg <= '1';
        wait for clk_period;
        loadReg <= '0';
		  

        wait;
    end process;

end Behavioral;
