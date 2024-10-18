-- Task: Create a trigger to reset the valid_email attribute when the email is changed
-- The trigger will fire before an update operation on the users table

DELIMITER //

CREATE TRIGGER reset_valid_email
BEFORE UPDATE ON users
FOR EACH ROW
BEGIN
    -- Check if the email has changed
    IF OLD.email <> NEW.email THEN
        SET NEW.valid_email = NULL; -- Reset valid_email attribute if email has changed
    END IF;
END; //

DELIMITER ;

