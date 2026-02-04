# COALESCE in SQL: Mastering NULL Handling

## 1️⃣ What is COALESCE?

**Definition**

`COALESCE()` returns the first non-NULL value from a list of expressions.

```sql
COALESCE(expr1, expr2, expr3, ...)
```

👉 SQL evaluates left to right  
👉 The moment it finds a non-NULL, it stops.

## 2️⃣ Simple Examples (Build Intuition)

### Example 1: Basic
```sql
SELECT COALESCE(NULL, NULL, 5, 10);
```
✔ **Result:** 5  
Because it's the first non-NULL value.

### Example 2: Default Value Pattern
```sql
SELECT COALESCE(phone_number, 'Not Provided')
FROM Users;
```
✔ If `phone_number` is NULL → show "Not Provided"  
✔ Otherwise → show actual phone number  

This is very common in real systems.

## 3️⃣ Why NULL is Tricky in SQL (IMPORTANT)

The golden rule:

❌ `NULL = NULL` → FALSE  
❌ `NULL <> 2` → UNKNOWN  

SQL uses 3-valued logic:

- TRUE
- FALSE
- UNKNOWN

And in WHERE clause:  
👉 UNKNOWN rows are filtered out

## 4️⃣ Now Let's Understand Your Query
```sql
SELECT name
FROM Customer
WHERE COALESCE(referee_id, 0) <> 2;
```

What does `referee_id` represent?

- It can be a number
- Or it can be NULL (customer has no referee)

### Without COALESCE ❌
```sql
WHERE referee_id <> 2;
```

| referee_id | referee_id <> 2 | Included? |
|------------|-----------------|-----------|
| 1          | TRUE           | ✅       |
| 2          | FALSE          | ❌       |
| NULL       | UNKNOWN        | ❌       |

💥 Customers with NULL `referee_id` get removed  
But the problem wants to include them

## 5️⃣ How COALESCE Fixes This
```sql
COALESCE(referee_id, 0)
```

| referee_id | COALESCE(referee_id, 0) |
|------------|--------------------------|
| 1          | 1                        |
| 2          | 2                        |
| NULL       | 0                        |

Now apply the condition:

`COALESCE(referee_id, 0) <> 2`

| referee_id | After COALESCE | Result |
|------------|-----------------|--------|
| 1          | 1               | ✅    |
| 2          | 2               | ❌    |
| NULL       | 0               | ✅    |

🎯 Exactly what we want

## 6️⃣ Why 0?

Because:

- `referee_id` values are positive
- 0 can never be equal to 2
- Safe default

This is a design choice, not magic.

## 7️⃣ Equivalent Solution (No COALESCE)
```sql
WHERE referee_id <> 2 OR referee_id IS NULL;
```

✔ Same logic  
✔ Slightly longer  
✔ COALESCE is cleaner

## 8️⃣ When Should YOU Use COALESCE?

Use it when:

✅ NULL should behave like a default value  
✅ You want NULL rows to pass a condition  
✅ You're preparing values for calculations  

### Example: Prevent Division Errors
```sql
SELECT salary / COALESCE(bonus, 1)
FROM Employee;
```

## 9️⃣ Interview-Ready Explanation (Memorize)

COALESCE returns the first non-NULL value. It is commonly used to replace NULLs with default values so that comparisons and calculations behave predictably in WHERE clauses.

🔥 **Mental Shortcut**

COALESCE = "If this is NULL, use that instead"
