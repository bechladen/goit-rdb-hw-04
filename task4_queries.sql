-- 1. DDL: схема + таблиці + FK
CREATE SCHEMA IF NOT EXISTS LibraryManagement;
USE LibraryManagement;

CREATE TABLE authors (
  author_id INT AUTO_INCREMENT PRIMARY KEY,
  author_name VARCHAR(255) NOT NULL
);

CREATE TABLE genres (
  genre_id INT AUTO_INCREMENT PRIMARY KEY,
  genre_name VARCHAR(255) NOT NULL
);

CREATE TABLE books (
  book_id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  publication_year YEAR,
  author_id INT NOT NULL,
  genre_id INT NOT NULL,
  CONSTRAINT fk_books_author
    FOREIGN KEY (author_id) REFERENCES authors(author_id),
  CONSTRAINT fk_books_genre
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL
);

CREATE TABLE borrowed_books (
  borrow_id INT AUTO_INCREMENT PRIMARY KEY,
  book_id INT NOT NULL,
  user_id INT NOT NULL,
  borrow_date DATE NOT NULL,
  return_date DATE,
  CONSTRAINT fk_borrow_book
    FOREIGN KEY (book_id) REFERENCES books(book_id),
  CONSTRAINT fk_borrow_user
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- 2. INSERT: по 1–2 рядки в кожну таблицю
USE LibraryManagement;

INSERT INTO authors (author_name)
VALUES ('George Orwell'), ('Frank Herbert');

INSERT INTO genres (genre_name)
VALUES ('Dystopian'), ('Sci-Fi');

INSERT INTO books (title, publication_year, author_id, genre_id)
VALUES
  ('1984', 1949, 1, 1),
  ('Dune', 1965, 2, 2);

INSERT INTO users (username, email)
VALUES ('yurii', 'yurii@example.com'), ('test_user', 'test@example.com');

INSERT INTO borrowed_books (book_id, user_id, borrow_date, return_date)
VALUES
  (1, 1, '2026-03-01', NULL),
  (2, 2, '2026-03-02', '2026-03-04');

-- 3 ОБʼЄДНАТИ (JOIN) усі таблиці CSV (mydb) за спільними ключами
USE mydb;

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
USE mydb;


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
USE mydb;

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
USE mydb;

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
USE mydb;

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
USE mydb;

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
USE mydb;

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
USE mydb;

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