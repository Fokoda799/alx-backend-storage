-- Source:
-- Average weighted score for all!
DELIMITER $$

DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUsers$$

CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE total_weighted_score FLOAT;
    DECLARE total_weight INT;
    DECLARE weighted_average FLOAT;
    DECLARE user_id INT;
    
    -- Cursor to iterate over each user
    DECLARE user_cursor CURSOR FOR SELECT id FROM users;
    DECLARE done INT DEFAULT 0;
    
    -- Handler for end of cursor
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    
    OPEN user_cursor;
    
    read_loop: LOOP
        FETCH user_cursor INTO user_id;
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Calculate the weighted sum of scores and total weight for the current user
        SELECT 
            SUM(c.score * p.weight),
            SUM(p.weight)
        INTO 
            total_weighted_score,
            total_weight
        FROM 
            corrections c
            JOIN projects p ON c.project_id = p.id
        WHERE 
            c.user_id = user_id;
        
        -- Compute the weighted average
        IF total_weight > 0 THEN
            SET weighted_average = total_weighted_score / total_weight;
        ELSE
            SET weighted_average = 0;
        END IF;
        
        -- Update the user's average_score
        UPDATE users
        SET average_score = weighted_average
        WHERE id = user_id;
    END LOOP;
    
    CLOSE user_cursor;
END$$

DELIMITER ;

