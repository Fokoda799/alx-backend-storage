-- Create a --Drop a Procedure
-- Create a procedure that will return the total number of employees in the employees table.
-- creates a stored procedure AddBonus that adds a new correction for a student.
-- The procedure first checks if a project with the given `project_name`
-- already exists in the projects table. If not, it creates a new project
-- with the given project_name and retrieves its ID using the
-- LAST_INSERT_ID() function.
-- Finally, the procedure inserts a new correction into the corrections table,
-- with the given user_id, the project_id of the project
-- (either retrieved or inserted in the previous step), and the given score.

-- To call this procedure, you can simply use the following SQL statement:
-- CALL AddBonus(user_id, project_name, score);
DELIMITER $$

DROP PROCEDURE IF EXISTS ADDBONUS;

CREATE PROCEDURE ADDBONUS(
    IN USER_ID INT,
    IN PROJECT_NAME VARCHAR(255),
    IN SCORE INT
)
BEGIN
    DECLARE PROJECT_ID INT;
 
    -- Check if project already exists?
    SELECT
        ID INTO PROJECT_ID
    FROM
        PROJECTS
    WHERE
        NAME = PROJECT_NAME;
 
    -- if it does not, insert new project
    IF PROJECT_ID IS NULL THEN
        INSERT INTO PROJECTS (
            NAME
        ) VALUES (
            PROJECT_NAME
        );
        SET PROJECT_ID = LAST_INSERT_ID();
    END IF;
 

    -- Insert new correction
    INSERT INTO CORRECTIONS (
        USER_ID,
        PROJECT_ID,
        SCORE
    ) VALUES (
        USER_ID,
        PROJECT_ID,
        SCORE
    );
    END$$ DELIMITER;