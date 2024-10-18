-- Creates stored procedure ComputeAverageWeightedScoreForUsers
-- that computes and stores the average weighted score for all students
DELIMITER $$
CREATE PROCEDURE ComputeAverageWeightedScoreForUsers()
BEGIN
    DECLARE student_id INT;
    DECLARE total_projects_weight INT;
    DECLARE average_weight_score FLOAT;
    DECLARE total_projects_weighted_score FLOAT;
    DECLARE students_flag INT DEFAULT FALSE;

    -- Cursor to iterate through all users
    DECLARE students_cursor CURSOR FOR SELECT id FROM users;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET students_flag = TRUE;

    -- Open the cursor
    OPEN students_cursor;

    students_loop: LOOP
        FETCH students_cursor INTO student_id;

        IF students_flag THEN 
            LEAVE students_loop;
        END IF;

        -- Calculate total weighted score for the user's corrections
        SELECT SUM(score * projects.weight) INTO total_projects_weighted_score
        FROM corrections 
        JOIN projects ON corrections.project_id = projects.id
        WHERE corrections.user_id = student_id 
        GROUP BY corrections.user_id;

        -- Calculate total weight of all projects
        SELECT SUM(projects.weight) INTO total_projects_weight FROM projects;

        -- Calculate average weighted score
        SET average_weight_score = total_projects_weighted_score / total_projects_weight;

        -- Update the user's average score in the users table
        UPDATE users SET average_score = average_weight_score WHERE id = student_id;
    END LOOP students_loop;

    -- Close the cursor
    CLOSE students_cursor;
END$$
DELIMITER ;
