library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Definição do Datapath
entity Datapath is
    Generic (W : integer := 4);  -- Largura dos registradores
    Port ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           start    : in  STD_LOGIC;
			  loadA    : in STD_LOGIC;
			  loadB    : in STD_LOGIC;
           bebida_sel : in STD_LOGIC;  -- Seleção de bebida (A ou B)
           quantidade : in  STD_LOGIC_VECTOR(W-1 downto 0); -- Quantidade a ser subtraída
           -- level_A   : in  STD_LOGIC_VECTOR(W-1 downto 0);  -- Nível da bebida A
           -- level_B   : in  STD_LOGIC_VECTOR(W-1 downto 0);  -- Nível da bebida B
           -- min_value : in  STD_LOGIC_VECTOR(W-1 downto 0);  -- Valor mínimo para comparação
           Q_A       : out STD_LOGIC_VECTOR(W-1 downto 0);  -- Novo nível de A
           Q_B       : out STD_LOGIC_VECTOR(W-1 downto 0);  -- Novo nível de B
			  CMP_R     : out STD_LOGIC;
           done      : out STD_LOGIC);  -- Sinal de conclusão da operação
	
			  
end Datapath;

architecture Behavioral of Datapath is
    -- Instanciação dos componentes
    signal mux_out     : STD_LOGIC_VECTOR(W-1 downto 0);  -- Saída do multiplexador
    signal comp_result : STD_LOGIC;  -- Resultado do comparador
    signal reg_A_out   : STD_LOGIC_VECTOR(W-1 downto 0);  -- Saída do registrador A
    signal reg_B_out   : STD_LOGIC_VECTOR(W-1 downto 0);  -- Saída do registrador B
    signal subtr_out   : STD_LOGIC_VECTOR(W-1 downto 0);  -- Saída do subtrator
begin

    -- Instanciação dos RegistradoreS
    Reg_A: entity work.RegistradorBebida
        Port map ( clk     => clk,
                   reset   => reset,
                   load    => loadA,
                   D       => subtr_out,
                   Q       => reg_A_out );

    Reg_B: entity work.RegistradorBebida
        Port map ( clk     => clk,
                   reset   => reset,
                   load    => loadB,
                   D       => subtr_out,
                   Q       => reg_B_out );

    -- Instanciação do Multiplexador
    Mux: entity work.Mux
        Port map ( Sel   => bebida_sel, 
                   A        => reg_A_out,
                   B        => reg_B_out,
                   Y        => mux_out );

    -- Instanciação do Comparador
    Comparador: entity work.Comparador
        Port map ( level    => mux_out,
                   min_value => "0011",
                   result    => comp_result);
						 
    -- Instanciação do Subtrator
    Subtrator: entity work.Subtrator
        Port map ( clk        => clk,
                   reset      => '1',
                   load       => start,  -- Ativado quando start da FSM estiver em '1'
                   quantidade => quantidade,
                   D          => mux_out,  -- Bebida selecionada pelo Mux
                   Q          => subtr_out,
                   done       => done );

    -- Saídas do Datapath (registradores A e B)
    Q_A <= reg_A_out;
    Q_B <= reg_B_out;
	 CMP_R <= comp_result;
end Behavioral;

