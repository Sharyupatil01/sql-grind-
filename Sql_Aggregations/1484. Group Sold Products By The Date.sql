//revise 
-- Question: https://leetcode.com/problems/group-sold-products-by-the-date/description/

Table Activities:

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| sell_date   | date    |
| product     | varchar |
+-------------+---------+
There is no primary key (column with unique values) for this table. It may contain duplicates.
Each row of this table contains the product name and the date it was sold in a market.
 

Write a solution to find for each date the number of different products sold and their names.

The sold products names for each date should be sorted lexicographically.

Return the result table ordered by sell_date.

The result format is in the following example.

 

Example 1:

Input: 
Activities table:
+------------+------------+
| sell_date  | product     |
+------------+------------+
| 2020-05-30 | Headphone  |
| 2020-06-01 | Pencil     |
| 2020-06-02 | Mask       |
| 2020-05-30 | Basketball |
| 2020-06-01 | Bible      |
| 2020-06-02 | Mask       |
| 2020-05-30 | T-Shirt    |
+------------+------------+
Output: 
+------------+----------+------------------------------+
| sell_date  | num_sold | products                     |
+------------+----------+------------------------------+
| 2020-05-30 | 3        | Basketball,Headphone,T-shirt |
| 2020-06-01 | 2        | Bible,Pencil                 |
| 2020-06-02 | 1        | Mask                         |
+------------+----------+------------------------------+
Explanation: 
For 2020-05-30, Sold items were (Headphone, Basketball, T-shirt), we sort them lexicographically and separate them by a comma.
For 2020-06-01, Sold items were (Pencil, Bible), we sort them lexicographically and separate them by a comma.
For 2020-06-02, the Sold item is (Mask), we just return it.


SELECT 
    sell_date,
    COUNT(DISTINCT product) AS num_sold,
    GROUP_CONCAT(DISTINCT product ORDER BY product SEPARATOR ',') AS products
FROM Activities
GROUP BY sell_date
ORDER BY sell_date;

-- COUNT(DISTINCT product) : to count the number of different products sold on each sell_date
-- GROUP_CONCAT(DISTINCT product ORDER BY product SEPARATOR ',') : to concatenate the
-- distinct product names for each sell_date, sorted lexicographically and separated by commas
-- GROUP BY sell_date : to group the records by sell_date
-- ORDER BY sell_date : to order the result by sell_date


--revise 
-- group_concat : to concatenate mutiple rows into a single column value using a separator
-- synatx : GROUP_CONCAT([DISTINCT] expression [ORDER BY expression ASC|DESC] [SEPARATOR str_val])
-- example : GROUP_CONCAT(DISTINCT product ORDER BY product SEPARATOR ',')

--revise 
-- count(distinct ...): to count the number of unique non-null values in a column or expression
-- example : COUNT(DISTINCT product) : to count the number of different products sold on
