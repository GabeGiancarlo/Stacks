mysqldump: [Warning] Using a password on the command line interface can be insecure.
-- MySQL dump 10.13  Distrib 8.0.44, for Linux (aarch64)
--
-- Host: localhost    Database: stacks_db
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `badges`
--

DROP TABLE IF EXISTS `badges`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `badges` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `tier` enum('bronze','silver','gold','platinum') NOT NULL,
  `icon_url` varchar(500) DEFAULT NULL,
  `criteria` text,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `badges`
--

LOCK TABLES `badges` WRITE;
/*!40000 ALTER TABLE `badges` DISABLE KEYS */;
INSERT INTO `badges` VALUES (1,'First Book','bronze',NULL,'Add your first book to the library'),(2,'Bookworm','silver',NULL,'Add 10 books to your library'),(3,'Avid Reader','gold',NULL,'Add 50 books to your library'),(4,'Literary Master','platinum',NULL,'Add 100 books to your library'),(5,'Reviewer','bronze',NULL,'Write your first review'),(6,'Critic','silver',NULL,'Write 10 reviews'),(7,'Book Critic','gold',NULL,'Write 50 reviews');
/*!40000 ALTER TABLE `badges` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `books`
--

DROP TABLE IF EXISTS `books`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `books` (
  `id` int NOT NULL AUTO_INCREMENT,
  `isbn` varchar(20) DEFAULT NULL,
  `title` varchar(500) NOT NULL,
  `author` varchar(255) NOT NULL,
  `cover_url` varchar(500) DEFAULT NULL,
  `description` text,
  `published_year` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_54337dc30d9bb2c3fadebc69094` (`isbn`)
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `books`
--

LOCK TABLES `books` WRITE;
/*!40000 ALTER TABLE `books` DISABLE KEYS */;
INSERT INTO `books` VALUES (1,'9780593099322','Dune','Frank Herbert',NULL,'Set on the desert planet Arrakis, Dune is the story of the boy Paul Atreides.',1965),(2,'9780439064873','Harry Potter and the Chamber of Secrets','J.K. Rowling',NULL,'The second book in the Harry Potter series.',1998),(3,'9780143127741','The Great Gatsby','F. Scott Fitzgerald',NULL,'A classic American novel about the Jazz Age.',1925),(4,'9781982137274','Project Hail Mary','Andy Weir',NULL,'A lone astronaut must save the earth from disaster.',2021),(5,'9780316251309','The Three-Body Problem','Liu Cixin',NULL,'A science fiction novel about humanity\'s first contact with an alien civilization.',2008),(6,'9780061120084','To Kill a Mockingbird','Harper Lee',NULL,'A gripping tale of racial injustice and loss of innocence.',1960),(7,'9780141439563','Pride and Prejudice','Jane Austen',NULL,'A romantic novel of manners written by Jane Austen.',1813),(8,'9780451524935','1984','George Orwell',NULL,'A dystopian social science fiction novel.',1949),(9,'9780060850524','Brave New World','Aldous Huxley',NULL,'A dystopian novel set in a futuristic World State.',1932),(10,'9780143039433','The Catcher in the Rye','J.D. Salinger',NULL,'A controversial novel about teenage rebellion.',1951),(11,'9780385494244','The Handmaid\'s Tale','Margaret Atwood',NULL,'A dystopian novel set in a totalitarian theocracy.',1985),(12,'9780062561029','The Seven Husbands of Evelyn Hugo','Taylor Jenkins Reid',NULL,'A captivating novel about a reclusive Hollywood icon.',2017),(13,'9781250178632','The Midnight Library','Matt Haig',NULL,'A novel about a library that contains books with different versions of one\'s life.',2020),(14,'9780525559474','The Invisible Man','Ralph Ellison',NULL,'A groundbreaking novel about race and identity in America.',1952),(15,'9780061122415','The Book Thief','Markus Zusak',NULL,'A story about a young girl living in Nazi Germany.',2005);
/*!40000 ALTER TABLE `books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `migrations`
--

DROP TABLE IF EXISTS `migrations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `migrations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `timestamp` bigint NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `migrations`
--

LOCK TABLES `migrations` WRITE;
/*!40000 ALTER TABLE `migrations` DISABLE KEYS */;
INSERT INTO `migrations` VALUES (1,1700000000000,'InitialSchema1700000000000');
/*!40000 ALTER TABLE `migrations` ENABLE KEYS */;
UNLOCK TABLES;

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
  `rating` int NOT NULL,
  `review_text` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_728447781a30bc3fcfe5c2f1cdf` (`user_id`),
  KEY `FK_1259866c6ef3e58270e2ff6abfd` (`book_id`),
  CONSTRAINT `FK_1259866c6ef3e58270e2ff6abfd` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_728447781a30bc3fcfe5c2f1cdf` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reviews`
--

LOCK TABLES `reviews` WRITE;
/*!40000 ALTER TABLE `reviews` DISABLE KEYS */;
INSERT INTO `reviews` VALUES (1,1,1,5,'An absolute masterpiece! The world-building is incredible.','2025-12-02 21:40:00','2025-12-02 21:40:00'),(2,1,2,4,'Great continuation of the series. Loved the mystery element.','2025-12-02 21:40:00','2025-12-02 21:40:00'),(3,1,3,5,'A timeless classic. The prose is beautiful.','2025-12-02 21:40:00','2025-12-02 21:40:00');
/*!40000 ALTER TABLE `reviews` ENABLE KEYS */;
UNLOCK TABLES;

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
  `earned_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_f1221d9b1aaa64b1f3c98ed46d3` (`user_id`),
  KEY `FK_715b81e610ab276ff6603cfc8e8` (`badge_id`),
  CONSTRAINT `FK_715b81e610ab276ff6603cfc8e8` FOREIGN KEY (`badge_id`) REFERENCES `badges` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_f1221d9b1aaa64b1f3c98ed46d3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_badges`
