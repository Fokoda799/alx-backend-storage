-- Source:
-- Create a stored procedure AddBonus that takes a user_id, a project_name and a score as arguments. The procedure should insert a new correction in the corrections table. If the project does not exist, it should be created. The project_id should be retrieved using the project_name. The procedure should return nothing.
CREATE PROCEDURE AddBonus(IN user_id INT, IN project_name VARCHAR(255), IN score INT)
BEGIN
    DECLARE project_id INT;

    -- Check if the project exists
    SELECT id INTO project_id
    FROM projects
    WHERE name = project_name;

    -- If project does not exist, create it
    IF project_id IS NULL THEN
        INSERT INTO projects (name) VALUES (project_name);
        SET project_id = LAST_INSERT_ID();
    END IF;

    -- Insert the new correction
    INSERT INTO corrections (user_id, project_id, score) 
    VALUES (user_id, project_id, score);
END;