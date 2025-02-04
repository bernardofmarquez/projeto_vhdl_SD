library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

Entity VolumeDispenser is 
	port (
		reset      : in std_logic;
		clock      : in std_logic;
		quantidade : in std_logic_vector (3 downto 0);
		bebidaSel  : in std_logic_vector(0 downto 0);
		start      : in std_logic;
		fill       : in std_logic;
		
		QA: out std_logic_vector (3 downto 0);
		QB: out std_logic_vector (3 downto 0)
		);
end VolumeDispenser;

architecture arch of VolumeDispenser is 
	component Datapath port (
		clk        : in std_logic;
		reset      : in std_logic;
		loadSel    : in std_logic;
		loadReg    : in std_logic;
		bebida_sel : in std_logic_vector(0 downto 0);
		quantidade : in  std_logic_vector(3 downto 0);
		Q_A        : out std_logic_vector(3 downto 0);
		Q_B        : out std_logic_vector(3 downto 0); 
		CMP_R      : out std_logic;
		done       : out std_logic
	); end component;
	
	component Controladora port (
		clock     : in std_logic;
		reset     : in std_logic;
		start_sub : in std_logic;
      critValue : in std_logic;
      Done      : in std_logic;
		loadReg   : out std_logic;
		loadSel   : out std_logic;
		loadFill  : out std_logic
	); end component;
	
	signal sigLoadReg: std_logic;
	signal sigLoadSel: std_logic;
	signal sigLoadFill: std_logic;
	signal sigCritValue: std_logic;
	signal sigDone: std_logic;
	
begin
	InstDatapath: Datapath port map (
						clk => clock,
						reset => reset,
						loadSel => sigLoadSel,
						loadReg => sigLoadReg,
						bebida_sel => bebidaSel,
						quantidade => quantidade,
						CMP_R         => sigCritValue,
						Q_A           => QA,
						Q_B           => QB,
						done          => sigDone
					);
	InstControladora: Controladora port map (
						clock => clock,
						reset => reset,
						start_sub => start,
						critValue => sigCritValue,
						Done => sigDone,
						loadReg => sigLoadReg,
						loadSel => sigLoadSel,
						loadFill => sigLoadFill
					);
end arch;