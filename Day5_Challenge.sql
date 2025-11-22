--Count the total number of patients in the hospital.
SELECT DISTINCT COUNT(*)
FROM patients;
--Calculate the average satisfaction score of all patients.
SELECT AVG(satisfaction) AS avg_satisfaction_score
FROM patients;
--Find the minimum and maximum age of patients.
SELECT MIN(a)