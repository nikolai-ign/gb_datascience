-- Составить общее текстовое описание БД и решаемых ею задач;
-- Представленная база данных представляет собой простейшую базу интернет магазина обуви.
-- Хранит товары, основные характеристики товара, цены, данные о покупателях и заказы покупателей. 

DROP DATABASE IF EXISTS shoesplanet;
CREATE DATABASE shoesplanet;
USE shoesplanet;

-- DDL
DROP TABLE IF EXISTS materials;
CREATE TABLE materials (
  id SERIAL PRIMARY KEY,
  material_name VARCHAR(255) NOT NULL,
  material_typename ENUM('нат','иск','текс') COMMENT 'Тип материала',
  KEY material_name_key (material_name)
) COMMENT = 'Материалы верха обуви';

DROP TABLE IF EXISTS colors;
CREATE TABLE colors (
  id SERIAL PRIMARY KEY,
  color_name VARCHAR(255) NOT NULL,
  KEY color_name_key (color_name)
) COMMENT = 'Цвета';

DROP TABLE IF EXISTS seasons;
CREATE TABLE seasons (
  id SERIAL PRIMARY KEY,
  season_name VARCHAR(255) NOT NULL,
  KEY season_name_key (season_name)
) COMMENT = 'Сезоны';

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  catalog_name VARCHAR(255) NOT NULL,
  sort_order INT UNSIGNED COMMENT 'Порядок сортировки',
  KEY catalog_name_key (catalog_name)
) COMMENT = 'Разделы каталога';

DROP TABLE IF EXISTS products;
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  isactive BIT COMMENT 'Активный товар',
  product_name VARCHAR(255) COMMENT 'Наименование товара',
  product_description VARCHAR(255) COMMENT 'Описание товара',
  material_id BIGINT UNSIGNED COMMENT 'Материал верха',
  color_id BIGINT UNSIGNED COMMENT 'Цвет',
  season_id BIGINT UNSIGNED COMMENT 'Сезон',
  catalog_id BIGINT UNSIGNED COMMENT 'Раздел каталога',
  sort_order BIGINT UNSIGNED COMMENT 'Порядок сортировки',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  KEY product_name_key (product_name),
  CONSTRAINT material_id_fk FOREIGN KEY (material_id) REFERENCES materials(id),
  CONSTRAINT color_id_fk FOREIGN KEY (color_id) REFERENCES colors(id),
  CONSTRAINT season_id_fk FOREIGN KEY (season_id) REFERENCES seasons(id),
  CONSTRAINT catalog_id_fk FOREIGN KEY (catalog_id) REFERENCES catalogs(id)
) COMMENT = 'Товары';

DROP TABLE IF EXISTS products_price;
CREATE TABLE products_price (
  product_id BIGINT UNSIGNED COMMENT 'Код товара',
  price INT UNSIGNED COMMENT 'Текущая цена со скидками',
  price_base INT UNSIGNED COMMENT 'Исходная цена без скидок',
  PRIMARY KEY (product_id),
  CONSTRAINT products_price_fk FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE ON UPDATE SET DEFAULT
) COMMENT = 'Цены';

