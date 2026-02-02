Table: Tweets

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| tweet_id       | int     |
| content        | varchar |
+----------------+---------+
tweet_id is the primary key (column with unique values) for this table.
content consists of alphanumeric characters, '!', or ' ' and no other special characters.
This table contains all the tweets in a social media app.
 

Write a solution to find the IDs of the invalid tweets. The tweet is invalid if the number of characters used in the content of the tweet is strictly greater than 15.

Return the result table in any order.

The result format is in the following example.

 
Example 1:
Input:
Tweets table:
+----------+---------------------+
| tweet_id | content             |
+----------+---------------------+
| 1        | Hello World!        |
| 2        | This is a tweet!!!  |
| 3        | Short tweet         |
+----------+---------------------+
Output:
+----------+
| tweet_id |
+----------+
| 2        |
+----------+

select tweet_id from tweets where length(content)>15;