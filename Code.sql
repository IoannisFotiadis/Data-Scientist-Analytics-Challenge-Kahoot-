/*  
SQL query for kahoot Data Scientist (Analytics) Challenge - Part 1
Author: Ioannis Fotiadis
Date: 02/05/2018						*/

/* How many users signed up each month in each account type? */
/* I assume that the timestamp(When this record was created) of duplicate records will differ. */

SELECT  EXTRACT(MONTH from table1.user_created),
	COUNT(CASE WHEN table1.account_type = 'teacher' then 1 ELSE NULL END) as "Teachers",
	COUNT(CASE WHEN table1.account_type = 'student' then 1 ELSE NULL END) as "Students",
	COUNT(CASE WHEN table1.account_type = 'business' then 1 ELSE NULL END) as "Business"
FROM table1
right join (
    select distinct (user_id), min(created) as MinDate 
    from table1
    group by user_id
) AS tm
 on table1.user_id = tm.user_id and table1.created = tm.MinDate 
--  where 	table1.user_created IN (SELECT max(user_created) FROM table1 AS t2 group by t2.user_created having count(t2.user_created) =1)
GROUP BY EXTRACT(MONTH from table1.user_created)
ORDER BY EXTRACT(MONTH from table1.user_created)


/* How many business account users might be working as Apple? */
/* I assume that you ask for current users that may have had for example a teacher account in the past, but they changed it to business now*/

SELECT COUNT(DISTINCT table1.user_id) AS "Users potentially working at Apple"
FROM table1
right join(
select distinct (user_id), max(created) as MaxDate
    FROM table1
    group by user_id
    order by user_id
    ) as tm
    on table1.user_id = tm.user_id and table1.created = tm.MaxDate
    WHERE table1.email LIKE '%@apple.%' AND table1.account_type = 'business'
