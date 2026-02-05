#  LeetCode 185 — Department Top Three Salaries


1. Correlated Subquery (classic SQL thinking)
2. Window Function (modern & optimal)

The goal is not just to solve the problem, but to **understand how SQL thinks internally**.

---

##  Problem Summary

For each department, return employees whose salary belongs to the **top 3 distinct salaries** in that department.

Important notes:
- Salaries may repeat
- Ranking must be **based on distinct salary values**
- Output includes: Department, Employee, Salary

---

##  Mental Model

Think in this way:
> “For every employee, decide whether they belong to the top 3 earners in their department.”

---

## 🔵 Approach 1: Correlated Subquery

###  Core Idea

For **each employee**, ask:

> How many **distinct salaries** in my department are **greater than mine**?

If that count is **less than 3**, then the employee is in the **top 3**.

---

###  How SQL Executes This (Visualization)

Department salaries:

9000, 8500, 8500, 7000, 6000

| Current Salary | Higher Distinct Salaries | Count | Keep? |
|---------------|-------------------------|-------|-------|
| 9000 | none | 0 | Yes |
| 8500 | 9000 | 1 | Yes  |
| 7000 | 9000, 8500 | 2 | Yes |
| 6000 | 9000, 8500, 7000 | 3 | No |

SQL performs this logic **row by row**.

---

###  Query (Correlated Subquery)

```sql
SELECT d.name AS Department,
       e.name AS Employee,
       e.salary AS Salary
FROM Employee e
JOIN Department d
ON e.departmentId = d.id
WHERE 3 > (
    SELECT COUNT(DISTINCT e2.salary)
    FROM Employee e2
    WHERE e2.departmentId = e.departmentId
      AND e2.salary > e.salary
);
```

---

###  Why This Is a Correlated Subquery

- The inner query **depends on values from the outer query**
- `e.departmentId` and `e.salary` come from the current row
- The subquery runs **once per employee**

You can think of it as a hidden loop.

---

###  When to Use This Approach

- Window functions are not allowed
- You want to show strong SQL fundamentals
- Interview asks for logical reasoning

---

## 🟢 Approach 2: Window Function (DENSE_RANK)

###  Core Idea

Instead of comparing employees manually:

> Rank salaries within each department and keep rank ≤ 3

This shifts SQL from **row-by-row thinking** to **set-based ranking**.

---

### Visualization (DENSE_RANK)

Department salaries:

9000, 8500, 8500, 7000

| Salary | Dense Rank |
|------|------------|
| 9000 | 1 |
| 8500 | 2 |
| 8500 | 2 |
| 7000 | 3 |

All employees with rank ≤ 3 are selected.

---

###  Query (Window Function)

```sql
SELECT Department, Employee, Salary
FROM (
    SELECT d.name AS Department,
           e.name AS Employee,
           e.salary AS Salary,
           DENSE_RANK() OVER (
               PARTITION BY e.departmentId
               ORDER BY e.salary DESC
           ) AS rnk
    FROM Employee e
    JOIN Department d
    ON e.departmentId = d.id
) t
WHERE rnk <= 3;
```

---

###  Why DENSE_RANK Is Required

| Function | Issue |
|--------|------|
| ROW_NUMBER | Breaks ties (no) |
| RANK | Skips ranks (no) |
| DENSE_RANK | Correct for distinct salaries (YES) |

---

##  Correlated Subquery vs Window Function

| Aspect | Correlated Subquery | Window Function |
|------|---------------------|-----------------|
| SQL Style | Classic | Modern |
| Performance | Slower | Faster |
| Readability | Logical | Clean |
| Interview Impact | Good | Very Strong |

---

## Interview Tip

> If window functions are allowed, prefer `DENSE_RANK`.
> Otherwise, correlated subqueries demonstrate strong fundamentals.

Mentioning **both approaches** is a big plus in interviews.

---

##  Key Takeaway

- Correlated subqueries think **row by row**
- Window functions think **rank by partition**


---


