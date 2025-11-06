-- Creating Table
CREATE TABLE cd.members
(
    memid integer NOT NULL,
    surname character varying(200) NOT NULL,
    firstname character varying(200) NOT NULL,
    address character varying(300) NOT NULL,
    zipcode integer NOT NULL,
    telephone character varying(20) NOT NULL,
    recommendedby integer,
    joindate timestamp NOT NULL,
    CONSTRAINT members_pk PRIMARY KEY (memid),
    CONSTRAINT fk_members_recommendedby FOREIGN KEY (recommendedby)
        REFERENCES cd.members(memid) ON DELETE SET NULL
);

CREATE TABLE cd.facilities
(
    facid integer NOT NULL,
    name character varying(100) NOT NULL,
    membercost numeric NOT NULL,
    guestcost numeric NOT NULL,
    initialoutlay numeric NOT NULL,
    monthlymaintenance numeric NOT NULL,
    CONSTRAINT facilities_pk PRIMARY KEY (facid)
);

CREATE TABLE cd.bookings
(
    bookid integer NOT NULL,
    facid integer NOT NULL,
    memid integer NOT NULL,
    starttime timestamp NOT NULL,
    slots integer NOT NULL,
    CONSTRAINT bookings_pk PRIMARY KEY (bookid),
    CONSTRAINT fk_bookings_facid FOREIGN KEY (facid) REFERENCES cd.facilities(facid),
    CONSTRAINT fk_bookings_memid FOREIGN KEY (memid) REFERENCES cd.members(memid)
);

-- Question 1
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES (9, 'Spa', 20, 30, 100000, 800);

-- Question 2
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
SELECT (SELECT MAX(facid) FROM cd.facilities)+1, 'Spa', 20, 30, 100000, 800;

-- Question 3
UPDATE cd.facilities
SET initialoutlay = 10000
WHERE name = 'Tennis Court 2';

-- Question 4
UPDATE cd.facilities
SET membercost = (SELECT membercost * 1.1 FROM cd.facilities WHERE name = 'Tennis Court 1'),
    guestcost  = (SELECT guestcost * 1.1 FROM cd.facilities WHERE name = 'Tennis Court 1')
WHERE name = 'Tennis Court 2';

-- Question 5
DELETE FROM cd.bookings;

-- Question 6
DELETE FROM cd.members
WHERE memid = 37
  AND memid NOT IN (SELECT DISTINCT memid FROM cd.bookings);

-- Question 7
DELETE FROM cd.members
WHERE memid = 37
  AND memid NOT IN (SELECT DISTINCT memid FROM cd.bookings);

-- Question 8
DELETE FROM cd.members
WHERE memid = 37
  AND memid NOT IN (SELECT DISTINCT memid FROM cd.bookings);

-- Question 9
SELECT facid, name, membercost, monthlymaintenance
FROM cd.facilities
WHERE membercost > 0
  AND membercost < (monthlymaintenance / 50.0);

-- Question 10
SELECT *
FROM cd.facilities
WHERE name ILIKE '%Tennis%';

-- Question 11
SELECT *
FROM cd.facilities
WHERE facid IN (1, 5);

-- Question 12
SELECT memid, surname, firstname, joindate
FROM cd.members
WHERE joindate >= DATE '2012-09-01';

-- Question 13
SELECT surname AS name
FROM cd.members
UNION
SELECT name
FROM cd.facilities;

-- Question 14
SELECT b.starttime
FROM cd.bookings b
         JOIN cd.members m ON b.memid = m.memid
WHERE m.firstname = 'David' AND m.surname = 'Farrell';

-- Question 15
SELECT b.starttime, f.name
FROM cd.bookings b
         JOIN cd.facilities f ON b.facid = f.facid
WHERE f.name ILIKE '%Tennis Court%'
  AND DATE(b.starttime) = '2012-09-21'
ORDER BY b.starttime;

-- Question 16
SELECT m.firstname AS member_firstname, m.surname AS member_surname,
       r.firstname AS recommender_firstname, r.surname AS recommender_surname
FROM cd.members m
         LEFT JOIN cd.members r ON m.recommendedby = r.memid
ORDER BY m.surname, m.firstname;

-- Question 17
SELECT DISTINCT r.firstname, r.surname
FROM cd.members m
         JOIN cd.members r ON m.recommendedby = r.memid
ORDER BY r.surname, r.firstname;

-- Question 18
SELECT m.firstname || ' ' || m.surname AS member,
       (SELECT r.firstname || ' ' || r.surname
        FROM cd.members r
        WHERE r.memid = m.recommendedby) AS recommender
FROM cd.members m
ORDER BY member;

-- Question 19
SELECT r.memid, COUNT(m.memid) AS recommendations_made
FROM cd.members r
         LEFT JOIN cd.members m ON m.recommendedby = r.memid
GROUP BY r.memid
ORDER BY r.memid;

-- Question 20
SELECT facid, SUM(slots) AS total_slots
FROM cd.bookings
GROUP BY facid
ORDER BY facid;

-- Question 21
SELECT facid, SUM(slots) AS total_slots
FROM cd.bookings
WHERE starttime >= '2012-09-01' AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY total_slots;

-- Question 22
SELECT facid,
       EXTRACT(MONTH FROM starttime) AS month,
       SUM(slots) AS total_slots
FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime) = 2012
GROUP BY facid, month
ORDER BY facid, month;

-- Question 23
SELECT COUNT(DISTINCT memid) AS total_members
FROM cd.bookings;

-- Question 24
SELECT m.memid, m.firstname, m.surname, MIN(b.starttime) AS first_booking
FROM cd.members m
         JOIN cd.bookings b ON m.memid = b.memid
WHERE b.starttime >= '2012-09-01'
GROUP BY m.memid, m.firstname, m.surname
ORDER BY m.memid;

-- Question 25
SELECT firstname, surname, COUNT(*) OVER() AS total_members
FROM cd.members
ORDER BY joindate;

-- Question 26
SELECT ROW_NUMBER() OVER(ORDER BY joindate) AS row_number, memid, firstname, surname, joindate
FROM cd.members;

-- Question 27
WITH totals AS (
    SELECT facid, SUM(slots) AS total_slots
    FROM cd.bookings
    GROUP BY facid
)
SELECT facid
FROM totals
WHERE total_slots = (SELECT MAX(total_slots) FROM totals);

-- Question 28
SELECT surname || ', ' || firstname AS name
FROM cd.members;

-- Question 29
SELECT memid, telephone
FROM cd.members
WHERE telephone LIKE '%(%'
   OR telephone LIKE '%)%'
ORDER BY memid;

-- Question 30
SELECT SUBSTR(surname, 1, 1) AS initial,
       COUNT(*) AS count
FROM cd.members
GROUP BY initial
ORDER BY initial;

