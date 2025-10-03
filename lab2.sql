--1.	Display the invoice number, the invoice date, the customer id, and the customer name for each order in the database.
SELECT invoice_num, invoice_date, customer.cust_id, cust_name
FROM invoice, customer
WHERE customer.cust_id = invoice.cust_id;

-- Or, 
-- this is EQUIJOIN

SELECT invoice_num, invoice_date, c.cust_id, cust_name 
FROM invoice AS i, customer AS c
WHERE c.cust_id = i.cust_id;
--or
--with inner join

SELECT invoice_num, invoice_date, customer.cust_id, cust_name
FROM invoice INNER JOIN customer ON invoice.cust_id = customer.cust_id;

--or
--with outer join with the right, note the precedence afforded by the keyword RIGHT.
-- Will show partners the right has with the left, and those from the right without a partner. 
SELECT invoice_num, invoice_date, customer.cust_id, cust_name
FROM invoice RIGHT OUTER JOIN customer ON invoice.cust_id = customer.cust_id;


--2.	Display the invoice number, the customer id, and the customer name for each order placed on September 12th, 2007.
SELECT invoice_num, invoice_date, c.cust_id, cust_name
FROM invoice AS i, customer AS c
WHERE c.cust_id = i.cust_id
AND invoice_date = '12-SEP-07';
-- OR 
SELECT invoice_num, invoice_date, c.cust_id, cust_name
FROM invoice AS i JOIN customer AS c ON i.cust_id = c.cust_id
WHERE invoice_date = '12-SEP-07';
--3.	Display the invoice number, the invoice date, the product id, the number of units ordered, and the line price for each line in each order.
-- SELECT * FROM line;
-- SELECT * FROM invoice;
SELECT invoice.invoice_num, invoice_date, line.prod_id, line.line_num_ordered, line_price
FROM invoice, line
WHERE invoice.invoice_num = line.invoice_num;
-- OR 
SELECT i.invoice_num, invoice_date, l.prod_id, l.line_num_ordered, line_price
FROM invoice AS i JOIN line AS l ON i.invoice_num = l.invoice_num;
--4.	Display the id and the name of each customer that placed an order on September 12th, 2007, using the IN operator in your query.
SELECT cust_id, cust_name 
FROM customer
WHERE cust_id IN 
(	SELECT cust_id 
	FROM invoice 
	WHERE invoice_date = '12-SEP-07');
--5.	Display the id and the name of each customer that placed an order on September 12th, 2007, using the EXISTS operator in your query.
-- SELECT * FROM customer;
SELECT cust_id, cust_name
FROM customer
WHERE EXISTS (
	SELECT 1
	FROM invoice
	WHERE invoice_date = '12-SEP-07'
	AND invoice.cust_id = customer.cust_id
);
--6.	Display the id and the name of each customer that did not place an order on September 12th, 2007.   (Be careful in performing this query.)
-- SELECT * FROM customer;
 SELECT customer.cust_id, cust_name
 FROM customer, invoice
 WHERE customer.cust_id = invoice.cust_id
 AND invoice_date != '12-SEP-07'
 GROUP BY customer.cust_id
 ORDER BY customer.cust_id;
 -- OR
 SELECT c.cust_id, cust_name
 FROM customer AS c JOIN invoice AS i ON c.cust_id = i.cust_id
 WHERE invoice_date != '12-SEP-07'
 GROUP BY c.cust_id
 ORDER BY c.cust_id;
--7.	Display the invoice number, the invoice date, the product id, the product description, and the product type for each line in each order.
-- SELECT * FROM invoice
-- SELECT * FROM product
-- SELECT * FROM line

SELECT invoice.invoice_num, invoice_date, product.prod_id, prod_desc, prod_type
FROM invoice, product, line
WHERE invoice.invoice_num = line.invoice_num
AND product.prod_id = line.prod_id;
-- OR
SELECT i.invoice_num, invoice_date, p.prod_id, prod_desc, prod_type
FROM invoice AS i JOIN line AS l ON i.invoice_num = l.invoice_num
JOIN product AS p ON l.prod_id = p.prod_id;
--8.	Display the same data as in question 7, but order the display by product type.  Within each type, order the display by invoice number.
SELECT invoice.invoice_num, invoice_date, product.prod_id, prod_desc, prod_type
FROM invoice, product, line
WHERE invoice.invoice_num = line.invoice_num
AND product.prod_id = line.prod_id
ORDER BY prod_type, invoice.invoice_num;
-- OR
SELECT i.invoice_num, invoice_date, p.prod_id, prod_desc, prod_type
FROM invoice AS i JOIN line AS l ON i.invoice_num = l.invoice_num
JOIN product AS p ON l.prod_id = p.prod_id
ORDER BY prod_type, i.invoice_num;
--9.	Display the sales representative's id, last name, and first name of each representative who represents, at a minimum, one customer whose credit is $10,000 using a subquery.
-- SELECT * FROM customer;
SELECT DISTINCT(rep.rep_id), rep_lname, rep_fname
FROM rep
WHERE rep_id IN (
	SELECT rep_id
	FROM customer
	WHERE cust_limit >= 10000
);
--10.	Display the same data as in the previous question without using a subquery.
SELECT DISTINCT(r.rep_id), rep_lname, rep_fname
FROM rep AS r JOIN customer AS c ON r.rep_id = c.rep_id
WHERE cust_limit >= 10000;
--11.	Display the id and the name of each customer with a current order for a Blender.
-- SELECT * FROM customer;
-- SELECT * FROM line;
SELECT DISTINCT(c.cust_id), cust_name
FROM customer AS c, invoice AS i, line AS l, product AS p
WHERE c.cust_id = i.cust_id
AND i.invoice_num = l.invoice_num
AND l.prod_id = p.prod_id
AND prod_desc = 'Blender';
-- OR...
SELECT DISTINCT(c.cust_id), cust_name
FROM customer AS c JOIN invoice AS i ON c.cust_id = i.cust_id 
JOIN line AS l ON i.invoice_num = l.invoice_num 
JOIN product AS p ON l.prod_id = p.prod_id
WHERE prod_desc = 'Blender';

