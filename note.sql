-- WHERE

-- Group করার আগে individual rows filter করে।

-- ex-
SELECT *
FROM users
WHERE age >= 25;

-- মানে:

-- যেসব individual user-এর age 25+, তাদের নাও।

---------------------------------------

-- HAVING

-- Group করার পরে groups filter করে।

SELECT age, COUNT(*) AS total_users
FROM users
GROUP BY age
HAVING COUNT(*) >= 2;

-- মানে:

-- আগে age অনুযায়ী group করো, তারপর যেসব group-এ কমপক্ষে 2 জন আছে শুধু সেগুলো রাখো।

--------------------------------

-- 3. WHERE + GROUP BY + HAVING

-- এখন তিনটাকে একসাথে ব্যবহার করি।

প্রশ্ন:

-- 25 বা তার বেশি বয়সীদের নিয়ে age অনুযায়ী group করো, তারপর যেসব age group-এ কমপক্ষে 2 জন আছে শুধু সেগুলো দেখাও।

SELECT age COUNT(*) AS total_users

FROM  users 

WHERE age <= 25 

GROUP BY age 

HAVING COUNT(*) >=2 ;


-- ধরো e-commerce database:

-- orders
-- ----------------
-- customer_id
-- amount

-- তুমি জানতে চাও:

-- যেসব customer কমপক্ষে 5টা order করেছে, তাদের দেখাও।

SELECT customer_id(*) AS Coustomer

FROM orders 

GROUP BY Coustomer

HAVING COUNT(*) >=5 ;

-- HAVING-এ Aggregate Function ব্যবহার

-- HAVING COUNT(*) > 5
-- HAVING SUM(amount) > 10000
-- HAVING AVG(age) > 25
-- HAVING MAX(price) > 1000


---------------------------------------------

-- SQL Query-এর একটা important flow

FROM
 ↓
WHERE                         
 ↓
GROUP BY
 ↓
HAVING
 ↓
SELECT
 ↓
ORDER BY
 ↓
LIMIT


WHERE   → কোন ROW?
GROUP BY → কীভাবে GROUP করব?
HAVING  → কোন GROUP রাখব?

----------------------------------------------------------

PostgreSQL — Primary Key & Foreign Key

-- একটা table-এর প্রতিটি row-এর unique identity হলো Primary Key।

-- এখানে:

-- id = 1
-- id = 2
-- id = 3
-- id = 4

-- প্রতিটা আলাদা।

-- তাই id-কে Primary Key করা খুব natural।

-- . Primary Key-এর মূল rules-
-- Unique হতে হবে
-- একই value দুইবার থাকতে পারবে না।
-- NULL হতে পারবে না

ex- 

CREATE TABLE users(

    id SERIAL PRIMARY KEY,      SERIAL ব্যবহার করলে PostgreSQL automatically ID generate করতে পারে।
    name VARCHER(100),
    email VARCHER(100),

    age INT
);

------------------------------------------------------------------

Foreign Key--

-- ধরো আমাদের দুইটা table আছে:

-- users
-- id | name
-- ---+-------
-- 1  | Jabed
-- 2  | Rahim
-- 3  | Karim
-- orders
-- id | user_id | product
-- ---+---------+---------
-- 101| 1       | Laptop
-- 102| 2       | Mouse
-- 103| 1       | Keyboard

-- এখানে orders.user_id কী?

-- এটা বলে:

-- এই order কোন user-এর?

-- user_id হলো Foreign Key

 

-- Table তৈরি করার সময় Foreign Key--

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id),
    product VARCHAR(100)
);


-- এখানে:

user_id INT REFERENCES users(id)

-- মানে:

-- orders.user_id অবশ্যই users.id-এর valid value reference করবে।


-------------------------------------------------------
| Primary Key                 | Foreign Key                                     |
| --------------------------- | ----------------------------------------------- |
| Row-এর unique identity      | অন্য table-এর row-কে reference করে              |
| Unique                      | সাধারণত duplicate হতে পারে                      |
| NULL হতে পারে না            | NULL হতে পারে, যদি constraint-এ নিষেধ না করা হয় |
| নিজের table-কে identify করে | অন্য table-এর relationship তৈরি করে             |


-- . Foreign Key duplicate হতে পারে কেন?

-- এটা খুব important।

-- users:

-- id | name
-- ---+------
-- 1  | Jabed
-- 2  | Rahim

-- orders:

-- id | user_id | product
-- ---+---------+---------
-- 101| 1       | Laptop
-- 102| 1       | Mouse
-- 103| 1       | Keyboard
-- 104| 2       | Phone

-- এখানে user_id = 1 তিনবার আছে।

-- এটা valid।

-- কারণ একজন user অনেকগুলো order করতে পারে।

-- তাই:

-- Primary Key → unique
-- Foreign Key → unique হওয়া বাধ্যতামূলক নয়



SUMMERY-

PRIMARY KEY
→ আমার table-এর unique identity

FOREIGN KEY
→ অন্য table-এর Primary Key-কে reference করে


---------------------------------------------------------------

-- PostgreSQL — Database Relationships

মূলত ৩ ধরনের relationship:

1. One-to-One
2. One-to-Many
3. Many-to-Many


-- One-to-One (1:1)

-- মানে:

-- একজনের সাথে মাত্র একজনের relationship।

-- ধরো:

-- users
-- -----
-- id | name
-- 1  | Jabed
-- 2  | Rahim

-- আর:

-- user_profiles
-- -------------
-- id | user_id | phone
-- 1  | 1       | 017...
-- 2  | 2       | 018...

