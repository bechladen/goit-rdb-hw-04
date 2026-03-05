USE mydb;

-- 3 ОБʼЄДНАТИ (JOIN) усі таблиці CSV (mydb) за спільними ключами
SELECT od.*, o.*, c.*, p.*, cat.*, e.*, sh.*, sup.*
FROM order_details od
INNER JOIN orders o        ON od.order_id = o.id
INNER JOIN customers c     ON o.customer_id = c.id
INNER JOIN employees e     ON o.employee_id = e.employee_id
INNER JOIN shippers sh     ON o.shipper_id = sh.id
INNER JOIN products p      ON od.product_id = p.id
INNER JOIN categories cat  ON p.category_id = cat.id
INNER JOIN suppliers sup   ON p.supplier_id = sup.id;

-- 4.1 Порахувати, скільки рядків отримали (COUNT)
SELECT COUNT(*) AS row_count
FROM order_details od
INNER JOIN orders o        ON od.order_id = o.id
INNER JOIN customers c     ON o.customer_id = c.id
INNER JOIN employees e     ON o.employee_id = e.employee_id
INNER JOIN shippers sh     ON o.shipper_id = sh.id
INNER JOIN products p      ON od.product_id = p.id
INNER JOIN categories cat  ON p.category_id = cat.id
INNER JOIN suppliers sup   ON p.supplier_id = sup.id;

-- 4.2 Замінити кілька INNER на LEFT/RIGHT і порівняти COUNT
SELECT COUNT(*) AS row_count_left
FROM orders o
LEFT JOIN order_details od ON od.order_id = o.id
LEFT JOIN customers c      ON o.customer_id = c.id
LEFT JOIN employees e      ON o.employee_id = e.employee_id
LEFT JOIN shippers sh      ON o.shipper_id = sh.id
LEFT JOIN products p       ON od.product_id = p.id
LEFT JOIN categories cat   ON p.category_id = cat.id
LEFT JOIN suppliers sup    ON p.supplier_id = sup.id;

-- 4.3 Взяти тільки рядки, де employee_id > 3 та ≤ 10
SELECT od.*, o.*, c.*, p.*, cat.*, e.*, sh.*, sup.*
FROM order_details od
INNER JOIN orders o        ON od.order_id = o.id
INNER JOIN customers c     ON o.customer_id = c.id
INNER JOIN employees e     ON o.employee_id = e.employee_id
INNER JOIN shippers sh     ON o.shipper_id = sh.id
INNER JOIN products p      ON od.product_id = p.id
INNER JOIN categories cat  ON p.category_id = cat.id
INNER JOIN suppliers sup   ON p.supplier_id = sup.id
WHERE o.employee_id > 3 AND o.employee_id <= 10;

-- 4.4 Згрупувати за назвою категорії + COUNT + AVG(quantity)
SELECT
  cat.name AS category_name,
  COUNT(*) AS row_count,
  AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN orders o        ON od.order_id = o.id
INNER JOIN products p      ON od.product_id = p.id
INNER JOIN categories cat  ON p.category_id = cat.id
GROUP BY cat.name;

-- 4.5 Відфільтрувати групи, де середня кількість > 21
SELECT
  cat.name AS category_name,
  COUNT(*) AS row_count,
  AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN orders o        ON od.order_id = o.id
INNER JOIN products p      ON od.product_id = p.id
INNER JOIN categories cat  ON p.category_id = cat.id
GROUP BY cat.name
HAVING AVG(od.quantity) > 21;

-- 4.6 Відсортувати за спаданням кількості рядків
SELECT
  cat.name AS category_name,
  COUNT(*) AS row_count,
  AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN orders o        ON od.order_id = o.id
INNER JOIN products p      ON od.product_id = p.id
INNER JOIN categories cat  ON p.category_id = cat.id
GROUP BY cat.name
HAVING AVG(od.quantity) > 21
ORDER BY row_count DESC;

-- 4.7 Вивести 4 рядки, пропустивши перший
SELECT
  cat.name AS category_name,
  COUNT(*) AS row_count,
  AVG(od.quantity) AS avg_quantity
FROM order_details od
INNER JOIN orders o        ON od.order_id = o.id
INNER JOIN products p      ON od.product_id = p.id
INNER JOIN categories cat  ON p.category_id = cat.id
GROUP BY cat.name
HAVING AVG(od.quantity) > 21
ORDER BY row_count DESC
LIMIT 4 OFFSET 1;