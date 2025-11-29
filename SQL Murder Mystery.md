🕵️ SQL Murder Mystery — Identifying the Killer Using PostgreSQL

This investigation uses PostgreSQL queries to trace movements, verify alibis, match evidence, and ultimately reveal the murderer.
Below is the full step-by-step breakdown.

1️⃣ Identifying When & Where the Crime Happened
SELECT *
FROM evidence
WHERE room = 'CEO Office'
  AND found_time BETWEEN 
      TIMESTAMP '2025-10-15 20:00:00'
      AND TIMESTAMP '2025-10-15 22:00:00';

Result
evidence_id	room	description	found_time
1	CEO Office	Fingerprint on desk	2025-10-15 21:05:00
2	CEO Office	Keycard swipe discrepancy	2025-10-15 21:10:00
Conclusion

The crime occurred inside the CEO Office, roughly around 9 PM — this becomes our main investigation window.

2️⃣ Checking Who Accessed the CEO Office
SELECT k.employee_id, e.name, k.entry_time, k.exit_time
FROM keycard_logs k
JOIN employees e USING (employee_id)
WHERE k.room = 'CEO Office'
  AND k.entry_time BETWEEN 
      TIMESTAMP '2025-10-15 20:45:00' 
      AND TIMESTAMP '2025-10-15 21:15:00'
ORDER BY k.entry_time;

Result
employee_id	name	entry_time	exit_time
4	David Kumar	20:50	21:00
Conclusion

During the murder window, only one person accessed the CEO Office:
➡️ David Kumar — our first and strongest suspect.

3️⃣ Verifying Alibis Against Actual Logs
SELECT a.employee_id, emp.name, a.claimed_location, a.claim_time,
       k.room AS actual_room, k.entry_time
FROM alibis a
JOIN employees emp USING (employee_id)
JOIN keycard_logs k USING (employee_id)
WHERE a.claim_time BETWEEN 
        TIMESTAMP '2025-10-15 20:30:00'
    AND TIMESTAMP '2025-10-15 21:30:00'
  AND a.claimed_location <> 'CEO Office'
  AND k.room = 'CEO Office'
  AND k.entry_time BETWEEN 
        TIMESTAMP '2025-10-15 20:45:00'
    AND TIMESTAMP '2025-10-15 21:15:00';

Result
employee_id	name	claimed_location	claim_time	actual_room	entry_time
4	David Kumar	Server Room	20:50	CEO Office	20:50
Conclusion

David lied.
He claimed he was in the Server Room, while data proves he was in the CEO Office at the same moment.

4️⃣ Analyzing Calls Around the Crime
SELECT c.call_id, c.call_time, c.duration_sec,
       caller.name AS caller, receiver.name AS receiver
FROM calls c
LEFT JOIN employees caller ON c.caller_id = caller.employee_id
LEFT JOIN employees receiver ON c.receiver_id = receiver.employee_id
WHERE c.call_time BETWEEN 
        TIMESTAMP '2025-10-15 20:50:00'
    AND TIMESTAMP '2025-10-15 21:00:00'
ORDER BY c.call_time;

Result
call_id	call_time	duration_sec	caller	receiver
1	20:55	45	David Kumar	Alice Johnson
Conclusion

David placed a short, suspicious call minutes before the murder — another major red flag.

5️⃣ Matching Evidence With Movements
SELECT 
    e.evidence_id, e.description, e.found_time,
    k.employee_id, emp.name, k.entry_time
FROM evidence e
JOIN keycard_logs k ON e.room = k.room
JOIN employees emp USING (employee_id)
WHERE e.room = 'CEO Office'
  AND k.entry_time BETWEEN 
        e.found_time - INTERVAL '2 hours'
    AND e.found_time + INTERVAL '2 hours';

Result
evidence_id	description	found_time	employee	entry_time
2	Keycard mismatch	21:10	David Kumar	20:50
1	Fingerprint on desk	21:05	David Kumar	20:50
Conclusion

Both evidence pieces within the CEO Office align perfectly with David’s entry time.

6️⃣ Final Cross-Check: Combining All Findings (CTEs)
WITH entered AS (
    SELECT DISTINCT employee_id
    FROM keycard_logs
    WHERE room = 'CEO Office'
      AND entry_time BETWEEN 
            TIMESTAMP '2025-10-15 20:45:00'
        AND TIMESTAMP '2025-10-15 21:15:00'
),
calls AS (
    SELECT DISTINCT caller_id AS employee_id
    FROM calls
    WHERE call_time BETWEEN 
            TIMESTAMP '2025-10-15 20:50:00'
        AND TIMESTAMP '2025-10-15 21:00:00'
    UNION
    SELECT DISTINCT receiver_id
    FROM calls
    WHERE call_time BETWEEN 
            TIMESTAMP '2025-10-15 20:50:00'
        AND TIMESTAMP '2025-10-15 21:00:00'
),
alibi_conflicts AS (
    SELECT DISTINCT a.employee_id
    FROM alibis a
    JOIN keycard_logs k USING (employee_id)
    WHERE a.claimed_location <> 'CEO Office'
      AND a.claim_time BETWEEN 
            TIMESTAMP '2025-10-15 20:30:00'
        AND TIMESTAMP '2025-10-15 21:30:00'
      AND k.room = 'CEO Office'
      AND k.entry_time BETWEEN 
            TIMESTAMP '2025-10-15 20:45:00'
        AND TIMESTAMP '2025-10-15 21:15:00'
)
SELECT emp.name AS killer
FROM employees emp
JOIN entered e USING (employee_id)
LEFT JOIN calls c USING (employee_id)
LEFT JOIN alibi_conflicts a USING (employee_id)
WHERE c.employee_id IS NOT NULL
   OR a.employee_id IS NOT NULL
LIMIT 1;

Final Output
killer
David Kumar
🟥 Final Verdict: David Kumar is the Killer
Why?

Only person entering the CEO Office during the murder window.

False alibi — claimed Server Room, but keycard proves otherwise.

Suspicious phone call before the crime.

Physical evidence (fingerprints + keycard anomaly) aligns with his presence.

David’s digital footprint, alibi violation, and physical evidence all converge to reveal the truth:

🕵️ Killer Identified: David Kumar