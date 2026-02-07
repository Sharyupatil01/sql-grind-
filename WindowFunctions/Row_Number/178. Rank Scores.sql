Table: Scores

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| score       | decimal |
+-------------+---------+
id is the primary key (column with unique values) for this table.
Each row of this table contains the score of a game. Score is a floating point value with two decimal places.
 

Write a solution to find the rank of the scores. The ranking should be calculated according to the following rules:

The scores should be ranked from the highest to the lowest.
If there is a tie between two scores, both should have the same ranking.
After a tie, the next ranking number should be the next consecutive integer value. In other words, there should be no holes between ranks.
Return the result table ordered by score in descending order.

The result format is in the following example.

 

Example 1:

Input: 
Scores table:
+----+-------+
| id | score |
+----+-------+
| 1  | 3.50  |
| 2  | 3.65  |
| 3  | 4.00  |
| 4  | 3.85  |
| 5  | 4.00  |
| 6  | 3.65  |
+----+-------+
Output: 
+-------+------+
| score | rank |
+-------+------+
| 4.00  | 1    |
| 4.00  | 1    |
| 3.85  | 2    |
| 3.65  | 3    |
| 3.65  | 3    |
| 3.50  | 4    |
+-------+------+


❗ You CANNOT make ROW_NUMBER() handle ties by itself.
If ties must get the same rank → ROW_NUMBER() is the wrong tool.

Now let’s unpack why, and then I’ll show you what can be done, and when.

1️⃣ Why ROW_NUMBER() breaks ties (by design)

Example data:

score
100
100
90
80
Using ROW_NUMBER()
SELECT score,
       ROW_NUMBER() OVER (ORDER BY score DESC) AS rn
FROM Scores;


Result:

score	rn
100	1
100	2
90	3
80	4

🧠 Key idea
ROW_NUMBER() says:

“Every row must have a unique number, no matter what.”

It does not care about equal values.

2️⃣ Why DENSE_RANK() works for ranking

DENSE_RANK() is designed to handle ties in ranking.


SELECT score,
       DENSE_RANK() OVER (ORDER BY score DESC) AS rank
FROM Scores;


Result:

score	rank
100	1
100	1
90	2
80	3

🧠 Dense Rank Rule

Same value → same rank

No gaps

✔ This is exactly what LeetCode 178. Rank Scores wants

3️⃣ Can we “fix” ROW_NUMBER() to behave like DENSE_RANK()?
🚫 Direct answer: NO

There is no condition, CASE, IF, or WHERE clause that can magically make ROW_NUMBER() give the same number for ties.

Why?

Because:

ROW_NUMBER() assigns numbers after sorting

It assigns one number per row

It does not look at neighboring values

4️⃣ BUT… can we simulate ranking without DENSE_RANK()?

Yes 😎
Using correlated subquery logic

Manual ranking logic:

Rank = number of distinct scores greater than current score + 1

Query:
SELECT 
    s1.score,
    (
        SELECT COUNT(DISTINCT s2.score)
        FROM Scores s2
        WHERE s2.score > s1.score
    ) + 1 AS rank
FROM Scores s1
ORDER BY s1.score DESC;


Result:

score	rank
100	1
100	1
90	2
80	3

✔ Same result as DENSE_RANK()
✔ Works even without window functions