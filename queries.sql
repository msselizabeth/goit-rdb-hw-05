-- 1
USE uni_tasks;

SELECT 
    od.*,
    (SELECT customer_id 
     FROM orders o 
     WHERE o.id = od.order_id) AS customer_id
FROM order_details od;

-- 2
USE uni_tasks;

SELECT *
FROM order_details
WHERE order_id IN (
    SELECT id
    FROM orders 
    WHERE shipper_id = 3
);

-- 3
USE uni_tasks;

SELECT 
    order_id, 
    AVG(quantity) AS avg_quantity
FROM (
    SELECT * FROM order_details 
    WHERE quantity > 10
) AS filtered_details
GROUP BY order_id;

-- 4
USE uni_tasks;

WITH temp AS (
    SELECT * FROM order_details 
    WHERE quantity > 10
)
SELECT 
    order_id, 
    AVG(quantity) AS avg_quantity
FROM temp
GROUP BY order_id;

-- 5
DROP FUNCTION IF EXISTS custom_divide;

DELIMITER //

CREATE FUNCTION custom_divide(val1 FLOAT, val2 FLOAT)
RETURNS FLOAT
DETERMINISTIC
BEGIN
    DECLARE res FLOAT DEFAULT 0;
    
    -- Check explicitly for zero
    IF val2 != 0 THEN 
        SET res = val1 / val2;
    END IF;
    
    RETURN res;
END //

DELIMITER ;

-- Applying the function
SELECT 
    order_id,
    quantity,
    custom_divide(quantity, 3.5) AS result
FROM order_details;