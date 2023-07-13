USE sakila;

-- Write a query to find what is the total business done by each store.
SELECT
  s.store_id,
  SUM(p.amount) AS total_business
FROM
  store s
JOIN
  staff st ON s.store_id = st.store_id
JOIN
  payment p ON st.staff_id = p.staff_id
GROUP BY
  s.store_id;


-- Convert the previous query into a stored procedure.

DELIMITER //

CREATE PROCEDURE GetTotalBusinessByStore()
BEGIN
  SELECT
    s.store_id,
    SUM(p.amount) AS total_business
  FROM
    store s
  JOIN
    staff st ON s.store_id = st.store_id
  JOIN
    payment p ON st.staff_id = p.staff_id
  GROUP BY
    s.store_id;
END //

DELIMITER ;

CALL GetTotalBusinessByStore();


-- Convert the previous query into a stored procedure that takes the input for store_id and displays the total sales for that store.

DELIMITER //

CREATE PROCEDURE GetTotalSalesByStore(IN inputStoreId INT)
BEGIN
  SELECT
    SUM(p.amount) AS total_sales
  FROM
    store s
  JOIN
    staff st ON s.store_id = st.store_id
  JOIN
    payment p ON st.staff_id = p.staff_id
  WHERE
    s.store_id = inputStoreId;
END //

DELIMITER ;

CALL GetTotalSalesByStore(1); -- Replace 1 with the desired store_id


-- Update the previous query. Declare a variable total_sales_value of float type, that will store the returned result (of the total sales amount for the store). Call the stored procedure and print the results.

DELIMITER //

CREATE PROCEDURE GetTotalSalesByStore(IN inputStoreId INT)
BEGIN
  DECLARE total_sales_value FLOAT;
  
  SELECT
    SUM(p.amount)
  INTO
    total_sales_value
  FROM
    store s
  JOIN
    staff st ON s.store_id = st.store_id
  JOIN
    payment p ON st.staff_id = p.staff_id
  WHERE
    s.store_id = inputStoreId;

  SELECT total_sales_value AS total_sales;
END //

DELIMITER ;

CALL GetTotalSalesByStore(1);


-- In the previous query, add another variable flag. If the total sales value for the store is over 30.000, then label it as green_flag, otherwise label is as red_flag. Update the stored procedure that takes an input as the store_id and returns total sales value for that store and flag value.

DELIMITER //

CREATE PROCEDURE GetTotalSalesAndFlagByStore(IN inputStoreId INT)
BEGIN
  DECLARE total_sales_value FLOAT;
  DECLARE flag VARCHAR(20);
  
  SELECT
    SUM(p.amount)
  INTO
    total_sales_value
  FROM
    store s
  JOIN
    staff st ON s.store_id = st.store_id
  JOIN
    payment p ON st.staff_id = p.staff_id
  WHERE
    s.store_id = inputStoreId;

  IF total_sales_value > 30000 THEN
    SET flag = 'green_flag';
  ELSE
    SET flag = 'red_flag';
  END IF;

  SELECT total_sales_value AS total_sales, flag;
END //

DELIMITER ;

CALL GetTotalSalesAndFlagByStore(2); 


