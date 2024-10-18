-- Task: Create a stored procedure ComputeAverageScoreForUser to compute and store the average score for a student
-- The procedure takes one input: user_id

DELIMITER //

-- Create a procedure which accepts one (1) values or argument
CREATE PROCEDURE `ComputeAverageScoreForUser`(user_id INT)
BEGIN

    UPDATE `users`
    SET `average_score` = (SELECT AVG(`score`) FROM `corrections` WHERE `corrections`.`user_id` = user_id)
    WHERE `id` = user_id;

END;
//
DELIMITER ;
