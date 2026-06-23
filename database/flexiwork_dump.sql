-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: localhost    Database: flexiwork
-- ------------------------------------------------------
-- Server version	8.0.46

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
-- Table structure for table `applications`
--

DROP TABLE IF EXISTS `applications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `applications` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `applied_at` datetime(6) NOT NULL,
  `qr_code_token` varchar(255) DEFAULT NULL,
  `status` enum('ACCEPTED','CANCELLED','PENDING','REJECTED') NOT NULL,
  `job_post_id` bigint NOT NULL,
  `worker_id` bigint NOT NULL,
  `reminder_sent_at` datetime(6) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_application_job_worker` (`job_post_id`,`worker_id`),
  UNIQUE KEY `UKtfoq4ri1kgbxal2bxw611d66b` (`qr_code_token`),
  KEY `FKkjk6b4jr9doibvec3acwfjv8d` (`worker_id`),
  CONSTRAINT `FKkjk6b4jr9doibvec3acwfjv8d` FOREIGN KEY (`worker_id`) REFERENCES `worker_profiles` (`id`),
  CONSTRAINT `FKnoht11l9xbirdln8hxeivffo1` FOREIGN KEY (`job_post_id`) REFERENCES `job_posts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `applications`
--

LOCK TABLES `applications` WRITE;
/*!40000 ALTER TABLE `applications` DISABLE KEYS */;
INSERT INTO `applications` VALUES (1,'2026-06-16 07:27:49.971469','5','2026-06-16 07:27:50.169313','2','2026-06-16 07:27:49.969476','a55c068e-d410-42fb-8300-d7f20b3a805d','ACCEPTED',5,1,NULL),(2,'2026-06-16 07:29:33.344731','5','2026-06-18 22:54:31.203171','5','2026-06-16 07:29:33.475573',NULL,'CANCELLED',6,1,NULL),(3,'2026-06-18 12:28:05.297244','5','2026-06-18 12:28:05.512349','2','2026-06-18 12:28:05.295235','e2614511-6ab0-4977-b11d-ec2962b27bfe','ACCEPTED',7,1,NULL);
/*!40000 ALTER TABLE `applications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `attendances`
--

DROP TABLE IF EXISTS `attendances`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `attendances` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `check_in_time` datetime(6) NOT NULL,
  `check_out_time` datetime(6) DEFAULT NULL,
  `extra_wage` decimal(10,2) NOT NULL,
  `scanned_by_user_id` bigint DEFAULT NULL,
  `scanned_out_by_user_id` bigint DEFAULT NULL,
  `verified` bit(1) NOT NULL,
  `application_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UK1txir4rnd4tf3gkb9lpe5k9rw` (`application_id`),
  CONSTRAINT `FK9d8tyfh4o4xh5u2mf3dxkvn5d` FOREIGN KEY (`application_id`) REFERENCES `applications` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `attendances`
--