--

LOCK TABLES `user_badges` WRITE;
/*!40000 ALTER TABLE `user_badges` DISABLE KEYS */;
INSERT INTO `user_badges` VALUES (1,1,1,'2025-12-02 21:40:00'),(2,1,5,'2025-12-02 21:40:00');
/*!40000 ALTER TABLE `user_badges` ENABLE KEYS */;
UNLOCK TABLES;

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
  `status` enum('want_to_read','reading','read') NOT NULL DEFAULT 'want_to_read',
  `added_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `FK_e746bb935afa81fbcaed41036f1` (`user_id`),
  KEY `FK_2cf4aaa9d796a62fe330a799822` (`book_id`),
  CONSTRAINT `FK_2cf4aaa9d796a62fe330a799822` FOREIGN KEY (`book_id`) REFERENCES `books` (`id`) ON DELETE CASCADE,
  CONSTRAINT `FK_e746bb935afa81fbcaed41036f1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_books`
--

LOCK TABLES `user_books` WRITE;
/*!40000 ALTER TABLE `user_books` DISABLE KEYS */;
INSERT INTO `user_books` VALUES (1,1,1,'read','2025-12-02 21:40:00'),(2,1,2,'read','2025-12-02 21:40:00'),(3,1,3,'read','2025-12-02 21:40:00'),(4,1,4,'read','2025-12-02 21:40:00'),(5,1,5,'read','2025-12-02 21:40:00'),(6,1,6,'reading','2025-12-02 21:40:00'),(7,1,7,'reading','2025-12-02 21:40:00'),(8,1,8,'reading','2025-12-02 21:40:00'),(9,1,9,'reading','2025-12-02 21:40:00'),(10,1,10,'reading','2025-12-02 21:40:00');
/*!40000 ALTER TABLE `user_books` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `username` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_97672ac88f789774dd47f7c8be3` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'user@test.com','$2b$12$90LxPUAEJqV3pEJLWcejAepOlFkMcTDJ5ZYxeILE4/uaDa8T88Bzy','testuser','2025-12-02 21:40:00'),(2,'admin@test.com','$2b$12$fuEey9ZMiDIF/GyeBxroBeAa3Oi6tSXEwAfO4gfbw3hwJ6sPMWHd6','admin','2025-12-02 21:40:00');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'stacks_db'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-12 20:06:44
