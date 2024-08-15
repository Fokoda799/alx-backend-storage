-- Source: 11-need_meeting.sql
-- Describe: Create a view named need_meeting that will return the name of students that need a meeting.
-- A student needs a meeting if his score is below 80 or if his last_meeting is older than 30 months.
-- The view should return the name of the students that need a meeting.
DROP VIEW IF EXISTS need_meeting;
CREATE VIEW need_meeting AS
SELECT name
FROM students
WHERE score < 80
   AND (last_meeting IS NULL
   OR last_meeting < DATE_SUB(NOW(), INTERVAL 30 MONTH));

