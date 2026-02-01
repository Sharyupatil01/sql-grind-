# Write your MySQL query statement below
-- name of customer where the referred by any customer with id !=2
--  and not referred by any customer 

--  or  clause 

select name 
from Customer 
where 
referee_id is null or referee_id!=2;