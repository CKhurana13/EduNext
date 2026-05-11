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
-- Table structure for table `timetable`
--

DROP TABLE IF EXISTS `timetable`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `timetable` (
  `timetable_id` int NOT NULL AUTO_INCREMENT,
  `class_name` varchar(20) DEFAULT NULL,
  `day` varchar(30) DEFAULT NULL,
  `period_no` int DEFAULT NULL,
  `sub_id` int DEFAULT NULL,
  `t_id` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`timetable_id`),
  KEY `class_name` (`class_name`),
  KEY `sub_id` (`sub_id`),
  KEY `t_id` (`t_id`),
  CONSTRAINT `timetable_ibfk_1` FOREIGN KEY (`class_name`) REFERENCES `class_login` (`class_name`),
  CONSTRAINT `timetable_ibfk_2` FOREIGN KEY (`sub_id`) REFERENCES `subjects` (`sub_id`),
  CONSTRAINT `timetable_ibfk_3` FOREIGN KEY (`t_id`) REFERENCES `teacher` (`t_id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `timetable`
--

LOCK TABLES `timetable` WRITE;
/*!40000 ALTER TABLE `timetable` DISABLE KEYS */;
INSERT INTO `timetable` VALUES (13,'12A','Monday',1,5,'101'),(14,'11A','Monday',1,6,'101'),(69,'12A','Monday',1,5,'101'),(70,'12A','Monday',2,3,'104'),(71,'12A','Monday',4,7,'106'),(72,'12A','Monday',5,1,'102'),(73,'12A','Monday',7,9,'108'),(74,'12A','Tuesday',1,11,'110'),(75,'12A','Tuesday',2,3,'104'),(76,'12A','Tuesday',4,5,'101'),(77,'12A','Tuesday',5,7,'106'),(78,'12A','Tuesday',7,1,'102'),(79,'11A','Monday',1,6,'101'),(80,'11A','Monday',2,4,'105'),(81,'11A','Monday',4,8,'107'),(82,'11A','Monday',5,2,'103'),(83,'11A','Monday',7,10,'109'),(84,'11A','Tuesday',1,12,'111'),(85,'11A','Tuesday',2,4,'105'),(86,'11A','Tuesday',4,6,'101'),(87,'11A','Tuesday',5,8,'107'),(88,'11A','Tuesday',7,2,'103');
/*!40000 ALTER TABLE `timetable` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-05-11 14:04:15
