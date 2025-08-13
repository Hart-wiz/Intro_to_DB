-- task_2.sql

-- CREATE DATABASE AND SELECT IT
CREATE DATABASE IF NOT EXISTS `alx_book_store`
  CHARACTER SET UTF8MB4
  COLLATE UTF8MB4_UNICODE_CI;
USE `alx_book_store`;

-- AUTHORS TABLE
CREATE TABLE IF NOT EXISTS `authors` (
  `author_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `birth_date` DATE NULL,
  `bio` TEXT NULL,
  PRIMARY KEY (`author_id`),
  INDEX `idx_authors_last_name` (`last_name`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

-- BOOKS TABLE
CREATE TABLE IF NOT EXISTS `books` (
  `book_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(255) NOT NULL,
  `author_id` INT UNSIGNED NOT NULL,
  `isbn` VARCHAR(20) NOT NULL,
  `price` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `published_date` DATE NULL,
  `stock` INT NOT NULL DEFAULT 0,
  PRIMARY KEY (`book_id`),
  UNIQUE KEY `uk_books_isbn` (`isbn`),
  INDEX `idx_books_author_id` (`author_id`),
  CONSTRAINT `fk_books_author`
    FOREIGN KEY (`author_id`) REFERENCES `authors`(`author_id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

-- CUSTOMERS TABLE
CREATE TABLE IF NOT EXISTS `customers` (
  `customer_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(100) NOT NULL,
  `last_name` VARCHAR(100) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `phone` VARCHAR(30) NULL,
  `address` VARCHAR(255) NULL,
  `city` VARCHAR(100) NULL,
  `state` VARCHAR(100) NULL,
  `postal_code` VARCHAR(20) NULL,
  `country` VARCHAR(100) NULL,
  `created_at` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`customer_id`),
  UNIQUE KEY `uk_customers_email` (`email`),
  INDEX `idx_customers_last_name` (`last_name`)
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

-- ORDERS TABLE
CREATE TABLE IF NOT EXISTS `orders` (
  `order_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `customer_id` INT UNSIGNED NOT NULL,
  `order_date` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` ENUM('PENDING','PAID','SHIPPED','CANCELLED','COMPLETED') NOT NULL DEFAULT 'PENDING',
  `total_amount` DECIMAL(12,2) NOT NULL DEFAULT 0.00,
  PRIMARY KEY (`order_id`),
  INDEX `idx_orders_customer_id` (`customer_id`),
  INDEX `idx_orders_status` (`status`),
  CONSTRAINT `fk_orders_customer`
    FOREIGN KEY (`customer_id`) REFERENCES `customers`(`customer_id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;

-- ORDER DETAILS TABLE
CREATE TABLE IF NOT EXISTS `order_details` (
  `order_id` INT UNSIGNED NOT NULL,
  `book_id` INT UNSIGNED NOT NULL,
  `quantity` INT NOT NULL DEFAULT 1,
  `unit_price` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`order_id`, `book_id`),
  INDEX `idx_order_details_book_id` (`book_id`),
  CONSTRAINT `fk_order_details_order`
    FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  CONSTRAINT `fk_order_details_book`
    FOREIGN KEY (`book_id`) REFERENCES `books`(`book_id`)
    ON UPDATE CASCADE
    ON DELETE RESTRICT
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4;
