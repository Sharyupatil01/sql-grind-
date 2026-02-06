# Player Retention – First Day Login Fraction


> *Find the fraction of players who logged in again on the day after their first login.*

---

##  Problem in Simple Words

We are asked:

> **Out of all players, how many returned exactly one day after their first-ever login?**

The final answer is a **fraction**, rounded to **2 decimal places**.

---

##  Given Table: `Activity`

| player_id | event_date |
|----------|------------|
| 1 | 2020-01-01 |
| 1 | 2020-01-02 |
| 1 | 2020-01-03 |
| 2 | 2020-01-01 |
| 3 | 2020-01-05 |
| 3 | 2020-01-06 |

Each row represents **one login event**.

---

##  Step 1: Find First Login for Each Player

We first calculate the **first login date per player**.

```sql
WITH FirstLogin AS (
    SELECT
        player_id,
        MIN(event_date) AS first_login
    FROM Activity
    GROUP BY player_id
)
```
### Think of this as:

<p>“Create a temporary table that stores the first day each player ever logged in.”</p>

###  Result of `FirstLogin`

| player_id | first_login |
|----------|-------------|
| 1 | 2020-01-01 |
| 2 | 2020-01-01 |
| 3 | 2020-01-05 |

Think of this as a **temporary table** that stores each player’s starting point.

---

##  Step 2: Check Who Returned the Next Day

We now join this table back with `Activity` to see if the player logged in **exactly one day later**.

```sql
LEFT JOIN Activity a
ON f.player_id = a.player_id
AND DATEDIFF(a.event_date, f.first_login) = 1
```

###  What `DATEDIFF = 1` means

```
a.event_date = first_login + 1 day
```

So we are checking:
- Did the player come back **the very next day**?

---

##  Why LEFT JOIN is Important

We want:
- **All players** in the denominator
- **Only returning players** in the numerator

`LEFT JOIN` ensures players who **did NOT return** are still counted.

Using `INNER JOIN` would incorrectly remove them.

---

##  Step 3: Calculate the Fraction

```sql
SELECT
    ROUND(
        COUNT(DISTINCT a.player_id) / COUNT(DISTINCT f.player_id),
        2
    ) AS fraction
FROM FirstLogin f
LEFT JOIN Activity a
ON f.player_id = a.player_id
AND DATEDIFF(a.event_date, f.first_login) = 1;
```

###  What is being counted?

- **Denominator**: `COUNT(DISTINCT f.player_id)` → total players
- **Numerator**: `COUNT(DISTINCT a.player_id)` → players who returned next day

---

##  Example Calculation

From the sample data:

- Total players = **3**
- Players who returned next day = **2**

```
Fraction = 2 / 3 = 0.67
```

---

##  Key Patterns to Remember

| Requirement | SQL Pattern |
|------------|------------|
| First occurrence | `MIN()` |
| Next / previous day | `DATEDIFF()` |
| Include all rows | `LEFT JOIN` |
| Ratio / percentage | `COUNT / COUNT` |
| Clean multi-step logic | `WITH (CTE)` |

---


