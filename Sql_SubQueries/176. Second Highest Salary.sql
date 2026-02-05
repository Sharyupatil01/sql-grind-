-- rEAD THE NOTES 
-- IMPORTANT 
-- AGGREGATE FUNCTION HANDLES NULL CASES NATURALLY 
-- WHEN EMPTY SET IS PASSED TO AGGREGATE FUNCTION IT RETURNS NULL 


Table: Employee

+-------------+------+
| Column Name | Type |
+-------------+------+
| id          | int  |
| salary      | int  |
+-------------+------+
id is the primary key (column with unique values) for this table.
Each row of this table contains information about the salary of an employee.
 

Write a solution to find the second highest distinct salary from the Employee table. If there is no second highest salary, return null (return None in Pandas).

The result format is in the following example.

 

Example 1:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
| 2  | 200    |
| 3  | 300    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| 200                 |
+---------------------+
Example 2:

Input: 
Employee table:
+----+--------+
| id | salary |
+----+--------+
| 1  | 100    |
+----+--------+
Output: 
+---------------------+
| SecondHighestSalary |
+---------------------+
| null                |

Solution:

select max(salary) as SecondHighestSalary
from Employee
where salary < (select max(salary) from Employee);


//READers Note:

his query naturally handles the "no second highest" case by returning NULL. Heres why:

The inner subquery (SELECT MAX(salary) FROM Employee) returns the highest salary.
The outer query filters for salaries strictly less than that value.
If no rows satisfy salary < max_salary (e.g., all salaries are equal, or only one row exists), the outer MAX(salary) has no rows to evaluate.
In SQL, aggregate functions like MAX() return NULL when applied to an empty set.
Try this thought experiment:
What would happen if the Employee table had only one row with salary = 5000?

Inner query → 5000
Outer query → WHERE salary < 5000 → no matching rows
Result → MAX() on empty set → NULL
This matches LeetCodes expected behavior for the problem. No extra NULL handling is needed—SQL’s default behavior does it for you. 🤔
What happens if you test this with a table where all salaries are the same?


When theres no second highest salary (e.g., only 1 unique salary or all salaries are equal):

Inner query → MAX(salary) returns the highest value (say 5000)
Outer query → WHERE salary < 5000 → no rows match (empty result set)
MAX(salary) on an empty set → returns NULL (standard SQL behavior)
This is exactly what LeetCode expects for the problem. No additional IFNULL or CASE is needed because:

The problems output requirement is NULL when no second highest exists
SQLs aggregate behavior automatically satisfies this
Test this yourself:
If Employee has [(1, 5000)] (one employee), the query returns NULL as the result.
If Employee has [(1, 5000), (2, 5000)] (all salaries equal), it also returns NULL.