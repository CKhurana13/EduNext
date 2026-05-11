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
-- Table structure for table `teacher`
--

DROP TABLE IF EXISTS `teacher`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `teacher` (
  `t_id` varchar(20) NOT NULL,
  `t_name` varchar(100) NOT NULL,
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `t_email` varchar(100) DEFAULT NULL,
  `subjects` varchar(255) DEFAULT NULL,
  `classes` varchar(255) DEFAULT NULL,
  `qualifications` varchar(255) DEFAULT NULL,
  `password` varchar(50) DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `doj` date DEFAULT NULL,
  `dob` date DEFAULT NULL,
  PRIMARY KEY (`t_id`),
  UNIQUE KEY `t_email` (`t_email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `teacher`
--

LOCK TABLES `teacher` WRITE;
/*!40000 ALTER TABLE `teacher` DISABLE KEYS */;
INSERT INTO `teacher` VALUES ('101','Vanika Sahu','XYZ Apartment, Rohini West','7838726117','vamikasahu02@gmail.com','Social Science','12A','Mtech','vanika','images/vanika.jpg','2019-09-08','2006-01-02'),('102','Ravi Kumar','Sector 15, Dwarka','9812345678','ravikumar@gmail.com','Mathematics','12A','M.Sc., B.Ed.','ravi123','images/ravi.jpg','2020-07-12','1985-06-15'),('103','Pooja Mehta','Vikas Puri, Delhi','9876543210','poojamehta@gmail.com','English','12A,11A,10A','M.A., B.Ed.','pooja123','images/pooja.jpg','2019-04-01','1987-11-23'),('104','Amit Sharma','Patel Nagar, Delhi','9123456780','amitsharma@gmail.com','Physics','12A','M.Sc., Ph.D.','amitpass','images/amit.jpg','2018-06-20','1984-03-30'),('105','Neha Verma','Lajpat Nagar, Delhi','9998887776','nehaverma@gmail.com','Chemistry','12A,11A,10A','M.Sc., NET','neha321','images/neha.jpg','2021-08-10','1990-01-19'),('106','Sandeep Singh','Karol Bagh, Delhi','8976543212','sandeep.singh@gmail.com','Biology','12A,11A','M.Sc., B.Ed.','sandy123','images/sandeep.jpg','2017-09-18','1986-05-05'),('107','Kavita Joshi','Ashok Vihar, Delhi','8867543210','kavitajoshi@gmail.com','Computer Science','12A','MCA, B.Ed.','kavita987','images/kavita.jpg','2022-01-15','1992-08-12'),('108','Rajeev Nair','Mayur Vihar, Delhi','9345612789','rajeev.nair@gmail.com','Economics','12A','M.A., M.Phil.','rajeev456','images/rajeev.jpg','2020-11-09','1989-04-27'),('109','Sneha Kapoor','Saket, Delhi','9786512340','sneha.kapoor@gmail.com','Political Science','12A,10A','M.A., UGC NET','sneha101','images/sneha.jpg','2016-03-25','1988-07-03'),('110','Alok Tiwari','Pitampura, Delhi','9032145678','aloktiwari@gmail.com','Physical Education','12A,11A','B.P.Ed., M.P.Ed.','alok999','images/alok.jpg','2015-12-05','1982-09-11'),('111','Meera Das','Janakpuri, Delhi','9765432101','meeradas@gmail.com','Hindi','12A,11A','M.A., B.Ed.','meera123','images/meera.jpg','2023-03-20','1991-02-14');
/*!40000 ALTER TABLE `teacher` ENABLE KEYS */;
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
