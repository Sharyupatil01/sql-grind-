REVISE : datediff function
: SELF JOIN CONCEPT 

Table: Weather

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| id            | int     |
| recordDate    | date    |
| temperature   | int     |
+---------------+---------+
id is the column with unique values for this table.
There are no different rows with the same recordDate.
This table contains information about the temperature on a certain day.
 

Write a solution to find all dates id with higher temperatures compared to its previous dates (yesterday).

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Weather table:
+----+------------+-------------+
| id | recordDate | temperature |
+----+------------+-------------+
| 1  | 2015-01-01 | 10          |
| 2  | 2015-01-02 | 25          |
| 3  | 2015-01-03 | 20          |
| 4  | 2015-01-04 | 30          |
+----+------------+-------------+
Output: 
+----+
| id |
+----+
| 2  |
| 4  |
+----+
Explanation: 
In 2015-01-02, the temperature was higher than the previous day (10 -> 25).
In 2015-01-04, the temperature was higher than the previous day (20 -> 30). 


SELECT w1.id
FROM Weather w1
JOIN Weather w2
ON DATEDIFF(w1.recordDate, w2.recordDate) = 1
WHERE w1.temperature > w2.temperature


-- note : Revise : datediff function 
-- datediff(date1 , date2)
-- date 1 - date 2 
-- table generated after datediff function 
-- +------------+------------+----------------+
-- | recordDate | recordDate | datediff(recordDate,recordDate) |
-- +------------+------------+----------------+
-- | 2015-01-01 | 2015-01-01 | 0              |
-- | 2015-01-01 | 2015-01-02 | -
-- | 2015-01-01 | 2015-01-03 | -2             |
-- | 2015-01-01 | 2015-01-04 | -3             |
-- | 2015-01-02 | 2015-01-01 | 1              |
-- | 2015-01-02 | 2015-01-02 | 0              |
-- | 2015-01-02 | 2015-01-03 | -1             |

-- here the value is negative because the first date is less than the second date
-- here we are looking for the value 1 because we want to compare the current date with the previous date
-- datediff(today's date , yesterday's date) = 1