--12.	Display the invoice number and the invoice date for each customer order placed by Charles Appliance and Sport.
SELECT invoice_num, invoice_date
FROM invoice AS i, customer AS c 
WHERE i.cust_id = c.cust_id
AND cust_name = 'Charles Appliance and Sport';
-- OR
SELECT invoice_num, invoice_date
FROM invoice AS i JOIN customer AS c ON i.cust_id = c.cust_id
WHERE cust_name = 'Charles Appliance and Sport';
--13.	Display the invoice number and the invoice date for each invoice that contains an Electric Range.
SELECT i.invoice_num, invoice_date
FROM invoice AS i JOIN line AS l ON i.invoice_num = l.invoice_num
JOIN product AS p ON l.prod_id = p.prod_id
AND prod_desc = 'Electric Range';
--14.	Display the invoice number and the invoice date for each invoice that was either placed by Charles Appliance and Sport or whose invoice contains an Electric Range.  Use a set operation to perform this query.
SELECT invoice_num, invoice_date
FROM invoice AS i JOIN customer AS c ON i.cust_id = c.cust_id
WHERE cust_name = 'Charles Appliance and Sport'
UNION
SELECT i.invoice_num, invoice_date
FROM invoice AS i JOIN line AS l ON i.invoice_num = l.invoice_num
JOIN product AS p ON l.prod_id = p.prod_id
WHERE prod_desc = 'Electric Range';

--15.	Display the invoice number and the invoice date for each invoice that was placed by Charles Appliance and Sport and whose invoice contains an Electric Range.  Use a set operation to perform this query.
SELECT invoice_num, invoice_date
FROM invoice AS i JOIN customer AS c ON i.cust_id = c.cust_id
WHERE cust_name = 'Charles Appliance and Sport'
INTERSECT
SELECT i.invoice_num, invoice_date
FROM invoice AS i JOIN line AS l ON i.invoice_num = l.invoice_num
JOIN product AS p ON l.prod_id = p.prod_id
WHERE prod_desc = 'Electric Range';
--16.	Display the invoice number and the invoice date for each invoice that was placed by Charles Appliance and Sport and whose invoice does not contain an Electric Range.  Use a set operation to perform this query.
SELECT invoice_num, invoice_date
FROM invoice AS i JOIN customer AS c ON i.cust_id = c.cust_id
WHERE cust_name = 'Charles Appliance and Sport'
EXCEPT
SELECT i.invoice_num, invoice_date
FROM invoice AS i JOIN line AS l ON i.invoice_num = l.invoice_num
JOIN product AS p ON l.prod_id = p.prod_id
WHERE prod_desc = 'Electric Range';

--17.	Display the product id, the product description, the product price, and the product type for each product whose product price is greater than the price of every part in product type SG.  Be sure to correctly choose either the ALL or the ANY operator in your query.
-- SELECT * FROM product;
SELECT prod_id, prod_desc, prod_price, prod_type
FROM product
WHERE prod_price > ALL(
SELECT prod_price
FROM product
WHERE prod_type = 'SG'
);
-- No other product has enough price to pass the highest SG product's price.
--18.	Display the same attributes as in the previous question.  However, use the other of the two operators: ALL or ANY.  This version of the SQL statement provides the answer to a question.  What is that question?  Add your answer as a comment to your list file.
SELECT prod_id, prod_desc, prod_price, prod_type
FROM product
WHERE prod_price > ANY(
SELECT prod_price
FROM product
WHERE prod_type = 'SG'
);
-- Display the product id, the product description, the product price, and the product type for each product whose product price is greater than the price of any part in product type SG.
-- Will display actual data because other products can have a higher price than the lowest price SG product.

--19.	Display the id, the description, the quantity, the invoice number, and the number of units ordered for each product.  Make sure to include all products in your output.  The order number and the number of ordered units must remain blank for any product that is not contained in an invoice.  Order your display by product number.
-- SELECT * FROM product;
-- SELECT * FROM line;
SELECT p.prod_id, prod_desc, prod_quantity, i.invoice_num, line_num_ordered
FROM product AS p LEFT OUTER JOIN line AS l ON p.prod_id = l.prod_id
LEFT OUTER JOIN invoice AS i ON l.invoice_num = i.invoice_num
ORDER BY p.prod_quantity;
-- One double, seemingly fine as the same product was bought in two separate invoices, cannot combine without losing invoice_num data.