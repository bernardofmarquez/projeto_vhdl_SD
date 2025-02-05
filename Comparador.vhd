library IEEE;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_1164.ALL;

entity Comparador is
    Generic (W : integer := 4);                             -- Largura dos registradores
    Port ( level     : in  STD_LOGIC_VECTOR(W-1 downto 0);  -- Nível da bebida
           min_value : in  STD_LOGIC_VECTOR(W-1 downto 0);  -- Valor mínimo
			  quantidade: in  STD_LOGIC_VECTOR(W-1 downto 0);  -- Valor a ser subtraido
           result    : out STD_LOGIC);                      -- Sinal de comparação
end Comparador;

architecture Behavioral of Comparador is
begin
    process(level, min_value, quantidade)
    begin
        if (quantidade >= level) or (unsigned(level) - unsigned(quantidade)) < unsigned(min_value)  then
            result <= '1';  -- Sinaliza se o nível está abaixo do mínimo
        else
            result <= '0';
        end if;
    end process;
end Behavioral;