LOCK TABLES `attendances` WRITE;
/*!40000 ALTER TABLE `attendances` DISABLE KEYS */;
INSERT INTO `attendances` VALUES (1,'2026-06-16 07:27:50.265011','3','2026-06-16 07:27:50.448182','3','2026-06-16 07:27:50.261388','2026-06-16 07:27:50.445956',500.00,3,3,_binary '',1),(2,'2026-06-18 12:28:05.610698','3','2026-06-18 12:28:05.610698','3','2026-06-18 12:28:05.607701',NULL,0.00,3,NULL,_binary '',3);
/*!40000 ALTER TABLE `attendances` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `company_profiles`
--

DROP TABLE IF EXISTS `company_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `company_profiles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `address_line` varchar(255) DEFAULT NULL,
  `approved_at` datetime(6) DEFAULT NULL,
  `br_certificate_path` varchar(255) DEFAULT NULL,
  `br_number` varchar(255) NOT NULL,
  `company_name` varchar(255) NOT NULL,
  `district` enum('AMPARA','ANURADHAPURA','BADULLA','BATTICALOA','COLOMBO','GALLE','GAMPAHA','HAMBANTOTA','JAFFNA','KALUTARA','KANDY','KEGALLE','KILINOCHCHI','KURUNEGALA','MANNAR','MATALE','MATARA','MONARAGALA','MULLAITIVU','NUWARA_ELIYA','POLONNARUWA','PUTTALAM','RATNAPURA','TRINCOMALEE','VAVUNIYA') DEFAULT NULL,
  `latitude` double DEFAULT NULL,
  `logo_path` varchar(255) DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `outside_photo_path` varchar(255) DEFAULT NULL,
  `status` enum('PENDING','REJECTED','VERIFIED') NOT NULL,
  `suspended` bit(1) NOT NULL,
  `suspended_at` datetime(6) DEFAULT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKm1fe8i41r6u3a0o0bqy0sh65t` (`user_id`),
  CONSTRAINT `FKns0ywxv4sm2h5xtalgw4663j5` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `company_profiles`
--

LOCK TABLES `company_profiles` WRITE;
/*!40000 ALTER TABLE `company_profiles` DISABLE KEYS */;
INSERT INTO `company_profiles` VALUES (1,'2026-06-16 07:26:55.063203','system','2026-06-18 12:28:35.953466','system','45 Galle Road, Colombo 03',NULL,NULL,'PV-00123456','ABC Hotels','COLOMBO',6.9047,NULL,79.8528,NULL,'VERIFIED',_binary '\0',NULL,2);
/*!40000 ALTER TABLE `company_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact_messages`
--

DROP TABLE IF EXISTS `contact_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact_messages` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `first_name` varchar(100) NOT NULL,
  `last_name` varchar(100) NOT NULL,
  `message` varchar(2000) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `topic` varchar(60) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact_messages`
--

LOCK TABLES `contact_messages` WRITE;
/*!40000 ALTER TABLE `contact_messages` DISABLE KEYS */;
INSERT INTO `contact_messages` VALUES (1,'2026-06-19 19:33:11.768230','system','2026-06-19 19:33:11.768230','system','test@example.com','Test','User','Just verifying the contact endpoint works end to end.','+94771234567','Other');
/*!40000 ALTER TABLE `contact_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `job_posts`
--

DROP TABLE IF EXISTS `job_posts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `job_posts` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `address_line` varchar(255) NOT NULL,
  `category` enum('AGRICULTURE','CLEANING','CONSTRUCTION','DELIVERY','EVENT_CAMPAIGN','FACTORY','HOTEL','OTHER','RESTAURANT_KITCHEN','WAREHOUSE') NOT NULL,
  `daily_wage` decimal(10,2) NOT NULL,
  `description` varchar(2000) NOT NULL,
  `district` enum('AMPARA','ANURADHAPURA','BADULLA','BATTICALOA','COLOMBO','GALLE','GAMPAHA','HAMBANTOTA','JAFFNA','KALUTARA','KANDY','KEGALLE','KILINOCHCHI','KURUNEGALA','MANNAR','MATALE','MATARA','MONARAGALA','MULLAITIVU','NUWARA_ELIYA','POLONNARUWA','PUTTALAM','RATNAPURA','TRINCOMALEE','VAVUNIYA') NOT NULL,
  `end_time` time(6) NOT NULL,
  `job_date` date NOT NULL,
  `latitude` double NOT NULL,
  `longitude` double NOT NULL,
  `start_time` time(6) NOT NULL,
  `status` enum('CANCELLED','COMPLETED','FILLED','OPEN') NOT NULL,
  `title` varchar(255) NOT NULL,
  `workers_accepted` int NOT NULL,
  `workers_needed` int NOT NULL,
  `company_id` bigint NOT NULL,
  `version` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FKcst7q0df3vf1nr1eoh9xhxmlt` (`company_id`),
  CONSTRAINT `FKcst7q0df3vf1nr1eoh9xhxmlt` FOREIGN KEY (`company_id`) REFERENCES `company_profiles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `job_posts`
--

LOCK TABLES `job_posts` WRITE;
/*!40000 ALTER TABLE `job_posts` DISABLE KEYS */;
INSERT INTO `job_posts` VALUES (1,'2026-06-16 07:26:55.293600','system','2026-06-16 07:26:55.293600','system','Colombo City Hotel, Colombo 03','RESTAURANT_KITCHEN',3000.00,'Assist chefs in preparation and clean kitchen equipment after service.','COLOMBO','17:00:00.000000','2026-06-17',6.91,79.855,'09:00:00.000000','OPEN','Restaurant Kitchen Helper',0,5,1,NULL),(2,'2026-06-16 07:26:55.303605','system','2026-06-16 07:26:55.303605','system','Grand Ballroom, Negombo','HOTEL',3500.00,'Serve guests at an evening wedding banquet. Smart appearance required.','GAMPAHA','23:00:00.000000','2026-06-17',7.2083,79.8358,'16:00:00.000000','OPEN','Hotel Banquet Staff',0,10,1,NULL),(3,'2026-06-16 07:26:55.309603','system','2026-06-16 07:26:55.309603','system','Katunayake Industrial Zone','FACTORY',2800.00,'Inspect finished garments and pack products at the Katunayake zone.','GAMPAHA','16:00:00.000000','2026-06-17',7.1697,79.8843,'08:00:00.000000','OPEN','Garment Factory Worker',0,20,1,NULL),(4,'2026-06-16 07:26:55.315235','system','2026-06-16 07:26:55.315235','system','Kandy City Centre','EVENT_CAMPAIGN',4000.00,'Represent a beverage brand and distribute flyers in supermarkets.','KANDY','18:00:00.000000','2026-06-17',7.2906,80.6337,'10:00:00.000000','OPEN','Brand Ambassador',0,4,1,NULL),(5,'2026-06-16 07:27:49.859478','2','2026-06-16 07:27:50.399153','2','Galle Rd','HOTEL',3000.00,'in/out + extend','COLOMBO','18:00:00.000000','2026-06-16',6.91,79.86,'06:00:00.000000','FILLED','Inc2 Test Job',1,1,1,NULL),(6,'2026-06-16 07:29:33.209280','2','2026-06-16 07:29:33.209280','2','x','HOTEL',3000.00,'cancel test','COLOMBO','17:00:00.000000','2026-06-19',6.91,79.86,'09:00:00.000000','OPEN','Future Job',0,2,1,NULL),(7,'2026-06-18 12:28:05.189245','2','2026-06-18 12:28:05.689306','2','x','HOTEL',3000.00,'x','COLOMBO','14:00:00.000000','2026-06-18',6.91,79.86,'06:00:00.000000','COMPLETED','Ban Test',1,1,1,NULL);
/*!40000 ALTER TABLE `job_posts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `otp_tokens`
--

DROP TABLE IF EXISTS `otp_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `otp_tokens` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `attempts` int NOT NULL,
  `expires_at` datetime(6) NOT NULL,
  `otp_hash` varchar(255) NOT NULL,
  `purpose` enum('EMAIL_CHANGE','PASSWORD_RESET','WHATSAPP_VERIFY') NOT NULL,
  `used` bit(1) NOT NULL,
  `user_id` bigint NOT NULL,
  `payload` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `otp_tokens`
--

LOCK TABLES `otp_tokens` WRITE;
/*!40000 ALTER TABLE `otp_tokens` DISABLE KEYS */;
INSERT INTO `otp_tokens` VALUES (1,'2026-06-18 22:54:46.384771','5','2026-06-18 22:54:46.384771','5',0,'2026-06-18 22:59:46.380220','$2a$10$MNe5r2fv5pJeImbXayFlQuCrAN7E6SEdyP7deDlZHGxN7x2C9Hx0i','PASSWORD_RESET',_binary '\0',5,NULL),(2,'2026-06-19 10:03:53.777731','7','2026-06-19 10:03:53.777731','7',0,'2026-06-19 10:08:53.771713','$2a$10$PYyUc2ggCBdpDNqy75F94uauJbUsP6GKD/5hA85GtWd5qjo4IaFCi','WHATSAPP_VERIFY',_binary '\0',7,NULL);
/*!40000 ALTER TABLE `otp_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `commission_amount` decimal(12,2) NOT NULL,
  `commission_rate` decimal(5,4) NOT NULL,
  `due_date` date DEFAULT NULL,
  `job_date` date NOT NULL,
  `paid_at` datetime(6) DEFAULT NULL,
  `receipt_number` varchar(255) DEFAULT NULL,
  `status` enum('OVERDUE','PAID','PENDING') NOT NULL,
  `total_wages` decimal(12,2) NOT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `workers_attended` int NOT NULL,
  `company_id` bigint NOT NULL,
  `job_post_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKu6rnuxne864s4rh7qgeql1vx` (`receipt_number`),
  KEY `FKkhntjjsepg7ytglxrc9mh0e7o` (`company_id`),
  KEY `FKctrc2og24cfda07r8j21p2agt` (`job_post_id`),
  CONSTRAINT `FKctrc2og24cfda07r8j21p2agt` FOREIGN KEY (`job_post_id`) REFERENCES `job_posts` (`id`),
  CONSTRAINT `FKkhntjjsepg7ytglxrc9mh0e7o` FOREIGN KEY (`company_id`) REFERENCES `company_profiles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (1,'2026-06-18 12:28:05.686308','2','2026-06-18 12:28:35.951466','system',300.00,0.1000,'2026-06-17','2026-06-18','2026-06-18 17:59:58.000000','FLX-2026-00001','PAID',3000.00,NULL,1,1,7);
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `shift_extensions`
--

DROP TABLE IF EXISTS `shift_extensions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `shift_extensions` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `applied_to_count` int NOT NULL,
  `extra_wage` decimal(10,2) NOT NULL,
  `new_end_time` time(6) NOT NULL,
  `job_post_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  KEY `FKmb74ykb4dfaefpo1pdydfhfj5` (`job_post_id`),
  CONSTRAINT `FKmb74ykb4dfaefpo1pdydfhfj5` FOREIGN KEY (`job_post_id`) REFERENCES `job_posts` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shift_extensions`
--

LOCK TABLES `shift_extensions` WRITE;
/*!40000 ALTER TABLE `shift_extensions` DISABLE KEYS */;
INSERT INTO `shift_extensions` VALUES (1,'2026-06-16 07:27:50.396176','2','2026-06-16 07:27:50.396176','2',1,500.00,'18:00:00.000000',5);
/*!40000 ALTER TABLE `shift_extensions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `active` bit(1) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('ADMIN','COMPANY','COMPANY_GUARD','COMPANY_POSTER','WORKER') NOT NULL,
  `parent_company_id` bigint DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_users_email` (`email`),
  UNIQUE KEY `uk_users_parent_company_role` (`parent_company_id`,`role`),
  CONSTRAINT `FKi0nid4np5aq43ewek0c167bfq` FOREIGN KEY (`parent_company_id`) REFERENCES `company_profiles` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'2026-06-16 07:26:54.937902','system','2026-06-16 07:26:54.937902','system',_binary '','admin@flexiwork.lk','$2a$10$eDwTW4sXHIrMHosH1LQQg.NNWCBoVXRvYZbpDFxZpdd6D3m2BOTjW','ADMIN',NULL),(2,'2026-06-16 07:26:55.054751','system','2026-06-16 07:26:55.054751','system',_binary '','hotel@abc.lk','$2a$10$sG/2A7WInRO6eGtqbU/9zuuM0yWc68AEFyKGput/j9CRBBY0dHRQO','COMPANY',NULL),(3,'2026-06-16 07:26:55.137091','system','2026-06-16 07:26:55.137091','system',_binary '','guard@abc.lk','$2a$10$cgmg0.Cmdk0soqNDZ45/8.uq.zPrrVDHtNKDQWG9KhKcpV9jPx5Ba','COMPANY_GUARD',1),(4,'2026-06-16 07:26:55.203176','system','2026-06-16 07:26:55.203176','system',_binary '','itadmin@abc.lk','$2a$10$81shUTq/RoexmhVdm2zec.BRfe3Cpv71EZuDOv2u2AonmPScx7h4m','COMPANY_POSTER',1),(5,'2026-06-16 07:26:55.273598','system','2026-06-16 07:26:55.273598','system',_binary '','kamal@gmail.com','$2a$10$5xRBBo07nVwjGDkZQ2vB9emCylZJxWrm9YClMQm2aUXbYaKRjOg2e','WORKER',NULL),(6,'2026-06-18 12:27:26.343445','system','2026-06-18 12:27:26.343445','system',_binary '','sched1781785645@test.lk','$2a$10$GTblIsHyJsFv4Euu9KOBK.XCWVosBH1I/095zlBFtawsEYtsKRssW','WORKER',NULL),(7,'2026-06-19 10:03:52.918660','system','2026-06-19 10:03:52.918660','system',_binary '','sedanlamba@gmail.com','$2a$10$t12Ow14su3ofRwGj/l2lKO/iYMay7vVDWtZz1dfFjoh5ylHWXiCZ6','WORKER',NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `worker_profiles`
--

DROP TABLE IF EXISTS `worker_profiles`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `worker_profiles` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `created_at` datetime(6) DEFAULT NULL,
  `created_by` varchar(255) DEFAULT NULL,
  `updated_at` datetime(6) DEFAULT NULL,
  `updated_by` varchar(255) DEFAULT NULL,
  `approved_at` datetime(6) DEFAULT NULL,
  `district` enum('AMPARA','ANURADHAPURA','BADULLA','BATTICALOA','COLOMBO','GALLE','GAMPAHA','HAMBANTOTA','JAFFNA','KALUTARA','KANDY','KEGALLE','KILINOCHCHI','KURUNEGALA','MANNAR','MATALE','MATARA','MONARAGALA','MULLAITIVU','NUWARA_ELIYA','POLONNARUWA','PUTTALAM','RATNAPURA','TRINCOMALEE','VAVUNIYA') DEFAULT NULL,
  `full_name` varchar(255) NOT NULL,
  `latitude` double DEFAULT NULL,
  `longitude` double DEFAULT NULL,
  `nic_back_path` varchar(255) DEFAULT NULL,
  `nic_front_path` varchar(255) DEFAULT NULL,
  `nic_number` varchar(255) NOT NULL,
  `profile_photo_path` varchar(255) DEFAULT NULL,
  `rating_average` double NOT NULL,
  `skills` varchar(500) DEFAULT NULL,
  `status` enum('PENDING','REJECTED','VERIFIED') NOT NULL,
  `whatsapp_number` varchar(255) DEFAULT NULL,
  `whatsapp_verified` bit(1) NOT NULL,
  `user_id` bigint NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UKljmkjf5tk6w2jt5w4q7rnv3er` (`user_id`),
  CONSTRAINT `FKcnisf432fdaiietnktm4a06nt` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `worker_profiles`
--

LOCK TABLES `worker_profiles` WRITE;
/*!40000 ALTER TABLE `worker_profiles` DISABLE KEYS */;
INSERT INTO `worker_profiles` VALUES (1,'2026-06-16 07:26:55.281597','system','2026-06-18 13:19:55.574331','5',NULL,'COLOMBO','Kamal Perera ',6.9271,79.8612,NULL,NULL,'199012345678','workers/5/1781788760737_72a6e405.jpg',4.5,'Kitchen helper, Cleaning, Waiter','VERIFIED','+94771234567',_binary '',5),(2,'2026-06-18 12:27:26.388360','system','2026-06-18 12:27:30.961426','system','2026-06-18 12:27:30.953801','KANDY','Sched Test',NULL,NULL,'workers/6/1781785646383_24fae29a.png','workers/6/1781785646382_27b31fb5.png','200099','workers/6/1781785646379_44d30aca.png',0,NULL,'VERIFIED','+94771119999',_binary '\0',6),(3,'2026-06-19 10:03:53.058862','system','2026-06-19 15:30:34.696774','admin@flexiwork.lk','2026-06-19 15:30:34.609447','MATARA','Lamba',5.9549,80.555,'workers/7/1781863433048_3654675e.jpg','workers/7/1781863433043_06ce2b50.jpg','200415903283','workers/7/1781863433023_a27f6301.jpg',0,'','VERIFIED','+94781181982',_binary '\0',7);
/*!40000 ALTER TABLE `worker_profiles` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'flexiwork'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-20  1:49:04
