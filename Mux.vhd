library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Mux is
    Generic (N : integer := 4);
    Port (
        A    : in  STD_LOGIC_VECTOR(N-1 downto 0);
        B    : in  STD_LOGIC_VECTOR(N-1 downto 0);
        Sel  : in  STD_LOGIC;
        Y    : out STD_LOGIC_VECTOR(N-1 downto 0)
    );
end Mux;

architecture Behavioral of Mux is
begin
    Y <= A when Sel = '0' else B;
end Behavioral;
