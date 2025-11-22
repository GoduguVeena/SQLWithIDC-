--Find services that have admitted more than 500 patients in total.
SELECT 
        service,
		SUM(patients_admitted) AS total_patients
FROM services_weekly
GROUP BY service
HAVING SUM(patients_admitted)>500;
--Show services where average patient satisfaction is below 75.
SELECT 
      service,
	  AVG(patient_satisfaction) AS avg_satisfaction
FROM services_weekly
GROUP BY service
HAVING AVG(patient_satisfaction)<80;

--List weeks where total staff presence across all services was less than 50.
SELECT week, SUM(staff_morale) AS total_staff
FROM services_weekly
GROUP BY week
HAVING SUM(staff_morale) < 50;

--Daily Challenge Day7
SELECT
    service,
    SUM(patients_refused) AS total_refused,
    AVG(patient_satisfaction) AS average_satisfaction
FROM services_weekly
GROUP BY service
HAVING
    SUM(patients_refused) > 100
    AND AVG(patient_satisfaction) < 80; 