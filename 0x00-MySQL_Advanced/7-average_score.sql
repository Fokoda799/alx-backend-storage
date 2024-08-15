-- Average score
-- Write a stored procedure ComputeAverageScoreForUser that computes the average score of a user.
DELIMITER $$
DROP PROCEDURE IF EXISTS ComputeAverageScoreForUser;
CREATE PROCEDURE ComputeAverageScoreForUser(
    IN user_id INT
)
BEGIN
    DECLARE average_score FLOAT;
    DECLARE total_score FLOAT;
    DECLARE total_projects INT;

    SELECT average_score INTO average_score
    FROM users 
    WHERE id = user_id;

    SELECT SUM(score) INTO total_score,
    COUNT(project_id) INTO total_projects
    FROM corrections
    WHERE user_id = user_id;

    IF total_projects = 0 THEN
        SET average_score = 0;
    ELSE
        SET average_score = total_score / total_projects;
    END IF;
END$$
DELIMITER ;
