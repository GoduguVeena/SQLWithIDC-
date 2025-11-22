
SELECT *FROM patients ORDER BY age DESC;

SELECT *FROM patients ORDER BY age,name ASC;

SELECT name,age from patients ORDER BY 2 DESC;

SELECT * FROM patients ORDER BY service,age;

SELECT week,service,patients_request,patients_refused FROM
services_weekly ORDER BY patients_refused DESC LIMIT  5;