DROP TABLE IF EXISTS customers;
CREATE TABLE customers (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  email VARCHAR(255),
  phone_number BIGINT UNSIGNED DEFAULT NULL COMMENT 'Номер телефона',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

DROP TABLE IF EXISTS orders;
CREATE TABLE orders(
  id SERIAL PRIMARY KEY,
  num VARCHAR(16) COMMENT 'Номер заказа',
  delivery_adress VARCHAR(255) COMMENT 'Адрес доставки',
  customer_id BIGINT UNSIGNED COMMENT 'Идентификатор покупателя',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  CONSTRAINT customer_id_fk FOREIGN KEY (customer_id) REFERENCES customers(id)
) comment='Заказы покупателей';

DROP TABLE IF EXISTS orders_products;
CREATE TABLE orders_products(
  id SERIAL PRIMARY KEY,
  order_id BIGINT UNSIGNED COMMENT 'Идентификатор заказа',
  product_id BIGINT UNSIGNED,
  product_price INT UNSIGNED COMMENT 'Цена на момент заказа (фиксируется, может отличатья от текущей цены)',
  CONSTRAINT order_id_fk FOREIGN KEY (order_id) REFERENCES orders(id),
  CONSTRAINT product_id_fk FOREIGN KEY (product_id) REFERENCES products(id)
) COMMENT='Содержимое заказов';

-- заполняем тестовыми данными
INSERT INTO materials VALUES
(1,'натуральная кожа','нат'),
(2,'искуственная кожа','иск'),
(3,'натуральная замша','нат'),
(4,'текстиль','текс'),
(5,'спилок','нат'),
(6,'полимерный материал','иск');

INSERT INTO colors VALUES
(1, 'черный'),
(2, 'белый'),
(3, 'бежевый'),
(4, 'розовый'),
(5, 'синий'),
(6, 'коричневый'),
(7, 'серый'),
(8, 'голубой'),
(9, 'красный'),
(10, 'жёлтый');

INSERT INTO seasons VALUES
(1,'Весна-лето'),
(2,'Осень'),
(3,'Зима'),
(4,'Демисезон');

INSERT INTO catalogs VALUES
(1,'Женская обувь ZAXY',1),
(2,'Женская обувь BOTTERO',2),
(3,'Женская обувь RIDLSTEP',3),
(4,'Мужская обувь CARTAGO',4),
(5,'Детская обувь Grendene Kids',5),
(6,'Детская обувь ZAXY',6);

INSERT INTO products (id, isactive, product_name, product_description, material_id, color_id, season_id, catalog_id, sort_order) VALUES
(1,1,'Балетки женские Zaxy 82708-51647','Супер новая версия популярной балетки с большим пышным цветком спереди.Цветок полупрозрачный, контрасного цвета. Модель, как всегда легкая, гибкая и имеет очень мягкую стельку.', 6,1,1,1,1),
(2,1,'Сандалии женские Zaxy 17684-90060','Настоящим модным трендом нового сезона становятся сандалии , выполненые в спортивном стиле. Эти сандалии идеально подойдут уверенным в ебе девушкам. Широкие ремни крестнакрест и регулируемая пряжка сделали эту модель необыкновенно практичной.', 6,2,1,1,1),
(3,1,'Туфли женские Bottero 330301-9','Туфли - неотъемлемая часть гардероба каждой модницы, они всегда придают образу легкость и женственность. А туфли Zaxy Fem Diva Top Sanda превращают девушек в настоящих леди. Выполнены из ароматизированного полимера.', 1,3,1,2,1),
(4,1,'Полусапоги женские Ridlstep 18235-304-2','Полусапожки верх искусственная  кожа, подкладка байка.Высота каблука 9 см. Модель с верхом их иск. меха. Комфортная модель, застежка молния.', 2,6,2,3,1),
(5,1,'Полусапоги женские Ridlstep 19241-498-2','Угги — это качественная утеплённая обувь на низком ходу. Она включает в себя уникальный дизайн, удобство в носке, натуральность и прочность. Натуральная кожа, натуральный мех, с застежкой  для более удобного обувания.', 3,7,3,3,1),
(6,1,'Шлепанцы мужские Cartago 11548-20138','Классическая модель шлепанцев SIENA  в легкой интерпретации выполнена с текстурированным ремнем , сдублированным изнутри с нейлоном  для дополнительной амортизации. Шлепанцы имеют стандартную обтекаемую форму.', 6,1,1,4,1),
(7,1,'Сандалии детские Grendene kids 22057-21730','Лицензионная тема Looney Tunes создана по мотивам одноименного мультсериала компании «Warner Bros.». Веселые сандалики декорированы мордашками персонажей этого культового мультфильма.', 6,8,1,5,1),
(8,1,'Сандалии детские Zaxy 17676-53599','Удобные сандалии с ремешком на липучке надёжно фиксируются на ножке. Мягкая стелька украшена рисунками. Модель с открытой пяткой.', 6,9,1,6,1);

INSERT INTO products_price VALUES
(1,2600,4500),
(2,2200,4200),
(3,4300,6500),
(4,5000,8000),
(5,4900,7500),
(6,1600,2800),
(7,2100,3800),
(8,2000,3700);

INSERT INTO customers(id, name, email, phone_number) VALUES
(1,'Ольга Н.', 'olga7979@mail.ru',89161234567),
(2,'Ирина М.', 'irina_mm@mail.ru',89034594567),
(3,'Антон Т.', 'ant-on-on@gmail.com',89102223344),
(4,'Марина А.', 'amarina67@mail.ru',89037778899),
(5,'Наталья Е.', 'nata@zaxyshoes.com',89125574323);

INSERT INTO orders(id, num, delivery_adress, customer_id) VALUES
(1,'0001','-',2),
(2,'0002','--',4),
(3,'0003','---',5),
(4,'0004','----',1);

INSERT INTO orders_products VALUES
(1,1,2,2200),
(2,1,3,4250),
(3,2,4,5000),
(4,2,5,4900),
(5,3,6,1550),
(6,4,7,2100),
(7,4,8,2000);

--
-- создаём представления
--

-- товары со всеми характеристиками
CREATE OR REPLACE VIEW products_view AS 
SELECT products.id, products.isactive, products.product_name, products_price.price, products_price.price_base, products.product_description, catalogs.catalog_name, materials.material_name, materials.material_typename, colors.color_name, seasons.season_name, products.sort_order AS products_sort_order, catalogs.sort_order AS catalogs_sort_order  
FROM ((((products JOIN products_price ON products.id = products_price.product_id) JOIN catalogs ON products.catalog_id = catalogs.id)   
JOIN materials ON products.material_id=materials.id) JOIN colors ON products.color_id=colors.id) JOIN seasons ON products.season_id=seasons.id;

-- развёрнутые заказы по всем покупателям с реквизитами покупателей и данными о товаре
CREATE OR REPLACE VIEW orders_all_view AS
SELECT orders.id AS order_id, orders.num AS order_num, orders.customer_id, customers.name AS customer_name, customers.email AS customer_email, customers.phone_number AS customer_phone_number, orders_products.product_id, 
orders_products.product_price AS product_order_price, products.product_name, products_price.price AS product_catalog_price  
FROM (((orders JOIN customers ON orders.customer_id =customers.id) JOIN orders_products ON orders.id=orders_products.order_id) JOIN products ON orders_products.product_id = products.id) JOIN products_price ON products.id=products_price.product_id;  

--
-- создаём хранимые процедуры / функции
--
DROP FUNCTION IF EXISTS get_discount;

DELIMITER //

-- рассчёт скидки цены заказа относительно базовой цены
CREATE FUNCTION get_discount (price_actual BIGINT UNSIGNED,price_order BIGINT UNSIGNED)
RETURNS DOUBLE DETERMINISTIC
BEGIN
  DECLARE x1 DOUBLE;
  DECLARE x2 DOUBLE;
  DECLARE res DOUBLE; 
  SET x1=CAST(price_actual AS DOUBLE);
  SET x2=CAST(price_order AS DOUBLE);
  SET res = (1-x2/x1)*100;
  RETURN ROUND(res,2);
END//
DELIMITER ;

DROP PROCEDURE IF EXISTS get_order;

DELIMITER //

-- получаем данные заказа по его идентификатору
CREATE PROCEDURE get_order (IN get_order_id BIGINT)
BEGIN
 SELECT orders.id AS order_id, orders.num AS order_num, orders.customer_id, customers.name AS customer_name, customers.email AS customer_email, orders_products.product_id, products.product_name, 
 orders_products.product_price AS product_order_price, products_price.price AS product_catalog_price  
 FROM (((orders JOIN customers ON orders.customer_id =customers.id) JOIN orders_products ON orders.id=orders_products.order_id) JOIN products ON orders_products.product_id = products.id) JOIN products_price ON products.id=products_price.product_id
 WHERE orders.id=get_order_id;
END//

DELIMITER ;

--
-- примеры работы (выборки, вызов процедур/функций)
--
USE shoesplanet;

-- товары, сортированные по порядку следования каталогов и внутри каталога
SELECT * FROM products_view AS pv ORDER BY catalogs_sort_order DESC, products_sort_order, products.product_name; 

-- все заказанные товары, у которых цена заказа отличается от цены каталога
SELECT * FROM orders_all_view WHERE product_order_price<>product_catalog_price;

-- получаем все строки из заказов со скидками
SELECT order_id, customer_name, customer_email, product_id, product_name, product_order_price, product_catalog_price, get_discount(product_catalog_price, product_order_price) AS discountp FROM orders_all_view WHERE product_order_price<>product_catalog_price;

-- количество активных товаров
SELECT COUNT(products.id) AS products_count_isactive FROM products GROUP BY products.isactive HAVING products.isactive=1; 

-- все товары чёрного цвета
SELECT products.id, products.product_name, products_price.price, colors.color_name 
FROM (products JOIN products_price ON products.id = products_price.product_id) JOIN colors ON products.color_id=colors.id 
WHERE colors.color_name LIKE '%чер%';

-- все товары из натуральных материалов
SELECT products.id, products.product_name, products_price.price, products.material_id, materials.material_name 
FROM (products JOIN products_price ON products.id = products_price.product_id) JOIN materials ON products.material_id=materials.id 
WHERE materials.id IN (SELECT id FROM materials WHERE material_typename='нат');

-- получаем заказ
CALL get_order(1);


