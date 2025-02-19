LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY Controladora IS
    PORT (
        clock     : IN STD_LOGIC;
        reset     : IN STD_LOGIC := '0';
        start_sub : IN STD_LOGIC := '0';
        critValue : IN STD_LOGIC := '0';
        Done      : IN STD_LOGIC := '0';
		  config    : IN STD_LOGIC := '0';
		  fill      : IN STD_LOGIC := '0';
		  
		  
		  critAlarm : out STD_LOGIC := '0';
		  loadMin   : out STD_LOGIC := '0';
		  loadReg   : out std_logic := '0';
		  loadSel   : out std_logic := '0';
		  loadFill  : out std_logic := '0'
    );
END Controladora;

ARCHITECTURE BEHAVIOR OF Controladora IS
    TYPE type_fstate IS (Start,Idle,ConfigS,FillS,Alarm,Checking,Dispensing,Finish);
    SIGNAL fstate : type_fstate;
    SIGNAL reg_fstate : type_fstate;
BEGIN
    PROCESS (clock,reg_fstate)
    BEGIN
        IF (clock='1' AND clock'event) THEN
            fstate <= reg_fstate;
        END IF;
    END PROCESS;

    PROCESS (fstate,reset,start_sub,config,critValue,fill,Done)
    BEGIN
        IF (reset='1') THEN
            reg_fstate <= Start;
        ELSE
            CASE fstate IS
                WHEN Start =>
                    reg_fstate <= Idle;
                WHEN Idle =>
					     critAlarm <= '0';
						  loadSel <= '1';
						  loadMin <= '0';
						  loadReg <= '0';
						  loadFill <= '0';
						  IF ((config = '1')) THEN 
								reg_fstate <= ConfigS;
						  ELSIF ((fill = '1')) THEN 
								reg_fstate <= FillS;
                    ELSIF ((start_sub = '1')) THEN
                        reg_fstate <= Checking;
                    ELSE
                        reg_fstate <= Idle;
                    END IF;
					 WHEN ConfigS => 
						  loadMin <= '1';
						  IF ((config = '0')) THEN 
								reg_fstate <= Idle;
						  ELSE 
						      reg_fstate <= ConfigS;
						  END IF;
					 WHEN FillS => 
					     loadFill <= '1';
						  IF ((fill = '0')) THEN 
								reg_fstate <= Idle;
						  ELSE 
						     reg_fstate <= FillS; 
						  END IF;
                WHEN Checking =>
						  loadSel <= '0';
                    IF (NOT((critValue = '1'))) THEN
                        reg_fstate <= Dispensing;
                    -- Inserting 'else' block to prevent latch inference
						  ELSIF (critValue = '1') THEN 
								reg_fstate <= Alarm;
                    ELSE
                        reg_fstate <= Checking;
                    END IF;
					 WHEN Alarm => 
					     critAlarm <= '1';
						  IF ((start_sub = '0')) THEN
							  reg_fstate <= Idle;
						  ELSE
							  reg_fstate <= Alarm;
						  END IF;
                WHEN Dispensing =>
						  loadReg <= '1';
                    IF ((Done = '1')) THEN
                        reg_fstate <= Finish;
                    -- Inserting 'else' block to prevent latch inference
                    ELSE
                        reg_fstate <= Dispensing;
                    END IF;
                WHEN Finish =>
						  loadReg <= '0';
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