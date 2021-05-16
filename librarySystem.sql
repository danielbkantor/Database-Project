-- MySQL dump 10.13  Distrib 8.0.23, for Win64 (x86_64)
--
-- Host: localhost    Database: library_system
-- ------------------------------------------------------
-- Server version	8.0.23

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `book`
--

DROP TABLE IF EXISTS `book`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book` (
  `book_id` int NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `publisher_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`book_id`),
  KEY `publisher_name` (`publisher_name`),
  CONSTRAINT `book_ibfk_1` FOREIGN KEY (`publisher_name`) REFERENCES `publisher` (`name`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book`
--

LOCK TABLES `book` WRITE;
/*!40000 ALTER TABLE `book` DISABLE KEYS */;
INSERT INTO `book` VALUES (1,'First 100 Words','Priddy Books'),(2,'Harry Potter','Pottermore'),(3,'Hunger Games','Scholastic'),(4,'Databases','Pearson');
/*!40000 ALTER TABLE `book` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_authors`
--

DROP TABLE IF EXISTS `book_authors`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_authors` (
  `book_id` int NOT NULL,
  `author_name` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`book_id`),
  CONSTRAINT `book_authors_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_authors`
--

LOCK TABLES `book_authors` WRITE;
/*!40000 ALTER TABLE `book_authors` DISABLE KEYS */;
INSERT INTO `book_authors` VALUES (1,'Priddy'),(2,'Rowling'),(3,'Collins'),(4,'Elmasri');
/*!40000 ALTER TABLE `book_authors` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_copies`
--

DROP TABLE IF EXISTS `book_copies`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_copies` (
  `book_id` int NOT NULL,
  `branch_id` int NOT NULL,
  `no_of_copies` int DEFAULT NULL,
  PRIMARY KEY (`book_id`,`branch_id`),
  KEY `branch_id` (`branch_id`),
  CONSTRAINT `book_copies_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE,
  CONSTRAINT `book_copies_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `library_branch` (`branch_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_copies`
--

LOCK TABLES `book_copies` WRITE;
/*!40000 ALTER TABLE `book_copies` DISABLE KEYS */;
INSERT INTO `book_copies` VALUES (1,1,2),(1,2,1),(1,3,2),(2,1,2),(2,2,2),(2,3,3),(2,4,4),(2,5,10),(2,6,1),(3,1,5),(3,2,8),(3,3,11),(3,4,5),(3,5,7),(3,6,8),(4,1,1),(4,2,2),(4,3,4),(4,5,1),(4,6,3);
/*!40000 ALTER TABLE `book_copies` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `book_loans`
--

DROP TABLE IF EXISTS `book_loans`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `book_loans` (
  `book_id` int NOT NULL,
  `branch_id` int DEFAULT NULL,
  `card_no` int NOT NULL,
  `date_out` varchar(10) DEFAULT NULL,
  `due_date` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`book_id`,`card_no`),
  KEY `branch_id` (`branch_id`),
  KEY `card_no` (`card_no`),
  CONSTRAINT `book_loans_ibfk_1` FOREIGN KEY (`book_id`) REFERENCES `book` (`book_id`) ON DELETE CASCADE,
  CONSTRAINT `book_loans_ibfk_2` FOREIGN KEY (`branch_id`) REFERENCES `library_branch` (`branch_id`) ON DELETE CASCADE,
  CONSTRAINT `book_loans_ibfk_3` FOREIGN KEY (`card_no`) REFERENCES `borrower` (`card_no`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `book_loans`
--

LOCK TABLES `book_loans` WRITE;
/*!40000 ALTER TABLE `book_loans` DISABLE KEYS */;
INSERT INTO `book_loans` VALUES (1,1,100,'8/19/2017','11/18/2017'),(1,2,101,'12/20/2017','3/19/2018'),(1,3,102,'12/21/2017','3/20/2018'),(1,3,103,'12/22/2017','3/21/2018'),(2,1,104,'12/23/2017','3/22/2018'),(2,1,105,'12/24/2017','3/23/2018'),(2,2,106,'12/25/2017','3/24/2018'),(2,3,107,'12/26/2017','3/25/2018'),(2,3,108,'12/27/2017','3/26/2018'),(2,4,109,'12/28/2017','3/27/2018'),(2,4,110,'12/29/2017','3/28/2018'),(2,4,111,'12/30/2017','3/29/2018'),(2,5,112,'12/31/2017','3/30/2018'),(2,5,113,'1/1/2018','3/31/2018'),(2,5,114,'1/2/2018','4/1/2018'),(2,5,115,'1/3/2018','4/2/2018'),(2,5,116,'1/4/2018','4/3/2018'),(2,5,117,'1/5/2018','4/4/2018'),(2,5,118,'1/6/2018','4/5/2018'),(2,6,119,'1/7/2018','4/6/2018'),(3,1,120,'1/8/2018','4/7/2018'),(3,1,121,'1/9/2018','4/8/2018'),(3,1,122,'1/10/2018','4/9/2018'),(3,1,123,'1/11/2018','4/10/2018'),(3,2,124,'1/12/2018','4/11/2018'),(3,2,125,'1/13/2018','4/12/2018'),(3,2,126,'1/14/2018','4/13/2018'),(3,2,127,'1/15/2018','4/14/2018'),(3,2,128,'1/16/2018','4/15/2018'),(3,2,129,'1/17/2018','4/16/2018'),(3,2,130,'1/18/2018','4/17/2018'),(3,3,131,'1/19/2018','4/18/2018'),(3,3,132,'1/20/2018','4/19/2018'),(3,3,133,'1/21/2018','4/20/2018'),(3,3,134,'1/22/2018','4/21/2018'),(3,3,135,'1/23/2018','4/22/2018'),(3,3,136,'1/24/2018','4/23/2018'),(3,3,137,'1/25/2018','4/24/2018'),(3,4,138,'1/26/2018','4/25/2018'),(3,4,139,'1/27/2018','4/26/2018'),(3,5,140,'1/28/2018','4/27/2018'),(3,6,141,'1/29/2018','4/28/2018'),(4,1,142,'1/30/2018','4/29/2018'),(4,2,143,'1/31/2018','4/30/2018'),(4,3,144,'2/1/2018','5/1/2018'),(4,6,145,'2/2/2018','5/2/2018');
/*!40000 ALTER TABLE `book_loans` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `borrower`
--

DROP TABLE IF EXISTS `borrower`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `borrower` (
  `card_no` int NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `phone` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`card_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `borrower`
--

LOCK TABLES `borrower` WRITE;
/*!40000 ALTER TABLE `borrower` DISABLE KEYS */;
INSERT INTO `borrower` VALUES (100,'Mitchell','555-0023'),(101,'Jillian','555-0022'),(102,'Ryan','555-0016'),(103,'Carissa','555-0042'),(104,'Sahib','555-0024'),(105,'Alex','555-5309'),(106,'John','555-0012'),(107,'Kyle','555-0007'),(108,'Max','555-0040'),(109,'Link','555-0013'),(110,'Dorothy','555-0028'),(111,'Drew','555-0000'),(112,'Mark','555-0008'),(113,'An','555-0019'),(114,'Michael','555-0021'),(115,'Norlan','867-5309'),(116,'Jeremy','555-0015'),(117,'Alicia','555-0027'),(118,'Hillary','555-0034'),(119,'Antonio','555-0017'),(120,'Edgar','555-0028'),(121,'Kyle','555-0018'),(122,'Naomi','555-0038'),(123,'Jaskaran','555-0032'),(124,'Link','555-0025'),(125,'Tom','555-0031'),(126,'Lisa','555-0038'),(127,'Marth','555-0006'),(128,'Mario','555-0014'),(129,'Pikachu','555-0026'),(130,'Fox','555-0039'),(131,'Kirby','555-0010'),(132,'Katya','555-0008'),(133,'Samus','555-0037'),(134,'Yoshi','555-0009'),(135,'Snake','555-0011'),(136,'Danilo','555-0008'),(137,'Jigglypuff','555-0041'),(138,'Mario','555-0020'),(139,'Osvaldo','555-5555'),(140,'Bowser','555-0030'),(141,'Ness','555-0035'),(142,'Clement','555-0018'),(143,'Powercat','555-0033'),(144,'Wario','555-0036'),(145,'Leeroy','555-0003');
/*!40000 ALTER TABLE `borrower` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `library_branch`
--

DROP TABLE IF EXISTS `library_branch`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `library_branch` (
  `branch_id` int NOT NULL,
  `branch_name` varchar(100) DEFAULT NULL,
  `address` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`branch_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `library_branch`
--

LOCK TABLES `library_branch` WRITE;
/*!40000 ALTER TABLE `library_branch` DISABLE KEYS */;
INSERT INTO `library_branch` VALUES (1,'Knox Holt','UOP'),(2,'Green','Stanford'),(3,'Cubberley','Stanford'),(4,'Health Sciences','UOP'),(5,'Shields','Davis'),(6,'University','Turlock');
/*!40000 ALTER TABLE `library_branch` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `publisher`
--

DROP TABLE IF EXISTS `publisher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `publisher` (
  `name` varchar(100) NOT NULL,
  `address` varchar(100) DEFAULT NULL,
  `phone` varchar(12) DEFAULT NULL,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publisher`
--

LOCK TABLES `publisher` WRITE;
/*!40000 ALTER TABLE `publisher` DISABLE KEYS */;
INSERT INTO `publisher` VALUES ('Pearson','NJ','800-555-9996'),('Pottermore','UK','800-555-9998'),('Priddy Books','NY','800-555-9999'),('Scholastic','NY','800-555-9997');
/*!40000 ALTER TABLE `publisher` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-05-14 14:53:30
