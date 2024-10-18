-- Creates stored procedure ComputeAverageWeightedScoreForUser
-- that computes and stores the average weighted score for a student
DELIMITER $$
CREATE PROCEDURE ComputeAverageWeightedScoreForUser(IN user_id INT)
BEGIN
    DECLARE average_weight_score FLOAT;
    DECLARE total_projects_weighted_score FLOAT;
    DECLARE total_projects_weight INT;

    -- Calculate total weighted score for the user's corrections
    SELECT SUM(score * projects.weight) INTO total_projects_weighted_score
    FROM corrections 
    JOIN projects ON project_id = projects.id
    WHERE corrections.user_id = user_id 
    GROUP BY corrections.user_id;

    -- Calculate total weight of all projects
    SELECT SUM(projects.weight) INTO total_projects_weight FROM projects;

    -- Calculate the average weighted score
    SET average_weight_score = total_projects_weighted_score / total_projects_weight;

    -- Update the user's average score in the users table
    UPDATE users SET average_score = average_weight_score WHERE id = user_id;
END$$
DELIMITER ;
