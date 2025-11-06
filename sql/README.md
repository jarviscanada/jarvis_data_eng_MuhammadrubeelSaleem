# Introduction

# SQL Queries

###### Table Setup (DDL)

###### Question 1: Insert some data into a table

```sql
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES (9, 'Spa', 20, 30, 100000, 800);
```

###### Question 2: Insert automatically generated value for the next facid, rather than specifying it as a constant.

```sql
insert into cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
select (select max(facid) from cd.facilities)+1, 'Spa', 20, 30, 100000, 800;   
```

###### Question 3: Correct the initial outlay for the second tennis court

```sql
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE name = 'Tennis Court 2';   
```
###### Question 4: Make Tennis Court 2 cost 10% more than Tennis Court 1

```sql
UPDATE cd.facilities
SET membercost = (SELECT membercost * 1.1 FROM cd.facilities WHERE name = 'Tennis Court 1'),
    guestcost  = (SELECT guestcost * 1.1 FROM cd.facilities WHERE name = 'Tennis Court 1')
WHERE name = 'Tennis Court 2';  
```

###### Question 5: Delete all bookings

```sql
DELETE FROM cd.bookings 
```

###### Question 6: Remove member 37 who has no bookings

```sql
DELETE FROM cd.members
WHERE memid = 37
AND memid NOT IN (SELECT DISTINCT memid FROM cd.bookings);
```

###### Question 7: Remove member 37 who has no bookings

```sql
DELETE FROM cd.members
WHERE memid = 37
AND memid NOT IN (SELECT DISTINCT memid FROM cd.bookings);
```

###### Question 8: Remove member 37 who has no bookings
```sql
DELETE FROM cd.members
WHERE memid = 37
  AND memid NOT IN (SELECT DISTINCT memid FROM cd.bookings);
```

###### Question 9: Facilities that charge a member fee < 1/50 of monthly maintenance
```sql
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0
  AND membercost < (monthlymaintenance / 50.0);
```

###### Question 10: All facilities with the word 'Tennis' in their name
```sql
SELECT *
FROM cd.facilities
WHERE name ILIKE '%Tennis%';
```

###### Question 11: Details of facilities with ID 1 and 5 (without OR)
```
SELECT *
FROM cd.facilities
WHERE facid IN (1, 5);
```

###### Question 12: Members who joined after the start of September 2012
```sql
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate >= DATE '2012-09-01';
```sql

###### Question 13: Combined list of all surnames and all facility names
```sql
SELECT surname AS name
FROM cd.members
UNION
SELECT name
FROM cd.facilities;
```

###### Q14: List start times for bookings by members named 'David Farrell'
```sql
SELECT b.starttime
FROM cd.bookings b
JOIN cd.members m ON b.memid = m.memid
WHERE m.firstname = 'David' AND m.surname = 'Farrell';
```

###### Q15: List of start times for tennis court bookings on '2012-09-21'
```sql
SELECT b.starttime, f.name
FROM cd.bookings b
JOIN cd.facilities f ON b.facid = f.facid
WHERE f.name ILIKE '%Tennis Court%'
  AND DATE(b.starttime) = '2012-09-21'
ORDER BY b.starttime;
```

###### Q16: List of all members with the individual who recommended them (if any)
```sql
SELECT m.firstname AS member_firstname, m.surname AS member_surname,
       r.firstname AS recommender_firstname, r.surname AS recommender_surname
FROM cd.members m
LEFT JOIN cd.members r ON m.recommendedby = r.memid
ORDER BY m.surname, m.firstname;
```

###### Q17: List of members who have recommended another member (no duplicates)
```sql
SELECT DISTINCT r.firstname, r.surname
FROM cd.members m
JOIN cd.members r ON m.recommendedby = r.memid
ORDER BY r.surname, r.firstname;
```

###### Q18: List of all members and who recommended them (if any), without joins
```sql
SELECT m.firstname || ' ' || m.surname AS member,
       (SELECT r.firstname || ' ' || r.surname
        FROM cd.members r
        WHERE r.memid = m.recommendedby) AS recommender
FROM cd.members m
ORDER BY member;
```

###### Q19: Count of recommendations each member made, ordered by member ID
```sql
SELECT r.memid, COUNT(m.memid) AS recommendations_made
FROM cd.members r
LEFT JOIN cd.members m ON m.recommendedby = r.memid
GROUP BY r.memid
ORDER BY r.memid;
```

###### Q20: Total number of slots booked per facility
```sql
SELECT facid, SUM(slots) AS total_slots
FROM cd.bookings
GROUP BY facid
ORDER BY facid;
```

###### Q21: Total slots booked per facility in September 2012
```sql
SELECT facid, SUM(slots) AS total_slots
FROM cd.bookings
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY total_slots;
```

###### Q22: Total slots booked per facility per month in 2012
```sql
SELECT facid,
       EXTRACT(MONTH FROM starttime) AS month,
       SUM(slots) AS total_slots
FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime) = 2012
GROUP BY facid, month
ORDER BY facid, month;
```

###### Q23: Total number of members (including guests) with at least one booking
```sql
SELECT COUNT(DISTINCT memid) AS total_members
FROM cd.bookings;
```

###### Q24: Each member name, id, and their first booking after September 1, 2012
```sql
SELECT m.memid, m.firstname, m.surname, MIN(b.starttime) AS first_booking
FROM cd.members m
JOIN cd.bookings b ON m.memid = b.memid
WHERE b.starttime >= '2012-09-01'
GROUP BY m.memid, m.firstname, m.surname
ORDER BY m.memid;
```

###### Q25: Member names with total member count, ordered by join date (include guests)
```sql
SELECT firstname, surname, COUNT(*) OVER() AS total_members
FROM cd.members
ORDER BY joindate;
```

###### Q26: Monotonically increasing numbered list of members ordered by join date
```sql
SELECT ROW_NUMBER() OVER(ORDER BY joindate) AS row_number, memid, firstname, surname, joindate
FROM cd.members;
```

###### Q27: Facility id(s) with the highest total slots booked (handle ties)
```sql
WITH totals AS (
  SELECT facid, SUM(slots) AS total_slots
  FROM cd.bookings
  GROUP BY facid
)
SELECT facid
FROM totals
WHERE total_slots = (SELECT MAX(total_slots) FROM totals);
```

###### Q28: Output names of all members formatted as 'Surname, Firstname'
```sql
SELECT surname || ', ' || firstname AS name
FROM cd.members;
```

###### Q29: Find all telephone numbers containing parentheses, returning member ID and telephone
```sql
SELECT memid, telephone
FROM cd.members
WHERE telephone LIKE '%(%'
   OR telephone LIKE '%)%'
ORDER BY memid;
```

###### Q30: Count of members whose surname starts with each letter of the alphabet
```sql
SELECT SUBSTR(surname, 1, 1) AS initial,
       COUNT(*) AS count
FROM cd.members
GROUP BY initial
ORDER BY initial;
```












