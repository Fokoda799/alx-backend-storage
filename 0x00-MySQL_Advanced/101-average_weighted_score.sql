-- Source:
-- Average weighted score for all!
DELIMITER $$

DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers$$

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE user_id INT;
    DECLARE cur CURSOR FOR SELECT id FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor to iterate over all users
    OPEN cur;

    -- Iterate over each user in the cursor
    read_loop: LOOP
        FETCH cur INTO user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Compute and store the average weighted score for the current user
        CALL ComputeAverageWeightedScoreForUser(user_id);
    END LOOP;

    -- Close the cursor
    CLOSE cur;
END$$

DELIMITER ;
