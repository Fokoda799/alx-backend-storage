-- Content: MySQL function to safely divide two numbers
-- MySQL Version: 5.7.31
DELIMITER $$

DROP FUNCTION IF EXISTS SafeDiv$$

CREATE FUNCTION SafeDiv(
    a INT,
    b INT
)
RETURNS FLOAT
BEGIN
    -- Check if the divisor is zero
    IF b = 0 THEN
        RETURN 0;
    ELSE
        RETURN a / b;
    END IF;
END$$

DELIMITER ;
