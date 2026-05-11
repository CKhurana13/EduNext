-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: teacher_web
-- ------------------------------------------------------
-- Server version	8.0.41

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
-- Table structure for table `homework`
--

DROP TABLE IF EXISTS `homework`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `homework` (
  `hw_id` int NOT NULL AUTO_INCREMENT,
  `className` varchar(10) NOT NULL,
  `sub_id` int NOT NULL,
  `chapter` varchar(50) DEFAULT NULL,
  `description` text,
  `due_date` date DEFAULT NULL,
  `assigned_date` date DEFAULT NULL,
  `t_id` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`hw_id`),
  KEY `sub_id` (`sub_id`),
  KEY `t_id` (`t_id`),
  CONSTRAINT `homework_ibfk_1` FOREIGN KEY (`sub_id`) REFERENCES `subjects` (`sub_id`),
  CONSTRAINT `homework_ibfk_2` FOREIGN KEY (`t_id`) REFERENCES `teacher` (`t_id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `homework`
--

LOCK TABLES `homework` WRITE;
/*!40000 ALTER TABLE `homework` DISABLE KEYS */;
INSERT INTO `homework` VALUES (1,'12A',5,'Chapter 1: India','Completet back exercise in Fair Notebook','2025-07-31','2025-07-29','101'),(3,'12A',5,'Chapter 2 - French revolution','Read Complete Chapter','2025-08-02','2025-07-29','101'),(4,'12A',5,'Chapter 2 - French revolution','Read Completet Chapter','2025-08-02','2025-07-29','101'),(5,'12A',5,'Chapter 3: Palampur','Read','2025-08-02','2025-07-29','101'),(6,'12A',5,'chapter 4: XYZ','complete work','2025-07-30','2025-07-30','101'),(7,'12A',5,'chapter 4: XYZ','complete work','2025-07-30','2025-08-24','101'),(8,'12A',5,'Chapter 3: Palampur','sxsxgdq','2026-05-12','2026-05-10','101');
/*!40000 ALTER TABLE `homework` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-11 14:04:14
