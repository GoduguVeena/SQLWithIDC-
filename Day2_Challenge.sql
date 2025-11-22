
SELECT 
    patient_id, 
    name, 
    age, 
    satisfaction 
FROM 
    patients 
WHERE 
    service = 'Surgery' AND satisfaction_sc < 70;