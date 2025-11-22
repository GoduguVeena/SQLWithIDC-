---Display the first 5 patients from the patients table.
SELECT * FROM patients LIMIT 5;
--Show patients 11-20 using OFFSET.
SELECT * FROM patients LIMIT 10 OFFSET 10;
--Get the 10 most recent patient admissions based on arrival_date.
SELECT * FROM patients ORDER BY arrival_date LIMIT 10;
--Daily Challenge Day 4--
SELECT patient_id , name ,service,satisfac