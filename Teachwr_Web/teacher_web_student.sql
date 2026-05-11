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
-- Table structure for table `student`
--

DROP TABLE IF EXISTS `student`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `student` (
  `s_id` varchar(10) NOT NULL,
  `s_name` varchar(100) NOT NULL,
  `f_name` varchar(100) DEFAULT NULL,
  `m_name` varchar(100) DEFAULT NULL,
  `s_email` varchar(100) DEFAULT NULL,
  `f_email` varchar(100) DEFAULT NULL,
  `m_email` varchar(100) DEFAULT NULL,
  `address` text,
  `dob` date DEFAULT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `class_name` varchar(20) DEFAULT NULL,
  `doa` date DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL,
  `class_code` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`s_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `student`
--

LOCK TABLES `student` WRITE;
/*!40000 ALTER TABLE `student` DISABLE KEYS */;
INSERT INTO `student` VALUES ('101','Raghav Tayal','Papa Tayal','Mummy Tayal','raghavtayal01@gmail.com','papatayal@gmail.com','mummytayal@gmail.com','inderlok','2005-09-01','9873517022','12A','2019-05-12','S/images/raghav.png','tiger55','AB12'),('102','Cheshta Khurana','Pawan Khurana','Ritu Khurana','cheshtak13@gmail.com','pawan@gmail.com','ritu@gmail.com','sector 3 Rohini','2005-11-13','9318368903','12A','2020-06-18','S/images/cheshta.png','vips','AB12'),('103','Ananya Sharma','Rajesh Sharma','Sunita Sharma','ananyas@gmail.com','rajeshs@gmail.com','sunis@gmail.com','Pitampura','2005-07-15','9876543210','12A','2020-06-20','S/images/ananya.png','sunshine','AB12'),('104','Aryan Gupta','Suresh Gupta','Kavita Gupta','aryangupta@gmail.com','sureshg@gmail.com','kavitag@gmail.com','Shalimar Bagh','2005-03-10','9879879870','10A','2020-06-22','S/images/aryan.png','aryan123','AB12'),('105','Mehak Jain','Pankaj Jain','Renu Jain','mehakjain@gmail.com','pankaj@gmail.com','renuj@gmail.com','Ashok Vihar','2005-12-02','9911223344','11A','2020-06-25','S/images/mehak.png','mehak456','AB12'),('106','Karan Mehta','Naresh Mehta','Anita Mehta','karanm@gmail.com','nareshm@gmail.com','anitam@gmail.com','Model Town','2005-06-29','9807654321','12A','2020-06-26','S/images/karan.png','karan99','AB12'),('107','Simran Kaur','Harjeet Singh','Gurmeet Kaur','simrankaur@gmail.com','harjeet@gmail.com','gurmeet@gmail.com','Punjabi Bagh','2005-02-14','9812345678','11A','2020-06-28','S/images/simran.png','simran07','AB12'),('108','Yash Verma','Ajay Verma','Sarita Verma','yashv@gmail.com','ajayv@gmail.com','saritav@gmail.com','Janakpuri','2005-08-05','9798989898','12A','2020-06-30','S/images/yash.png','verma88','AB12'),('109','Nikita Bansal','Manoj Bansal','Suman Bansal','nikitab@gmail.com','manoj@gmail.com','suman@gmail.com','Paschim Vihar','2005-10-22','9871122334','10A','2020-07-02','S/images/nikita.png','nikita12','AB12'),('110','Ritik Arora','Vijay Arora','Neha Arora','ritikarora@gmail.com','vijay@gmail.com','neha@gmail.com','Rohini Sector 9','2005-01-09','9988776655','12A','2020-07-05','S/images/ritik.png','arora34','AB12'),('111','Ishita Malhotra','Nitin Malhotra','Swati Malhotra','ishitam@gmail.com','nitin@gmail.com','swati@gmail.com','Kirti Nagar','2005-04-30','9765432109','10A','2020-07-07','S/images/ishita.png','ishita99','AB12'),('112','Aman Dubey','Alok Dubey','Meena Dubey','amandubey@gmail.com','alok@gmail.com','meena@gmail.com','Dwarka Sector 12','2005-11-25','9823456789','11A','2020-07-09','S/images/aman.png','dubey56','AB12'),('113','Nishtha Chhetri','Papa Chhetri','Mumma Chhetri','nishtha@gmail.com','papachhetri@gmail.com','mummychhetri@gmail.com','Dwarka','2025-06-20','8451144520','12A','2019-02-14',NULL,'nishtha','AB12'),('114','jiya','a','a','aaaaaaaaaaaaaa@gmail.com','bbb@gmail.com','cc@gmail.com','cv','2005-03-12','1236547895','12A','2014-02-12',NULL,'jiya','AB12');
/*!40000 ALTER TABLE `student` ENABLE KEYS */;
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
