-- Source:
-- Average weighted score
DELIMITER $$

DROP PROCEDURE IF EXISTS ComputeAverageWeightedScoreForUser$$

CREATE PROCEDURE ComputeAverageWeightedScoreForUser(
    IN user_id INT
)
BEGIN
    DECLARE total_weighted_score FLOAT DEFAULT 0;
    DECLARE total_weight FLOAT DEFAULT 0;
    DECLARE average_weighted_score FLOAT DEFAULT 0;

    -- Calculate total weighted score and total weight for the user
    SELECT SUM(c.score * p.weight), SUM(p.weight)
    INTO total_weighted_score, total_weight
    FROM corrections c
    JOIN projects p ON c.project_id = p.id
    WHERE c.user_id = user_id;

    -- Compute the average weighted score
    IF total_weight > 0 THEN
        SET average_weighted_score = total_weighted_score / total_weight;
    ELSE
        SET average_weighted_score = 0;
    END IF;

    -- Update the user's average_score
    UPDATE users
    SET average_score = average_weighted_score
    WHERE id = user_id;
END$$

DELIMITER ;
