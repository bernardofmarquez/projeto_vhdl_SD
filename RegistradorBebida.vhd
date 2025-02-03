library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity RegistradorBebida is
    Generic (W : integer := 4);  -- Largura dos registradores
    Port ( clk  : in  STD_LOGIC;
           reset : in  STD_LOGIC;
           load  : in  STD_LOGIC;
           D     : in  STD_LOGIC_VECTOR(W-1 downto 0);
           Q     : out STD_LOGIC_VECTOR(W-1 downto 0));
end RegistradorBebida;

architecture Behavioral of RegistradorBebida is
begin
    process(clk, reset)
    begin
        if reset = '1' then
            Q <= (others => '1');
        elsif rising_edge(clk) then
            if load = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end Behavioral;
