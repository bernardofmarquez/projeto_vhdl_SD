LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Controladora IS
    PORT (
        clock     : IN STD_LOGIC;
        reset     : IN STD_LOGIC := '0';
        start_sub : IN STD_LOGIC := '0';
        critValue : IN STD_LOGIC := '0';
        Done      : IN STD_LOGIC := '0';
		  loadReg   : out std_logic := '0';
		  loadSel   : out std_logic := '0';
		  loadFill  : out std_logic := '0'
    );
END Controladora;

ARCHITECTURE BEHAVIOR OF Controladora IS
    TYPE type_fstate IS (Start,Idle,Checking,Dispensing,Finish);
    SIGNAL fstate : type_fstate;
    SIGNAL reg_fstate : type_fstate;
BEGIN
    PROCESS (clock,reg_fstate)
    BEGIN
        IF (clock='1' AND clock'event) THEN
            fstate <= reg_fstate;
        END IF;
    END PROCESS;

    PROCESS (fstate,reset,start_sub,critValue,Done)
    BEGIN
        IF (reset='1') THEN
            reg_fstate <= Start;
        ELSE
            CASE fstate IS
                WHEN Start =>
                    reg_fstate <= Idle;
                WHEN Idle =>
						  loadSel <= '1';
						  loadReg <= '0';
                    IF ((start_sub = '1')) THEN
                        reg_fstate <= Checking;
                    ELSE
                        reg_fstate <= Idle;
                    END IF;
                WHEN Checking =>
						  loadSel <= '0';
                    IF (NOT((critValue = '1'))) THEN
                        reg_fstate <= Dispensing;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= Checking;
                    END IF;
                WHEN Dispensing =>
                    IF ((Done = '1')) THEN
                        reg_fstate <= Finish;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= Dispensing;
                    END IF;
                WHEN Finish =>
						  loadReg <= '1';
                    IF (NOT((start_sub = '1'))) THEN
                        reg_fstate <= Idle;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= Finish;
                    END IF;
                WHEN OTHERS => 
                    report "Reach undefined state";
            END CASE;
        END IF;
    END PROCESS;
END BEHAVIOR;