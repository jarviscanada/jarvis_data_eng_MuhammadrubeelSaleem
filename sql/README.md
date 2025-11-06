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









