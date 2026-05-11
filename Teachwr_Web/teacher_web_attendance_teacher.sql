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
-- Table structure for table `attendance_teacher`
--

DROP TABLE IF EXISTS `attendance_teacher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendance_teacher` (
  `attendance_id` int NOT NULL AUTO_INCREMENT,
  `attendance_date` date DEFAULT NULL,
  `status` enum('P','A','H') DEFAULT NULL,
  `s_id` varchar(20) DEFAULT NULL,
  `class_name` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`attendance_id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendance_teacher`
--

LOCK TABLES `attendance_teacher` WRITE;
/*!40000 ALTER TABLE `attendance_teacher` DISABLE KEYS */;
INSERT INTO `attendance_teacher` VALUES (1,'2025-07-27','P','102','12A'),(2,'2025-07-28','A','102','12A'),(3,'2025-07-29','P','102','12A'),(4,'2025-07-30','P','102','12A'),(5,'2025-07-31','P','102','12A'),(10,'2025-08-24','P','101','12A'),(11,'2025-08-24','P','102','12A'),(12,'2025-08-24','P','103','12A'),(13,'2025-08-24','P','106','12A'),(14,'2025-08-24','P','108','12A'),(15,'2025-08-24','P','110','12A'),(16,'2025-08-24','P','113','12A'),(17,'2025-08-24','P','114','12A');
/*!40000 ALTER TABLE `attendance_teacher` ENABLE KEYS */;
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
