REVISE 
-- Question: https://leetcode.com/problems/average-selling-price/description/


Table: Prices

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| start_date    | date    |
| end_date      | date    |
| price         | int     |
+---------------+---------+
(product_id, start_date, end_date) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates the price of the product_id in the period from start_date to end_date.
For each product_id there will be no two overlapping periods. That means there will be no two intersecting periods for the same product_id.
 

Table: UnitsSold

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| purchase_date | date    |
| units         | int     |
+---------------+---------+
This table may contain duplicate rows.
Each row of this table indicates the date, units, and product_id of each product sold. 
 

Write a solution to find the average selling price for each product. average_price should be rounded to 2 decimal places. If a product does not have any sold units, its average selling price is assumed to be 0.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Prices table:
+------------+------------+------------+--------+
| product_id | start_date | end_date   | price  |
+------------+------------+------------+--------+
| 1          | 2019-02-17 | 2019-02-28 | 5      |
| 1          | 2019-03-01 | 2019-03-22 | 20     |
| 2          | 2019-02-01 | 2019-02-20 | 15     |
| 2          | 2019-02-21 | 2019-03-31 | 30     |
+------------+------------+------------+--------+
UnitsSold table:
+------------+---------------+-------+
| product_id | purchase_date | units |
+------------+---------------+-------+
| 1          | 2019-02-25    | 100   |
| 1          | 2019-03-01    | 15    |
| 2          | 2019-02-10    | 200   |
| 2          | 2019-03-22    | 30    |
+------------+---------------+-------+
Output: 
+------------+---------------+
| product_id | average_price |
+------------+---------------+
| 1          | 6.96          |
| 2          | 16.96         |
+------------+---------------+
Explanation: 
Average selling price = Total Price of Product / Number of products sold.
Average selling price for product 1 = ((100 * 5) + (15 * 20)) / 115 = 6.96
Average selling price for product 2 = ((200 * 15) + (30 * 30)) / 230 = 16.96

STEP 1: What should one row of the final output represent?

Ask yourself:

“What does ONE row in the answer mean?”

Here:

One row = one product_id + its average_price


So:
👉 GROUP BY product_id is guaranteed.

🧠 STEP 2: What is the CORE CALCULATION?

Don’t think SQL yet. Think math.

Average price =

Total revenue / Total units sold


Translate to SQL terms:

SUM(price * units) / SUM(units)


This becomes your SELECT formula.

🧠 STEP 3: Which rows are VALID?

Now filter the data logically.

Valid sale =

purchase_date BETWEEN start_date AND end_date


This is NOT a WHERE filter
because it involves both tables → goes in the JOIN condition

🔑 Interview insight:

“Conditions deciding how tables match go in ON, not WHERE”

🧠 STEP 4: What happens when data is missing?

Ask:

“What if a product has no sales?”

SUM(units) becomes NULL

Division breaks

Expected output = 0

Solution:

Use LEFT JOIN

Use IFNULL() or COALESCE()

🧠 STEP 5: Formatting the output

Final polish:

Convert to decimal

Round to 2 places

3️⃣ Now Translate This Thinking → SQL (Clean & Calm)
🔹 Step-by-step build (this is how you should code in interviews)
Step 1: Join tables correctly

FROM Prices p
LEFT JOIN UnitsSold u
ON p.product_id = u.product_id
AND u.purchase_date BETWEEN p.start_date AND p.end_date

Step 2: Aggregate correctly

SUM(p.price * u.units) / SUM(u.units)

Step 3: Handle no-sales case + rounding

ROUND(
  IFNULL(SUM(p.price * u.units) / SUM(u.units), 0),
  2
)

Step 4: Group by product

GROUP BY p.product_id


//final answer 

SELECT 
    p.product_id,
    ROUND(
        IFNULL(SUM(p.price * u.units) / SUM(u.units), 0),
        2
    ) AS average_price
FROM Prices p
LEFT JOIN UnitsSold u
    ON p.product_id = u.product_id
    AND u.purchase_date BETWEEN p.start_date AND p.end_date
GROUP BY p.product_id;



//NOTE : 
// LEFT JOIN : to include products with no sales
// IFNULL : to handle cases where there are no sold units
// ROUND(..., 2) : to round the average price to 2 decimal places