-- এখানে:

-- Jabed ───── Profile 1
-- Rahim ───── Profile 2

-- একজন user → একটি profile।

-- একটি profile → একজন user।

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);
CREATE TABLE user_profiles (
    id SERIAL PRIMARY KEY,
    user_id INT UNIQUE REFERENCES users(id),
    phone VARCHAR(20)
);

-- এখানে:

-- user_id INT UNIQUE

-- UNIQUE দেওয়ার কারণে একই user-এর জন্য দ্বিতীয় profile তৈরি করা যাবে না।

2️⃣ One-to-Many (1:N)

--  সবচেয়ে common relationship।

-- মানে:

-- একজনের সাথে অনেকগুলো related record থাকতে পারে।

-- আমাদের আগের example:

-- users
-- -----
-- 1 | Jabed
-- 2 | Rahim
-- orders
-- ------
-- 101 | 1 | Laptop
-- 102 | 1 | Mouse
-- 103 | 1 | Keyboard
-- 104 | 2 | Phone

-- Visual:

--              ┌── Order 101
-- Jabed ───────┼── Order 102
--              └── Order 103

-- Rahim ─────────── Order 104

-- অর্থাৎ:

-- 1 User
--  ↓
-- Many Orders

-- এটাই One-to-Many।


3️⃣ Many-to-Many (M:N)

-- একাধিক A → একাধিক B

-- ধরো university:

-- Students
-- --------
-- Jabed
-- Rahim
-- Karim

-- আর courses:

-- Courses
-- -------
-- Database
-- AI
-- Networking

-- একজন student অনেক course নিতে পারে।

-- আবার একটা course-এ অনেক student থাকতে পারে।

-- Visual:

-- Jabed ─────── Database
--    │
--    └────────── AI

-- Rahim ─────── Database
--    │
--    └────────── Networking

-- Karim ─────── AI

-- তাই:

-- Students ←→ Courses

-- = Many-to-Many.

-- ❓ তাহলে database-এ কীভাবে রাখব?

-- সরাসরি এভাবে রাখা ভালো না:

-- students
-- id | name | courses

-- কারণ একটা student-এর অনেক course হবে।

-- তাই আমরা একটা junction table / join table তৈরি করি।

-- students
-- --------
-- id | name

-- courses
-- -------
-- id | name

-- student_courses
-- ---------------
-- student_id
-- course_id
-- Junction Table
CREATE TABLE student_courses (
    student_id INT REFERENCES students(id),
    course_id INT REFERENCES courses(id)
);

-- Data:

-- student_id | course_id
-- -----------+----------
-- 1          | 1
-- 1          | 2
-- 2          | 1
-- 2          | 3
-- 3          | 2

-- -- এখানে:

-- Jabed → Database
-- Jabed → AI

-- Rahim → Database
-- Rahim → Networking

-- Karim → AI

JOINs-

JOIN দিয়ে আমরা দুই বা তার বেশি table-এর related data একসাথে দেখব।


1️⃣ JOIN আসলে কী?

ধরো আমাদের দুইটা table আছে:

users
id	name
1	Jabed
2	Rahim
3	Karim
orders
id	user_id	product
101	1	Laptop
102	1	Mouse
103	2	Keyboard
104	5	Monitor

এখানে:

users.id
   ↓
orders.user_id

orders.user_id হচ্ছে Foreign Key।


-- এখন আমরা চাই:

-- কোন user কোন product order করেছে?

-- তাহলে শুধু orders table দেখলে user-এর নাম নেই।

-- JOIN করে আমরা এমন result চাই:

-- user_name	product
-- Jabed	Laptop
-- Jabed	Mouse
-- Rahim	Keyboard

-- এটাই JOIN-এর কাজ।

INNER JOIN--

3️⃣ SQL Syntax
SELECT users.name, orders.product
FROM users
INNER JOIN orders
ON users.id = orders.user_id;

-- এখানে:

-- FROM users

-- মানে প্রথম table।

-- তারপর:

-- INNER JOIN orders

-- মানে orders table-এর সাথে join করব।

-- সবচেয়ে important অংশ:

-- ON users.id = orders.user_id

-- মানে:

-- users.id আর orders.user_id যেখানে match করবে, সেগুলো connect করো।


LEFT JOIN---

-- LEFT JOIN = বাম পাশের table-এর সব row দেখাবে।

-- Matching থাকলে ডান পাশের data দেখাবে।

-- Matching না থাকলে ডান পাশের জায়গায়:

-- NULL

-- দেখাবে।


SELECT users.name, orders.product
FROM users
LEFT JOIN orders
ON users.id = orders.user_id;




--------
RIGHT JOIN

-- এটা বুঝতে LEFT JOIN-এর কথা মনে রাখলেই হবে।

-- 🧠 Shortcut

-- LEFT JOIN → Left table-এর সবাই থাকবে
-- RIGHT JOIN → Right table-এর সবাই থাকবে

----

FULL JOIN কী?

-- FULL JOIN = দুই table-এর সব row রাখবে।

-- Matching থাকলে দুই পাশের data একসাথে আসবে।

-- Matching না থাকলে যে পাশের data নেই সেখানে NULL হবে।


SELECT
    users.name,
    orders.product
FROM users
FULL OUTER JOIN orders
ON users.id = orders.user_id;


| name  | product  |
| ----- | -------- |
| Jabed | Laptop   |
| Jabed | Mouse    |
| Rahim | Keyboard |
| Karim | NULL     |
| Sadia | NULL     |
| NULL  | Monitor  |




