-- Average score
-- Write a stored procedure ComputeAverageScoreForUser that computes the average score of a user.
-- DELIMITER $$

DELIMITER $$

DROP PROCEDURE IF EXISTS ComputeAverageScoreForUser$$

CREATE PROCEDURE ComputeAverageScoreForUser(
    IN v_user_id INT
)
BEGIN
    DECLARE total_score FLOAT DEFAULT 0.0;
    DECLARE total_projects INT DEFAULT 0;
    DECLARE v_average_score FLOAT DEFAULT 0.0;

    SELECT average_score
    INTO v_average_score
    FROM users
    WHERE id = v_user_id;

    -- Calculate total score and total projects for the user
    SELECT SUM(score), COUNT(*)
    INTO total_score, total_projects
    FROM corrections
    WHERE user_id = v_user_id;

    -- Calculate average score if there are projects
    IF total_projects = 0 THEN
        SET v_average_score = 0.0;
    ELSE
        SET v_average_score = total_score / total_projects;
    END IF;

    -- Update the average score for the user
    UPDATE users
    SET average_score = v_average_score
    WHERE id = v_user_id;
END$$

DELIMITER ;

