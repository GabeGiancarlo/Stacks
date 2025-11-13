-- MySQL dump 10.13  Distrib 8.0.x, for macOS (x86_64)
-- Host: localhost    Database: stacks_db
-- ------------------------------------------------------
-- Server version	8.0.x

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Current Database: `stacks_db`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `stacks_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci */;

USE `stacks_db`;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `display_name` varchar(255) DEFAULT NULL,
  `bio` text,
  `avatar_url` varchar(500) DEFAULT NULL,
  `privacy_settings` json DEFAULT NULL,
  `total_books_read` int DEFAULT '0',
  `total_pages_read` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_login_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`),
  UNIQUE KEY `username` (`username`),
  KEY `idx_email` (`email`),
  KEY `idx_username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `isbn` varchar(20) NOT NULL,
  `title` varchar(500) NOT NULL,
  `subtitle` varchar(500) DEFAULT NULL,
  `description` text,
  `cover_image_url` varchar(500) DEFAULT NULL,
  `publication_date` date DEFAULT NULL,
  `publisher` varchar(255) DEFAULT NULL,
  `page_count` int DEFAULT NULL,
  `language` varchar(50) DEFAULT NULL,
  `source_api` varchar(50) DEFAULT NULL COMMENT 'google_books or open_library',
  `fetched_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `isbn` (`isbn`),
  KEY `idx_isbn` (`isbn`),
  KEY `idx_title` (`title`(100)),
  FULLTEXT KEY `idx_fulltext_title` (`title`,`subtitle`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `authors`
--

DROP TABLE IF EXISTS `authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `authors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `bio` text,
  `photo_url` varchar(500) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `death_date` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `genres`
--

DROP TABLE IF EXISTS `genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `genres` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `parent_genre_id` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_parent_genre` (`parent_genre_id`),
  CONSTRAINT `genres_ibfk_1` FOREIGN KEY (`parent_genre_id`) REFERENCES `genres` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_books`
--

DROP TABLE IF EXISTS `user_books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `reading_status` enum('Read','Currently Reading','Want to Read','Owned') NOT NULL DEFAULT 'Owned',
  `rating` tinyint DEFAULT NULL,
  `notes` text,
  `current_page` int DEFAULT '0',
  `completion_percentage` decimal(5,2) DEFAULT '0.00',
  `date_added` date DEFAULT NULL,
  `date_started` date DEFAULT NULL,
  `date_finished` date DEFAULT NULL,
  `custom_metadata` json DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_book` (`user_id`,`book_id`),
  KEY `idx_user_status` (`user_id`,`reading_status`),
  KEY `idx_user_book` (`user_id`,`book_id`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `user_books_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_books_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_books_chk_1` CHECK ((`rating` >= 1) and (`rating` <= 5)),
  CONSTRAINT `user_books_chk_2` CHECK ((`completion_percentage` >= 0) and (`completion_percentage` <= 100))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reading_sessions`
--

DROP TABLE IF EXISTS `reading_sessions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reading_sessions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_book_id` int NOT NULL,
  `session_date` date NOT NULL,
  `duration_minutes` int DEFAULT NULL,
  `pages_read` int DEFAULT '0',
  `progress_notes` text,
  `reading_location` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_book_session` (`user_book_id`,`session_date`),
  CONSTRAINT `reading_sessions_ibfk_1` FOREIGN KEY (`user_book_id`) REFERENCES `user_books` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reading_history`
--

DROP TABLE IF EXISTS `reading_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reading_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `history_date` date NOT NULL,
  `pages_read` int DEFAULT '0',
  `cumulative_pages_read` int DEFAULT '0',
  `reading_streak_days` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_history_date` (`user_id`,`history_date`),
  KEY `idx_user_history` (`user_id`,`history_date`),
  CONSTRAINT `reading_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shelves`
--

DROP TABLE IF EXISTS `shelves`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shelves` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text,
  `shelf_style` enum('wood','modern','vintage','white_minimal') DEFAULT 'wood',
  `display_order` int DEFAULT '0',
  `privacy_setting` enum('public','private','friends_only') DEFAULT 'private',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_shelf` (`user_id`,`display_order`),
  CONSTRAINT `shelves_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shelf_books`
--

DROP TABLE IF EXISTS `shelf_books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shelf_books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `shelf_id` int NOT NULL,
  `book_id` int NOT NULL,
  `display_position` int DEFAULT '0',
  `shelf_notes` text,
  `date_added` date DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_shelf_book_position` (`shelf_id`,`book_id`,`display_position`),
  KEY `idx_shelf_position` (`shelf_id`,`display_position`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `shelf_books_ibfk_1` FOREIGN KEY (`shelf_id`) REFERENCES `shelves` (`id`) ON DELETE CASCADE,
  CONSTRAINT `shelf_books_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `reviews`
--

DROP TABLE IF EXISTS `reviews`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reviews` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `book_id` int NOT NULL,
  `review_content` text NOT NULL,
  `rating` tinyint NOT NULL,
  `helpful_votes` int DEFAULT '0',
  `status` enum('draft','published') DEFAULT 'published',
  `privacy_setting` enum('public','private','friends_only') DEFAULT 'public',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_book_review` (`user_id`,`book_id`),
  KEY `idx_book_rating` (`book_id`,`rating`),
  KEY `idx_user_reviews` (`user_id`,`created_at`),
  KEY `book_id` (`book_id`),
  CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `reviews_chk_1` CHECK ((`rating` >= 1) and (`rating` <= 5))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `friends`
--

DROP TABLE IF EXISTS `friends`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `friends` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user1_id` int NOT NULL,
  `user2_id` int NOT NULL,
  `status` enum('active','blocked') DEFAULT 'active',
  `date_connected` date DEFAULT NULL,
  `last_interaction_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_friendship` (`user1_id`,`user2_id`),
  KEY `idx_user1_friends` (`user1_id`,`status`),
  KEY `idx_user2_friends` (`user2_id`,`status`),
  KEY `user2_id` (`user2_id`),
  CONSTRAINT `friends_ibfk_1` FOREIGN KEY (`user1_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `friends_ibfk_2` FOREIGN KEY (`user2_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `friends_chk_1` CHECK ((`user1_id` < `user2_id`))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `friend_requests`
--

DROP TABLE IF EXISTS `friend_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `friend_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `requester_id` int NOT NULL,
  `recipient_id` int NOT NULL,
  `status` enum('pending','accepted','rejected') DEFAULT 'pending',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `responded_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_friend_request` (`requester_id`,`recipient_id`),
  KEY `idx_recipient_status` (`recipient_id`,`status`),
  KEY `idx_requester_status` (`requester_id`,`status`),
  KEY `recipient_id` (`recipient_id`),
  CONSTRAINT `friend_requests_ibfk_1` FOREIGN KEY (`requester_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `friend_requests_ibfk_2` FOREIGN KEY (`recipient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `friend_requests_chk_1` CHECK ((`requester_id` != `recipient_id`))
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `activities`
--

DROP TABLE IF EXISTS `activities`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `activities` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `activity_type` varchar(50) NOT NULL COMMENT 'added_book, finished_reading, wrote_review, earned_badge',
  `target_book_id` int DEFAULT NULL,
  `target_review_id` int DEFAULT NULL,
  `target_badge_id` int DEFAULT NULL,
  `activity_metadata` json DEFAULT NULL,
  `visibility` enum('public','private','friends_only') DEFAULT 'public',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_activity` (`user_id`,`created_at`),
  KEY `idx_activity_type` (`activity_type`,`created_at`),
  KEY `target_book_id` (`target_book_id`),
  KEY `target_review_id` (`target_review_id`),
  KEY `target_badge_id` (`target_badge_id`),
  CONSTRAINT `activities_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `activities_ibfk_2` FOREIGN KEY (`target_book_id`) REFERENCES `books` (`id`) ON DELETE SET NULL,
  CONSTRAINT `activities_ibfk_3` FOREIGN KEY (`target_review_id`) REFERENCES `reviews` (`id`) ON DELETE SET NULL,
  CONSTRAINT `activities_ibfk_4` FOREIGN KEY (`target_badge_id`) REFERENCES `badges` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `badges`
--

DROP TABLE IF EXISTS `badges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `badges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text,
  `category` enum('Reading','Collection','Social','Discovery') NOT NULL,
  `tier` enum('Bronze','Silver','Gold','Platinum','Diamond') NOT NULL,
  `icon_url` varchar(500) DEFAULT NULL,
  `unlock_criteria` json DEFAULT NULL,
  `points_value` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  KEY `idx_category_tier` (`category`,`tier`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user_badges`
--

DROP TABLE IF EXISTS `user_badges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_badges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `badge_id` int NOT NULL,
  `date_earned` date NOT NULL,
  `progress_to_next_tier` decimal(5,2) DEFAULT '0.00',
  `display_priority` int DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_badge` (`user_id`,`badge_id`),
  KEY `idx_user_badges` (`user_id`,`date_earned`),
  KEY `idx_badge_users` (`badge_id`,`date_earned`),
  KEY `badge_id` (`badge_id`),
  CONSTRAINT `user_badges_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_badges_ibfk_2` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_badges_chk_1` CHECK ((`progress_to_next_tier` >= 0) and (`progress_to_next_tier` <= 100))
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `book_authors`
--

DROP TABLE IF EXISTS `book_authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_authors` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `author_id` int NOT NULL,
  `role` varchar(50) DEFAULT 'author' COMMENT 'author, co-author, illustrator, editor, translator',
  `author_order` int DEFAULT '0' COMMENT 'Order for display (0 = primary author)',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_book_author` (`book_id`,`author_id`),
  KEY `idx_book_authors` (`book_id`,`author_order`),
  KEY `idx_author_books` (`author_id`),
  KEY `author_id` (`author_id`),
  CONSTRAINT `book_authors_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `book_authors_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `authors` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `book_genres`
--

DROP TABLE IF EXISTS `book_genres`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_genres` (
  `id` int NOT NULL AUTO_INCREMENT,
  `book_id` int NOT NULL,
  `genre_id` int NOT NULL,
  `designation` enum('primary','secondary') DEFAULT 'primary',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_book_genre` (`book_id`,`genre_id`),
  KEY `idx_book_genres` (`book_id`,`designation`),
  KEY `idx_genre_books` (`genre_id`),
  KEY `genre_id` (`genre_id`),
  CONSTRAINT `book_genres_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `book_genres_ibfk_2` FOREIGN KEY (`genre_id`) REFERENCES `genres` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `recipient_id` int NOT NULL,
  `notification_type` varchar(50) NOT NULL COMMENT 'friend_request, review_comment, activity_mention, badge_earned',
  `associated_friend_request_id` int DEFAULT NULL,
  `associated_review_id` int DEFAULT NULL,
  `notification_content` text,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `read_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `idx_recipient_read` (`recipient_id`,`is_read`,`created_at`),
  KEY `idx_notification_type` (`notification_type`,`created_at`),
  KEY `associated_friend_request_id` (`associated_friend_request_id`),
  KEY `associated_review_id` (`associated_review_id`),
  CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`recipient_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`associated_friend_request_id`) REFERENCES `friend_requests` (`id`) ON DELETE SET NULL,
  CONSTRAINT `notifications_ibfk_3` FOREIGN KEY (`associated_review_id`) REFERENCES `reviews` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'alice@example.com','alice_reader','$2y$10$example_hash_1','Alice Johnson','Avid fantasy reader and book collector','https://example.com/avatars/alice.jpg',NULL,15,4500,'2024-01-15 10:00:00','2024-01-15 10:00:00',NULL),(2,'bob@example.com','bob_bookworm','$2y$10$example_hash_2','Bob Smith','Science fiction enthusiast','https://example.com/avatars/bob.jpg',NULL,8,2400,'2024-01-10 10:00:00','2024-01-10 10:00:00',NULL),(3,'charlie@example.com','charlie_lit','$2y$10$example_hash_3','Charlie Brown','Literary fiction lover','https://example.com/avatars/charlie.jpg',NULL,12,3600,'2023-12-01 10:00:00','2023-12-01 10:00:00',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'9780439708180','Harry Potter and the Philosopher\'s Stone',NULL,'The first book in the Harry Potter series','https://example.com/covers/hp1.jpg','1997-06-26','Bloomsbury',223,'English','google_books',NULL,'2024-01-15 10:00:00','2024-01-15 10:00:00'),(2,'9780553103540','A Game of Thrones','A Song of Ice and Fire: Book One','The first book in the epic fantasy series','https://example.com/covers/got1.jpg','1996-08-01','Bantam Books',694,'English','google_books',NULL,'2024-02-01 10:00:00','2024-02-01 10:00:00'),(3,'9780141439518','Pride and Prejudice',NULL,'A romantic novel of manners','https://example.com/covers/pap.jpg','1813-01-28','T. Egerton',432,'English','open_library',NULL,'2024-02-15 10:00:00','2024-02-15 10:00:00'),(4,'9780061120084','To Kill a Mockingbird',NULL,'A novel about racial inequality in the American South','https://example.com/covers/tkam.jpg','1960-07-11','J.B. Lippincott & Co.',281,'English','google_books',NULL,'2024-02-10 10:00:00','2024-02-10 10:00:00'),(5,'9781982137274','The Seven Husbands of Evelyn Hugo',NULL,'A captivating novel about a reclusive Hollywood icon','https://example.com/covers/evelyn.jpg','2017-06-13','Atria Books',400,'English','google_books',NULL,'2024-02-12 10:00:00','2024-02-12 10:00:00');
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `authors`
--

LOCK TABLES `authors` WRITE;
/*!40000 ALTER TABLE `authors` DISABLE KEYS */;
INSERT INTO `authors` VALUES (1,'J.K. Rowling','British author best known for the Harry Potter series','https://example.com/authors/rowling.jpg','1965-07-31',NULL,'2024-01-15 10:00:00','2024-01-15 10:00:00'),(2,'George R.R. Martin','American novelist and short story writer, author of A Song of Ice and Fire','https://example.com/authors/martin.jpg','1948-09-20',NULL,'2024-02-01 10:00:00','2024-02-01 10:00:00'),(3,'Jane Austen','English novelist known for her romantic fiction','https://example.com/authors/austen.jpg','1775-12-16','1817-07-18','2024-02-15 10:00:00','2024-02-15 10:00:00');
/*!40000 ALTER TABLE `authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `genres`
--

LOCK TABLES `genres` WRITE;
/*!40000 ALTER TABLE `genres` DISABLE KEYS */;
INSERT INTO `genres` VALUES (1,'Fiction',NULL,'2024-01-15 10:00:00'),(2,'Fantasy',1,'2024-01-15 10:00:00'),(3,'Science Fiction',1,'2024-01-15 10:00:00'),(4,'Romance',1,'2024-01-15 10:00:00'),(5,'Mystery',1,'2024-01-15 10:00:00');
/*!40000 ALTER TABLE `genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_books`
--

LOCK TABLES `user_books` WRITE;
/*!40000 ALTER TABLE `user_books` DISABLE KEYS */;
INSERT INTO `user_books` VALUES (1,1,1,'Read',5,'Amazing start to the series!',223,100.00,'2024-01-15','2024-01-15','2024-01-20',NULL,'2024-01-15 10:00:00','2024-01-20 10:00:00'),(2,1,2,'Currently Reading',4,'Very engaging, love the characters',350,50.43,'2024-02-01','2024-02-01',NULL,NULL,'2024-02-01 10:00:00','2024-02-06 10:00:00'),(3,2,1,'Read',5,'Childhood favorite, re-read for nostalgia',223,100.00,'2024-01-10','2024-01-10','2024-01-12',NULL,'2024-01-10 10:00:00','2024-01-12 10:00:00'),(4,2,3,'Want to Read',NULL,'Classic I need to read',0,0.00,'2024-02-15',NULL,NULL,NULL,'2024-02-15 10:00:00','2024-02-15 10:00:00'),(5,3,2,'Read',5,'Epic fantasy at its finest',694,100.00,'2023-12-01','2023-12-01','2023-12-20',NULL,'2023-12-01 10:00:00','2023-12-20 10:00:00'),(6,3,4,'Currently Reading',NULL,'Powerful story',150,53.38,'2024-02-10','2024-02-10',NULL,NULL,'2024-02-10 10:00:00','2024-02-13 10:00:00');
/*!40000 ALTER TABLE `user_books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `reading_sessions`
--

LOCK TABLES `reading_sessions` WRITE;
/*!40000 ALTER TABLE `reading_sessions` DISABLE KEYS */;
INSERT INTO `reading_sessions` VALUES (1,2,'2024-02-05',45,25,'Great chapter about the Wall','Home','2024-02-05 10:00:00'),(2,2,'2024-02-06',60,30,'Daenerys chapters are fascinating','Coffee Shop','2024-02-06 10:00:00'),(3,6,'2024-02-12',30,20,'Atticus is such a great character','Library','2024-02-12 10:00:00'),(4,6,'2024-02-13',40,25,'The trial scene is intense','Home','2024-02-13 10:00:00');
/*!40000 ALTER TABLE `reading_sessions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `reading_history`
--

LOCK TABLES `reading_history` WRITE;
/*!40000 ALTER TABLE `reading_history` DISABLE KEYS */;
INSERT INTO `reading_history` VALUES (1,1,'2024-02-05',25,4525,5,'2024-02-05 10:00:00','2024-02-05 10:00:00'),(2,1,'2024-02-06',30,4555,6,'2024-02-06 10:00:00','2024-02-06 10:00:00'),(3,2,'2024-01-10',100,100,1,'2024-01-10 10:00:00','2024-01-10 10:00:00'),(4,2,'2024-01-11',123,223,2,'2024-01-11 10:00:00','2024-01-11 10:00:00'),(5,3,'2024-02-12',20,3620,3,'2024-02-12 10:00:00','2024-02-12 10:00:00'),(6,3,'2024-02-13',25,3645,4,'2024-02-13 10:00:00','2024-02-13 10:00:00');
/*!40000 ALTER TABLE `reading_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `shelves`
--

LOCK TABLES `shelves` WRITE;
/*!40000 ALTER TABLE `shelves` DISABLE KEYS */;
INSERT INTO `shelves` VALUES (1,1,'Fantasy Favorites','My favorite fantasy books','wood',1,'public','2024-01-20 10:00:00','2024-01-20 10:00:00'),(2,1,'To Read','Books I want to read next','modern',2,'private','2024-02-01 10:00:00','2024-02-01 10:00:00'),(3,2,'Classics','Classic literature collection','vintage',1,'friends_only','2024-02-15 10:00:00','2024-02-15 10:00:00'),(4,3,'Epic Series','Long fantasy and sci-fi series','wood',1,'public','2023-12-20 10:00:00','2023-12-20 10:00:00');
/*!40000 ALTER TABLE `shelves` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `shelf_books`
--

LOCK TABLES `shelf_books` WRITE;
/*!40000 ALTER TABLE `shelf_books` DISABLE KEYS */;
INSERT INTO `shelf_books` VALUES (1,1,1,1,'The book that started it all','2024-01-20','2024-01-20 10:00:00'),(2,1,2,2,'Currently reading, loving it','2024-02-01','2024-02-01 10:00:00'),(3,3,3,1,'A must-read classic','2024-02-15','2024-02-15 10:00:00'),(4,4,2,1,'Best fantasy series','2023-12-20','2023-12-20 10:00:00');
/*!40000 ALTER TABLE `shelf_books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,1,1,'This book is absolutely magical! J.K. Rowling creates such a vivid world that you can\'t help but get lost in it. The characters are well-developed and the plot is engaging from start to finish. A perfect introduction to the wizarding world.',5,12,'published','public','2024-01-20 10:00:00','2024-01-20 10:00:00'),(2,2,1,'Re-reading this as an adult was such a joy. The story holds up beautifully and I noticed so many details I missed as a child. Highly recommend for readers of all ages.',5,8,'published','public','2024-01-12 10:00:00','2024-01-12 10:00:00'),(3,3,2,'George R.R. Martin is a master storyteller. The multiple POVs work brilliantly and the political intrigue is fascinating. Can\'t wait to continue the series!',5,15,'published','public','2023-12-20 10:00:00','2023-12-20 10:00:00');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `friends`
--

LOCK TABLES `friends` WRITE;
/*!40000 ALTER TABLE `friends` DISABLE KEYS */;
INSERT INTO `friends` VALUES (1,1,2,'active','2024-01-05','2024-02-10 10:00:00','2024-01-05 10:00:00'),(2,1,3,'active','2024-01-20','2024-02-12 10:00:00','2024-01-20 10:00:00'),(3,2,3,'active','2023-12-15','2024-02-08 10:00:00','2023-12-15 10:00:00');
/*!40000 ALTER TABLE `friends` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `friend_requests`
--

LOCK TABLES `friend_requests` WRITE;
/*!40000 ALTER TABLE `friend_requests` DISABLE KEYS */;
INSERT INTO `friend_requests` VALUES (1,1,2,'accepted','2024-01-05 10:00:00','2024-01-05 14:30:00'),(2,1,3,'accepted','2024-01-20 09:15:00','2024-01-20 11:45:00'),(3,2,3,'accepted','2023-12-15 16:20:00','2023-12-15 18:00:00');
/*!40000 ALTER TABLE `friend_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `activities`
--

LOCK TABLES `activities` WRITE;
/*!40000 ALTER TABLE `activities` DISABLE KEYS */;
INSERT INTO `activities` VALUES (1,1,'added_book',1,NULL,NULL,'{\"source\": \"isbn_scan\"}','public','2024-01-15 10:00:00'),(2,1,'finished_reading',1,NULL,NULL,'{\"pages_read\": 223, \"days_taken\": 5}','public','2024-01-20 10:00:00'),(3,1,'wrote_review',1,1,NULL,'{\"rating\": 5}','public','2024-01-20 10:00:00'),(4,2,'added_book',1,NULL,NULL,'{\"source\": \"search\"}','public','2024-01-10 10:00:00'),(5,3,'finished_reading',2,NULL,NULL,'{\"pages_read\": 694, \"days_taken\": 19}','public','2023-12-20 10:00:00'),(6,3,'wrote_review',2,3,NULL,'{\"rating\": 5}','public','2023-12-20 10:00:00');
/*!40000 ALTER TABLE `activities` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `badges`
--

LOCK TABLES `badges` WRITE;
/*!40000 ALTER TABLE `badges` DISABLE KEYS */;
INSERT INTO `badges` VALUES (1,'First Book','Read your first book','Reading','Bronze','https://example.com/badges/first_book.png','{\"books_read\": 1}',10,'2024-01-15 10:00:00'),(2,'Bookworm','Read 10 books','Reading','Silver','https://example.com/badges/bookworm.png','{\"books_read\": 10}',50,'2024-01-15 10:00:00'),(3,'Page Turner','Read 1000 pages','Reading','Bronze','https://example.com/badges/page_turner.png','{\"pages_read\": 1000}',25,'2024-01-15 10:00:00'),(4,'Social Reader','Write 5 reviews','Social','Silver','https://example.com/badges/social_reader.png','{\"reviews_written\": 5}',40,'2024-01-15 10:00:00'),(5,'Friend Maker','Add 3 friends','Social','Bronze','https://example.com/badges/friend_maker.png','{\"friends_count\": 3}',15,'2024-01-15 10:00:00');
/*!40000 ALTER TABLE `badges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `user_badges`
--

LOCK TABLES `user_badges` WRITE;
/*!40000 ALTER TABLE `user_badges` DISABLE KEYS */;
INSERT INTO `user_badges` VALUES (1,1,1,'2024-01-20',0.00,1,'2024-01-20 10:00:00'),(2,1,3,'2024-01-25',0.00,2,'2024-01-25 10:00:00'),(3,2,1,'2024-01-12',0.00,1,'2024-01-12 10:00:00'),(4,3,1,'2023-12-20',0.00,1,'2023-12-20 10:00:00'),(5,3,2,'2024-01-15',0.00,1,'2024-01-15 10:00:00'),(6,3,3,'2024-01-10',0.00,2,'2024-01-10 10:00:00');
/*!40000 ALTER TABLE `user_badges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `book_authors`
--

LOCK TABLES `book_authors` WRITE;
/*!40000 ALTER TABLE `book_authors` DISABLE KEYS */;
INSERT INTO `book_authors` VALUES (1,1,1,'author',0,'2024-01-15 10:00:00'),(2,2,2,'author',0,'2024-02-01 10:00:00'),(3,3,3,'author',0,'2024-02-15 10:00:00');
/*!40000 ALTER TABLE `book_authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `book_genres`
--

LOCK TABLES `book_genres` WRITE;
/*!40000 ALTER TABLE `book_genres` DISABLE KEYS */;
INSERT INTO `book_genres` VALUES (1,1,2,'primary','2024-01-15 10:00:00'),(2,2,2,'primary','2024-02-01 10:00:00'),(3,3,4,'primary','2024-02-15 10:00:00'),(4,4,1,'primary','2024-02-10 10:00:00'),(5,5,4,'primary','2024-02-12 10:00:00');
/*!40000 ALTER TABLE `book_genres` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping data for table `notifications`
--

LOCK TABLES `notifications` WRITE;
/*!40000 ALTER TABLE `notifications` DISABLE KEYS */;
INSERT INTO `notifications` VALUES (1,2,'friend_request',1,NULL,'alice_reader sent you a friend request',1,'2024-01-05 10:00:00','2024-01-05 14:30:00'),(2,3,'friend_request',2,NULL,'alice_reader sent you a friend request',1,'2024-01-20 09:15:00','2024-01-20 11:45:00'),(3,1,'activity_mention',NULL,NULL,'bob_bookworm liked your review of Harry Potter and the Philosopher\'s Stone',0,NULL,'2024-02-10 10:00:00'),(4,2,'badge_earned',NULL,NULL,'Congratulations! You earned the First Book badge',1,'2024-01-12 10:00:00','2024-01-12 10:00:00'),(5,3,'badge_earned',NULL,NULL,'Congratulations! You earned the Bookworm badge',0,NULL,'2024-01-15 10:00:00');
/*!40000 ALTER TABLE `notifications` ENABLE KEYS */;
UNLOCK TABLES;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2024-02-15 10:00:00

