library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Subtrator is
    Generic (W : integer := 4);  -- Largura dos registradores
    Port ( clk      : in  STD_LOGIC;
           reset    : in  STD_LOGIC;
           load     : in  STD_LOGIC;
           quantidade : in  STD_LOGIC_VECTOR(W-1 downto 0);
           D        : in  STD_LOGIC_VECTOR(W-1 downto 0);
           Q        : out STD_LOGIC_VECTOR(W-1 downto 0);
           done     : out STD_LOGIC);
end Subtrator;

architecture Behavioral of Subtrator is
signal novo_valor : STD_LOGIC_VECTOR(W-1 downto 0);
begin
    process(clk, reset)
    begin
        if reset = '0' then
            novo_valor <= (others => '0');
            done <= '0';
        elsif rising_edge(clk) then
            if load = '1' then
                novo_valor <= D - quantidade;
                done <= '1'; -- Indica que a dispensação foi concluída
            else
                done <= '0';
            end if;
        end if;
    end process;

    Q <= novo_valor;
end Behavioral;
