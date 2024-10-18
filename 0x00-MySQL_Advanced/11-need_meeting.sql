-- Task: Create a view need_meeting to list students needing a meeting
-- The view returns students with a score under 80 and no last meeting or last meeting more than 1 month ago

CREATE OR REPLACE VIEW need_meeting AS 
SELECT name 
FROM students
WHERE score < 80 
AND (last_meeting IS NULL OR
TIMESTAMPDIFF(MONTH, last_meeting, CURDATE()) > 1);
