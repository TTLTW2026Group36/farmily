-- MySQL dump 10.13  Distrib 9.7.0, for Linux (x86_64)
--
-- Host: localhost    Database: farmily
-- ------------------------------------------------------
-- Server version	9.7.0

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
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '2d0b68f7-5e4f-11f1-85ad-029386080897:1-1555';

--
-- Table structure for table `address`
--

DROP TABLE IF EXISTS `address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `address` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `receiver` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address_detail` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `district` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `city` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_default` tinyint(1) DEFAULT '0',
  `is_deleted` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ghn_district_id` int DEFAULT NULL,
  `ghn_ward_code` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_address_user_deleted` (`user_id`,`is_deleted`),
  CONSTRAINT `address_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `address`
--

LOCK TABLES `address` WRITE;
/*!40000 ALTER TABLE `address` DISABLE KEYS */;
INSERT INTO `address` VALUES (15,1,'chutantai','0332991664','123','Huyện U Minh','Cà Mau',1,0,'2026-05-28 18:27:02','2026-05-30 18:45:11',2042,'610302'),(17,26,'Thúy Quỳnh','0378827924','108/4, Phường Linh Xuân','Thành Phố Thủ Đức','Hồ Chí Minh',1,0,'2026-06-02 14:14:23','2026-06-02 14:14:23',3695,'90735'),(18,27,'duc','0332991664','123, Phường VII','Thành phố Vị Thanh','Hậu Giang',0,1,'2026-06-02 16:16:58','2026-06-02 16:37:46',1653,'640105'),(19,25,'Chu Tấn Tài','0332991664','123','Huyện U Minh','Cà Mau',1,0,'2026-06-02 17:42:08','2026-06-02 17:42:08',2042,'610302'),(20,27,'TaiPlatForm','0332991664','144 nguyen ai quoc, Xã Thừa Đức','Huyện Cẩm Mỹ','Đồng Nai',1,0,'2026-06-02 17:45:36','2026-06-02 17:45:36',1702,'481107'),(21,26,'Thy Lieu','0378827924','50/47 Nhất Chi Mai','Quận Tân Bình','Hồ Chí Minh',0,0,'2026-06-04 08:41:25','2026-06-04 08:41:25',1455,'21413'),(22,1,'Phat','0911112222','Điện Biên Phủ','Thành phố Bạc Liêu','Bạc Liêu',0,0,'2026-06-04 15:36:58','2026-06-04 15:36:58',1655,'600103'),(23,1,'Chu Tấn Tài','0332991664','123','Huyện Định Quán','Đồng Nai',0,0,'2026-06-11 08:10:25','2026-06-11 08:10:25',1700,'480408'),(24,34,'Tài','0332991664','123, Phường 2','Thành phố Tuy Hòa','Phú Yên',1,0,'2026-06-11 08:42:57','2026-06-11 08:42:57',1663,'390102'),(25,30,'Ly Phat','0912345678','08 Lê Duẩn','Huyện Ia H Drai','Kon Tum',1,0,'2026-06-16 05:18:49','2026-06-16 05:18:49',3446,'361003'),(26,1,'Chu Tấn Tài','0332991664','144C Linh Trung, PhÆ°á»ng Linh Trung, Thá»§ Äá»©c, Há»“ ChÃ­ Minh','Huyện Định Quán','Đồng Nai',0,0,'2026-06-16 06:25:26','2026-06-16 07:17:50',3695,'90737'),(27,26,'Nguyen Hong','0378827924','235/7','Huyện Tu Mơ Rông','Kon Tum',0,0,'2026-06-16 07:52:29','2026-06-16 07:52:29',2225,'360903');
/*!40000 ALTER TABLE `address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `admin_notifications`
--

DROP TABLE IF EXISTS `admin_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `admin_notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'new_order, low_stock, new_user, order_cancelled',
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `reference_id` int DEFAULT NULL COMMENT 'ID tham chiếu (order_id, product_id, user_id)',
  `reference_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'order, product, user',
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_is_read` (`is_read`) USING BTREE,
  KEY `idx_created_at` (`created_at`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `admin_notifications`
--

LOCK TABLES `admin_notifications` WRITE;
/*!40000 ALTER TABLE `admin_notifications` DISABLE KEYS */;
INSERT INTO `admin_notifications` VALUES (118,'new_order','Đơn hàng mới #122','Khách hàng  đã đặt hàng 45.900đ',122,'order',1,'2026-06-02 14:14:23'),(119,'new_order','Đơn hàng mới #123','Khách hàng  đã đặt hàng 66.500đ',123,'order',1,'2026-06-02 16:17:11'),(120,'new_order','Đơn hàng mới #124','Khách hàng  đã đặt hàng 85.500đ',124,'order',1,'2026-06-02 17:42:20'),(121,'new_order','Đơn hàng mới #125','Khách hàng  đã đặt hàng 85.500đ',125,'order',1,'2026-06-02 17:45:36'),(122,'new_order','Đơn hàng mới #126','Khách hàng  đã đặt hàng 85.500đ',126,'order',1,'2026-06-02 17:54:33'),(123,'expiring_product','Biến thể sắp hết hạn: Rau diếp cá (500g)','Biến thể \"500g\" của sản phẩm \"Rau diếp cá\" (Tồn kho: 247) sẽ hết hạn vào ngày 06/06/2026.',189,'product',1,'2026-06-04 05:59:46'),(124,'expiring_product','Biến thể sắp hết hạn: Rau diếp cá (1kg)','Biến thể \"1kg\" của sản phẩm \"Rau diếp cá\" (Tồn kho: 30) sẽ hết hạn vào ngày 06/06/2026.',189,'product',1,'2026-06-04 06:38:18'),(125,'new_order','Đơn hàng mới #127','Khách hàng  đã đặt hàng 120.900đ',127,'order',1,'2026-06-04 08:41:35'),(126,'new_order','Đơn hàng mới #128','Khách hàng  đã đặt hàng 75.500đ',128,'order',1,'2026-06-04 13:33:48'),(127,'new_order','Đơn hàng mới #129','Khách hàng  đã đặt hàng 73.900đ',129,'order',1,'2026-06-04 15:29:00'),(128,'new_order','Đơn hàng mới #130','Khách hàng  đã đặt hàng 162.500đ',130,'order',1,'2026-06-04 15:32:32'),(129,'new_order','Đơn hàng mới #132','Khách hàng  đã đặt hàng 117.900đ',132,'order',1,'2026-06-04 15:33:50'),(130,'new_contact','Liên hệ mới từ thy quynh','Tiêu đề: giao thiếu hàng',5,'contact',1,'2026-06-04 15:38:48'),(131,'expiring_product','Biến thể sắp hết hạn: Cà chua thân gỗ hộp (500g)','Biến thể \"500g\" của sản phẩm \"Cà chua thân gỗ hộp\" (Tồn kho: 5) sẽ hết hạn vào ngày 06/06/2026.',96,'product',1,'2026-06-04 15:50:47'),(132,'expiring_product','Biến thể sắp hết hạn: Cà chua thân gỗ hộp (1kg)','Biến thể \"1kg\" của sản phẩm \"Cà chua thân gỗ hộp\" (Tồn kho: 2) sẽ hết hạn vào ngày 06/06/2026.',96,'product',1,'2026-06-04 15:50:47'),(133,'new_order','Đơn hàng mới #133','Khách hàng  đã đặt hàng 160.900đ',133,'order',1,'2026-06-04 15:51:38'),(134,'flash_sale_low_stock','Flash Sale sắp hết hàng','Sản phẩm Flash Sale \"Cà chua thân gỗ hộp\" chỉ còn lại 2 sản phẩm.',27,'flash_sale',1,'2026-06-04 15:51:38'),(135,'new_order','Đơn hàng mới #134','Khách hàng  đã đặt hàng 84.900đ',134,'order',1,'2026-06-04 15:52:39'),(136,'new_order','Đơn hàng mới #135','Khách hàng  đã đặt hàng 147.200đ',135,'order',1,'2026-06-04 18:11:23'),(137,'new_order','Đơn hàng mới #136','Khách hàng  đã đặt hàng 68.500đ',136,'order',1,'2026-06-04 18:47:49'),(138,'new_order','Đơn hàng mới #137','Khách hàng  đã đặt hàng 82.900đ',137,'order',1,'2026-06-09 18:57:37'),(139,'new_order','Đơn hàng mới #138','Khách hàng  đã đặt hàng 85.500đ',138,'order',1,'2026-06-10 03:23:49'),(140,'order_cancelled','Đơn hàng #138 đã bị hủy','Khách hàng ADMIN đã hủy đơn hàng',138,'order',1,'2026-06-10 03:25:04'),(141,'new_order','Đơn hàng mới #139','Khách hàng  đã đặt hàng 145.500đ',139,'order',1,'2026-06-10 18:23:15'),(142,'new_review','Đánh giá mới cho sản phẩm','Khách hàng TaiPlatForm đánh giá 1 sao: Tài đẹp trai',8,'review',1,'2026-06-10 18:25:07'),(143,'expired_product','Biến thể đã hết hạn: Cà chua thân gỗ hộp (500g)','Biến thể \"500g\" của sản phẩm \"Cà chua thân gỗ hộp\" (Tồn kho: 10) đã hết hạn sử dụng vào ngày 08/06/2026.',96,'product',1,'2026-06-10 18:25:27'),(144,'expired_product','Biến thể đã hết hạn: Cà chua thân gỗ hộp (1kg)','Biến thể \"1kg\" của sản phẩm \"Cà chua thân gỗ hộp\" (Tồn kho: 10) đã hết hạn sử dụng vào ngày 08/06/2026.',96,'product',1,'2026-06-10 18:25:27'),(145,'expired_product','Biến thể đã hết hạn: Rau diếp cá (500g)','Biến thể \"500g\" của sản phẩm \"Rau diếp cá\" (Tồn kho: 245) đã hết hạn sử dụng vào ngày 06/06/2026.',189,'product',1,'2026-06-10 18:25:27'),(146,'expired_product','Biến thể đã hết hạn: Rau diếp cá (1kg)','Biến thể \"1kg\" của sản phẩm \"Rau diếp cá\" (Tồn kho: 30) đã hết hạn sử dụng vào ngày 06/06/2026.',189,'product',1,'2026-06-10 18:25:27'),(147,'new_review','Đánh giá mới cho sản phẩm','Khách hàng TaiPlatForm đánh giá 1 sao: Haha',9,'review',1,'2026-06-10 18:27:45'),(148,'new_order','Đơn hàng mới #140','Khách hàng  đã đặt hàng 173.500đ',140,'order',1,'2026-06-11 08:11:00'),(149,'new_order','Đơn hàng mới #141','Khách hàng  đã đặt hàng 63.500đ',141,'order',1,'2026-06-11 08:42:57'),(150,'new_order','Đơn hàng mới #142','Khách hàng  đã đặt hàng 90.500đ',142,'order',1,'2026-06-11 13:20:35'),(151,'refund_request','Yêu cầu hoàn tiền mới #1','TaiPlatForm gửi yêu cầu hoàn tiền cho đơn hàng #142 (90.500đ) — Lý do: Rau củ bị dập nát',1,'refund',1,'2026-06-12 07:59:50'),(152,'new_order','Đơn hàng mới #143','Khách hàng  đã đặt hàng 715.000đ',143,'order',1,'2026-06-12 15:19:19'),(153,'new_chat_message','Tin nhắn mới từ TaiPlatForm','Khách hàng TaiPlatForm đã gửi tin nhắn mới',2,'chat',1,'2026-06-14 08:58:29'),(154,'new_chat_message','Tin nhắn mới từ TaiPlatForm','Khách hàng TaiPlatForm đã gửi tin nhắn mới',2,'chat',1,'2026-06-14 08:58:54'),(155,'new_chat_message','Tin nhắn mới từ ADMIN','Khách hàng ADMIN đã gửi tin nhắn mới',3,'chat',1,'2026-06-14 09:13:02'),(156,'new_chat_message','Tin nhắn mới từ ADMIN','Khách hàng ADMIN đã gửi tin nhắn mới',3,'chat',1,'2026-06-14 09:14:14'),(157,'new_chat_message','Tin nhắn mới từ ADMIN','Khách hàng ADMIN đã gửi tin nhắn mới',3,'chat',1,'2026-06-14 09:14:29'),(158,'new_chat_message','Tin nhắn mới từ admin','Khách hàng admin đã gửi tin nhắn mới',4,'chat',1,'2026-06-14 09:16:03'),(159,'new_chat_message','Tin nhắn mới từ TaiPlatForm','Khách hàng TaiPlatForm đã gửi tin nhắn mới',5,'chat',1,'2026-06-14 10:22:44'),(160,'refund_request','Yêu cầu hoàn tiền mới #2','TaiPlatForm gửi yêu cầu hoàn tiền cho đơn hàng #143 (715.000đ) — Lý do: Lý do khác',2,'refund',1,'2026-06-14 12:11:40'),(161,'refund_request','Yêu cầu hoàn tiền mới #3','TaiPlatForm gửi yêu cầu hoàn tiền cho đơn hàng #140 (173.500đ) — Lý do: Hàng bị mốc mọt',3,'refund',1,'2026-06-14 13:18:02'),(162,'new_chat_message','Tin nhắn mới từ TaiPlatForm','Khách hàng TaiPlatForm đã gửi tin nhắn mới',14,'chat',1,'2026-06-14 13:18:37'),(163,'new_order','Đơn hàng mới #144','Khách hàng  đã đặt hàng 68.300đ',144,'order',1,'2026-06-14 14:47:04'),(164,'refund_request','Yêu cầu hoàn tiền mới #4','Thúy Quỳnh gửi yêu cầu hoàn tiền cho đơn hàng #144 (68.300đ) — Lý do: Rau củ bị dập nát',4,'refund',1,'2026-06-14 14:49:56'),(165,'new_chat_message','Tin nhắn mới từ Thúy Quỳnh','Khách hàng Thúy Quỳnh đã gửi tin nhắn mới',15,'chat',1,'2026-06-14 14:55:41'),(166,'new_order','Đơn hàng mới #145','Khách hàng  đã đặt hàng 53.300đ',145,'order',1,'2026-06-14 14:55:59'),(167,'refund_request','Yêu cầu hoàn tiền mới #5','Thúy Quỳnh gửi yêu cầu hoàn tiền cho đơn hàng #145 (53.300đ) — Lý do: Hàng bị mốc mọt',5,'refund',1,'2026-06-14 14:57:12'),(168,'new_chat_message','Tin nhắn mới từ Thúy Quỳnh','Khách hàng Thúy Quỳnh đã gửi tin nhắn mới',16,'chat',1,'2026-06-14 14:58:59'),(169,'new_chat_message','Tin nhắn mới từ Thúy Quỳnh','Khách hàng Thúy Quỳnh đã gửi tin nhắn mới',16,'chat',1,'2026-06-14 14:59:41'),(170,'new_chat_message','Tin nhắn mới từ Thúy Quỳnh','Khách hàng Thúy Quỳnh đã gửi tin nhắn mới',16,'chat',1,'2026-06-14 15:01:38'),(171,'new_chat_message','Tin nhắn mới từ Thúy Quỳnh','Khách hàng Thúy Quỳnh đã gửi tin nhắn mới',16,'chat',1,'2026-06-14 15:01:41'),(172,'new_chat_message','Tin nhắn mới từ Thúy Quỳnh','Khách hàng Thúy Quỳnh đã gửi tin nhắn mới',16,'chat',1,'2026-06-14 15:01:47'),(173,'new_order','Đơn hàng mới #146','Khách hàng  đã đặt hàng 121.900đ',146,'order',1,'2026-06-14 18:55:11'),(174,'new_order','Đơn hàng mới #147','Khách hàng  đã đặt hàng 172.900đ',147,'order',1,'2026-06-14 19:13:06'),(175,'new_order','Đơn hàng mới #148','Khách hàng  đã đặt hàng 43.300đ',148,'order',1,'2026-06-14 20:03:12'),(176,'new_review','Đánh giá mới cho sản phẩm','Khách hàng Thúy Quỳnh đánh giá 5 sao: rau tươi ạ',10,'review',1,'2026-06-14 20:04:16'),(177,'new_review','Đánh giá mới cho sản phẩm','Khách hàng Thúy Quỳnh đánh giá 5 sao: rau ngon',11,'review',1,'2026-06-14 20:08:51'),(178,'review_reported','Đánh giá bị báo cáo vi phạm','Khách hàng \"Thúy Quỳnh\" đã báo cáo vi phạm đánh giá #11.',11,'review',1,'2026-06-14 20:17:35'),(179,'new_contact','Liên hệ mới từ Châu Thị Thuý Quỳnh','Tiêu đề: mua sỉ rau',6,'contact',1,'2026-06-14 20:39:52'),(180,'new_order','Đơn hàng mới #149','Khách hàng  đã đặt hàng 95.500đ',149,'order',1,'2026-06-15 17:03:34'),(181,'new_order','Đơn hàng mới #150','Khách hàng  đã đặt hàng 55.900đ',150,'order',1,'2026-06-16 02:26:41'),(182,'new_order','Đơn hàng mới #151','Khách hàng  đã đặt hàng 480.850đ',151,'order',0,'2026-06-16 05:18:51'),(183,'new_order','Đơn hàng mới #152','Khách hàng  đã đặt hàng 391.500đ',152,'order',0,'2026-06-16 06:07:22'),(184,'new_order','Đơn hàng mới #153','Khách hàng  đã đặt hàng 145.820đ',153,'order',0,'2026-06-16 06:08:16'),(185,'new_order','Đơn hàng mới #154','Khách hàng  đã đặt hàng 552.500đ',154,'order',0,'2026-06-16 06:16:31'),(186,'new_order','Đơn hàng mới #155','Khách hàng  đã đặt hàng 220.500đ',155,'order',0,'2026-06-16 06:21:25'),(187,'new_order','Đơn hàng mới #156','Khách hàng  đã đặt hàng 100.500đ',156,'order',0,'2026-06-16 06:27:15'),(188,'new_order','Đơn hàng mới #157','Khách hàng  đã đặt hàng 48.900đ',157,'order',0,'2026-06-16 06:51:19'),(189,'new_order','Đơn hàng mới #158','Khách hàng  đã đặt hàng 100.500đ',158,'order',0,'2026-06-16 07:08:45'),(190,'new_order','Đơn hàng mới #159','Khách hàng  đã đặt hàng 100.500đ',159,'order',1,'2026-06-16 07:21:15'),(191,'new_order','Đơn hàng mới #160','Khách hàng  đã đặt hàng 90.470đ',160,'order',1,'2026-06-16 07:29:50'),(192,'new_order','Đơn hàng mới #161','Khách hàng  đã đặt hàng 170.500đ',161,'order',0,'2026-06-16 07:52:48'),(193,'new_order','Đơn hàng mới #162','Khách hàng  đã đặt hàng 78.300đ',162,'order',0,'2026-06-16 07:53:09'),(194,'new_order','Đơn hàng mới #163','Khách hàng  đã đặt hàng 75.500đ',163,'order',0,'2026-06-16 08:56:09'),(195,'new_order','Đơn hàng mới #164','Khách hàng  đã đặt hàng 163.500đ',164,'order',1,'2026-06-16 09:02:53'),(196,'new_order','Đơn hàng mới #165','Khách hàng  đã đặt hàng 150.500đ',165,'order',0,'2026-06-17 11:05:31'),(197,'new_order','Đơn hàng mới #166','Khách hàng  đã đặt hàng 96.500đ',166,'order',0,'2026-06-17 11:05:46'),(198,'new_order','Đơn hàng mới #167','Khách hàng  đã đặt hàng 103.500đ',167,'order',0,'2026-06-18 16:48:49');
/*!40000 ALTER TABLE `admin_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart`
--

DROP TABLE IF EXISTS `cart`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  CONSTRAINT `cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart`
--

LOCK TABLES `cart` WRITE;
/*!40000 ALTER TABLE `cart` DISABLE KEYS */;
INSERT INTO `cart` VALUES (10,26,'2026-06-02 14:13:17'),(11,27,'2026-06-02 16:17:02'),(12,25,'2026-06-02 17:41:58'),(13,1,'2026-06-04 13:33:32'),(14,34,'2026-06-11 08:42:16'),(16,30,'2026-06-16 04:41:47');
/*!40000 ALTER TABLE `cart` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `cart_items`
--

DROP TABLE IF EXISTS `cart_items`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `cart_items` (
  `id` int NOT NULL AUTO_INCREMENT,
  `cart_id` int NOT NULL,
  `product_id` int NOT NULL,
  `variant_id` int DEFAULT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `variant_id` (`variant_id`) USING BTREE,
  KEY `idx_cart_id` (`cart_id`) USING BTREE,
  CONSTRAINT `cart_items_ibfk_1` FOREIGN KEY (`cart_id`) REFERENCES `cart` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cart_items_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `cart_items_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=99 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=COMPRESSED;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cart_items`
--

LOCK TABLES `cart_items` WRITE;
/*!40000 ALTER TABLE `cart_items` DISABLE KEYS */;
INSERT INTO `cart_items` VALUES (50,12,189,310,14),(64,12,107,178,1),(79,10,158,257,4),(81,10,114,187,1),(82,10,96,156,1),(83,13,158,257,2),(84,13,107,178,2),(85,13,48,67,1),(86,13,96,156,1),(97,16,186,300,1),(98,16,185,298,1);
/*!40000 ALTER TABLE `cart_items` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'active',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_name` (`name`) USING BTREE,
  KEY `idx_category_status` (`status`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'Rau ăn lá',NULL,'2025-12-31 22:21:47','active'),(2,'Rau ăn củ',NULL,'2025-12-31 22:21:51','active'),(3,'Rau ăn thân',NULL,'2025-12-31 22:21:52','active'),(4,'Rau ăn hoa/bông',NULL,'2025-12-31 22:21:53','active'),(5,'Rau ăn quả',NULL,'2025-12-31 22:21:54','active'),(6,'Rau ăn hạt',NULL,'2025-12-31 22:21:56','active'),(7,'Trái cây',NULL,'2025-12-31 22:22:09','active');
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_conversations`
--

DROP TABLE IF EXISTS `chat_conversations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_conversations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `refund_request_id` int DEFAULT NULL,
  `subject` varchar(255) DEFAULT NULL,
  `status` enum('open','closed') DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_conv_user` (`user_id`),
  KEY `idx_conv_refund` (`refund_request_id`),
  KEY `idx_conv_status` (`status`),
  CONSTRAINT `chat_conversations_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  CONSTRAINT `chat_conversations_ibfk_2` FOREIGN KEY (`refund_request_id`) REFERENCES `refund_requests` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_conversations`
--

LOCK TABLES `chat_conversations` WRITE;
/*!40000 ALTER TABLE `chat_conversations` DISABLE KEYS */;
INSERT INTO `chat_conversations` VALUES (1,1,NULL,NULL,'closed','2026-06-14 08:52:32','2026-06-14 09:13:47'),(2,1,NULL,'Hoi ve san pham','closed','2026-06-14 08:58:29','2026-06-14 09:13:53'),(3,25,NULL,'tư vấn món ăn','closed','2026-06-14 09:13:02','2026-06-14 09:15:17'),(4,25,NULL,'hạn sử dụng','open','2026-06-14 09:16:03','2026-06-14 09:17:05'),(5,1,1,'Hỗ trợ hoàn tiền #1','closed','2026-06-14 09:46:15','2026-06-14 11:23:45'),(6,25,1,'Hỗ trợ hoàn tiền #1','closed','2026-06-14 11:14:09','2026-06-14 11:23:43'),(7,25,1,'Hỗ trợ hoàn tiền #1','open','2026-06-14 11:38:06','2026-06-14 11:38:06'),(8,25,1,'Hỗ trợ hoàn tiền #1','open','2026-06-14 11:41:27','2026-06-14 11:41:27'),(9,25,1,'Hỗ trợ hoàn tiền #1','open','2026-06-14 11:42:49','2026-06-14 11:42:49'),(10,25,1,'Hỗ trợ hoàn tiền #1','open','2026-06-14 11:47:32','2026-06-14 11:47:32'),(11,25,1,'Hỗ trợ hoàn tiền #1','open','2026-06-14 11:48:08','2026-06-14 11:48:08'),(12,25,1,'Hỗ trợ hoàn tiền #1','open','2026-06-14 11:48:35','2026-06-14 11:48:35'),(13,1,2,'Hỗ trợ hoàn tiền đơn hàng #143','open','2026-06-14 12:20:29','2026-06-14 12:20:53'),(14,1,3,'Hỗ trợ hoàn tiền đơn hàng #140','open','2026-06-14 13:18:18','2026-06-14 13:18:37'),(15,26,4,'Hỗ trợ hoàn tiền đơn hàng #144','closed','2026-06-14 14:51:14','2026-06-14 15:03:29'),(16,26,NULL,'đơn #145 bị mốc','open','2026-06-14 14:58:59','2026-06-14 15:01:47'),(17,26,5,'Hỗ trợ hoàn tiền đơn hàng #145','open','2026-06-16 03:39:41','2026-06-16 03:39:41');
/*!40000 ALTER TABLE `chat_conversations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_messages`
--

DROP TABLE IF EXISTS `chat_messages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_messages` (
  `id` int NOT NULL AUTO_INCREMENT,
  `conversation_id` int NOT NULL,
  `sender_id` int NOT NULL,
  `sender_type` enum('customer','admin') NOT NULL,
  `content` text NOT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_msg_conv` (`conversation_id`),
  KEY `idx_msg_read` (`conversation_id`,`is_read`,`sender_type`),
  CONSTRAINT `chat_messages_ibfk_1` FOREIGN KEY (`conversation_id`) REFERENCES `chat_conversations` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_messages`
--

LOCK TABLES `chat_messages` WRITE;
/*!40000 ALTER TABLE `chat_messages` DISABLE KEYS */;
INSERT INTO `chat_messages` VALUES (1,2,1,'customer','Chao admin, minh muon hoi ve chat luong rau.',1,'2026-06-14 08:58:29'),(2,2,1,'customer','Gui them tin nhan nua nhe admin.',1,'2026-06-14 08:58:54'),(3,2,25,'admin','ok nhé',1,'2026-06-14 08:59:14'),(4,2,25,'admin','ban muon hoi ve san pham nao vay ?',1,'2026-06-14 09:00:52'),(5,3,25,'customer','tôi có rau dền thì nấu món gì',1,'2026-06-14 09:13:02'),(6,3,25,'admin','nấu canh bạn nhé!',1,'2026-06-14 09:14:07'),(7,3,25,'customer','ok bạn nhé',1,'2026-06-14 09:14:14'),(8,3,25,'admin','ko có gì nhé',1,'2026-06-14 09:14:23'),(9,3,25,'customer','ok bạn',1,'2026-06-14 09:14:29'),(10,4,25,'customer','bao lâu thfi hết hạn rau má',1,'2026-06-14 09:16:03'),(11,4,25,'admin','Rau má tươi có thể bảo quản trong tủ lạnh từ 3 - 5 ngày. Nếu đã xay hoặc ép thành nước, thời gian sử dụng tối đa là 24 giờ và phải luôn để trong tủ lạnh. Sau khoảng thời gian này, rau má sẽ mất chất dinh dưỡng, biến chất, dễ sinh vi khuẩn và không nên sử dụng.',1,'2026-06-14 09:17:05'),(12,5,25,'admin','hi',1,'2026-06-14 09:46:22'),(13,5,25,'admin','bên shop vừa nhận được yêu cầu hoàn tiền của đơn hàng \r\n#142',1,'2026-06-14 09:51:45'),(14,5,25,'admin','test',1,'2026-06-14 09:52:34'),(15,5,25,'admin','testtesttesttesttesttesttesttest',1,'2026-06-14 09:52:40'),(16,5,25,'admin','test',1,'2026-06-14 09:52:43'),(17,5,25,'admin','test',1,'2026-06-14 09:52:44'),(18,5,25,'admin','test',1,'2026-06-14 09:52:45'),(19,5,1,'customer','dạ ok shop',1,'2026-06-14 10:22:44'),(20,13,25,'admin','Chào bạn, Admin đang xử lý yêu cầu hoàn tiền của bạn.',1,'2026-06-14 12:20:53'),(21,14,25,'admin','chào bạn, bạn chưa gửi minh chứng',1,'2026-06-14 13:18:30'),(22,14,1,'customer','ok bạn ơi',1,'2026-06-14 13:18:37'),(23,15,25,'admin','chào chị ạ',1,'2026-06-14 14:52:13'),(24,15,26,'customer','chào shop',1,'2026-06-14 14:55:41'),(25,16,26,'customer','đơn #145 bị mốc',1,'2026-06-14 14:58:59'),(26,16,25,'admin','e xin lỗi',1,'2026-06-14 14:59:39'),(27,16,26,'customer','s',1,'2026-06-14 14:59:41'),(28,16,25,'admin','a',1,'2026-06-14 15:01:33'),(29,16,26,'customer','s',1,'2026-06-14 15:01:38'),(30,16,26,'customer','a',1,'2026-06-14 15:01:41'),(31,16,26,'customer','sdè',1,'2026-06-14 15:01:47');
/*!40000 ALTER TABLE `chat_messages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contact`
--

DROP TABLE IF EXISTS `contact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contact` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `fullname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `subject` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `organization` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  CONSTRAINT `contact_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contact`
--

LOCK TABLES `contact` WRITE;
/*!40000 ALTER TABLE `contact` DISABLE KEYS */;
INSERT INTO `contact` VALUES (5,26,'thy quynh','chauthithuyquynh2019@gmail.com','0378827924','giao thiếu hàng','','thiếu rau díp cá','2026-06-04 15:38:48'),(6,26,'Châu Thị Thuý Quỳnh','chauthithuyquynh2019@gmail.com','0999988887','mua sỉ rau','','Thấy chất lượng của bạn tốt, tôi muốn mua rau với số lượng sĩ','2026-06-14 20:39:52');
/*!40000 ALTER TABLE `contact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupon_usage`
--

DROP TABLE IF EXISTS `coupon_usage`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupon_usage` (
  `id` int NOT NULL AUTO_INCREMENT,
  `coupon_id` int NOT NULL,
  `user_id` int DEFAULT NULL,
  `order_id` int NOT NULL,
  `discount_amount` decimal(15,2) NOT NULL,
  `used_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_coupon_id` (`coupon_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_order_id` (`order_id`) USING BTREE,
  CONSTRAINT `fk_cu_coupon` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_cu_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_cu_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupon_usage`
--

LOCK TABLES `coupon_usage` WRITE;
/*!40000 ALTER TABLE `coupon_usage` DISABLE KEYS */;
INSERT INTO `coupon_usage` VALUES (8,8,26,129,20000.00,'2026-06-04 15:29:00'),(9,11,1,130,20000.00,'2026-06-04 15:32:32'),(10,11,26,132,20000.00,'2026-06-04 15:33:50'),(11,8,26,133,20000.00,'2026-06-04 15:51:38'),(12,8,1,135,20000.00,'2026-06-04 18:11:23'),(13,9,1,135,60500.00,'2026-06-04 18:11:23'),(14,8,1,139,20000.00,'2026-06-10 18:23:15'),(15,8,1,140,20000.00,'2026-06-11 08:11:00'),(16,9,1,143,60500.00,'2026-06-12 15:19:19'),(17,13,26,146,20000.00,'2026-06-14 18:55:11'),(18,14,26,147,50000.00,'2026-06-14 19:13:06'),(19,15,1,154,10000.00,'2026-06-16 06:16:31');
/*!40000 ALTER TABLE `coupon_usage` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `coupons`
--

DROP TABLE IF EXISTS `coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `coupons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_type` enum('percent','fixed','freeship') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `discount_value` decimal(15,2) NOT NULL DEFAULT '0.00',
  `max_discount` decimal(15,2) DEFAULT NULL,
  `min_order_value` decimal(15,2) NOT NULL DEFAULT '0.00',
  `quantity` int NOT NULL DEFAULT '0',
  `used_count` int NOT NULL DEFAULT '0',
  `max_usage_per_user` int NOT NULL DEFAULT '1',
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_code` (`code`) USING BTREE,
  KEY `idx_is_active` (`is_active`) USING BTREE,
  KEY `idx_date_range` (`start_date`,`end_date`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `coupons`
--

LOCK TABLES `coupons` WRITE;
/*!40000 ALTER TABLE `coupons` DISABLE KEYS */;
INSERT INTO `coupons` VALUES (8,'HELLOSUMMER','fixed',20000.00,NULL,50000.00,50,7,3,'2026-05-29 00:10:00','2027-06-03 01:10:00',1,'2026-05-28 18:10:02','2026-06-11 08:11:00'),(9,'FREESHIPNOW','freeship',0.00,NULL,150000.00,200,3,2,'2026-05-29 00:10:00','2027-05-30 01:10:00',1,'2026-05-28 18:10:02','2026-06-12 15:19:19'),(11,'HOT20','percent',20.00,20000.00,100000.00,500,2,1,'2026-06-04 15:09:00','2026-06-06 15:08:00',1,'2026-06-04 08:08:44','2026-06-05 14:36:54'),(13,'HOT30','percent',30.00,20000.00,100000.00,100,1,1,'2026-06-15 01:45:00','2026-06-21 01:46:00',1,'2026-06-14 18:46:14','2026-06-14 21:17:38'),(14,'HOT50','percent',50.00,50000.00,150000.00,1,1,2,'2026-06-15 02:10:00','2026-06-16 02:10:00',1,'2026-06-14 19:10:49','2026-06-14 21:11:07'),(15,'NONGSANSACH','fixed',10000.00,NULL,40000.00,200,1,1,'2026-06-16 01:01:00','2026-06-26 04:01:00',1,'2026-06-14 21:01:26','2026-06-16 06:16:31');
/*!40000 ALTER TABLE `coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `email_verification_tokens`
--

DROP TABLE IF EXISTS `email_verification_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `email_verification_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `expire_at` timestamp NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `token` (`token`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `email_verification_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `email_verification_tokens`
--

LOCK TABLES `email_verification_tokens` WRITE;
/*!40000 ALTER TABLE `email_verification_tokens` DISABLE KEYS */;
INSERT INTO `email_verification_tokens` VALUES (5,1,'f6b7d44d-dfe0-4ab4-8ebf-0ecb1d3969be','2026-06-17 03:50:59');
/*!40000 ALTER TABLE `email_verification_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `flash_sales`
--

DROP TABLE IF EXISTS `flash_sales`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `flash_sales` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `discount_percent` decimal(5,2) DEFAULT '0.00',
  `sold_count` int DEFAULT '0',
  `stock_limit` int DEFAULT '0',
  `start_time` datetime NOT NULL,
  `end_time` datetime NOT NULL,
  `max_qty_per_user` int DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_product_id` (`product_id`) USING BTREE,
  KEY `idx_time_range` (`start_time`,`end_time`) USING BTREE,
  CONSTRAINT `flash_sales_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `flash_sales`
--

LOCK TABLES `flash_sales` WRITE;
/*!40000 ALTER TABLE `flash_sales` DISABLE KEYS */;
INSERT INTO `flash_sales` VALUES (22,174,20.00,1,247,'2026-06-04 00:00:00','2026-06-06 00:00:00',0),(24,189,20.00,5,247,'2026-06-04 00:12:00','2027-06-07 00:12:00',0),(25,175,20.00,10,50,'2026-01-01 00:12:00','2027-01-01 00:12:00',0),(26,177,20.00,6,50,'2026-01-01 01:01:00','2027-01-01 01:01:00',0),(27,96,20.00,7,10,'2026-06-04 13:50:00','2026-06-07 12:50:00',0),(28,158,35.00,2,50,'2026-01-01 01:01:00','2027-01-01 01:01:00',0),(29,137,10.00,0,29,'2026-01-01 01:01:00','2027-01-01 01:11:00',0),(30,107,19.00,2,46,'2026-01-01 01:11:00','2027-01-01 01:01:00',0),(31,166,20.00,0,30,'2026-01-01 01:01:00','2027-01-01 01:01:00',12);
/*!40000 ALTER TABLE `flash_sales` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news`
--

DROP TABLE IF EXISTS `news`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `author_id` int DEFAULT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `excerpt` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `view_count` int DEFAULT '0',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'published',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_created_at` (`created_at`) USING BTREE,
  KEY `idx_category_id` (`category_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `author_id` (`author_id`) USING BTREE,
  CONSTRAINT `news_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `news_categories` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `news_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `users` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=32 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news`
--

LOCK TABLES `news` WRITE;
/*!40000 ALTER TABLE `news` DISABLE KEYS */;
INSERT INTO `news` VALUES (1,1,1,'Top 10 loại rau củ giàu dinh dưỡng nhất bạn nên ăn mỗi ngày','<h3>1. Bông cải xanh (Súp lơ xanh)</h3>\n<p>Bông cải xanh được mệnh danh là siêu thực phẩm nhờ chứa hàm lượng cao chất chống oxy hóa, sulforaphane – hợp chất có khả năng giảm nguy cơ ung thư. Nó cũng cung cấp lượng lớn vitamin C, K và chất xơ dồi dào giúp hỗ trợ hệ tiêu hóa hoạt động khỏe mạnh.</p>\n<div class=\"content-image\"><img src=\"https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?auto=format&fit=crop&w=800&q=80\" alt=\"Bông cải xanh tươi ngon\"></div>\n\n<h3>2. Rau cải bó xôi (Rau bina)</h3>\n<p>Loại rau lá xanh này chứa nhiều sắt, canxi và các chất chống oxy hóa như lutein và zeaxanthin, cực kỳ có lợi cho thị lực và tim mạch. Cải bó xôi cũng rất dễ chế biến, từ nấu canh, xào cho đến làm sinh tố.</p>\n<div class=\"content-image\"><img src=\"https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=800&q=80\" alt=\"Rau cải bó xôi tươi\"></div>\n\n<h3>3. Cà rốt</h3>\n<p>Cà rốt cực kỳ nổi tiếng với hàm lượng beta-carotene (tiền chất vitamin A) dồi dào, giúp duy trì đôi mắt sáng khỏe và tăng cường hệ miễn dịch. Ngoài ra, chất xơ và kali trong cà rốt cũng hỗ trợ kiểm soát huyết áp ổn định.</p>\n<div class=\"content-image\"><img src=\"https://images.unsplash.com/photo-1598170845058-32b9d6a5da37?auto=format&fit=crop&w=800&q=80\" alt=\"Củ cà rốt tươi ngon\"></div>\n\n<h3>4. Tỏi và hành tây</h3>\n<p>Tuy là gia vị nhưng tỏi và hành tây chứa nhiều hợp chất lưu huỳnh hoạt tính sinh học như allicin. Chúng có tính kháng khuẩn mạnh, giúp giảm cholesterol xấu, hạ huyết áp và nâng cao sức đề kháng hiệu quả.</p>\n\n<h3>5. Khoai lang</h3>\n<p>Khoai lang là nguồn tinh bột phức hợp tuyệt vời, giàu chất xơ, vitamin A và kali. Ăn khoai lang giúp ổn định đường huyết, cung cấp năng lượng bền bỉ và rất tốt cho người muốn giảm cân lành mạnh.</p>\n\n<p><strong>Lời khuyên dinh dưỡng:</strong> Bạn nên kết hợp nhiều loại rau củ với các màu sắc khác nhau trong thực đơn hàng ngày để cơ thể được bổ sung đa dạng các vitamin và khoáng chất cần thiết.</p>','Khám phá danh sách 10 loại rau củ quả quen thuộc nhưng mang lại nguồn dinh dưỡng vàng cho cơ thể, giúp phòng ngừa nhiều bệnh mãn tính hiệu quả.','https://images.unsplash.com/photo-1518843875459-f738682238a6?auto=format&fit=crop&w=800&q=80',1430,'published','2026-05-24 18:10:40','2026-06-22 17:24:42'),(2,2,1,'Bí quyết bảo quản rau củ tươi ngon cả tuần không lo héo úa','<p>Bảo quản rau củ trong tủ lạnh không đúng cách sẽ khiến chúng nhanh bị úng, héo hoặc mất đi chất dinh dưỡng vốn có. Dưới đây là các bước chuẩn bị và phân loại giúp rau củ của bạn luôn tươi xanh.</p>\n\n<h3>1. Không rửa rau củ trước khi cho vào tủ lạnh</h3>\n<p>Nước ẩm bám trên rau là nguyên nhân hàng đầu khiến vi khuẩn sinh sôi và làm rau bị úng nát. Hãy chỉ rửa rau ngay trước khi chế biến. Nếu rau bị ướt lúc mua về, hãy dùng khăn giấy thấm thật khô trước khi lưu trữ.</p>\n\n<h3>2. Phân loại rau củ trước khi bảo quản</h3>\n<p>Không nên để chung tất cả các loại rau củ vào một túi. Một số loại quả như chuối, cà chua, táo sản sinh ra khí ethylene – một loại khí thúc đẩy quá trình chín và làm các loại rau lá xanh để gần đó nhanh bị vàng úng.</p>\n<div class=\"content-image\"><img src=\"https://images.unsplash.com/photo-1606850780554-b55ea4dd0b70?auto=format&fit=crop&w=800&q=80\" alt=\"Bảo quản rau củ phân loại trong ngăn mát tủ lạnh\"></div>\n\n<h3>3. Sử dụng giấy báo hoặc khăn giấy</h3>\n<p>Bọc rau lá xanh bằng khăn giấy hoặc giấy báo sạch trước khi cho vào túi zip hoặc hộp kín. Khăn giấy sẽ hấp thụ bớt độ ẩm thừa, giữ cho lá rau khô ráo nhưng vẫn đủ độ ẩm tự nhiên để không bị héo.</p>\n\n<h3>4. Nhiệt độ tủ lạnh thích hợp</h3>\n<p>Nhiệt độ lý tưởng để bảo quản rau củ là từ 3°C đến 5°C. Nếu nhiệt độ quá thấp, rau có thể bị đóng băng và dập nát; ngược lại, nhiệt độ quá cao sẽ khiến vi khuẩn phát triển nhanh hơn.</p>','Hướng dẫn chi tiết các mẹo nhỏ cực kỳ hữu ích giúp giữ các loại rau xanh, củ quả luôn tươi ngon, mọng nước và không mất chất dinh dưỡng khi để trong tủ lạnh.','https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?auto=format&fit=crop&w=800&q=80',857,'published','2026-05-26 18:10:40','2026-06-23 04:11:18'),(3,3,1,'Tại sao rau củ hữu cơ lại là lựa chọn hàng đầu cho sức khỏe?','<p>Xu hướng sử dụng thực phẩm hữu cơ (organic) đang ngày càng phổ biến trong các gia đình hiện đại. Vậy rau củ hữu cơ thực chất là gì và chúng mang lại lợi ích gì vượt trội?</p>\n\n<h3>1. Không chứa hóa chất độc hại</h3>\n<p>Rau củ hữu cơ được canh tác theo quy trình nghiêm ngặt: không phân bón hóa học, không thuốc trừ sâu biến đổi gen và không chất kích thích tăng trưởng. Điều này giúp loại bỏ hoàn toàn nguy cơ tích tụ độc tố trong cơ thể người sử dụng.</p>\n<div class=\"content-image\"><img src=\"https://images.unsplash.com/photo-1592417817098-8f3d6eb19675?auto=format&fit=crop&w=800&q=80\" alt=\"Thu hoạch rau củ hữu cơ sạch\"></div>\n\n<h3>2. Hương vị tự nhiên và đậm đà hơn</h3>\n<p>Nhờ được phát triển tự nhiên trên đất giàu mùn hữu cơ và hấp thụ dinh dưỡng tự nhiên, rau củ hữu cơ thường có vị ngọt thanh, giòn và thơm đậm đà hơn rõ rệt so với rau củ canh tác công nghiệp.</p>\n\n<h3>3. Hàm lượng chất chống oxy hóa cao hơn</h3>\n<p>Nhiều nghiên cứu khoa học đã chỉ ra rằng thực phẩm hữu cơ chứa lượng chất chống oxy hóa cao hơn từ 20% đến 40% so với thông thường. Hợp chất này đóng vai trò quan trọng trong việc bảo vệ tế bào, tăng cường hệ miễn dịch và chống lão hóa.</p>\n\n<h3>4. Thân thiện với môi trường</h3>\n<p>Canh tác hữu cơ không chỉ bảo vệ sức khỏe con người mà còn bảo vệ nguồn nước, tái tạo độ phì nhiêu cho đất và giữ gìn hệ sinh thái tự nhiên bền vững cho thế hệ tương lai.</p>','Tìm hiểu sự khác biệt cốt lõi giữa rau củ hữu cơ và rau củ thông thường, lợi ích về sức khỏe cũng như giá trị dinh dưỡng vượt trội mà chúng mang lại.','https://images.unsplash.com/photo-1464226184884-fa280b87c399?auto=format&fit=crop&w=800&q=80',988,'published','2026-05-28 18:10:40','2026-06-23 04:21:02'),(4,4,1,'5 công thức làm salad rau củ thanh mát, giữ trọn dưỡng chất','<p>Salad là món ăn tuyệt vời để bổ sung rau xanh vào khẩu phần ăn hàng ngày mà không ngán. Dưới đây là 3 công thức salad cực ngon, dễ làm tại nhà:</p>\n\n<h3>1. Salad ức gà sốt dầu giấm (Giàu protein và chất xơ)</h3>\n<p><strong>Nguyên liệu:</strong> Xà lách, cà chua bi, dưa leo, hành tây đỏ, ức gà áp chảo xé nhỏ.\n<br/><strong>Nước sốt:</strong> 2 muỗng dầu olive, 1 muỗng giấm táo, 1 muỗng mật ong, một ít muối và tiêu đen. Trộn đều các nguyên liệu và thưởng thức ngay.</p>\n\n<h3>2. Salad bơ và tôm sốt chanh leo (Hương vị nhiệt đới bùng nổ)</h3>\n<p><strong>Nguyên liệu:</strong> Bơ chín cắt hạt lựu, tôm luộc bóc vỏ, rau mầm, bắp ngọt luộc chín.\n<br/><strong>Nước sốt:</strong> Nước cốt chanh leo lọc hạt, một chút mayonnaise, một muỗng mật ong. Sự béo ngậy của bơ hòa quyện cùng vị chua ngọt thanh mát của chanh leo tạo nên hương vị khó cưỡng.</p>\n<div class=\"content-image\"><img src=\"https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80\" alt=\"Chuẩn bị nguyên liệu salad rau củ quả\"></div>\n\n<h3>3. Salad rau củ cầu vồng (Đa dạng sắc màu dưỡng chất)</h3>\n<p><strong>Nguyên liệu:</strong> Bắp cải tím thái sợi, cà rốt bào sợi, ớt chuông vàng, rau cải xoăn (kale).\n<br/><strong>Nước sốt:</strong> Sốt mè rang thơm bùi hoặc dầu mè kết hợp nước tương tỏi ớt nhẹ nhàng.</p>','Gợi ý những công thức nước sốt và cách mix các loại rau củ tươi ngon để tạo nên đĩa salad giàu vitamin, dễ ăn cho cả gia đình vào những ngày hè.','https://images.unsplash.com/photo-1574316071802-0d684efa7bf5?auto=format&fit=crop&w=800&q=80',731,'published','2026-05-29 18:10:40','2026-06-22 06:38:15'),(5,5,1,'Cách nhận biết rau củ sạch đạt tiêu chuẩn VietGAP bằng mắt thường','<p>Trong bối cảnh thực phẩm bẩn tràn lan, việc nhận biết và chọn mua rau củ sạch là vô cùng quan trọng để bảo vệ sức khỏe gia đình. Dưới đây là một số mẹo giúp bạn chọn rau an toàn:</p>\n\n<h3>1. Quan sát màu sắc rau củ</h3>\n<p>Rau quả chứa nhiều hóa chất bảo vệ thực vật hoặc chất kích thích tăng trưởng thường có màu xanh đậm mướt mát, bóng bẩy bất thường. Rau sạch tự nhiên thường có màu xanh nhạt hoặc xanh sáng, lá dày và có kích thước không quá đồng đều.</p>\n\n<h3>2. Hình dáng bên ngoài</h3>\n<p>Rau sạch canh tác tự nhiên thường có kích thước vừa phải, thân rau rắn chắc, củ quả có thể có những vết sâu ăn lá nhỏ hoặc hình dáng hơi cong queo. Những loại củ quả to mọng, bóng bẩy, không tì vết thường tiềm ẩn nguy cơ chứa chất kích thích cao.</p>\n\n<h3>3. Mùi hương tự nhiên</h3>\n<p>Rau củ sạch luôn giữ được mùi thơm tự nhiên của từng loại rau quả. Ngược lại, nếu ngửi thấy mùi hắc của hóa chất, hoặc mùi lạ không tự nhiên thì tuyệt đối không nên mua.</p>\n<div class=\"content-image\"><img src=\"https://images.unsplash.com/photo-1566385101042-1a010c129fa6?auto=format&fit=crop&w=800&q=80\" alt=\"Lựa chọn rau củ tươi sạch tự nhiên\"></div>\n\n<h3>4. Chú ý nguồn gốc xuất xứ</h3>\n<p>Hãy ưu tiên mua rau củ tại các cửa hàng nông sản uy tín, siêu thị lớn có chứng nhận VietGAP, GlobalGAP hoặc hữu cơ được in rõ ràng trên bao bì sản phẩm.</p>','Hướng dẫn người tiêu dùng thông thái nhận biết rau củ an toàn qua hình dáng, màu sắc và mùi hương tự nhiên, tránh xa thực phẩm chứa hóa chất độc hại.','https://images.unsplash.com/photo-1610348725531-843dff563e2c?auto=format&fit=crop&w=800&q=80',623,'published','2026-05-30 18:10:40','2026-06-20 10:02:02'),(6,1,1,'Lợi ích kỳ diệu của việc uống nước ép rau củ mỗi buổi sáng','<p>Uống nước ép rau củ tươi vào buổi sáng khi bụng đói là một trong những cách hiệu quả nhất để thanh lọc cơ thể và cung cấp năng lượng sạch cho cả ngày dài hoạt động.</p>\n\n<h3>1. Hấp thụ chất dinh dưỡng tối đa</h3>\n<p>Khi ép rau củ, phần chất xơ thô bị loại bỏ, giúp hệ tiêu hóa dễ dàng hấp thụ các vitamin, khoáng chất và enzym sống chỉ trong vòng 15-20 phút mà không tốn nhiều năng lượng để tiêu hóa.</p>\n<div class=\"content-image\"><img src=\"https://images.unsplash.com/photo-1610970881699-44a5587caaec?auto=format&fit=crop&w=800&q=80\" alt=\"Nước ép rau quả nguyên chất\"></div>\n\n<h3>2. Thải độc và làm đẹp da</h3>\n<p>Nước ép rau củ như cần tây, dưa leo, rau cải xoăn chứa lượng lớn chất chống oxy hóa và nước tự nhiên giúp thanh lọc gan, làm sạch ruột, từ đó giúp làn da sáng khỏe, giảm mụn và ngăn ngừa lão hóa từ bên trong.</p>\n\n<h3>3. Cung cấp năng lượng tức thì</h3>\n<p>Đường tự nhiên trong rau quả kết hợp với các vitamin nhóm B giúp tăng cường sự tỉnh táo, tập trung mà không gây tăng sụt đường huyết đột ngột như khi uống cà phê hay nước ngọt.</p>','Bổ sung năng lượng và vitamin tự nhiên cho ngày mới bằng một ly nước ép rau củ quả. Xem ngay tác dụng của thói quen lành mạnh này đối với làn da và vóc dáng.','https://images.unsplash.com/photo-1506084868230-bb9d95c24759?auto=format&fit=crop&w=800&q=80',1164,'published','2026-05-31 18:10:40','2026-06-20 15:13:31'),(7,3,1,'Chế độ ăn \"Cầu Vồng\" - Bí quyết cân bằng dinh dưỡng từ màu sắc rau củ','<p>Chế độ ăn cầu vồng (Eat the Rainbow) khuyên chúng ta nên ăn đa dạng các loại thực phẩm thực vật với đầy đủ màu sắc mỗi ngày để đảm bảo cung cấp toàn diện các phytonutrient (dưỡng chất thực vật) có ích cho cơ thể.</p>\n\n<h3>1. Nhóm màu đỏ (Cà chua, dưa hấu, dâu tây)</h3>\n<p>Chứa nhiều lycopene và anthocyanin, giúp bảo vệ tim mạch, cải thiện trí nhớ và giảm nguy cơ mắc một số bệnh ung thư.</p>\n\n<h3>2. Nhóm màu vàng và cam (Cà rốt, bí ngô, xoài)</h3>\n<p>Rất giàu beta-carotene, vitamin C giúp tăng cường thị lực, hỗ trợ làn da khỏe mạnh và tăng sức đề kháng.</p>\n\n<h3>3. Nhóm màu xanh lá (Cải xoăn, súp lơ, cải bó xôi)</h3>\n<p>Giàu diệp lục, lutein, zeaxanthin và folate, hỗ trợ đắc lực cho thị lực, sự phát triển tế bào và thải độc gan hiệu quả.</p>\n<div class=\"content-image\"><img src=\"https://images.unsplash.com/photo-1508737027454-e6454ef45afd?auto=format&fit=crop&w=800&q=80\" alt=\"Các loại rau lá xanh giàu vitamin\"></div>\n\n<h3>4. Nhóm màu xanh lam và tím (Bắp cải tím, việt quất, cà tím)</h3>\n<p>Chứa lượng anthocyanin cực cao giúp chống viêm mạnh mẽ, hỗ trợ sức khỏe não bộ và bảo vệ hệ thống mạch máu.</p>\n\n<h3>5. Nhóm màu trắng (Tỏi, hành tây, nấm, súp lơ trắng)</h3>\n<p>Chứa allicin và beta-glucans giúp kháng khuẩn, kháng virus và tăng cường hệ minh dịch tự nhiên của cơ thể.</p>','Mỗi màu sắc của rau củ quả đại diện cho một nhóm dưỡng chất đặc trưng. Hãy cùng khám phá ý nghĩa của từng sắc màu và cách thiết thực thực đơn đầy đủ dưỡng chất.','https://images.unsplash.com/photo-1610348725531-843dff563e2c?auto=format&fit=crop&w=800&q=80',1070,'published','2026-06-01 18:10:40','2026-06-20 06:04:22');
/*!40000 ALTER TABLE `news` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news_categories`
--

DROP TABLE IF EXISTS `news_categories`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `slug` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `slug` (`slug`) USING BTREE,
  KEY `idx_slug` (`slug`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_categories`
--

LOCK TABLES `news_categories` WRITE;
/*!40000 ALTER TABLE `news_categories` DISABLE KEYS */;
INSERT INTO `news_categories` VALUES (1,'Sức Khỏe','suc-khoe','Các bài viết về sức khỏe và dinh dưỡng','2026-01-21 02:50:05'),(2,'Mẹo Vặt','meo-vat','Mẹo hay trong cuộc sống hàng ngày','2026-01-21 02:50:05'),(3,'Dinh Dưỡng','dinh-duong','Kiến thức về dinh dưỡng và thực phẩm','2026-01-21 02:50:05'),(4,'Công Thức','cong-thuc','Các công thức nấu ăn ngon từ rau củ quả','2026-01-21 02:50:05'),(5,'An Toàn Thực Phẩm','an-toan-thuc-pham','Thông tin về tiêu chuẩn an toàn thực phẩm','2026-01-21 02:50:05');
/*!40000 ALTER TABLE `news_categories` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `news_images`
--

DROP TABLE IF EXISTS `news_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `news_images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `news_id` int NOT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `caption` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `position` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_news_id` (`news_id`) USING BTREE,
  CONSTRAINT `news_images_ibfk_1` FOREIGN KEY (`news_id`) REFERENCES `news` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `news_images`
--

LOCK TABLES `news_images` WRITE;
/*!40000 ALTER TABLE `news_images` DISABLE KEYS */;
INSERT INTO `news_images` VALUES (34,1,'https://images.unsplash.com/photo-1518843875459-f738682238a6?auto=format&fit=crop&w=800&q=80','Bông cải xanh tươi sạch giàu chất chống oxy hóa',1,'2026-06-03 18:10:40'),(35,1,'https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=800&q=80','Cải bó xôi chứa nhiều sắt và canxi',2,'2026-06-03 18:10:40'),(36,2,'https://images.unsplash.com/photo-1542273917363-3b1817f69a2d?auto=format&fit=crop&w=800&q=80','Bảo quản đúng cách giúp rau củ tươi ngon lâu hơn',1,'2026-06-03 18:10:40'),(37,3,'https://images.unsplash.com/photo-1464226184884-fa280b87c399?auto=format&fit=crop&w=800&q=80','Nông trại canh tác rau củ hữu cơ tự nhiên',1,'2026-06-03 18:10:40'),(38,4,'https://images.unsplash.com/photo-1574316071802-0d684efa7bf5?auto=format&fit=crop&w=800&q=80','Đĩa salad tươi ngon cho bữa ăn lành mạnh',1,'2026-06-03 18:10:40'),(39,5,'https://images.unsplash.com/photo-1610348725531-843dff563e2c?auto=format&fit=crop&w=800&q=80','Rau củ sạch đạt tiêu chuẩn VietGAP tại cửa hàng',1,'2026-06-03 18:10:40'),(40,6,'https://images.unsplash.com/photo-1506084868230-bb9d95c24759?auto=format&fit=crop&w=800&q=80','Nước ép cần tây dưa leo cho buổi sáng sảng khoái',1,'2026-06-03 18:10:40'),(41,7,'https://images.unsplash.com/photo-1610348725531-843dff563e2c?auto=format&fit=crop&w=800&q=80','Thực phẩm đa dạng sắc màu giúp cân bằng dưỡng chất',1,'2026-06-03 18:10:40');
/*!40000 ALTER TABLE `news_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_details`
--

DROP TABLE IF EXISTS `order_details`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_details` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `product_id` int NOT NULL,
  `variant_id` int DEFAULT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `unit_price` decimal(15,2) NOT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `import_price` decimal(15,2) DEFAULT '0.00',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `variant_id` (`variant_id`) USING BTREE,
  KEY `idx_order_id` (`order_id`) USING BTREE,
  CONSTRAINT `order_details_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `order_details_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `order_details_ibfk_3` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=348 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_details`
--

LOCK TABLES `order_details` WRITE;
/*!40000 ALTER TABLE `order_details` DISABLE KEYS */;
INSERT INTO `order_details` VALUES (225,122,186,300,1,10000.00,10000.00,0.00),(226,122,185,298,1,15000.00,15000.00,0.00),(227,123,189,304,1,28000.00,28000.00,0.00),(228,124,114,187,1,25000.00,25000.00,0.00),(229,125,114,187,1,25000.00,25000.00,0.00),(230,126,114,187,1,25000.00,25000.00,0.00),(231,127,186,300,3,10000.00,30000.00,0.00),(232,127,185,298,2,15000.00,30000.00,0.00),(233,127,182,295,1,40000.00,40000.00,0.00),(234,128,48,67,1,15000.00,15000.00,0.00),(235,129,48,67,1,15000.00,15000.00,0.00),(236,129,115,188,1,18000.00,18000.00,0.00),(237,129,96,156,1,40000.00,40000.00,0.00),(238,130,177,286,1,10000.00,10000.00,0.00),(239,130,178,288,1,19000.00,19000.00,0.00),(240,130,184,297,1,18000.00,18000.00,0.00),(241,130,183,296,1,30000.00,30000.00,0.00),(242,130,186,300,1,10000.00,10000.00,0.00),(243,130,113,186,1,35000.00,35000.00,0.00),(249,132,189,304,1,28000.00,28000.00,18000.00),(250,132,186,300,1,10000.00,10000.00,0.00),(251,132,185,298,1,15000.00,15000.00,0.00),(252,132,184,297,1,18000.00,18000.00,0.00),(253,132,181,293,1,10000.00,10000.00,0.00),(254,132,179,290,2,18000.00,36000.00,0.00),(255,133,96,156,5,32000.00,160000.00,30000.00),(256,134,96,157,2,32000.00,64000.00,60000.00),(257,135,114,187,1,25000.00,25000.00,0.00),(258,135,109,182,1,38000.00,38000.00,0.00),(259,135,177,286,1,8000.00,8000.00,0.00),(260,135,175,282,1,28000.00,28000.00,0.00),(261,135,174,281,1,11200.00,11200.00,0.00),(262,135,178,288,3,19000.00,57000.00,0.00),(263,136,177,286,1,8000.00,8000.00,0.00),(264,137,189,304,1,22400.00,22400.00,18000.00),(265,138,186,300,1,10000.00,10000.00,0.00),(266,138,185,298,1,15000.00,15000.00,0.00),(267,139,48,68,7,15000.00,105000.00,0.00),(268,140,185,299,5,25000.00,125000.00,0.00),(269,140,177,286,1,8000.00,8000.00,0.00),(270,141,114,187,1,25000.00,25000.00,0.00),(271,142,48,67,2,15000.00,30000.00,0.00),(272,143,96,157,3,80000.00,240000.00,60000.00),(273,143,114,187,17,25000.00,425000.00,0.00),(274,143,48,67,1,15000.00,15000.00,0.00),(275,143,113,186,1,35000.00,35000.00,0.00),(276,144,189,304,1,22400.00,22400.00,18000.00),(277,144,186,300,1,10000.00,10000.00,0.00),(278,144,185,298,1,15000.00,15000.00,0.00),(279,145,189,304,1,22400.00,22400.00,18000.00),(280,145,186,300,1,10000.00,10000.00,0.00),(281,146,184,297,1,18000.00,18000.00,0.00),(282,146,185,298,1,15000.00,15000.00,0.00),(283,146,175,282,1,28000.00,28000.00,0.00),(284,146,170,275,1,25000.00,25000.00,0.00),(285,146,168,271,1,35000.00,35000.00,0.00),(286,147,181,293,1,10000.00,10000.00,0.00),(287,147,180,292,1,18000.00,18000.00,0.00),(288,147,184,297,1,18000.00,18000.00,0.00),(289,147,185,298,2,15000.00,30000.00,0.00),(290,147,179,290,7,18000.00,126000.00,0.00),(291,148,189,304,1,22400.00,22400.00,18000.00),(292,149,113,186,1,35000.00,35000.00,0.00),(293,150,113,186,1,35000.00,35000.00,0.00),(294,151,175,282,3,28000.00,84000.00,0.00),(295,151,177,286,1,8000.00,8000.00,0.00),(296,151,158,257,1,12350.00,12350.00,0.00),(297,151,114,187,1,25000.00,25000.00,0.00),(298,151,113,186,1,35000.00,35000.00,0.00),(299,151,96,156,1,40000.00,40000.00,30000.00),(300,151,48,67,1,15000.00,15000.00,0.00),(301,151,109,182,1,38000.00,38000.00,0.00),(302,151,115,188,1,18000.00,18000.00,0.00),(303,151,108,180,1,145000.00,145000.00,0.00),(304,152,108,180,1,145000.00,145000.00,0.00),(305,152,96,156,1,40000.00,40000.00,30000.00),(306,152,114,187,1,25000.00,25000.00,0.00),(307,152,115,188,1,18000.00,18000.00,0.00),(308,152,116,189,1,15000.00,15000.00,0.00),(309,152,113,186,1,35000.00,35000.00,0.00),(310,152,48,67,1,15000.00,15000.00,0.00),(311,152,109,182,1,38000.00,38000.00,0.00),(312,153,177,286,1,8000.00,8000.00,0.00),(313,153,158,257,1,12350.00,12350.00,0.00),(314,153,113,186,1,35000.00,35000.00,0.00),(315,153,107,178,1,29970.00,29970.00,0.00),(316,154,108,180,2,145000.00,290000.00,0.00),(317,154,113,186,2,35000.00,70000.00,0.00),(318,154,114,187,2,25000.00,50000.00,0.00),(319,154,175,282,2,28000.00,56000.00,0.00),(320,154,179,290,2,18000.00,36000.00,0.00),(321,155,108,180,1,145000.00,145000.00,0.00),(322,155,48,67,1,15000.00,15000.00,0.00),(323,156,114,187,1,25000.00,25000.00,0.00),(324,156,48,67,1,15000.00,15000.00,0.00),(325,157,181,293,1,10000.00,10000.00,0.00),(326,157,184,297,1,18000.00,18000.00,0.00),(327,158,96,156,1,40000.00,40000.00,30000.00),(328,159,96,156,1,40000.00,40000.00,30000.00),(329,160,107,178,1,29970.00,29970.00,0.00),(330,161,175,282,2,28000.00,56000.00,0.00),(331,161,186,300,3,10000.00,30000.00,0.00),(332,161,113,186,1,35000.00,35000.00,0.00),(333,162,181,293,1,10000.00,10000.00,0.00),(334,162,189,304,1,22400.00,22400.00,18000.00),(335,162,186,300,1,10000.00,10000.00,0.00),(336,162,185,298,1,15000.00,15000.00,0.00),(337,163,48,67,1,15000.00,15000.00,0.00),(338,164,96,156,1,40000.00,40000.00,30000.00),(339,164,114,187,1,25000.00,25000.00,0.00),(340,164,109,182,1,38000.00,38000.00,0.00),(341,165,96,156,1,40000.00,40000.00,30000.00),(342,165,113,186,1,35000.00,35000.00,0.00),(343,165,48,67,1,15000.00,15000.00,0.00),(344,166,177,286,1,8000.00,8000.00,0.00),(345,166,175,282,1,28000.00,28000.00,0.00),(346,167,114,187,1,25000.00,25000.00,0.00),(347,167,115,188,1,18000.00,18000.00,0.00);
/*!40000 ALTER TABLE `order_details` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `order_status_history`
--

DROP TABLE IF EXISTS `order_status_history`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `order_status_history` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `old_status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `new_status` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `changed_by` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'admin, user, system',
  `changed_by_id` int DEFAULT NULL COMMENT 'user_id hoặc admin_id',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci COMMENT 'Lý do / ghi chú khi đổi trạng thái',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_osh_order_id` (`order_id`) USING BTREE,
  KEY `idx_osh_created_at` (`created_at`) USING BTREE,
  CONSTRAINT `order_status_history_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=181 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_status_history`
--

LOCK TABLES `order_status_history` WRITE;
/*!40000 ALTER TABLE `order_status_history` DISABLE KEYS */;
INSERT INTO `order_status_history` VALUES (74,122,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-02 14:15:19'),(75,122,'confirmed','shipping','admin',26,NULL,'2026-06-02 14:15:54'),(76,122,'shipping','completed','admin',26,NULL,'2026-06-02 14:15:59'),(77,123,'pending','processing','admin',27,NULL,'2026-06-02 16:17:38'),(78,123,'processing','shipping','admin',27,NULL,'2026-06-02 16:17:41'),(79,123,'shipping','completed','admin',27,NULL,'2026-06-02 16:17:44'),(80,125,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-02 17:45:44'),(81,126,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-02 17:55:07'),(82,129,'pending','processing','admin',26,NULL,'2026-06-04 15:29:16'),(83,129,'processing','shipping','admin',26,NULL,'2026-06-04 15:29:20'),(84,134,'pending','processing','admin',NULL,NULL,'2026-06-04 16:28:01'),(85,133,'pending','processing','admin',NULL,NULL,'2026-06-04 16:28:04'),(86,132,'pending','processing','admin',NULL,NULL,'2026-06-04 16:28:08'),(87,134,'processing','shipping','admin',NULL,NULL,'2026-06-04 16:28:12'),(88,133,'processing','shipping','admin',NULL,NULL,'2026-06-04 16:28:15'),(89,134,'shipping','completed','admin',NULL,NULL,'2026-06-04 16:28:18'),(90,133,'shipping','completed','admin',NULL,NULL,'2026-06-04 16:28:22'),(91,132,'processing','shipping','admin',NULL,NULL,'2026-06-04 16:28:24'),(92,132,'shipping','completed','admin',NULL,NULL,'2026-06-04 16:28:28'),(93,128,'pending','processing','admin',NULL,NULL,'2026-06-04 16:28:31'),(94,129,'shipping','completed','admin',NULL,NULL,'2026-06-04 16:28:34'),(95,130,'pending','processing','admin',NULL,NULL,'2026-06-04 16:28:37'),(96,128,'processing','shipping','admin',NULL,NULL,'2026-06-04 16:28:39'),(97,128,'shipping','completed','admin',NULL,NULL,'2026-06-04 16:28:42'),(98,130,'processing','shipping','admin',NULL,NULL,'2026-06-04 16:28:45'),(99,130,'shipping','completed','admin',NULL,NULL,'2026-06-04 16:29:03'),(100,127,'pending','processing','admin',NULL,NULL,'2026-06-04 16:29:08'),(101,126,'confirmed','shipping','admin',NULL,NULL,'2026-06-04 16:29:12'),(102,127,'processing','shipping','admin',NULL,NULL,'2026-06-04 16:29:14'),(103,126,'shipping','completed','admin',NULL,NULL,'2026-06-04 16:29:17'),(104,127,'shipping','completed','admin',NULL,NULL,'2026-06-04 16:29:19'),(105,125,'confirmed','shipping','admin',NULL,NULL,'2026-06-04 16:29:43'),(106,124,'pending','processing','admin',NULL,NULL,'2026-06-04 16:29:47'),(107,125,'shipping','completed','admin',NULL,NULL,'2026-06-04 16:29:51'),(108,124,'processing','shipping','admin',NULL,NULL,'2026-06-04 16:29:53'),(109,124,'shipping','completed','admin',NULL,NULL,'2026-06-04 16:29:56'),(110,135,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-04 18:25:41'),(111,135,'confirmed','shipping','admin',1,NULL,'2026-06-04 18:26:36'),(112,135,'shipping','completed','admin',1,NULL,'2026-06-04 18:26:51'),(113,136,'pending','processing','admin',1,NULL,'2026-06-04 18:48:41'),(114,136,'processing','shipping','admin',NULL,NULL,'2026-06-04 19:06:29'),(115,138,'pending','cancelled','user',25,'Người dùng hủy đơn hàng','2026-06-10 03:25:04'),(116,140,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-11 08:11:09'),(117,142,'pending','processing','admin',25,NULL,'2026-06-12 06:40:41'),(118,141,'pending','processing','admin',25,NULL,'2026-06-12 06:40:44'),(119,142,'processing','shipping','admin',25,NULL,'2026-06-12 06:40:46'),(120,141,'processing','shipping','admin',25,NULL,'2026-06-12 06:40:49'),(121,142,'shipping','completed','admin',25,NULL,'2026-06-12 06:40:52'),(122,141,'shipping','completed','admin',25,NULL,'2026-06-12 06:40:54'),(123,140,'confirmed','shipping','admin',25,NULL,'2026-06-12 06:40:57'),(124,140,'shipping','completed','admin',25,NULL,'2026-06-12 06:41:01'),(125,139,'pending','processing','admin',25,NULL,'2026-06-12 06:41:03'),(126,137,'pending','processing','admin',25,NULL,'2026-06-12 06:41:06'),(127,139,'processing','shipping','admin',25,NULL,'2026-06-12 06:41:08'),(128,137,'processing','shipping','admin',25,NULL,'2026-06-12 06:41:11'),(129,139,'shipping','completed','admin',25,NULL,'2026-06-12 06:41:14'),(130,137,'shipping','completed','admin',25,NULL,'2026-06-12 06:41:17'),(131,136,'shipping','completed','admin',25,NULL,'2026-06-12 06:41:19'),(132,143,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-12 15:19:48'),(133,143,'confirmed','shipping','admin',23,NULL,'2026-06-12 15:33:48'),(134,143,'shipping','completed','admin',23,NULL,'2026-06-12 15:33:52'),(135,142,'completed','refunded','admin',25,'Hoàn tiền đã được xác nhận (RefundRequest #1)','2026-06-14 11:42:44'),(136,142,'completed','refunded','admin',25,'Hoàn tiền đã được xác nhận (RefundRequest #1)','2026-06-14 11:48:32'),(137,143,'completed','refunded','admin',25,'Hoàn tiền đã được xác nhận (RefundRequest #2)','2026-06-14 13:14:47'),(138,140,'completed','refunded','admin',25,'Hoàn tiền đã được xác nhận (RefundRequest #3)','2026-06-14 14:02:46'),(139,144,'pending','processing','admin',25,NULL,'2026-06-14 14:47:54'),(140,144,'processing','shipping','admin',25,NULL,'2026-06-14 14:47:58'),(141,144,'shipping','completed','admin',25,NULL,'2026-06-14 14:48:32'),(142,145,'pending','processing','admin',25,NULL,'2026-06-14 14:56:17'),(143,145,'processing','shipping','admin',25,NULL,'2026-06-14 14:56:22'),(144,145,'shipping','completed','admin',25,NULL,'2026-06-14 14:56:26'),(145,148,'pending','processing','admin',25,NULL,'2026-06-14 20:03:32'),(146,148,'processing','shipping','admin',25,NULL,'2026-06-14 20:03:34'),(147,148,'shipping','completed','admin',25,NULL,'2026-06-14 20:03:40'),(148,149,'pending','processing','admin',25,NULL,'2026-06-15 17:05:40'),(149,149,'processing','shipping','admin',25,NULL,'2026-06-15 17:05:57'),(150,149,'shipping','completed','admin',25,NULL,'2026-06-15 17:06:57'),(151,150,'pending','processing','admin',25,NULL,'2026-06-16 02:26:54'),(152,150,'processing','shipping','admin',25,NULL,'2026-06-16 02:26:57'),(153,150,'shipping','completed','admin',25,NULL,'2026-06-16 02:27:00'),(154,144,'completed','refunded','admin',25,'Hoàn tiền đã được xác nhận (RefundRequest #4)','2026-06-16 03:39:28'),(155,153,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-16 06:09:47'),(156,154,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-16 06:16:38'),(157,154,'confirmed','shipping','admin',25,NULL,'2026-06-16 06:18:40'),(158,153,'confirmed','shipping','admin',25,NULL,'2026-06-16 06:20:35'),(159,154,'shipping','completed','admin',25,NULL,'2026-06-16 06:20:41'),(160,153,'shipping','completed','admin',25,NULL,'2026-06-16 06:20:44'),(161,155,'pending','processing','admin',25,NULL,'2026-06-16 06:21:47'),(162,155,'processing','shipping','admin',25,NULL,'2026-06-16 06:22:13'),(163,156,'pending','processing','admin',25,NULL,'2026-06-16 06:27:54'),(164,156,'processing','shipping','admin',25,NULL,'2026-06-16 06:28:03'),(165,156,'pending','processing','admin',25,NULL,'2026-06-16 06:31:24'),(166,156,'processing','shipping','admin',25,NULL,'2026-06-16 06:31:36'),(167,155,'pending','processing','admin',25,NULL,'2026-06-16 06:35:10'),(168,156,'pending','processing','admin',25,NULL,'2026-06-16 06:48:52'),(169,156,'processing','shipping','admin',25,NULL,'2026-06-16 06:49:23'),(170,158,'pending','processing','admin',25,NULL,'2026-06-16 07:09:08'),(171,158,'processing','shipping','admin',25,NULL,'2026-06-16 07:09:13'),(172,156,'pending','processing','admin',25,NULL,'2026-06-16 07:20:14'),(173,159,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-16 07:21:22'),(174,159,'confirmed','shipping','admin',25,NULL,'2026-06-16 07:21:36'),(175,160,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-16 07:29:57'),(176,162,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-16 08:03:19'),(177,163,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-16 08:56:18'),(178,164,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-16 09:03:05'),(179,166,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-17 11:06:28'),(180,167,'pending','confirmed','system',NULL,'Đơn hàng được xác nhận tự động sau khi thanh toán thành công qua chuyển khoản ngân hàng.','2026-06-18 16:48:58');
/*!40000 ALTER TABLE `order_status_history` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `orders`
--

DROP TABLE IF EXISTS `orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `orders` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `address_id` int NOT NULL,
  `payment_method_id` int NOT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'pending',
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `shipping_fee` decimal(10,2) DEFAULT '0.00',
  `total_price` decimal(15,2) NOT NULL,
  `guest_email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `guest_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `guest_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `order_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `payment_status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'unpaid',
  `admin_note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `coupon_id` int DEFAULT NULL,
  `discount_amount` decimal(15,2) NOT NULL DEFAULT '0.00',
  `freeship_coupon_id` int DEFAULT NULL,
  `freeship_discount_amount` double DEFAULT '0',
  `ghn_order_code` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `address_id` (`address_id`) USING BTREE,
  KEY `payment_method_id` (`payment_method_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  KEY `idx_order_date` (`order_date`) USING BTREE,
  KEY `idx_coupon_id` (`coupon_id`) USING BTREE,
  CONSTRAINT `fk_orders_coupon` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE SET NULL ON UPDATE RESTRICT,
  CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`address_id`) REFERENCES `address` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `orders_ibfk_3` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_method` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=168 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orders`
--

LOCK TABLES `orders` WRITE;
/*!40000 ALTER TABLE `orders` DISABLE KEYS */;
INSERT INTO `orders` VALUES (122,26,17,2,'completed','',20900.00,45900.00,NULL,NULL,NULL,'2026-06-02 14:14:23','paid',NULL,NULL,0.00,NULL,0,NULL),(123,27,18,1,'completed','',38500.00,66500.00,NULL,NULL,NULL,'2026-06-02 16:17:11','unpaid',NULL,NULL,0.00,NULL,0,NULL),(124,25,19,1,'completed','',60500.00,85500.00,NULL,NULL,NULL,'2026-06-02 17:42:20','unpaid',NULL,NULL,0.00,NULL,0,NULL),(125,27,20,2,'completed','Ko co j',60500.00,85500.00,NULL,NULL,NULL,'2026-06-02 17:45:36','paid',NULL,NULL,0.00,NULL,0,NULL),(126,25,19,2,'completed','',60500.00,85500.00,NULL,NULL,NULL,'2026-06-02 17:54:33','paid',NULL,NULL,0.00,NULL,0,NULL),(127,26,21,1,'completed','',20900.00,120900.00,NULL,NULL,NULL,'2026-06-04 08:41:35','unpaid',NULL,NULL,0.00,NULL,0,NULL),(128,1,15,1,'completed','',60500.00,75500.00,NULL,NULL,NULL,'2026-06-04 13:33:48','unpaid',NULL,NULL,0.00,NULL,0,NULL),(129,26,17,1,'completed','',20900.00,73900.00,NULL,NULL,NULL,'2026-06-04 15:29:00','unpaid',NULL,8,20000.00,NULL,0,NULL),(130,1,15,1,'completed','',60500.00,162500.00,NULL,NULL,NULL,'2026-06-04 15:32:32','unpaid',NULL,11,20000.00,NULL,0,NULL),(132,26,17,1,'completed','',20900.00,117900.00,NULL,NULL,NULL,'2026-06-04 15:33:50','unpaid',NULL,11,20000.00,NULL,0,NULL),(133,26,17,1,'completed','',20900.00,160900.00,NULL,NULL,NULL,'2026-06-04 15:51:38','unpaid',NULL,8,20000.00,NULL,0,NULL),(134,26,17,1,'completed','',20900.00,84900.00,NULL,NULL,NULL,'2026-06-04 15:52:39','unpaid',NULL,NULL,0.00,NULL,0,NULL),(135,1,15,2,'completed','',60500.00,147200.00,NULL,NULL,NULL,'2026-06-04 18:11:23','paid',NULL,8,20000.00,9,60500,NULL),(136,1,15,1,'completed','',60500.00,68500.00,NULL,NULL,NULL,'2026-06-04 18:47:49','unpaid',NULL,NULL,0.00,NULL,0,NULL),(137,1,15,1,'completed','',60500.00,82900.00,NULL,NULL,NULL,'2026-06-09 18:57:37','unpaid',NULL,NULL,0.00,NULL,0,NULL),(138,25,19,1,'cancelled','',60500.00,85500.00,NULL,NULL,NULL,'2026-06-10 03:23:49','unpaid',NULL,NULL,0.00,NULL,0,NULL),(139,1,15,1,'completed','',60500.00,145500.00,NULL,NULL,NULL,'2026-06-10 18:23:15','unpaid',NULL,8,20000.00,NULL,0,NULL),(140,1,23,2,'refunded','',60500.00,173500.00,NULL,NULL,NULL,'2026-06-11 08:11:00','paid',NULL,8,20000.00,NULL,0,NULL),(141,34,24,1,'completed','',38500.00,63500.00,NULL,NULL,NULL,'2026-06-11 08:42:57','unpaid',NULL,NULL,0.00,NULL,0,NULL),(142,1,23,1,'refunded','',60500.00,90500.00,NULL,NULL,NULL,'2026-06-11 13:20:35','unpaid',NULL,NULL,0.00,NULL,0,NULL),(143,1,15,2,'refunded','',60500.00,715000.00,NULL,NULL,NULL,'2026-06-12 15:19:19','paid',NULL,NULL,0.00,9,60500,NULL),(144,26,17,1,'refunded','',20900.00,68300.00,NULL,NULL,NULL,'2026-06-14 14:47:04','unpaid',NULL,NULL,0.00,NULL,0,NULL),(145,26,17,1,'completed','',20900.00,53300.00,NULL,NULL,NULL,'2026-06-14 14:55:59','unpaid',NULL,NULL,0.00,NULL,0,NULL),(146,26,17,1,'pending','',20900.00,121900.00,NULL,NULL,NULL,'2026-06-14 18:55:11','unpaid',NULL,13,20000.00,NULL,0,NULL),(147,26,17,1,'pending','',20900.00,172900.00,NULL,NULL,NULL,'2026-06-14 19:13:06','unpaid',NULL,14,50000.00,NULL,0,NULL),(148,26,17,1,'completed','',20900.00,43300.00,NULL,NULL,NULL,'2026-06-14 20:03:12','unpaid',NULL,NULL,0.00,NULL,0,NULL),(149,27,20,1,'completed','',60500.00,95500.00,NULL,NULL,NULL,'2026-06-15 17:03:34','unpaid',NULL,NULL,0.00,NULL,0,NULL),(150,26,17,1,'completed','',20900.00,55900.00,NULL,NULL,NULL,'2026-06-16 02:26:41','unpaid',NULL,NULL,0.00,NULL,0,NULL),(151,30,25,1,'pending','',60500.00,480850.00,NULL,NULL,NULL,'2026-06-16 05:18:50','unpaid',NULL,NULL,0.00,NULL,0,NULL),(152,30,25,1,'pending','',60500.00,391500.00,NULL,NULL,NULL,'2026-06-16 06:07:22','unpaid',NULL,NULL,0.00,NULL,0,NULL),(153,30,25,2,'completed','',60500.00,145820.00,NULL,NULL,NULL,'2026-06-16 06:08:16','paid',NULL,NULL,0.00,NULL,0,NULL),(154,1,23,2,'completed','',60500.00,552500.00,NULL,NULL,NULL,'2026-06-16 06:16:31','paid',NULL,15,10000.00,NULL,0,NULL),(155,1,23,1,'pending','',60500.00,220500.00,NULL,NULL,NULL,'2026-06-16 06:21:25','unpaid',NULL,NULL,0.00,NULL,0,NULL),(156,1,26,1,'processing','',60500.00,100500.00,NULL,NULL,NULL,'2026-06-16 06:27:15','unpaid',NULL,NULL,0.00,NULL,0,'LXX7T4'),(157,26,17,2,'pending','',20900.00,48900.00,NULL,NULL,NULL,'2026-06-16 06:51:19','pending',NULL,NULL,0.00,NULL,0,NULL),(158,1,26,1,'shipping','',60500.00,100500.00,NULL,NULL,NULL,'2026-06-16 07:08:45','unpaid',NULL,NULL,0.00,NULL,0,NULL),(159,1,15,2,'shipping','',60500.00,100500.00,NULL,NULL,NULL,'2026-06-16 07:21:15','paid',NULL,NULL,0.00,NULL,0,NULL),(160,1,15,2,'confirmed','',60500.00,90470.00,NULL,NULL,NULL,'2026-06-16 07:29:50','paid',NULL,NULL,0.00,NULL,0,'LXX7A9'),(161,26,27,1,'pending','',49500.00,170500.00,NULL,NULL,NULL,'2026-06-16 07:52:48','unpaid',NULL,NULL,0.00,NULL,0,NULL),(162,26,17,2,'confirmed','',20900.00,78300.00,NULL,NULL,NULL,'2026-06-16 07:53:09','paid',NULL,NULL,0.00,NULL,0,'LXXGGG'),(163,1,15,2,'confirmed','',60500.00,75500.00,NULL,NULL,NULL,'2026-06-16 08:56:09','paid',NULL,NULL,0.00,NULL,0,'LXXGT8'),(164,1,15,2,'confirmed','',60500.00,163500.00,NULL,NULL,NULL,'2026-06-16 09:02:53','paid',NULL,NULL,0.00,NULL,0,'LXXGAK'),(165,30,25,1,'pending','',60500.00,150500.00,NULL,NULL,NULL,'2026-06-17 11:05:31','unpaid',NULL,NULL,0.00,NULL,0,NULL),(166,30,25,2,'confirmed','',60500.00,96500.00,NULL,NULL,NULL,'2026-06-17 11:05:46','paid',NULL,NULL,0.00,NULL,0,'LXXYVG'),(167,30,25,2,'confirmed','',60500.00,103500.00,NULL,NULL,NULL,'2026-06-18 16:48:49','paid',NULL,NULL,0.00,NULL,0,'LXA4KR');
/*!40000 ALTER TABLE `orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `password_reset_tokens`
--

DROP TABLE IF EXISTS `password_reset_tokens`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `password_reset_tokens` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(6) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `expires_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_used` tinyint(1) DEFAULT '0',
  `so_lan_sai` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_email` (`email`) USING BTREE,
  KEY `idx_otp_code` (`token`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  CONSTRAINT `password_reset_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `password_reset_tokens`
--

LOCK TABLES `password_reset_tokens` WRITE;
/*!40000 ALTER TABLE `password_reset_tokens` DISABLE KEYS */;
INSERT INTO `password_reset_tokens` VALUES (5,27,'taiplatform69@gmail.com','602710','2026-06-05 18:56:10','2026-06-05 19:01:10',1,0),(6,27,'taiplatform69@gmail.com','906844','2026-06-05 18:57:12','2026-06-05 19:02:12',1,0),(7,27,'taiplatform69@gmail.com','741662','2026-06-05 19:00:13','2026-06-05 19:05:13',1,0),(8,27,'taiplatform69@gmail.com','864859','2026-06-05 19:01:24','2026-06-05 19:06:25',1,0),(9,27,'taiplatform69@gmail.com','692193','2026-06-15 06:46:17','2026-06-15 06:51:17',1,0),(10,27,'taiplatform69@gmail.com','406784','2026-06-15 07:16:27','2026-06-15 07:21:27',1,0),(11,27,'taiplatform69@gmail.com','875175','2026-06-15 07:20:52','2026-06-15 07:25:53',1,0),(12,27,'taiplatform69@gmail.com','461626','2026-06-15 07:23:45','2026-06-15 07:28:46',1,0),(13,27,'taiplatform69@gmail.com','570981','2026-06-15 07:25:03','2026-06-15 07:30:04',1,0),(14,27,'taiplatform69@gmail.com','254274','2026-06-15 07:30:39','2026-06-15 07:35:39',1,0),(15,27,'taiplatform69@gmail.com','353109','2026-06-15 07:53:40','2026-06-15 07:58:41',1,0),(16,27,'taiplatform69@gmail.com','943747','2026-06-15 10:40:40','2026-06-15 10:45:41',1,0),(17,27,'taiplatform69@gmail.com','340314','2026-06-15 10:41:42','2026-06-15 10:46:42',1,0),(18,27,'taiplatform69@gmail.com','873392','2026-06-15 10:47:05','2026-06-15 10:52:06',1,0),(19,27,'taiplatform69@gmail.com','285528','2026-06-15 10:59:51','2026-06-15 11:04:51',1,0),(20,27,'taiplatform69@gmail.com','512319','2026-06-15 11:01:25','2026-06-15 11:06:26',1,1),(21,27,'taiplatform69@gmail.com','200749','2026-06-15 11:05:05','2026-06-15 11:10:05',1,0),(22,27,'taiplatform69@gmail.com','992823','2026-06-15 11:07:39','2026-06-15 11:12:39',1,0),(23,26,'chauthithuyquynh2019@gmail.com','431833','2026-06-16 02:36:56','2026-06-16 02:41:57',1,0),(24,27,'taiplatform69@gmail.com','906380','2026-06-16 02:37:45','2026-06-16 02:42:45',1,0),(25,27,'taiplatform69@gmail.com','850924','2026-06-16 02:42:47','2026-06-16 02:47:48',0,0),(26,30,'lyphat0101@gmail.com','409813','2026-06-16 03:53:51','2026-06-16 03:58:51',1,0),(27,30,'lyphat0101@gmail.com','840763','2026-06-16 03:56:18','2026-06-16 04:01:19',1,1);
/*!40000 ALTER TABLE `password_reset_tokens` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment_method`
--

DROP TABLE IF EXISTS `payment_method`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment_method` (
  `id` int NOT NULL AUTO_INCREMENT,
  `method_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment_method`
--

LOCK TABLES `payment_method` WRITE;
/*!40000 ALTER TABLE `payment_method` DISABLE KEYS */;
INSERT INTO `payment_method` VALUES (1,'Thanh toán khi nhận hàng (COD)','active'),(2,'Chuyển khoản ngân hàng','active');
/*!40000 ALTER TABLE `payment_method` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payments`
--

DROP TABLE IF EXISTS `payments`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payments` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `payment_code` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Internal unique code per attempt',
  `invoice_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT 'Sent to SePay as order_invoice_number',
  `provider` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'sepay',
  `amount` decimal(15,2) NOT NULL,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL DEFAULT 'pending' COMMENT 'pending|paid|failed|expired',
  `payment_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'SePay checkout URL if applicable',
  `raw_webhook_payload` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT 'Full JSON from IPN for audit',
  `sepay_order_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'SePay internal order ID from IPN',
  `transaction_id` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT 'SePay transaction ID from IPN',
  `paid_at` timestamp NULL DEFAULT NULL,
  `expired_at` timestamp NOT NULL COMMENT 'Auto-set to created_at + 15 min',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `payment_code` (`payment_code`) USING BTREE,
  UNIQUE KEY `invoice_number` (`invoice_number`) USING BTREE,
  KEY `idx_payment_code` (`payment_code`) USING BTREE,
  KEY `idx_invoice_number` (`invoice_number`) USING BTREE,
  KEY `idx_order_id` (`order_id`) USING BTREE,
  KEY `idx_status` (`status`) USING BTREE,
  CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=88 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payments`
--

LOCK TABLES `payments` WRITE;
/*!40000 ALTER TABLE `payments` DISABLE KEYS */;
INSERT INTO `payments` VALUES (67,122,'PAY-26981458','FM-122-1780409663429','sepay',45900.00,'paid',NULL,'{\"timestamp\":1780409686,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"5ef2df14-5e8d-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A1EE52534420\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"45900.00\",\"order_invoice_number\":\"FM-122-1780409663429\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/147.0.0.0 Safari\\/537.36\",\"ip_address\":\"2001:ee0:50e4:59e0:5191:f551:fe21:3d64\",\"order_description\":\"Thanh toan don hang Farmily #122\"},\"transaction\":{\"id\":\"7c75363e-5e8d-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a1ee556b0b88\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-02 21:14:46\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"45900\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A1EE52534420','6a1ee556b0b88','2026-06-02 14:15:19','2026-06-02 14:29:23','2026-06-02 14:14:23','2026-06-02 14:15:19'),(68,125,'PAY-BC310EC7','FM-125-1780422336203','sepay',85500.00,'paid',NULL,'{\"timestamp\":1780422310,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"dedaa896-5eaa-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A1F16A30D7C4\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"85500.00\",\"order_invoice_number\":\"FM-125-1780422336203\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (Linux; Android 10; K) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/145.0.0.0 Mobile Safari\\/537.36\",\"ip_address\":\"113.23.25.248\",\"order_description\":\"Thanh toan don hang Farmily #125\"},\"transaction\":{\"id\":\"e1156325-5eaa-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a1f16a6c2cb6\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-03 00:45:10\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"85500\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A1F16A30D7C4','6a1f16a6c2cb6','2026-06-02 17:45:44','2026-06-02 18:00:36','2026-06-02 17:45:36','2026-06-02 17:45:44'),(69,126,'PAY-0DA1FA7F','FM-126-1780422873266','sepay',85500.00,'paid',NULL,'{\"timestamp\":1780422874,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"2f89cd1e-5eac-11f1-b21a-a6006ab65aca\",\"order_id\":\"SP-TEST-CTB8A989-6A1F18BB38144\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"85500.00\",\"order_invoice_number\":\"FM-126-1780422873266\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (X11; Linux x86_64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/145.0.0.0 Safari\\/537.36\",\"ip_address\":\"113.23.25.248\",\"order_description\":\"Thanh toan don hang Farmily #126\"},\"transaction\":{\"id\":\"2f8b5840-5eac-11f1-b21a-a6006ab65aca\",\"payment_method\":\"CARD\",\"transaction_id\":\"trans-6a1f18d7deb5c\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-03 07:54:31\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"85500\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":\"000000xxxxxx0000\",\"card_holder_name\":\"TTATTTNA\",\"card_expiry\":\"1126\",\"card_funding_method\":\"CREDIT\",\"card_brand\":\"UNKNOWN\"},\"customer\":null,\"agreement\":null}','SP-TEST-CTB8A989-6A1F18BB38144','trans-6a1f18d7deb5c','2026-06-02 17:55:07','2026-06-02 18:09:33','2026-06-02 17:54:33','2026-06-02 17:55:07'),(70,135,'PAY-A18C443D','FM-135-1780596683954','sepay',147200.00,'expired',NULL,NULL,NULL,NULL,NULL,'2026-06-05 01:26:24','2026-06-04 18:11:23','2026-06-04 18:24:04'),(71,135,'PAY-4321DEF3','FM-135-1780597444021','sepay',147200.00,'expired',NULL,NULL,NULL,NULL,NULL,'2026-06-05 01:39:04','2026-06-04 18:24:04','2026-06-04 18:25:35'),(72,135,'PAY-6C71718E','FM-135-1780597535494','sepay',147200.00,'paid',NULL,'{\"timestamp\":1780597505,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"c8975b08-6042-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A21C2FE3FDA7\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"147200.00\",\"order_invoice_number\":\"FM-135-1780597535494\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (X11; Linux x86_64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/145.0.0.0 Safari\\/537.36\",\"ip_address\":\"113.23.25.248\",\"order_description\":\"Thanh toan don hang Farmily #135\"},\"transaction\":{\"id\":\"ca83df6f-6042-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a21c301789b6\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-05 01:25:05\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"147200\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A21C2FE3FDA7','6a21c301789b6','2026-06-04 18:25:41','2026-06-05 01:40:35','2026-06-04 18:25:35','2026-06-04 18:25:41'),(73,140,'PAY-8D3E92D6','FM-140-1781165460770','sepay',173500.00,'paid',NULL,'{\"timestamp\":1781165427,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"182c34f6-656d-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A2A6D6F97ABC\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"173500.00\",\"order_invoice_number\":\"FM-140-1781165460770\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (Linux; Android 10; K) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/147.0.0.0 Mobile Safari\\/537.36\",\"ip_address\":\"118.71.93.183\",\"order_description\":\"Thanh toan don hang Farmily #140\"},\"transaction\":{\"id\":\"1a8351b3-656d-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a2a6d7386396\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-11 15:10:27\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"173500\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A2A6D6F97ABC','6a2a6d7386396','2026-06-11 08:11:09','2026-06-11 08:26:01','2026-06-11 08:11:00','2026-06-11 08:11:09'),(74,143,'PAY-DB41AEC8','FM-143-1781277559969','sepay',715000.00,'paid',NULL,'{\"timestamp\":1781277544,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"1fc07237-6672-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A2C235D9B58A\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"715000.00\",\"order_invoice_number\":\"FM-143-1781277559969\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (X11; Linux x86_64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/145.0.0.0 Safari\\/537.36\",\"ip_address\":\"2402:800:6312:62ea:9868:3477:5e97:4062\",\"order_description\":\"Thanh toan don hang Farmily #143\"},\"transaction\":{\"id\":\"26458852-6672-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a2c23688c784\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-12 22:19:04\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"715000\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A2C235D9B58A','6a2c23688c784','2026-06-12 15:19:48','2026-06-12 15:34:20','2026-06-12 15:19:19','2026-06-12 15:19:48'),(75,153,'PAY-290CB7DD','FM-153-1781590096725','sepay',145820.00,'expired',NULL,NULL,NULL,NULL,NULL,'2026-06-16 06:23:17','2026-06-16 06:08:16','2026-06-16 06:09:15'),(76,153,'PAY-ADB833AE','FM-153-1781590155800','sepay',145820.00,'expired',NULL,NULL,NULL,NULL,NULL,'2026-06-16 06:24:16','2026-06-16 06:09:15','2026-06-16 06:09:34'),(77,153,'PAY-B3E30B08','FM-153-1781590174047','sepay',145820.00,'paid',NULL,'{\"timestamp\":1781590139,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"f6a232b0-6949-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A30E8767BC54\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"145820.00\",\"order_invoice_number\":\"FM-153-1781590174047\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/149.0.0.0 Safari\\/537.36\",\"ip_address\":\"171.243.49.170\",\"order_description\":\"Thanh toan don hang Farmily #153\"},\"transaction\":{\"id\":\"f9d5598e-6949-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a30e87bd642e\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-16 13:08:59\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"145820\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A30E8767BC54','6a30e87bd642e','2026-06-16 06:09:47','2026-06-16 06:24:34','2026-06-16 06:09:34','2026-06-16 06:09:47'),(78,154,'PAY-BC0FAC01','FM-154-1781590591511','sepay',552500.00,'paid',NULL,'{\"timestamp\":1781590550,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"ecea127f-694a-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A30EA13A99F5\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"552500.00\",\"order_invoice_number\":\"FM-154-1781590591511\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (X11; Linux x86_64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/145.0.0.0 Safari\\/537.36\",\"ip_address\":\"14.191.95.190\",\"order_description\":\"Thanh toan don hang Farmily #154\"},\"transaction\":{\"id\":\"eed4e999-694a-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a30ea16dec3b\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-16 13:15:50\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"552500\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A30EA13A99F5','6a30ea16dec3b','2026-06-16 06:16:38','2026-06-16 06:31:32','2026-06-16 06:16:31','2026-06-16 06:16:38'),(79,157,'PAY-B24D5A0A','FM-157-1781592679850','sepay',48900.00,'pending',NULL,NULL,NULL,NULL,NULL,'2026-06-16 07:06:20','2026-06-16 06:51:19','2026-06-16 06:51:19'),(80,159,'PAY-F49C674F','FM-159-1781594475740','sepay',100500.00,'paid',NULL,'{\"timestamp\":1781594435,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"f816f1a2-6953-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A30F93FD4213\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"100500.00\",\"order_invoice_number\":\"FM-159-1781594475740\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (X11; Linux x86_64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/145.0.0.0 Safari\\/537.36\",\"ip_address\":\"14.191.216.3\",\"order_description\":\"Thanh toan don hang Farmily #159\"},\"transaction\":{\"id\":\"f9f2007d-6953-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a30f942eff16\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-16 14:20:34\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"100500\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A30F93FD4213','6a30f942eff16','2026-06-16 07:21:22','2026-06-16 07:36:16','2026-06-16 07:21:15','2026-06-16 07:21:22'),(81,160,'PAY-E655DD3F','FM-160-1781594990318','sepay',90470.00,'paid',NULL,'{\"timestamp\":1781594950,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"2ae9b6cf-6955-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A30FB4298E0E\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"90470.00\",\"order_invoice_number\":\"FM-160-1781594990318\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (X11; Linux x86_64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/145.0.0.0 Safari\\/537.36\",\"ip_address\":\"14.191.216.3\",\"order_description\":\"Thanh toan don hang Farmily #160\"},\"transaction\":{\"id\":\"2d0b284b-6955-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a30fb46314b2\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-16 14:29:10\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"90470\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A30FB4298E0E','6a30fb46314b2','2026-06-16 07:29:57','2026-06-16 07:44:50','2026-06-16 07:29:50','2026-06-16 07:29:57'),(82,162,'PAY-DA1131C2','FM-162-1781596389942','sepay',78300.00,'expired',NULL,NULL,NULL,NULL,NULL,'2026-06-16 08:08:10','2026-06-16 07:53:09','2026-06-16 08:03:12'),(83,162,'PAY-08712253','FM-162-1781596992427','sepay',78300.00,'paid',NULL,'{\"timestamp\":1781596951,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"d3b5b511-6959-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A310313BF181\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"78300.00\",\"order_invoice_number\":\"FM-162-1781596992427\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/147.0.0.0 Safari\\/537.36\",\"ip_address\":\"203.113.146.152\",\"order_description\":\"Thanh toan don hang Farmily #162\"},\"transaction\":{\"id\":\"d5e86db2-6959-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a31031773573\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-16 15:02:31\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"78300\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A310313BF181','6a31031773573','2026-06-16 08:03:19','2026-06-16 08:18:12','2026-06-16 08:03:12','2026-06-16 08:03:19'),(84,163,'PAY-12EB3D44','FM-163-1781600169538','sepay',75500.00,'paid',NULL,'{\"timestamp\":1781600131,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"39b05ba0-6961-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A310F7D4CB74\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"75500.00\",\"order_invoice_number\":\"FM-163-1781600169538\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/147.0.0.0 Safari\\/537.36\",\"ip_address\":\"125.235.126.171\",\"order_description\":\"Thanh toan don hang Farmily #163\"},\"transaction\":{\"id\":\"3d31a18a-6961-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a310f832ffc9\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-16 15:55:31\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"75500\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A310F7D4CB74','6a310f832ffc9','2026-06-16 08:56:18','2026-06-16 09:11:10','2026-06-16 08:56:09','2026-06-16 08:56:18'),(85,164,'PAY-DFB14579','FM-164-1781600573542','sepay',163500.00,'paid',NULL,'{\"timestamp\":1781600538,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"2d2951e2-6962-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A311115C0A84\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"163500.00\",\"order_invoice_number\":\"FM-164-1781600573542\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit\\/537.36 (KHTML, like Gecko) Chrome\\/147.0.0.0 Safari\\/537.36\",\"ip_address\":\"125.235.126.171\",\"order_description\":\"Thanh toan don hang Farmily #164\"},\"transaction\":{\"id\":\"2ff75715-6962-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a31111a791df\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-16 16:02:18\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"163500\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A311115C0A84','6a31111a791df','2026-06-16 09:03:05','2026-06-16 09:17:54','2026-06-16 09:02:53','2026-06-16 09:03:05'),(86,166,'PAY-FDDBA81F','FM-166-1781694346359','sepay',96500.00,'paid',NULL,'{\"timestamp\":1781694339,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"80e80624-6a3c-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A327F5F6EDB9\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"96500.00\",\"order_invoice_number\":\"FM-166-1781694346359\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 26_2_0 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) CriOS\\/149.0.7827.137 Mobile\\/15E148 Safari\\/604.1\",\"ip_address\":\"171.243.48.204\",\"order_description\":\"Thanh toan don hang Farmily #166\"},\"transaction\":{\"id\":\"967209df-6a3c-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a327f8390315\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-17 18:05:39\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"96500\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A327F5F6EDB9','6a327f8390315','2026-06-17 11:06:28','2026-06-17 11:20:46','2026-06-17 11:05:46','2026-06-17 11:06:28'),(87,167,'PAY-F42D850F','FM-167-1781801329805','sepay',103500.00,'paid',NULL,'{\"timestamp\":1781801288,\"notification_type\":\"ORDER_PAID\",\"order\":{\"id\":\"970f986e-6b35-11f1-b21a-a6006ab65aca\",\"order_id\":\"PAY41636A34214404BB9\",\"order_status\":\"CAPTURED\",\"order_currency\":\"VND\",\"order_amount\":\"103500.00\",\"order_invoice_number\":\"FM-167-1781801329805\",\"custom_data\":[],\"user_agent\":\"Mozilla\\/5.0 (iPhone; CPU iPhone OS 26_2_0 like Mac OS X) AppleWebKit\\/605.1.15 (KHTML, like Gecko) CriOS\\/149.0.7827.137 Mobile\\/15E148 Safari\\/604.1\",\"ip_address\":\"27.64.68.124\",\"order_description\":\"Thanh toan don hang Farmily #167\"},\"transaction\":{\"id\":\"99d00b83-6b35-11f1-b21a-a6006ab65aca\",\"payment_method\":\"BANK_TRANSFER\",\"transaction_id\":\"6a3421489c227\",\"transaction_type\":\"PAYMENT\",\"transaction_date\":\"2026-06-18 23:48:08\",\"transaction_status\":\"APPROVED\",\"transaction_amount\":\"103500\",\"transaction_currency\":\"VND\",\"authentication_status\":\"AUTHENTICATION_SUCCESSFUL\",\"card_number\":null,\"card_holder_name\":null,\"card_expiry\":null,\"card_funding_method\":null,\"card_brand\":null},\"customer\":null,\"agreement\":null}','PAY41636A34214404BB9','6a3421489c227','2026-06-18 16:48:58','2026-06-18 17:03:50','2026-06-18 16:48:49','2026-06-18 16:48:58');
/*!40000 ALTER TABLE `payments` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_images`
--

DROP TABLE IF EXISTS `product_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `image_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_product_id` (`product_id`) USING BTREE,
  CONSTRAINT `product_images_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_images`
--

LOCK TABLES `product_images` WRITE;
/*!40000 ALTER TABLE `product_images` DISABLE KEYS */;
INSERT INTO `product_images` VALUES (1,1,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/z6346987865307-297095747a1d2b1fcf68372c106f4cc0-1740398265677.jpg?v=1740398294953','2025-12-31 16:36:48'),(2,2,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690553515908.jpg?v=1740143514633','2025-12-31 16:36:48'),(3,3,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1692162651001.jpg?v=1692162656573','2025-12-31 16:36:48'),(4,4,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/cai-thao-kim-chi-1739353784015.jpg?v=1739353790407','2025-12-31 16:36:48'),(5,5,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690554439245.jpg?v=1690554445830','2025-12-31 16:36:48'),(6,6,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/2-1690537666497.jpg?v=1739509428623','2025-12-31 16:36:48'),(7,7,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690540159213.jpg?v=1690540165033','2025-12-31 16:36:48'),(8,8,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690553851829.jpg?v=1740143360663','2025-12-31 16:36:48'),(9,9,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/khoai-lang-nhat-1739421199711.jpg?v=1739421239607','2025-12-31 16:36:48'),(10,10,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/khoai-lang-mat-ta-nung-da-lat-1739368840580.jpg?v=1739368895610','2025-12-31 16:36:48'),(11,11,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690211185997.jpg?v=1690211192007','2025-12-31 16:36:48'),(12,12,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690259660301.jpg?v=1690259668920','2025-12-31 16:36:48'),(13,13,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690536689905.jpg?v=1690536850987','2025-12-31 16:36:48'),(14,14,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690272904078.jpg?v=1690272910383','2025-12-31 16:36:48'),(15,15,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/thom-khom-1739454807453.jpg?v=1739454823637','2025-12-31 16:36:48'),(16,16,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/qua-chanh-vang-1740037565547.jpg?v=1740037619670','2025-12-31 16:36:48'),(17,17,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/ot-chuong-vang-1739435987860.jpg?v=1739436018647','2025-12-31 16:36:48'),(18,18,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/cai-xoan-kale-1739425744522.jpg?v=1739425775620','2025-12-31 16:36:48'),(19,19,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/ot-chuong-xanh-1739436028398.jpg?v=1739436050623','2025-12-31 16:36:48'),(20,20,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/ca-rot-cuong-xanh-1739366385947.jpg?v=1739366419620','2025-12-31 16:36:48'),(21,21,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690470920960.jpg?v=1690470926757','2025-12-31 16:36:48'),(22,22,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689950915311.jpg?v=1689950922093','2025-12-31 16:36:48'),(23,23,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690214302980.jpg?v=1690214308777','2025-12-31 16:36:48'),(24,24,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/ot-chuong-do-1739435914613.jpg?v=1739435974637','2025-12-31 16:36:48'),(25,25,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690553253058.jpg?v=1690553261593','2025-12-31 16:36:48'),(26,26,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690469210087.jpg?v=1690469464527','2025-12-31 16:36:48'),(27,27,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/3-1739442902117.jpg?v=1739442978617','2025-12-31 16:36:48'),(28,28,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/ot-chuong-3-mau-1739436071542.jpg?v=1739436107793','2025-12-31 16:36:48'),(29,29,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690272861148.jpg?v=1690272867163','2025-12-31 16:36:48'),(30,30,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/can-tay-da-lat-1739425911968.jpg?v=1739425958670','2025-12-31 16:36:48'),(31,31,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689951737597.jpg?v=1689951744033','2025-12-31 16:36:48'),(32,32,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689951639639.jpg?v=1689951646383','2025-12-31 16:36:48'),(33,33,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689949773113.jpg?v=1689949779523','2025-12-31 16:36:48'),(34,34,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689950856946.jpg?v=1689950863210','2025-12-31 16:36:48'),(35,35,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689949231266.jpg?v=1689949237653','2025-12-31 16:36:48'),(36,36,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/bap-my-1739365528524.jpg?v=1739365546623','2025-12-31 16:36:48'),(37,37,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689950666958.jpg?v=1689950672197','2025-12-31 16:36:48'),(38,38,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689951530159.jpg?v=1689951535917','2025-12-31 16:36:48'),(39,39,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689949909734.jpg?v=1689949915700','2025-12-31 16:36:48'),(40,40,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689952203212.jpg?v=1689952210220','2025-12-31 16:36:48'),(41,41,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/4-1739444633204.jpg?v=1739444715640','2025-12-31 16:36:48'),(42,42,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689950803403.jpg?v=1689950810280','2025-12-31 16:36:48'),(43,43,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1739442681322.jpg?v=1739442702673','2025-12-31 16:36:48'),(44,44,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689949700589.jpg?v=1689949708837','2025-12-31 16:36:48'),(45,45,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689952852965.jpg?v=1689952858467','2025-12-31 16:36:48'),(46,46,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689951918929.jpg?v=1689951926670','2025-12-31 16:36:48'),(47,47,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689952260184.jpg?v=1689952268570','2025-12-31 16:36:48'),(48,48,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690765769461.jpg?v=1690765776260','2025-12-31 16:36:48'),(49,49,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1689949492180.jpg?v=1689949498403','2025-12-31 16:36:48'),(50,50,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690554303534.jpg?v=1740143279647','2025-12-31 16:36:48'),(51,51,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690553987321.jpg?v=1690553993380','2025-12-31 16:36:48'),(52,52,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690553796005.jpg?v=1690553801757','2025-12-31 16:36:48'),(53,53,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/2-1690539915238.jpg?v=1739509310633','2025-12-31 16:36:48'),(54,54,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690552048150.jpg?v=1690552055453','2025-12-31 16:36:48'),(55,55,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/3-1690539989518.jpg?v=1690539995403','2025-12-31 16:36:48'),(56,56,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690552065476.jpg?v=1690552074263','2025-12-31 16:36:48'),(57,57,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690556366432.jpg?v=1690556372220','2025-12-31 16:36:48'),(58,58,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690536532201.jpg?v=1690536801957','2025-12-31 16:36:48'),(59,59,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/7fc0f7c3-1b39-4fb3-9bd3-3e6f6a682731.jpg?v=1630325150033','2025-12-31 16:36:48'),(60,60,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690536764060.jpg?v=1739510297070','2025-12-31 16:36:48'),(61,61,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690537465934.jpg?v=1690537472577','2025-12-31 16:36:48'),(62,62,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690552084378.jpg?v=1690552090870','2025-12-31 16:36:48'),(63,63,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/dd7dbbe9-da89-4024-bff5-e4c5849ccb71.jpg?v=1630325138310','2025-12-31 16:36:48'),(64,64,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/cai-thao-1739353608261.jpg?v=1739353633653','2025-12-31 16:36:48'),(65,65,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690554212948.jpg?v=1740143319623','2025-12-31 16:36:48'),(66,66,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690536982035.jpg?v=1740143775647','2025-12-31 16:36:48'),(67,67,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/bap-cai-mem-1740040162109.jpg?v=1740040214717','2025-12-31 16:36:48'),(68,68,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690537599103.jpg?v=1690537605363','2025-12-31 16:36:48'),(69,69,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690537417225.jpg?v=1690537423243','2025-12-31 16:36:48'),(70,70,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/2-1690553657196.jpg?v=1739509162630','2025-12-31 16:36:48'),(71,71,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690536564842.jpg?v=1690536808803','2025-12-31 16:36:48'),(72,72,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690539895563.jpg?v=1690539901517','2025-12-31 16:36:48'),(73,73,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690537525761.jpg?v=1690537531487','2025-12-31 16:36:48'),(74,74,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690536307195.jpg?v=1690536434897','2025-12-31 16:36:48'),(75,75,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/cai-ngong-1739516058632.jpg?v=1740143838653','2025-12-31 16:36:48'),(76,76,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/5743c7a2-a32f-4eb4-a001-f57b49123a48.jpg?v=1635415130207','2025-12-31 16:36:48'),(77,77,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690552103108.jpg?v=1690552110180','2025-12-31 16:36:48'),(78,78,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/3-1690539819055.jpg?v=1739516279620','2025-12-31 16:36:48'),(79,79,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/cai-be-xanh-da-lat-1740039328494.jpg?v=1740039370857','2025-12-31 16:36:48'),(80,80,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690554099900.jpg?v=1690554107800','2025-12-31 16:36:48'),(81,81,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/bap-cai-trai-tim-1739354002154.jpg?v=1739354036617','2025-12-31 16:36:48'),(82,82,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/gia-mam-1739426988255.jpg?v=1739427046703','2025-12-31 16:36:48'),(83,83,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/hat-tieu-den-1739427414127.jpg?v=1739427428647','2025-12-31 16:36:48'),(84,84,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/rau-rung-tay-ninh-1740200363911.jpg?v=1740200423643','2025-12-31 16:36:48'),(85,85,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690272788232.jpg?v=1690272795210','2025-12-31 16:36:48'),(86,86,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690273010824.jpg?v=1690273017510','2025-12-31 16:36:48'),(87,87,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690272837583.jpg?v=1690272844897','2025-12-31 16:36:48'),(88,88,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/rau-rung-gia-lai-1740200467248.jpg?v=1740200490720','2025-12-31 16:36:48'),(89,89,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690272881935.jpg?v=1690272888690','2025-12-31 16:36:48'),(90,90,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/2-1690347681400.jpg?v=1739501712717','2025-12-31 16:36:48'),(91,91,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690797060752.jpg?v=1706106833833','2025-12-31 16:36:48'),(92,92,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690731413628.jpg?v=1690731419617','2025-12-31 16:36:48'),(93,93,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690731510580.jpg?v=1690731517590','2025-12-31 16:36:49'),(94,94,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/2-1690795235293.jpg?v=1739589223630','2025-12-31 16:36:49'),(95,95,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690731548314.jpg?v=1690731556767','2025-12-31 16:36:49'),(96,96,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690704999977.jpg?v=1690705006527','2025-12-31 16:36:49'),(97,97,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/ca-chua-beef-1739453687771.jpg?v=1739453774633','2025-12-31 16:36:49'),(98,98,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690706495385.jpg?v=1690706500453','2025-12-31 16:36:49'),(99,99,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690704962916.jpg?v=1690704968497','2025-12-31 16:36:49'),(100,100,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/5-1739444873416.jpg?v=1739444930603','2025-12-31 16:36:49'),(101,101,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690705192100.jpg?v=1690705199347','2025-12-31 16:36:49'),(102,102,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690706294574.jpg?v=1690706301737','2025-12-31 16:36:49'),(103,103,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/ot-chuong-baby-1739435644565.jpg?v=1739435683630','2025-12-31 16:36:49'),(104,104,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690955655909.jpg?v=1690955662707','2025-12-31 16:36:49'),(105,105,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/bong-lo-xanh-1739425314609.jpg?v=1739425353667','2025-12-31 16:36:49'),(106,106,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/bong-lo-baby-1739425485668.jpg?v=1739425520630','2025-12-31 16:36:49'),(107,107,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/bong-cai-trang-1739424897920.jpg?v=1739424949633','2025-12-31 16:36:49'),(108,108,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690955754842.jpg?v=1690955760597','2025-12-31 16:36:49'),(109,109,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690470696665.jpg?v=1690470702257','2025-12-31 16:36:49'),(110,110,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/ca-rot-baby-1739366249739.jpg?v=1739366276620','2025-12-31 16:36:49'),(111,111,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/460f5336-682d-4f36-87ba-8f70065565ad.jpg?v=1632059033233','2025-12-31 16:36:49'),(112,112,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690468993237.jpg?v=1690469381290','2025-12-31 16:36:49'),(113,113,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690470350774.jpg?v=1690470357387','2025-12-31 16:36:49'),(114,114,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690470831551.jpg?v=1690470838140','2025-12-31 16:36:49'),(115,115,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/82ade6fa-e381-4f17-bfdb-2070f41500d2.jpg?v=1632058958307','2025-12-31 16:36:49'),(116,116,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690470435758.jpg?v=1690470442183','2025-12-31 16:36:49'),(117,117,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690470248564.jpg?v=1690470254410','2025-12-31 16:36:49'),(118,118,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/cu-cai-1739367608199.jpg?v=1739367644623','2025-12-31 16:36:49'),(119,119,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690469786809.jpg?v=1690469793280','2025-12-31 16:36:49'),(120,120,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/cu-cai-duong-1739367385158.jpg?v=1739367479607','2025-12-31 16:36:49'),(121,121,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/khoai-mon-sap-1739421440360.jpg?v=1739421498640','2025-12-31 16:36:49'),(122,122,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/cu-san-1739426270795.jpg?v=1739426303630','2025-12-31 16:36:49'),(123,123,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690469733358.jpg?v=1690469739260','2025-12-31 16:36:49'),(124,124,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/khoai-mo-tim-1740038664403.jpg?v=1740038681633','2025-12-31 16:36:49'),(125,125,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/su-hao-1739421962171.jpg?v=1739422031620','2025-12-31 16:36:49'),(126,126,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690255952753.jpg?v=1690255959570','2025-12-31 16:36:49'),(127,127,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/hat-tieu-xanh-1739427254138.jpg?v=1739427298663','2025-12-31 16:36:49'),(128,128,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/14-1690200324637.jpg?v=1690200330083','2025-12-31 16:36:49'),(129,129,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690200687510.jpg?v=1690200695617','2025-12-31 16:36:49'),(130,130,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690259876514.jpg?v=1690259882767','2025-12-31 16:36:49'),(131,131,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690272811875.jpg?v=1690272817857','2025-12-31 16:36:49'),(132,132,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690202031810.jpg?v=1690202039267','2025-12-31 16:36:49'),(133,133,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690256064625.jpg?v=1690256073663','2025-12-31 16:36:49'),(134,134,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690200424121.jpg?v=1690200429657','2025-12-31 16:36:49'),(135,135,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690258734548.jpg?v=1690258740877','2025-12-31 16:36:49'),(136,136,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690201435107.jpg?v=1690201442980','2025-12-31 16:36:49'),(137,137,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690201385474.jpg?v=1690201392023','2025-12-31 16:36:49'),(138,138,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690257173357.jpg?v=1690257184010','2025-12-31 16:36:49'),(139,139,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/rau-nem-om-gai-1739518435674.jpg?v=1739518467707','2025-12-31 16:36:49'),(140,140,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690214246524.jpg?v=1690214253130','2025-12-31 16:36:49'),(141,141,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690347593795.jpg?v=1690347620810','2025-12-31 16:36:49'),(142,142,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690211239265.jpg?v=1690211246190','2025-12-31 16:36:49'),(143,143,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/2-1690257207685.jpg?v=1739500996973','2025-12-31 16:36:49'),(144,144,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690200472564.jpg?v=1690200478277','2025-12-31 16:36:49'),(145,145,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/2-1690259626468.jpg?v=1739501630917','2025-12-31 16:36:49'),(146,146,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690202057149.jpg?v=1690202062907','2025-12-31 16:36:49'),(147,147,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690200550995.jpg?v=1690200557167','2025-12-31 16:36:49'),(148,148,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690211210957.jpg?v=1690211217237','2025-12-31 16:36:49'),(149,149,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/2-1690257150643.jpg?v=1739501378837','2025-12-31 16:36:49'),(150,150,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690254907374.jpg?v=1690254912657','2025-12-31 16:36:49'),(151,151,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690256107814.jpg?v=1690256114607','2025-12-31 16:36:49'),(152,152,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690214366059.jpg?v=1690214372253','2025-12-31 16:36:49'),(153,153,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690256048776.jpg?v=1690256054047','2025-12-31 16:36:49'),(154,154,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690213937350.jpg?v=1690213943477','2025-12-31 16:36:49'),(155,155,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/2-1690259855578.jpg?v=1739518037640','2025-12-31 16:36:49'),(156,156,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/hat-tieu-den-xay-1739427464165.jpg?v=1739427491650','2025-12-31 16:36:49'),(157,157,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690203751265.jpg?v=1690203756953','2025-12-31 16:36:49'),(158,158,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/cu-hanh-tay-tim-1740037713030.jpg?v=1740038879697','2025-12-31 16:36:49'),(159,159,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/san-pham-moi-2-1740202513564.jpg?v=1740202564687','2025-12-31 16:36:49'),(160,160,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/bi-dao-xanh-1739350666962.jpg?v=1739350918827','2025-12-31 16:36:49'),(161,161,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690797142867.jpg?v=1706106820760','2025-12-31 16:36:49'),(162,162,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690796390967.jpg?v=1706106877670','2025-12-31 16:36:49'),(163,163,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690796621762.jpg?v=1690796629377','2025-12-31 16:36:49'),(164,164,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/87965548-8a82-4a53-8383-ba07b3e32d41.jpg?v=1630325222390','2025-12-31 16:36:49'),(165,165,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/27011c42-4fbf-4852-abea-1eefe87a4d2f.jpg?v=1630325226013','2025-12-31 16:36:49'),(166,166,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690796712521.jpg?v=1690796718513','2025-12-31 16:36:49'),(167,167,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/6a9a0a8a-d094-4a6f-a2d3-bd16818b76d6.jpg?v=1635412329190','2025-12-31 16:36:49'),(168,168,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690796820490.jpg?v=1690796826687','2025-12-31 16:36:49'),(169,169,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690795176025.jpg?v=1690795181087','2025-12-31 16:36:49'),(170,170,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/7-1739445802708.jpg?v=1739445832650','2025-12-31 16:36:49'),(171,171,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/bi-ngoi-xanh-1740405237958.jpg?v=1740405296870','2025-12-31 16:36:49'),(172,172,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690795208041.jpg?v=1690795214580','2025-12-31 16:36:49'),(173,173,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690796950348.jpg?v=1706106863647','2025-12-31 16:36:49'),(174,174,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690797013517.jpg?v=1706106845680','2025-12-31 16:36:49'),(175,175,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/8-1739445587081.jpg?v=1739445639637','2025-12-31 16:36:49'),(176,176,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690797286461.jpg?v=1706106796640','2025-12-31 16:36:49'),(177,177,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/dua-leo-1739368545072.jpg?v=1739368570627','2025-12-31 16:36:49'),(178,178,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/11-1739445363590.jpg?v=1739445377637','2025-12-31 16:36:49'),(179,179,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690795518601.jpg?v=1690896642323','2025-12-31 16:36:49'),(180,180,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/2-1690795501513.jpg?v=1739505816800','2025-12-31 16:36:49'),(181,181,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/dau-bap-1739426450119.jpg?v=1739426479630','2025-12-31 16:36:49'),(182,182,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690797226881.jpg?v=1706106808640','2025-12-31 16:36:49'),(183,183,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/bi-do-non-1739365968128.jpg?v=1739366044617','2025-12-31 16:36:49'),(184,184,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/1-1690796586296.jpg?v=1690796591527','2025-12-31 16:36:49'),(185,185,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/dau-cove-1739426551236.jpg?v=1739426582690','2025-12-31 16:36:49'),(186,186,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/su-su-1739436834930.jpg?v=1739437039627','2025-12-31 16:36:49'),(187,187,'https://bizweb.dktcdn.net/thumb/grande/100/435/899/products/fec3fe71-36dd-4703-863b-e59018ab00c7.jpg?v=1631006581353','2025-12-31 16:36:49'),(189,189,'https://www.vinmec.com/static/uploads/medium_20201118_142711_986247_rau_diep_ca_max_1800x1800_jpg_268f3b12ff.jpg','2026-03-29 01:33:23');
/*!40000 ALTER TABLE `product_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product_variants`
--

DROP TABLE IF EXISTS `product_variants`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product_variants` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `options_value` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `stock` int DEFAULT '0',
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `import_price` decimal(10,2) DEFAULT '0.00',
  `expiry_date` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_product_id` (`product_id`) USING BTREE,
  CONSTRAINT `product_variants_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=313 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product_variants`
--

LOCK TABLES `product_variants` WRITE;
/*!40000 ALTER TABLE `product_variants` DISABLE KEYS */;
INSERT INTO `product_variants` VALUES (1,1,'default',997,25000.00,'2025-12-31 16:36:48',0.00,NULL),(2,2,'300g',999,21000.00,'2025-12-31 16:36:48',0.00,NULL),(3,2,'1kg',999,41000.00,'2025-12-31 16:36:48',0.00,NULL),(4,3,'1 cây',999,29000.00,'2025-12-31 16:36:48',0.00,NULL),(5,3,'1kg',999,39000.00,'2025-12-31 16:36:48',0.00,NULL),(6,4,'default',999,39000.00,'2025-12-31 16:36:48',0.00,NULL),(7,5,'250g',999,25000.00,'2025-12-31 16:36:48',0.00,NULL),(8,5,'1kg',999,45000.00,'2025-12-31 16:36:48',0.00,NULL),(9,6,'300g',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(10,6,'1kg',999,32000.00,'2025-12-31 16:36:48',0.00,NULL),(11,7,'300g',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(12,7,'1kg',999,32000.00,'2025-12-31 16:36:48',0.00,NULL),(13,8,'300g',999,13000.00,'2025-12-31 16:36:48',0.00,NULL),(14,8,'1kg',999,33000.00,'2025-12-31 16:36:48',0.00,NULL),(15,9,'500g',998,30000.00,'2025-12-31 16:36:48',0.00,NULL),(16,10,'500g',999,35000.00,'2025-12-31 16:36:48',0.00,NULL),(17,11,'300g',997,9000.00,'2025-12-31 16:36:48',0.00,NULL),(18,11,'1kg',999,19000.00,'2025-12-31 16:36:48',0.00,NULL),(19,12,'50g',964,5500.00,'2025-12-31 16:36:48',0.00,NULL),(20,12,'1kg',985,55500.00,'2025-12-31 16:36:48',0.00,NULL),(21,13,'300g',999,20000.00,'2025-12-31 16:36:48',0.00,NULL),(22,13,'1kg',999,40000.00,'2025-12-31 16:36:48',0.00,NULL),(23,14,'100g',999,5500.00,'2025-12-31 16:36:48',0.00,NULL),(24,14,'1kg',999,55500.00,'2025-12-31 16:36:48',0.00,NULL),(25,15,'default',999,25000.00,'2025-12-31 16:36:48',0.00,NULL),(26,16,'160g',999,21000.00,'2025-12-31 16:36:48',0.00,NULL),(27,16,'1kg',999,41000.00,'2025-12-31 16:36:48',0.00,NULL),(28,17,'1kg',999,31500.00,'2025-12-31 16:36:48',0.00,NULL),(29,18,'300g',999,20000.00,'2025-12-31 16:36:48',0.00,NULL),(30,18,'1kg',999,20000.00,'2025-12-31 16:36:48',0.00,NULL),(31,19,'1kg',999,31500.00,'2025-12-31 16:36:48',0.00,NULL),(32,20,'400g',999,25000.00,'2025-12-31 16:36:48',0.00,NULL),(33,21,'400g',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(34,22,'1kg',999,39000.00,'2025-12-31 16:36:48',0.00,NULL),(35,22,'400g',999,39000.00,'2025-12-31 16:36:48',0.00,NULL),(36,23,'200g',999,7000.00,'2025-12-31 16:36:48',0.00,NULL),(37,23,'1kg',999,7000.00,'2025-12-31 16:36:48',0.00,NULL),(38,24,'1kg',999,31500.00,'2025-12-31 16:36:48',0.00,NULL),(39,25,'250g',999,27000.00,'2025-12-31 16:36:48',0.00,NULL),(40,25,'1kg',999,27000.00,'2025-12-31 16:36:48',0.00,NULL),(41,26,'400g',999,35000.00,'2025-12-31 16:36:48',0.00,NULL),(42,27,'1 kg',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(43,28,'default',999,51500.00,'2025-12-31 16:36:48',0.00,NULL),(44,29,'50g',999,5500.00,'2025-12-31 16:36:48',0.00,NULL),(45,29,'1kg',999,5500.00,'2025-12-31 16:36:48',0.00,NULL),(46,30,'1 cây',999,45000.00,'2025-12-31 16:36:48',0.00,NULL),(47,30,'2kg',999,45000.00,'2025-12-31 16:36:48',0.00,NULL),(48,31,'default',999,75000.00,'2025-12-31 16:36:48',0.00,NULL),(49,32,'default',999,75000.00,'2025-12-31 16:36:48',0.00,NULL),(50,33,'default',999,35000.00,'2025-12-31 16:36:48',0.00,NULL),(51,34,'default',999,17000.00,'2025-12-31 16:36:48',0.00,NULL),(52,35,'default',999,290000.00,'2025-12-31 16:36:48',0.00,NULL),(53,36,'default',999,17000.00,'2025-12-31 16:36:48',0.00,NULL),(54,37,'400g',999,17500.00,'2025-12-31 16:36:48',0.00,NULL),(55,37,'1kg',999,17500.00,'2025-12-31 16:36:48',0.00,NULL),(56,38,'default',999,55000.00,'2025-12-31 16:36:48',0.00,NULL),(57,39,'default',999,35000.00,'2025-12-31 16:36:48',0.00,NULL),(58,40,'default',999,35000.00,'2025-12-31 16:36:48',0.00,NULL),(59,41,'default',999,21000.00,'2025-12-31 16:36:48',0.00,NULL),(60,42,'default',999,19000.00,'2025-12-31 16:36:48',0.00,NULL),(61,43,'default',999,25000.00,'2025-12-31 16:36:48',0.00,NULL),(62,44,'default',999,19000.00,'2025-12-31 16:36:48',0.00,NULL),(63,45,'default',999,130000.00,'2025-12-31 16:36:48',0.00,NULL),(64,46,'300g',999,36000.00,'2025-12-31 16:36:48',0.00,NULL),(65,46,'1kg',999,36000.00,'2025-12-31 16:36:48',0.00,NULL),(66,47,'default',999,35000.00,'2025-12-31 16:36:48',0.00,NULL),(67,48,'500g',985,15000.00,'2025-12-31 16:36:48',0.00,NULL),(68,48,'1kg',978,15000.00,'2025-12-31 16:36:48',0.00,NULL),(69,49,'default',999,85000.00,'2025-12-31 16:36:48',0.00,NULL),(70,50,'1 gói',999,17000.00,'2025-12-31 16:36:48',0.00,NULL),(71,50,'1kg',999,17000.00,'2025-12-31 16:36:48',0.00,NULL),(72,51,'300g',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(73,51,'1kg',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(74,52,'300g',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(75,52,'1kg',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(76,53,'300g',999,20000.00,'2025-12-31 16:36:48',0.00,NULL),(77,53,'1kg',999,20000.00,'2025-12-31 16:36:48',0.00,NULL),(78,54,'250g',999,21000.00,'2025-12-31 16:36:48',0.00,NULL),(79,54,'1kg',999,21000.00,'2025-12-31 16:36:48',0.00,NULL),(80,55,'1 cây',999,29400.00,'2025-12-31 16:36:48',0.00,NULL),(81,55,'1kg',999,29400.00,'2025-12-31 16:36:48',0.00,NULL),(82,56,'600g',999,21000.00,'2025-12-31 16:36:48',0.00,NULL),(83,56,'1kg',999,21000.00,'2025-12-31 16:36:48',0.00,NULL),(84,57,'300g',999,20000.00,'2025-12-31 16:36:48',0.00,NULL),(85,57,'1kg',999,20000.00,'2025-12-31 16:36:48',0.00,NULL),(86,58,'300g',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(87,58,'1kg',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(88,59,'300g',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(89,59,'1kg',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(90,60,'1kg',999,35000.00,'2025-12-31 16:36:48',0.00,NULL),(91,60,'250g',999,35000.00,'2025-12-31 16:36:48',0.00,NULL),(92,61,'default',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(93,62,'250gr',999,17000.00,'2025-12-31 16:36:48',0.00,NULL),(94,62,'1kg',999,17000.00,'2025-12-31 16:36:48',0.00,NULL),(95,63,'300g',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(96,63,'1kg',989,12000.00,'2025-12-31 16:36:48',0.00,NULL),(97,64,'1kg',999,27000.00,'2025-12-31 16:36:48',0.00,NULL),(98,64,'1 cây',999,27000.00,'2025-12-31 16:36:48',0.00,NULL),(99,65,'250g',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(100,65,'1kg',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(101,66,'300g',995,12000.00,'2025-12-31 16:36:48',0.00,NULL),(102,66,'1kg',995,12000.00,'2025-12-31 16:36:48',0.00,NULL),(103,67,'1kg',999,27000.00,'2025-12-31 16:36:48',0.00,NULL),(104,67,'1 cây',999,27000.00,'2025-12-31 16:36:48',0.00,NULL),(105,68,'300g',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(106,68,'1kg',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(107,69,'300g',999,18000.00,'2025-12-31 16:36:48',0.00,NULL),(108,69,'1kg',999,18000.00,'2025-12-31 16:36:48',0.00,NULL),(109,70,'500g',999,20000.00,'2025-12-31 16:36:48',0.00,NULL),(110,70,'1kg',999,20000.00,'2025-12-31 16:36:48',0.00,NULL),(111,71,'400g',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(112,71,'1kg',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(113,72,'300g',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(114,72,'1kg',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(115,73,'400g',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(116,73,'1kg',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(117,74,'300g',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(118,74,'1kg',989,12000.00,'2025-12-31 16:36:48',0.00,NULL),(119,75,'300g',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(120,75,'1kg',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(121,76,'200g',999,52500.00,'2025-12-31 16:36:48',0.00,NULL),(122,76,'1kg',999,52500.00,'2025-12-31 16:36:48',0.00,NULL),(123,77,'350g',999,17000.00,'2025-12-31 16:36:48',0.00,NULL),(124,77,'1kg',999,17000.00,'2025-12-31 16:36:48',0.00,NULL),(125,78,'300g',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(126,78,'1kg',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(127,79,'1 cây',999,19000.00,'2025-12-31 16:36:48',0.00,NULL),(128,79,'1kg',999,19000.00,'2025-12-31 16:36:48',0.00,NULL),(129,80,'default',999,12000.00,'2025-12-31 16:36:48',0.00,NULL),(130,81,'1kg',999,35000.00,'2025-12-31 16:36:48',0.00,NULL),(131,81,'1 cây',999,35000.00,'2025-12-31 16:36:48',0.00,NULL),(132,82,'default',999,7500.00,'2025-12-31 16:36:48',0.00,NULL),(133,83,'75g',999,10000.00,'2025-12-31 16:36:48',0.00,NULL),(134,83,'1kg',999,10000.00,'2025-12-31 16:36:48',0.00,NULL),(135,84,'1 gói',999,13000.00,'2025-12-31 16:36:48',0.00,NULL),(136,84,'1kg',999,13000.00,'2025-12-31 16:36:48',0.00,NULL),(137,85,'100g',999,5500.00,'2025-12-31 16:36:48',0.00,NULL),(138,85,'1kg',999,5500.00,'2025-12-31 16:36:48',0.00,NULL),(139,86,'100g',999,5000.00,'2025-12-31 16:36:48',0.00,NULL),(140,86,'1kg',999,5000.00,'2025-12-31 16:36:48',0.00,NULL),(141,87,'100g',999,8500.00,'2025-12-31 16:36:48',0.00,NULL),(142,87,'1kg',999,8500.00,'2025-12-31 16:36:48',0.00,NULL),(143,88,'1 gói',999,19000.00,'2025-12-31 16:36:48',0.00,NULL),(144,88,'1kg',999,19000.00,'2025-12-31 16:36:48',0.00,NULL),(145,89,'100g',999,5500.00,'2025-12-31 16:36:48',0.00,NULL),(146,89,'1kg',999,5500.00,'2025-12-31 16:36:48',0.00,NULL),(147,90,'default',999,15000.00,'2025-12-31 16:36:48',0.00,NULL),(148,91,'1kg',999,27000.00,'2025-12-31 16:36:48',0.00,NULL),(149,92,'250gr',999,13500.00,'2025-12-31 16:36:48',0.00,NULL),(150,92,'1kg',999,13500.00,'2025-12-31 16:36:48',0.00,NULL),(151,93,'default',999,17500.00,'2025-12-31 16:36:49',0.00,NULL),(152,94,'300g',999,18000.00,'2025-12-31 16:36:49',0.00,NULL),(153,94,'1kg',999,18000.00,'2025-12-31 16:36:49',0.00,NULL),(154,95,'200gr',999,9000.00,'2025-12-31 16:36:49',0.00,NULL),(155,95,'1kg',999,9000.00,'2025-12-31 16:36:49',0.00,NULL),(156,96,'500g',4,40000.00,'2025-12-31 16:36:49',30000.00,'2026-06-08 00:00:00'),(157,96,'1kg',7,80000.00,'2025-12-31 16:36:49',60000.00,'2026-06-08 00:00:00'),(158,97,'500gr',999,19500.00,'2025-12-31 16:36:49',0.00,NULL),(159,97,'1kg',999,19500.00,'2025-12-31 16:36:49',0.00,NULL),(160,98,'200g',999,35000.00,'2025-12-31 16:36:49',0.00,NULL),(161,98,'1kg',999,35000.00,'2025-12-31 16:36:49',0.00,NULL),(162,99,'250gr',999,17000.00,'2025-12-31 16:36:49',0.00,NULL),(163,99,'500gr',999,17000.00,'2025-12-31 16:36:49',0.00,NULL),(164,100,'500gr',999,15500.00,'2025-12-31 16:36:49',0.00,NULL),(165,100,'1kg',999,15500.00,'2025-12-31 16:36:49',0.00,NULL),(166,101,'250gr',999,13000.00,'2025-12-31 16:36:49',0.00,NULL),(167,101,'1kg',999,13000.00,'2025-12-31 16:36:49',0.00,NULL),(168,102,'170g',999,9500.00,'2025-12-31 16:36:49',0.00,NULL),(169,102,'1kg',999,9500.00,'2025-12-31 16:36:49',0.00,NULL),(170,103,'500g',999,21000.00,'2025-12-31 16:36:49',0.00,NULL),(171,103,'1kg',999,21000.00,'2025-12-31 16:36:49',0.00,NULL),(172,104,'270gr',999,32500.00,'2025-12-31 16:36:49',0.00,NULL),(173,104,'1kg',999,32500.00,'2025-12-31 16:36:49',0.00,NULL),(174,105,'800gr',999,27000.00,'2025-12-31 16:36:49',0.00,NULL),(175,105,'1kg',999,27000.00,'2025-12-31 16:36:49',0.00,NULL),(176,106,'500gr',999,29500.00,'2025-12-31 16:36:49',0.00,NULL),(177,106,'1kg',999,29500.00,'2025-12-31 16:36:49',0.00,NULL),(178,107,'450gr',997,37000.00,'2025-12-31 16:36:49',0.00,NULL),(179,107,'1kg',999,37000.00,'2025-12-31 16:36:49',0.00,NULL),(180,108,'450gr',992,145000.00,'2025-12-31 16:36:49',0.00,NULL),(181,108,'1kg',997,145000.00,'2025-12-31 16:36:49',0.00,NULL),(182,109,'500g',993,38000.00,'2025-12-31 16:36:49',0.00,NULL),(183,110,'175g',999,25000.00,'2025-12-31 16:36:49',0.00,NULL),(184,111,'500g',999,15000.00,'2025-12-31 16:36:49',0.00,NULL),(185,112,'500g',999,15000.00,'2025-12-31 16:36:49',0.00,NULL),(186,113,'600g',973,35000.00,'2025-12-31 16:36:49',0.00,NULL),(187,114,'500g',961,25000.00,'2025-12-31 16:36:49',0.00,NULL),(188,115,'500g',985,18000.00,'2025-12-31 16:36:49',0.00,NULL),(189,116,'400g',998,15000.00,'2025-12-31 16:36:49',0.00,NULL),(190,117,'200g',999,29000.00,'2025-12-31 16:36:49',0.00,NULL),(191,118,'default',999,20000.00,'2025-12-31 16:36:49',0.00,NULL),(192,119,'default',999,90000.00,'2025-12-31 16:36:49',0.00,NULL),(193,120,'175g',999,15000.00,'2025-12-31 16:36:49',0.00,NULL),(194,121,'600g',999,21000.00,'2025-12-31 16:36:49',0.00,NULL),(195,122,'500g',999,13000.00,'2025-12-31 16:36:49',0.00,NULL),(196,122,'1 kg',999,13000.00,'2025-12-31 16:36:49',0.00,NULL),(197,123,'400g',999,15000.00,'2025-12-31 16:36:49',0.00,NULL),(198,124,'default',999,24000.00,'2025-12-31 16:36:49',0.00,NULL),(199,125,'600g',999,25000.00,'2025-12-31 16:36:49',0.00,NULL),(200,126,'200g',999,11000.00,'2025-12-31 16:36:49',0.00,NULL),(201,126,'1kg',999,11000.00,'2025-12-31 16:36:49',0.00,NULL),(202,127,'50g',999,9000.00,'2025-12-31 16:36:49',0.00,NULL),(203,127,'1kg',999,9000.00,'2025-12-31 16:36:49',0.00,NULL),(204,128,'90g',999,9000.00,'2025-12-31 16:36:49',0.00,NULL),(205,128,'1kg',999,9000.00,'2025-12-31 16:36:49',0.00,NULL),(206,129,'90g',999,12000.00,'2025-12-31 16:36:49',0.00,NULL),(207,129,'1kg',999,12000.00,'2025-12-31 16:36:49',0.00,NULL),(208,130,'100g',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(209,130,'1kg',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(210,131,'50g',999,3000.00,'2025-12-31 16:36:49',0.00,NULL),(211,131,'1kg',999,3000.00,'2025-12-31 16:36:49',0.00,NULL),(212,132,'80gr',999,8000.00,'2025-12-31 16:36:49',0.00,NULL),(213,132,'1kg',999,8000.00,'2025-12-31 16:36:49',0.00,NULL),(214,133,'default',999,11500.00,'2025-12-31 16:36:49',0.00,NULL),(215,134,'150gr',999,6000.00,'2025-12-31 16:36:49',0.00,NULL),(216,134,'1kg',999,6000.00,'2025-12-31 16:36:49',0.00,NULL),(217,135,'100g',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(218,135,'1kg',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(219,136,'90g',999,8000.00,'2025-12-31 16:36:49',0.00,NULL),(220,136,'1kg',999,8000.00,'2025-12-31 16:36:49',0.00,NULL),(221,137,'200g',999,5000.00,'2025-12-31 16:36:49',0.00,NULL),(222,137,'1kg',999,5000.00,'2025-12-31 16:36:49',0.00,NULL),(223,138,'500g',999,20000.00,'2025-12-31 16:36:49',0.00,NULL),(224,138,'1kg',999,20000.00,'2025-12-31 16:36:49',0.00,NULL),(225,139,'default',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(226,140,'170g',999,7500.00,'2025-12-31 16:36:49',0.00,NULL),(227,140,'1kg',999,7500.00,'2025-12-31 16:36:49',0.00,NULL),(228,141,'50g',999,3500.00,'2025-12-31 16:36:49',0.00,NULL),(229,142,'100g',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(230,142,'1kg',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(231,143,'100g',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(232,143,'1kg',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(233,144,'300g',999,13000.00,'2025-12-31 16:36:49',0.00,NULL),(234,144,'1kg',999,13000.00,'2025-12-31 16:36:49',0.00,NULL),(235,145,'default',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(236,146,'80g',999,6000.00,'2025-12-31 16:36:49',0.00,NULL),(237,146,'1kg',999,6000.00,'2025-12-31 16:36:49',0.00,NULL),(238,147,'90g',999,9000.00,'2025-12-31 16:36:49',0.00,NULL),(239,147,'1kg',999,9000.00,'2025-12-31 16:36:49',0.00,NULL),(240,148,'default',999,9000.00,'2025-12-31 16:36:49',0.00,NULL),(241,149,'2 cây',999,13500.00,'2025-12-31 16:36:49',0.00,NULL),(242,149,'1kg',999,13500.00,'2025-12-31 16:36:49',0.00,NULL),(243,150,'20gr',999,5000.00,'2025-12-31 16:36:49',0.00,NULL),(244,150,'1kg',999,5000.00,'2025-12-31 16:36:49',0.00,NULL),(245,151,'default',999,7500.00,'2025-12-31 16:36:49',0.00,NULL),(246,152,'default',999,45000.00,'2025-12-31 16:36:49',0.00,NULL),(247,153,'100g',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(248,153,'1kg',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(249,154,'200g',999,9000.00,'2025-12-31 16:36:49',0.00,NULL),(250,154,'1kg',999,9000.00,'2025-12-31 16:36:49',0.00,NULL),(251,155,'100g',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(252,155,'1kg',999,5500.00,'2025-12-31 16:36:49',0.00,NULL),(253,156,'75g',999,11000.00,'2025-12-31 16:36:49',0.00,NULL),(254,156,'1kg',999,11000.00,'2025-12-31 16:36:49',0.00,NULL),(255,157,'80g',999,6000.00,'2025-12-31 16:36:49',0.00,NULL),(256,157,'1kg',999,6000.00,'2025-12-31 16:36:49',0.00,NULL),(257,158,'1kg',2,19000.00,'2025-12-31 16:36:49',0.00,NULL),(258,159,'90g',999,8000.00,'2025-12-31 16:36:49',0.00,NULL),(259,159,'1kg',999,8000.00,'2025-12-31 16:36:49',0.00,NULL),(260,160,'1kg',999,25000.00,'2025-12-31 16:36:49',0.00,NULL),(261,161,'400g',999,14000.00,'2025-12-31 16:36:49',0.00,NULL),(262,161,'1kg',999,14000.00,'2025-12-31 16:36:49',0.00,NULL),(263,162,'600g',999,18000.00,'2025-12-31 16:36:49',0.00,NULL),(264,162,'1kg',999,18000.00,'2025-12-31 16:36:49',0.00,NULL),(265,163,'400g',20,14000.00,'2025-12-31 16:36:49',0.00,NULL),(266,163,'1kg',8,14000.00,'2025-12-31 16:36:49',0.00,NULL),(267,164,'default',999,15000.00,'2025-12-31 16:36:49',0.00,NULL),(268,165,'default',998,15000.00,'2025-12-31 16:36:49',0.00,NULL),(269,166,'1kg',999,24000.00,'2025-12-31 16:36:49',0.00,NULL),(270,167,'default',999,25000.00,'2025-12-31 16:36:49',0.00,NULL),(271,168,'400g',997,35000.00,'2025-12-31 16:36:49',0.00,NULL),(272,168,'1kg',999,35000.00,'2025-12-31 16:36:49',0.00,NULL),(273,169,'400g',998,13000.00,'2025-12-31 16:36:49',0.00,NULL),(274,169,'1kg',999,13000.00,'2025-12-31 16:36:49',0.00,NULL),(275,170,'1kg',998,25000.00,'2025-12-31 16:36:49',0.00,NULL),(276,171,'1kg',993,25000.00,'2025-12-31 16:36:49',0.00,NULL),(277,172,'400g',999,10000.00,'2025-12-31 16:36:49',0.00,NULL),(278,172,'1kg',999,10000.00,'2025-12-31 16:36:49',0.00,NULL),(279,173,'400g',999,18000.00,'2025-12-31 16:36:49',0.00,NULL),(280,173,'1kg',999,18000.00,'2025-12-31 16:36:49',0.00,NULL),(281,174,'1kg',998,14000.00,'2025-12-31 16:36:49',0.00,NULL),(282,175,'700g',986,35000.00,'2025-12-31 16:36:49',0.00,NULL),(283,175,'1kg',999,35000.00,'2025-12-31 16:36:49',0.00,NULL),(284,176,'300g',998,12000.00,'2025-12-31 16:36:49',0.00,NULL),(285,176,'1kg',999,12000.00,'2025-12-31 16:36:49',0.00,NULL),(286,177,'400g',989,10000.00,'2025-12-31 16:36:49',0.00,NULL),(287,177,'1kg',999,10000.00,'2025-12-31 16:36:49',0.00,NULL),(288,178,'300g',989,19000.00,'2025-12-31 16:36:49',0.00,NULL),(289,178,'1kg',999,29000.00,'2025-12-31 16:36:49',0.00,NULL),(290,179,'400gr',983,18000.00,'2025-12-31 16:36:49',0.00,NULL),(291,179,'1kg',998,30000.00,'2025-12-31 16:36:49',0.00,NULL),(292,180,'1kg',988,18000.00,'2025-12-31 16:36:49',0.00,NULL),(293,181,'300g',986,10000.00,'2025-12-31 16:36:49',0.00,NULL),(294,181,'1kg',998,120000.00,'2025-12-31 16:36:49',0.00,NULL),(295,182,'1kg',0,40000.00,'2025-12-31 16:36:49',0.00,NULL),(296,183,'1kg',0,30000.00,'2025-12-31 16:36:49',0.00,NULL),(297,184,'1kg',4,18000.00,'2025-12-31 16:36:49',0.00,NULL),(298,185,'500g',975,15000.00,'2025-12-31 16:36:49',0.00,NULL),(299,185,'1kg',974,25000.00,'2025-12-31 16:36:49',0.00,NULL),(300,186,'1kg',11,10000.00,'2025-12-31 16:36:49',0.00,NULL),(301,187,'500g',0,95000.00,'2025-12-31 16:36:49',0.00,NULL),(302,187,'1kg',0,195000.00,'2025-12-31 16:36:49',0.00,NULL),(304,189,'500g',241,28000.00,'2026-03-29 01:33:23',18000.00,'2026-06-16 17:00:00'),(310,189,'1kg',30,50000.00,'2026-06-04 06:36:39',40000.00,'2026-06-16 17:00:00');
/*!40000 ALTER TABLE `product_variants` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `products` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int DEFAULT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `avg_rating` decimal(3,2) DEFAULT '0.00',
  `review_count` int DEFAULT '0',
  `soild_count` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `deleted_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_category_id` (`category_id`) USING BTREE,
  KEY `idx_name` (`name`) USING BTREE,
  KEY `idx_products_deleted_at` (`deleted_at`)
) ENGINE=InnoDB AUTO_INCREMENT=199 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,1,'Cải muối dưa (cải sậy)',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:40:44',NULL),(2,1,'Cải mù tạt',NULL,NULL,300,'2025-12-31 16:36:48','2026-03-18 14:40:46',NULL),(3,1,'Xà lách Mỹ Iceberg',NULL,NULL,1,'2025-12-31 16:36:48','2026-01-25 17:06:17',NULL),(4,1,'Cải Thảo làm Kim chi',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:40:47',NULL),(5,1,'Rau xà lách xoong nhỏ (xoong nhuyễn)',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-01-25 17:06:28',NULL),(6,1,'Rau Mồng tơi',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-01-25 17:06:31',NULL),(7,1,'Rau Cải thìa',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-01-25 17:06:33',NULL),(8,1,'Rau cải xanh con',NULL,NULL,301,'2025-12-31 16:36:48','2026-01-25 17:10:40',NULL),(9,2,'Khoai lang Nhật',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:40:50',NULL),(10,2,'Khoai lang mật Tà Nung',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:40:52',NULL),(11,5,'Quả Chanh Đà Lạt',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:40:52',NULL),(12,1,'Rau nêm Ngò rí',4.00,2,NULL,'2025-12-31 16:36:48','2026-05-16 19:04:05',NULL),(13,1,'Rau Cải cầu vồng',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-01-25 17:06:45',NULL),(14,1,'Rau thơm(Diếp cá)',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:41:26',NULL),(15,7,'Quả thơm trái lớn',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:41:34',NULL),(16,5,'Quả Chanh vàng',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:41:38',NULL),(17,5,'Ớt chuông vàng',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:41:40',NULL),(18,2,'Rau Cải xoăn Kale',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:41:41',NULL),(19,7,'Ớt chuông xanh',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:41:42',NULL),(20,2,'Cà rốt cuống xanh',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:41:46',NULL),(21,5,'Khoai tây hồng',NULL,NULL,400,'2025-12-31 16:36:48','2026-03-18 14:41:49',NULL),(22,7,'Chanh dây',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:41:59',NULL),(23,5,'Quả tắc',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:41:55',NULL),(24,5,'Ớt chuông đỏ trái vừa',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:02',NULL),(25,1,'Rau Bồ Công Anh Tím',NULL,NULL,1,'2025-12-31 16:36:48','2026-03-18 14:42:05',NULL),(26,2,'Khoai tây da vàng',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:06',NULL),(27,2,'Củ dền',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:10',NULL),(28,4,'Ớt chuông ba màu',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:21',NULL),(29,7,'Rau thơm - Húng lũi',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:25',NULL),(30,1,'Cần tây cây vừa',NULL,NULL,2,'2025-12-31 16:36:48','2026-03-18 14:42:29',NULL),(31,7,'Nho kẹo',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:31',NULL),(32,7,'Dưa lưới Đài Loan',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:35',NULL),(33,7,'Bơ vườn',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:36',NULL),(34,6,'Bắp nếp',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:42',NULL),(35,7,'Kiwi vàng',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:44',NULL),(36,6,'Bắp mỹ',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:45',NULL),(37,7,'Táo xanh Phan Rang',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:46',NULL),(38,7,'Cherry',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:47',NULL),(39,7,'Xoài chín',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:47',NULL),(40,7,'Bơ 034',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:48',NULL),(41,7,'Chuối laba Đà Lạt',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:48',NULL),(42,7,'Cam sành',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:49',NULL),(43,7,'Thơm lớn gọt',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:50',NULL),(44,7,'Dưa hấu',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:50',NULL),(45,7,'Quýt úc',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:42:51',NULL),(46,7,'Thù lù - Tầm bóp Nam mỹ',NULL,NULL,300,'2025-12-31 16:36:48','2026-03-18 14:43:01',NULL),(47,7,'Bơ Sáp',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:03',NULL),(48,7,'Ổi vườn',NULL,NULL,535,'2025-12-31 16:36:48','2026-06-17 11:05:31',NULL),(49,7,'Nho mẫu đơn',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:05',NULL),(50,1,'Xà lách diếp',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:08',NULL),(51,1,'Rau càng cua',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:12',NULL),(52,1,'Rau cải trời',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:12',NULL),(53,1,'Rau Cải bó xôi (rau bina)',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:13',NULL),(54,1,'Xà lách Romaine',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:13',NULL),(55,1,'Bắp cải tím',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:21',NULL),(56,1,'Xà lách Carol',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:28',NULL),(57,1,'Rau Cải hoa hồng',NULL,NULL,300,'2025-12-31 16:36:48','2026-03-18 14:43:29',NULL),(58,1,'Rau cải nhúng baby',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:52',NULL),(59,1,'Rau Cải xanh baby',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:53',NULL),(60,1,'Rau đắng',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:53',NULL),(61,1,'Rau đay trắng',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:54',NULL),(62,1,'Xà lách Gai',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:56',NULL),(63,1,'Rau muống hạt',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:43:59',NULL),(64,1,'Cải Thảo',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:44:01',NULL),(65,6,'Mầm rau muống hạt',NULL,NULL,250,'2025-12-31 16:36:48','2026-03-18 14:44:03',NULL),(66,1,'Rau muống nước',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:44:05',NULL),(67,6,'Bắp cải mềm Đà Lạt',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:44:05',NULL),(68,3,'Ngọn rau lang',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:44:36',NULL),(69,1,'Rau má lá nhỏ',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:44:50',NULL),(70,3,'Ngọn su su',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:44:51',NULL),(71,1,'Rau Cần nước',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:44:58',NULL),(72,1,'Rau Cải ngọt',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:44:59',NULL),(73,1,'Rau Xà lách xoong Đà Lạt',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:45:01',NULL),(74,1,'Rau muống nước baby',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:45:02',NULL),(75,3,'Rau Cải ngồng baby',NULL,NULL,300,'2025-12-31 16:36:48','2026-03-18 14:46:54',NULL),(76,1,'Rau salad Rocket',NULL,NULL,1,'2025-12-31 16:36:48','2026-03-18 14:46:59',NULL),(77,1,'Xà lách búp',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:47:03',NULL),(78,1,'Rau Ngót',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:47:05',NULL),(79,1,'Rau Cải bẹ xanh Đà Lạt',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:47:06',NULL),(80,1,'Rau dền',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:47:08',NULL),(81,6,'Bắp cải trái tim',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:47:11',NULL),(82,1,'Giá mầm',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:47:20',NULL),(83,6,'Hạt Tiêu đen',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:47:23',NULL),(84,1,'Rau rừng Tây Ninh',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:47:27',NULL),(85,7,'Rau thơm - Tía tô',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:47:33',NULL),(86,7,'Rau thơm - Kinh giới',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:47:34',NULL),(87,7,'Rau thơm - Húng quế',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:47:35',NULL),(88,5,'Rau rừng Gia Lai (Bầu đất , rau lủi)',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:48:09',NULL),(89,7,'Rau thơm - Húng cây',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:48:12',NULL),(90,7,'Rau thơm mix các loại',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:48:14',NULL),(91,5,'Quả Khổ qua rừng',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:48:17',NULL),(92,1,'Ngải cứu',NULL,NULL,NULL,'2025-12-31 16:36:48','2026-03-18 14:48:18',NULL),(93,1,'Combo Lá xông giải cảm',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:48:21',NULL),(94,5,'Quả Khổ qua rừng baby',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:48:23',NULL),(95,1,'Lá trà xanh',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:48:25',NULL),(96,5,'Cà chua thân gỗ hộp',NULL,NULL,518,'2025-12-31 16:36:49','2026-06-17 11:05:31',NULL),(97,5,'Cà chua Beef',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:48:31',NULL),(98,5,'Ớt ngọt snack',NULL,NULL,200,'2025-12-31 16:36:49','2026-03-18 14:48:32',NULL),(99,5,'Cà chua cherry socola',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:48:33',NULL),(100,5,'Cà chua',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:48:34',NULL),(101,5,'Cà chua bi',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:48:35',NULL),(102,5,'Ớt sừng ngọt',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:48:35',NULL),(103,5,'Ớt chuông baby',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:48:36',NULL),(104,4,'Bông thiên lý',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:10',NULL),(105,4,'Bông lơ xanh',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:10',NULL),(106,4,'Bông lơ xanh baby',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:11',NULL),(107,4,'Bông lơ trắng',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:11',NULL),(108,4,'Bông Atiso tươi',NULL,NULL,459,'2025-12-31 16:36:49','2026-06-16 06:21:25',NULL),(109,2,'Củ hồi',NULL,NULL,506,'2025-12-31 16:36:49','2026-06-16 09:02:53',NULL),(110,2,'Cà rốt baby',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:14',NULL),(111,2,'Khoai lang nghệ',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:14',NULL),(112,2,'Khoai lang tím',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:14',NULL),(113,2,'Su hào tím',1.00,1,621,'2025-12-31 16:36:49','2026-06-17 11:05:31',NULL),(114,2,'Khoai lang Như ngọc',1.00,1,537,'2025-12-31 16:36:49','2026-06-18 16:48:49',NULL),(115,2,'Khoai lang sữa',NULL,NULL,509,'2025-12-31 16:36:49','2026-06-18 16:48:49',NULL),(116,2,'Củ năng',NULL,NULL,401,'2025-12-31 16:36:49','2026-06-16 06:07:22',NULL),(117,2,'Củ cải màu',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:17',NULL),(118,2,'Củ cải',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:17',NULL),(119,2,'Cà rốt baby tròn',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:18',NULL),(120,2,'Củ cải đường',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:18',NULL),(121,2,'Khoai môn sáp Đà Lạt',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:19',NULL),(122,2,'Củ sắn',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:21',NULL),(123,2,'Cà rốt cuống tím',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:37',NULL),(124,2,'Khoai mỡ tím',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:20',NULL),(125,2,'Su hào',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:25',NULL),(126,1,'Lá lốt',NULL,NULL,1,'2025-12-31 16:36:49','2026-03-18 14:49:29',NULL),(127,6,'Hạt Tiêu xanh',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:30',NULL),(128,2,'Củ Tỏi tím',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:44',NULL),(129,2,'Củ Tỏi Cô đơn',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:44',NULL),(130,1,'Rau nêm Ngò gai',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:45',NULL),(131,1,'Rau răm',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:45',NULL),(132,2,'Củ Gừng sẻ',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:46',NULL),(133,1,'Lá Giang',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:46',NULL),(134,2,'Củ Hành tím indo',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:48',NULL),(135,1,'Rau nêm Rau Thì là',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:48',NULL),(136,2,'Củ Hành tím',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:49',NULL),(137,2,'Củ Sả cây',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:50',NULL),(138,1,'Rau nêm Hành Đất',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:50',NULL),(139,1,'Rau Nêm Ngò ôm - Ngò gai',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:52',NULL),(140,7,'Quả Khế chua',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:58',NULL),(141,7,'Me vắt',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:49:59',NULL),(142,1,'Rau nêm - Cần tàu',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:00',NULL),(143,1,'Rau nêm Hành lá',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:00',NULL),(144,2,'Củ Hành tây tươi Đà Lạt',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:04',NULL),(145,1,'Rau Nêm Hành - ngò',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:07',NULL),(146,2,'Củ Riềng',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:13',NULL),(147,2,'Củ tỏi Đà Lạt',NULL,NULL,1,'2025-12-31 16:36:49','2026-03-18 14:50:14',NULL),(148,3,'Bạc Hà - Dọc mùng',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:15',NULL),(149,1,'Rau nêm Hành Paro',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:17',NULL),(150,6,'Hạt điều màu',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:20',NULL),(151,1,'Lá dứa',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:29',NULL),(152,5,'Quả Gấc',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:24',NULL),(153,1,'Lá hẹ',NULL,NULL,1,'2025-12-31 16:36:49','2026-03-18 14:50:32',NULL),(154,7,'Quả Chuối chát',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:34',NULL),(155,1,'Rau nêm Ngò ôm',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:36',NULL),(156,6,'Hạt Tiêu xay',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:39',NULL),(157,2,'Củ Nghệ',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:41',NULL),(158,2,'Củ Hành Tây tím',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:41',NULL),(159,2,'Củ Tỏi tép lớn',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:42',NULL),(160,5,'Quả Bí Đao xanh',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:44',NULL),(161,5,'Mướp hương baby',NULL,NULL,400,'2025-12-31 16:36:49','2026-03-18 14:50:44',NULL),(162,5,'Quả Bí đao xanh baby',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:45',NULL),(163,5,'Quả Đậu đũa',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:46',NULL),(164,5,'Quả Cà Pháo Tím',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:47',NULL),(165,5,'Quả Cà Pháo trắng',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:49',NULL),(166,5,'Bí đỏ Nhật',NULL,NULL,1,'2025-12-31 16:36:49','2026-03-18 14:50:50',NULL),(167,5,'Khổ qua tây',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:50',NULL),(168,5,'Quả Cà tím sọc',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:51',NULL),(169,7,'Quả Chuối xanh ',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:50:55',NULL),(170,5,'Bí đỏ Hồ Lô',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-06-16 03:30:55',NULL),(171,5,'Bí Ngòi xanh',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:04',NULL),(172,7,'Dưa hấu baby',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:06',NULL),(173,5,'Khổ qua baby',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:09',NULL),(174,5,'Khổ qua Đà Lạt',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:11',NULL),(175,5,'Bí hạt đậu, bí sữa',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:13',NULL),(176,5,'Quả su su baby',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:14',NULL),(177,5,'Quả Dưa leo',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:14',NULL),(178,5,'Bí ngô mini vàng',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:22',NULL),(179,5,'Quả Đậu Cove Nhật',NULL,NULL,416,'2025-12-31 16:36:49','2026-06-16 06:16:31',NULL),(180,7,'Quả Đu đủ xanh',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:27',NULL),(181,5,'Quả Đậu bắp',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:28',NULL),(182,5,'Quả Sa kê',5.00,1,NULL,'2025-12-31 16:36:49','2026-06-15 17:53:06',NULL),(183,5,'Quả Bí đỏ non',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:31',NULL),(184,5,'Quả Bí Ngòi Hàn Quốc',NULL,NULL,14,'2025-12-31 16:36:49','2026-06-16 06:51:19',NULL),(185,5,'Quả Đậu cô ve',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:32',NULL),(186,5,'Quả Su su',NULL,NULL,NULL,'2025-12-31 16:36:49','2026-03-18 14:51:33',NULL),(187,6,'Hạt điều rang muối',NULL,NULL,502,'2025-12-31 16:36:49','2026-01-25 17:20:36',NULL),(189,1,'Rau diếp cá',5.00,3,59,'2026-03-29 01:33:23','2026-06-16 07:53:09',NULL);
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refund_request_images`
--

DROP TABLE IF EXISTS `refund_request_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refund_request_images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `refund_request_id` int NOT NULL,
  `image_url` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `cloudinary_public_id` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `media_type` varchar(10) COLLATE utf8mb4_unicode_ci DEFAULT 'image',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `refund_request_id` (`refund_request_id`),
  CONSTRAINT `refund_request_images_ibfk_1` FOREIGN KEY (`refund_request_id`) REFERENCES `refund_requests` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refund_request_images`
--

LOCK TABLES `refund_request_images` WRITE;
/*!40000 ALTER TABLE `refund_request_images` DISABLE KEYS */;
INSERT INTO `refund_request_images` VALUES (1,1,'https://res.cloudinary.com/dawh6klty/video/upload/v1781251188/farmily/reviews/1/dbqlt1luik0cq299l7fx.webm','farmily/reviews/1/dbqlt1luik0cq299l7fx','video','2026-06-12 07:59:49'),(2,1,'https://res.cloudinary.com/dawh6klty/image/upload/v1781251190/farmily/reviews/1/eqwcwdloh7wqryfnt30u.png','farmily/reviews/1/eqwcwdloh7wqryfnt30u','image','2026-06-12 07:59:50'),(3,2,'https://res.cloudinary.com/dawh6klty/image/upload/v1781439099/farmily/reviews/2/f3h08xxbalvtucg6sazv.png','farmily/reviews/2/f3h08xxbalvtucg6sazv','image','2026-06-14 12:11:40'),(4,4,'https://res.cloudinary.com/dawh6klty/image/upload/v1781448595/farmily/reviews/4/m6mlcn8ms2wfd3onbm5q.jpg','farmily/reviews/4/m6mlcn8ms2wfd3onbm5q','image','2026-06-14 14:49:56'),(5,5,'https://res.cloudinary.com/dawh6klty/image/upload/v1781449032/farmily/reviews/5/upf9wlcaxikzt5onp7ji.jpg','farmily/reviews/5/upf9wlcaxikzt5onp7ji','image','2026-06-14 14:57:12');
/*!40000 ALTER TABLE `refund_request_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `refund_requests`
--

DROP TABLE IF EXISTS `refund_requests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `refund_requests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `order_id` int NOT NULL,
  `user_id` int NOT NULL,
  `reason` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text COLLATE utf8mb4_unicode_ci,
  `bank_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bank_account` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `bank_holder` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `refund_amount` double NOT NULL,
  `status` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'pending',
  `admin_note` text COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `transaction_code` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_order_refund` (`order_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `refund_requests_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  CONSTRAINT `refund_requests_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `refund_requests`
--

LOCK TABLES `refund_requests` WRITE;
/*!40000 ALTER TABLE `refund_requests` DISABLE KEYS */;
INSERT INTO `refund_requests` VALUES (1,142,1,'Rau củ bị dập nát','sản phẩm bị hư hỏng nặng không thể xử lý','BIDV','0332991664','CHU TAN TAI',90500,'refunded','Duyệt yêu cầu hoàn tiền','2026-06-12 07:59:46','2026-06-14 11:48:32','FT260614001'),(2,143,1,'Lý do khác','tôi ko thích nữa nên muốn hoàn tiền','BIDV','0332991664','CHU TAN TAI',90500,'refunded','Duyệt hoàn tiền cho đơn 143','2026-06-14 12:11:37','2026-06-14 13:14:47','12356465'),(3,140,1,'Hàng bị mốc mọt','giao thiếu củ kjhoai tây','BIDV','0332991664','CHU TAN TAI',173500,'refunded','','2026-06-14 13:18:02','2026-06-14 14:02:46','1236589123'),(4,144,26,'Rau củ bị dập nát','bị hư','BiDV','03898676989','CHÂU THỊ THUÝ QUỲNH',68300,'refunded','cho shop xin lỗi khách hàng vì trãi nghiệm không như mong đợi','2026-06-14 14:49:53','2026-06-16 03:39:28','123123123123123'),(5,145,26,'Hàng bị mốc mọt','bị hư','MB','9278657281','CHÂU THỊ THUÝ QUỲNH',53300,'approved','','2026-06-14 14:57:10','2026-06-16 03:39:44',NULL);
/*!40000 ALTER TABLE `refund_requests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review`
--

DROP TABLE IF EXISTS `review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `order_id` int DEFAULT NULL,
  `variant_id` int DEFAULT NULL,
  `rating` int NOT NULL,
  `review_text` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'approved',
  `report_count` int NOT NULL DEFAULT '0',
  `helpful_count` int NOT NULL DEFAULT '0',
  `edit_count` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `order_id` (`order_id`) USING BTREE,
  KEY `variant_id` (`variant_id`) USING BTREE,
  KEY `idx_product_id` (`product_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_review_status` (`status`) USING BTREE,
  KEY `idx_review_product_status` (`product_id`,`status`) USING BTREE,
  CONSTRAINT `review_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `review_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `review_ibfk_3` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `review_ibfk_4` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review`
--

LOCK TABLES `review` WRITE;
/*!40000 ALTER TABLE `review` DISABLE KEYS */;
INSERT INTO `review` VALUES (7,27,189,123,304,5,'nogn',NULL,'2026-06-02 16:38:00','approved',0,0,0),(10,26,189,148,304,5,'rau tươi ạ',NULL,'2026-06-14 20:04:13','approved',0,0,0),(11,26,189,145,304,5,'rau ngon',NULL,'2026-06-14 20:08:45','approved',1,0,0);
/*!40000 ALTER TABLE `review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_helpful`
--

DROP TABLE IF EXISTS `review_helpful`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_helpful` (
  `id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uq_review_user` (`review_id`,`user_id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  CONSTRAINT `review_helpful_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `review` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `review_helpful_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_helpful`
--

LOCK TABLES `review_helpful` WRITE;
/*!40000 ALTER TABLE `review_helpful` DISABLE KEYS */;
/*!40000 ALTER TABLE `review_helpful` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `review_images`
--

DROP TABLE IF EXISTS `review_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `review_images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `review_id` int NOT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `media_type` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'image',
  `cloudinary_public_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_review_id` (`review_id`) USING BTREE,
  KEY `idx_review_images_media_type` (`review_id`,`media_type`) USING BTREE,
  CONSTRAINT `review_images_ibfk_1` FOREIGN KEY (`review_id`) REFERENCES `review` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `review_images`
--

LOCK TABLES `review_images` WRITE;
/*!40000 ALTER TABLE `review_images` DISABLE KEYS */;
INSERT INTO `review_images` VALUES (13,10,'https://res.cloudinary.com/dawh6klty/image/upload/v1781467455/farmily/reviews/10/vyp4br8jvcbigxxx8bkh.png','2026-06-14 20:04:16','image','farmily/reviews/10/vyp4br8jvcbigxxx8bkh'),(14,11,'https://res.cloudinary.com/dawh6klty/image/upload/v1781467727/farmily/reviews/11/fwqbhv28hsyohgn9pn2u.png','2026-06-14 20:08:47','image','farmily/reviews/11/fwqbhv28hsyohgn9pn2u'),(15,11,'https://res.cloudinary.com/dawh6klty/video/upload/v1781467730/farmily/reviews/11/wb9smynafltcgxdgomxh.mp4','2026-06-14 20:08:51','video','farmily/reviews/11/wb9smynafltcgxdgomxh');
/*!40000 ALTER TABLE `review_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `saved_coupons`
--

DROP TABLE IF EXISTS `saved_coupons`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `saved_coupons` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `coupon_id` int NOT NULL,
  `saved_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_coupon` (`user_id`,`coupon_id`),
  KEY `coupon_id` (`coupon_id`),
  CONSTRAINT `saved_coupons_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  CONSTRAINT `saved_coupons_ibfk_2` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `saved_coupons`
--

LOCK TABLES `saved_coupons` WRITE;
/*!40000 ALTER TABLE `saved_coupons` DISABLE KEYS */;
INSERT INTO `saved_coupons` VALUES (15,25,9,'2026-06-04 14:14:40'),(16,25,8,'2026-06-04 14:15:52'),(17,25,11,'2026-06-04 14:15:53'),(18,26,11,'2026-06-04 15:28:32'),(19,26,8,'2026-06-04 15:28:35'),(20,26,9,'2026-06-04 15:28:35'),(21,1,8,'2026-06-10 18:23:42'),(22,1,9,'2026-06-10 18:23:43'),(23,26,13,'2026-06-14 18:52:19'),(24,26,14,'2026-06-14 19:12:52'),(25,1,13,'2026-06-15 05:32:09');
/*!40000 ALTER TABLE `saved_coupons` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `static_page`
--

DROP TABLE IF EXISTS `static_page`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `static_page` (
  `id` int NOT NULL AUTO_INCREMENT,
  `slug` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `slug` (`slug`) USING BTREE,
  KEY `idx_slug` (`slug`) USING BTREE,
  KEY `idx_type` (`type`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `static_page`
--

LOCK TABLES `static_page` WRITE;
/*!40000 ALTER TABLE `static_page` DISABLE KEYS */;
INSERT INTO `static_page` VALUES (2,'huong-dan-mua-hang','Hướng dẫn mua hàng','<p><strong>Bước 1:</strong> Truy cập website v&agrave; lựa chọn sản phẩm cần mua để mua h&agrave;ng</p>\r\n<p><strong>Bước 2:</strong> Click v&agrave;o sản phẩm muốn mua, m&agrave;n h&igrave;nh hiển thị ra pop up với c&aacute;c lựa chọn sau:</p>\r\n<ul>\r\n<li style=\"text-align: left;\">Nếu bạn muốn tiếp tục mua h&agrave;ng: Bấm v&agrave;o phần tiếp tục mua h&agrave;ng để lựa chọn th&ecirc;m sản phẩm v&agrave;o giỏ h&agrave;ng</li>\r\n<li style=\"text-align: left;\">Nếu bạn muốn xem giỏ h&agrave;ng để cập nhật sản phẩm: Bấm v&agrave;o xem giỏ h&agrave;ng</li>\r\n<li style=\"text-align: left;\">Nếu bạn muốn đặt h&agrave;ng v&agrave; thanh to&aacute;n cho sản phẩm n&agrave;y: Bấm v&agrave;o Đặt h&agrave;ng v&agrave; thanh to&aacute;n</li>\r\n</ul>\r\n<p><strong>Bước 3:</strong> Lựa chọn th&ocirc;ng tin t&agrave;i khoản thanh to&aacute;n</p>\r\n<ul>\r\n<li>Nếu bạn đ&atilde; c&oacute; t&agrave;i khoản: Nhập th&ocirc;ng tin đăng nhập (email v&agrave; mật khẩu)</li>\r\n<li>Nếu bạn chưa c&oacute; t&agrave;i khoản: Điền th&ocirc;ng tin c&aacute; nh&acirc;n để đăng k&yacute; t&agrave;i khoản mới</li>\r\n<li>Nếu bạn muốn mua h&agrave;ng kh&ocirc;ng cần t&agrave;i khoản: Chọn mục đặt h&agrave;ng kh&ocirc;ng cần t&agrave;i khoản</li>\r\n</ul>\r\n<p><strong>Bước 4:</strong> Điền c&aacute;c th&ocirc;ng tin của bạn để nhận đơn h&agrave;ng, lựa chọn h&igrave;nh thức thanh to&aacute;n v&agrave; vận chuyển cho đơn h&agrave;ng của m&igrave;nh</p>\r\n<p><strong>Bước 5:</strong> Xem lại th&ocirc;ng tin đặt h&agrave;ng, điền ch&uacute; th&iacute;ch v&agrave; gửi đơn h&agrave;ng</p>\r\n<p>Sau khi nhận được đơn h&agrave;ng bạn gửi, ch&uacute;ng t&ocirc;i sẽ li&ecirc;n hệ bằng c&aacute;ch gọi điện lại để x&aacute;c nhận đơn h&agrave;ng v&agrave; địa chỉ của bạn.</p>\r\n<p><strong>Tr&acirc;n trọng cảm ơn qu&yacute; kh&aacute;ch!</strong></p>','guide','active','2026-01-20 02:40:11','2026-01-20 03:31:59'),(3,'dieu-khoan-dich-vu','Điều khoản dịch vụ','<p>Khi quý khách truy cập vào trang web của chúng tôi có nghĩa là quý khách đồng ý với các điều khoản này. Trang web có quyền thay đổi, chỉnh sửa, thêm hoặc lược bỏ bất kỳ phần nào trong Quy định và Điều kiện sử dụng, vào bất cứ lúc nào.</p>\r\n\r\n<h3>1. Hướng dẫn sử dụng web</h3>\r\n<ul>\r\n    <li>Người dùng tối thiểu phải 18 tuổi hoặc truy cập dưới sự giám sát của cha mẹ/người giám hộ hợp pháp.</li>\r\n    <li>Chúng tôi cấp giấy phép sử dụng để bạn có thể mua sắm trên web trong khuôn khổ điều khoản và điều kiện sử dụng đã đề ra.</li>\r\n    <li>Nghiêm cấm sử dụng bất kỳ phần nào của trang web này với mục đích thương mại khi chưa được cho phép bằng văn bản.</li>\r\n</ul>\r\n\r\n<h3>2. Chấp nhận đơn hàng và giá cả</h3>\r\n<ul>\r\n    <li>Chúng tôi có quyền từ chối hoặc hủy đơn hàng vì bất kỳ lý do gì vào bất kỳ lúc nào.</li>\r\n    <li>Chúng tôi cam kết cung cấp thông tin giá cả chính xác nhất cho người tiêu dùng.</li>\r\n</ul>\r\n\r\n<h3>3. Thương hiệu và bản quyền</h3>\r\n<p>Mọi quyền sở hữu trí tuệ, nội dung thông tin và tất cả các thiết kế, văn bản, đồ họa, phần mềm, hình ảnh đều là tài sản của chúng tôi. Toàn bộ nội dung được bảo vệ bởi luật bản quyền Việt Nam.</p>\r\n\r\n<h3>4. Quy định về bảo mật</h3>\r\n<p>Trang web coi trọng việc bảo mật thông tin và sử dụng các biện pháp tốt nhất để bảo vệ thông tin và việc thanh toán của quý khách.</p>\r\n\r\n<h3>5. Thay đổi, hủy bỏ giao dịch</h3>\r\n<p>Khách hàng có quyền chấm dứt giao dịch bằng cách:</p>\r\n<ul>\r\n    <li>Thông báo qua đường dây nóng: 04.6674.2332</li>\r\n    <li>Trả lại hàng hoá chưa sử dụng theo chính sách đổi trả hàng.</li>\r\n</ul>','policy','active','2026-01-20 02:40:11','2026-01-20 02:40:11'),(4,'chinh-sach-hoan-tra','Chính sách nhận và hoàn trả hàng hóa','<p>N&ocirc;ng sản Farmily cung cấp thực phẩm sạch, thực phẩm an to&agrave;n, thực phẩm hữu cơ, đặc sản v&ugrave;ng miền, &hellip; đồng nghĩa với việc sản phẩm của ch&uacute;ng t&ocirc;i kh&ocirc;ng đạt được sự đồng đều như những mặt h&agrave;ng sản xuất truyền thống.</p>\r\n<h3>1. Farmily.com chấp nhận đổi trả</h3>\r\n<ul>\r\n<li>Sản phẩm giao đến kh&ocirc;ng nguy&ecirc;n vẹn, hư hại do qu&aacute; tr&igrave;nh vận chuyển.</li>\r\n<li>Sản phẩm giao sai kh&ocirc;ng đ&uacute;ng với đơn đặt h&agrave;ng ban đầu.</li>\r\n<li>Sản phẩm đ&atilde; hết hạn sử dụng trước hoặc v&agrave;o ng&agrave;y giao h&agrave;ng.</li>\r\n<li>Sản phẩm bị hỏng do lỗi của Farmily.com</li>\r\n<li>Đ&aacute;p ứng điều kiện thời gian y&ecirc;u cầu đổi trả h&agrave;ng.</li>\r\n</ul>\r\n<h3>2. Farmily.com cam kết ch&iacute;nh s&aacute;ch Đổi Trả</h3>\r\n<ul>\r\n<li>Bồi ho&agrave;n 100% những sản phẩm lỗi chất lượng dẫn tới hỏng kh&ocirc;ng sử dụng được.</li>\r\n<li>Qu&yacute; kh&aacute;ch c&oacute; thể y&ecirc;u cầu đổi trả, hoặc chuyển sang đơn h&agrave;ng kh&aacute;c nếu kh&ocirc;ng h&agrave;i l&ograve;ng.</li>\r\n<li>Li&ecirc;n hệ bộ phận chăm s&oacute;c kh&aacute;ch h&agrave;ng: Hotline 033 299 1664</li>\r\n</ul>\r\n<h3>3. Quy tr&igrave;nh đổi trả h&agrave;ng</h3>\r\n<ul>\r\n<li>Gọi đến hotline 033 299 1664 th&ocirc;ng b&aacute;o y&ecirc;u cầu đổi trả h&agrave;ng</li>\r\n<li>Th&ocirc;ng b&aacute;o số phiếu mua h&agrave;ng v&agrave; mặt h&agrave;ng cần đổi trả</li>\r\n<li>Farmily.com x&aacute;c nhận nhu cầu đổi trả</li>\r\n<li>Sản phẩm gửi trả lại phải bao gồm phiếu mua h&agrave;ng</li>\r\n<li>Sản phẩm đổi trả phải c&ograve;n nguy&ecirc;n vẹn như ban đầu</li>\r\n</ul>\r\n<h3>4. Chi ph&iacute; đổi trả</h3>\r\n<ul>\r\n<li>Lỗi của Farmily.com: Miễn ph&iacute; giao h&agrave;ng đổi trả</li>\r\n<li>Do kh&aacute;ch h&agrave;ng thay đổi nhu cầu: Kh&aacute;ch chịu ph&iacute; gửi h&agrave;ng</li>\r\n</ul>\r\n<p><strong>Mọi thắc mắc g&oacute;p &yacute; sẽ được giải đ&aacute;p trong thời gian sớm nhất. Xin cảm ơn qu&yacute; kh&aacute;ch!</strong></p>','policy','active','2026-01-20 03:40:10','2026-03-29 01:59:28');
/*!40000 ALTER TABLE `static_page` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `static_page_images`
--

DROP TABLE IF EXISTS `static_page_images`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `static_page_images` (
  `id` int NOT NULL AUTO_INCREMENT,
  `static_page_id` int NOT NULL,
  `image_url` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `position` int DEFAULT '0',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `idx_static_page_id` (`static_page_id`) USING BTREE,
  CONSTRAINT `static_page_images_ibfk_1` FOREIGN KEY (`static_page_id`) REFERENCES `static_page` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `static_page_images`
--

LOCK TABLES `static_page_images` WRITE;
/*!40000 ALTER TABLE `static_page_images` DISABLE KEYS */;
/*!40000 ALTER TABLE `static_page_images` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_notifications`
--

DROP TABLE IF EXISTS `user_notifications`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_notifications` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `type` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `message` text COLLATE utf8mb4_unicode_ci,
  `link` varchar(500) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `reference_id` int DEFAULT NULL,
  `reference_type` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT '0',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `idx_user_unread` (`user_id`,`is_read`,`created_at` DESC),
  KEY `idx_user_created` (`user_id`,`created_at` DESC),
  CONSTRAINT `user_notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=53 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_notifications`
--

LOCK TABLES `user_notifications` WRITE;
/*!40000 ALTER TABLE `user_notifications` DISABLE KEYS */;
INSERT INTO `user_notifications` VALUES (3,34,'broadcast','Ngay mai 6-6 sẽ sale 60% với mã 66giamgia','voucher giảm 60% cuc khung nha ba con','/ma-giam-gia',NULL,NULL,0,'2026-06-15 17:04:52'),(4,33,'broadcast','Ngay mai 6-6 sẽ sale 60% với mã 66giamgia','voucher giảm 60% cuc khung nha ba con','/ma-giam-gia',NULL,NULL,0,'2026-06-15 17:04:52'),(5,32,'broadcast','Ngay mai 6-6 sẽ sale 60% với mã 66giamgia','voucher giảm 60% cuc khung nha ba con','/ma-giam-gia',NULL,NULL,0,'2026-06-15 17:04:52'),(6,31,'broadcast','Ngay mai 6-6 sẽ sale 60% với mã 66giamgia','voucher giảm 60% cuc khung nha ba con','/ma-giam-gia',NULL,NULL,0,'2026-06-15 17:04:52'),(7,30,'broadcast','Ngay mai 6-6 sẽ sale 60% với mã 66giamgia','voucher giảm 60% cuc khung nha ba con','/ma-giam-gia',NULL,NULL,0,'2026-06-15 17:04:52'),(8,29,'broadcast','Ngay mai 6-6 sẽ sale 60% với mã 66giamgia','voucher giảm 60% cuc khung nha ba con','/ma-giam-gia',NULL,NULL,0,'2026-06-15 17:04:52'),(9,28,'broadcast','Ngay mai 6-6 sẽ sale 60% với mã 66giamgia','voucher giảm 60% cuc khung nha ba con','/ma-giam-gia',NULL,NULL,0,'2026-06-15 17:04:52'),(10,27,'broadcast','Ngay mai 6-6 sẽ sale 60% với mã 66giamgia','voucher giảm 60% cuc khung nha ba con','/ma-giam-gia',NULL,NULL,1,'2026-06-15 17:04:52'),(11,26,'broadcast','Ngay mai 6-6 sẽ sale 60% với mã 66giamgia','voucher giảm 60% cuc khung nha ba con','/ma-giam-gia',NULL,NULL,0,'2026-06-15 17:04:52'),(12,1,'broadcast','Ngay mai 6-6 sẽ sale 60% với mã 66giamgia','voucher giảm 60% cuc khung nha ba con','/ma-giam-gia',NULL,NULL,1,'2026-06-15 17:04:52'),(13,27,'order_status','Đơn hàng #149 đang được xử lý','Cửa hàng đang chuẩn bị hàng cho bạn.','/ho-so/don-hang/149',149,'order',1,'2026-06-15 17:05:40'),(14,27,'order_status','Đơn hàng #149 đang được giao','Đơn hàng đã được giao cho đơn vị vận chuyển.','/ho-so/don-hang/149',149,'order',1,'2026-06-15 17:05:57'),(15,27,'order_status','Đơn hàng #149 hoàn thành','Đơn hàng đã được giao thành công. Cảm ơn bạn đã mua hàng!','/ho-so/don-hang/149',149,'order',1,'2026-06-15 17:06:57'),(16,34,'flash_sale','⚡ Flash Sale: Bí đỏ Nhật giảm 20%!','Nhanh tay mua ngay, số lượng có hạn!','/gia-tot',NULL,NULL,0,'2026-06-16 02:24:29'),(17,33,'flash_sale','⚡ Flash Sale: Bí đỏ Nhật giảm 20%!','Nhanh tay mua ngay, số lượng có hạn!','/gia-tot',NULL,NULL,0,'2026-06-16 02:24:29'),(18,32,'flash_sale','⚡ Flash Sale: Bí đỏ Nhật giảm 20%!','Nhanh tay mua ngay, số lượng có hạn!','/gia-tot',NULL,NULL,0,'2026-06-16 02:24:29'),(19,31,'flash_sale','⚡ Flash Sale: Bí đỏ Nhật giảm 20%!','Nhanh tay mua ngay, số lượng có hạn!','/gia-tot',NULL,NULL,0,'2026-06-16 02:24:29'),(20,30,'flash_sale','⚡ Flash Sale: Bí đỏ Nhật giảm 20%!','Nhanh tay mua ngay, số lượng có hạn!','/gia-tot',NULL,NULL,0,'2026-06-16 02:24:29'),(21,29,'flash_sale','⚡ Flash Sale: Bí đỏ Nhật giảm 20%!','Nhanh tay mua ngay, số lượng có hạn!','/gia-tot',NULL,NULL,0,'2026-06-16 02:24:29'),(22,28,'flash_sale','⚡ Flash Sale: Bí đỏ Nhật giảm 20%!','Nhanh tay mua ngay, số lượng có hạn!','/gia-tot',NULL,NULL,0,'2026-06-16 02:24:29'),(23,27,'flash_sale','⚡ Flash Sale: Bí đỏ Nhật giảm 20%!','Nhanh tay mua ngay, số lượng có hạn!','/gia-tot',NULL,NULL,0,'2026-06-16 02:24:29'),(24,26,'flash_sale','⚡ Flash Sale: Bí đỏ Nhật giảm 20%!','Nhanh tay mua ngay, số lượng có hạn!','/gia-tot',NULL,NULL,0,'2026-06-16 02:24:29'),(25,1,'flash_sale','⚡ Flash Sale: Bí đỏ Nhật giảm 20%!','Nhanh tay mua ngay, số lượng có hạn!','/gia-tot',NULL,NULL,0,'2026-06-16 02:24:29'),(26,26,'order_status','Đơn hàng #150 đang được xử lý','Cửa hàng đang chuẩn bị hàng cho bạn.','/ho-so/don-hang/150',150,'order',0,'2026-06-16 02:26:54'),(27,26,'order_status','Đơn hàng #150 đang được giao','Đơn hàng đã được giao cho đơn vị vận chuyển.','/ho-so/don-hang/150',150,'order',0,'2026-06-16 02:26:57'),(28,26,'order_status','Đơn hàng #150 hoàn thành','Đơn hàng đã được giao thành công. Cảm ơn bạn đã mua hàng!','/ho-so/don-hang/150',150,'order',0,'2026-06-16 02:27:00'),(29,26,'order_status','Đơn hàng #144 đã được hoàn tiền','Yêu cầu hoàn tiền của bạn đã được xử lý thành công.','/ho-so/don-hang/144',144,'order',0,'2026-06-16 03:39:28'),(30,1,'order_status','Đơn hàng #154 đang được giao','Đơn hàng đã được giao cho đơn vị vận chuyển.','/ho-so/don-hang/154',154,'order',0,'2026-06-16 06:18:40'),(31,30,'order_status','Đơn hàng #153 đang được giao','Đơn hàng đã được giao cho đơn vị vận chuyển.','/ho-so/don-hang/153',153,'order',0,'2026-06-16 06:20:35'),(32,1,'order_status','Đơn hàng #154 hoàn thành','Đơn hàng đã được giao thành công. Cảm ơn bạn đã mua hàng!','/ho-so/don-hang/154',154,'order',0,'2026-06-16 06:20:41'),(33,30,'order_status','Đơn hàng #153 hoàn thành','Đơn hàng đã được giao thành công. Cảm ơn bạn đã mua hàng!','/ho-so/don-hang/153',153,'order',0,'2026-06-16 06:20:44'),(34,1,'order_status','Đơn hàng #155 đang được xử lý','Cửa hàng đang chuẩn bị hàng cho bạn.','/ho-so/don-hang/155',155,'order',0,'2026-06-16 06:21:47'),(35,1,'order_status','Đơn hàng #155 đang được giao','Đơn hàng đã được giao cho đơn vị vận chuyển.','/ho-so/don-hang/155',155,'order',0,'2026-06-16 06:22:13'),(36,1,'order_status','Đơn hàng #156 đang được xử lý','Cửa hàng đang chuẩn bị hàng cho bạn.','/ho-so/don-hang/156',156,'order',0,'2026-06-16 06:27:54'),(37,1,'order_status','Đơn hàng #156 đang được giao','Đơn hàng đã được giao cho đơn vị vận chuyển.','/ho-so/don-hang/156',156,'order',0,'2026-06-16 06:28:03'),(38,1,'order_status','Đơn hàng #156 đang được xử lý','Cửa hàng đang chuẩn bị hàng cho bạn.','/ho-so/don-hang/156',156,'order',0,'2026-06-16 06:31:24'),(39,1,'order_status','Đơn hàng #156 đang được giao','Đơn hàng đã được giao cho đơn vị vận chuyển.','/ho-so/don-hang/156',156,'order',0,'2026-06-16 06:31:36'),(40,1,'order_status','Đơn hàng #155 đang được xử lý','Cửa hàng đang chuẩn bị hàng cho bạn.','/ho-so/don-hang/155',155,'order',0,'2026-06-16 06:35:10'),(41,1,'order_status','Đơn hàng #156 đang được xử lý','Cửa hàng đang chuẩn bị hàng cho bạn.','/ho-so/don-hang/156',156,'order',0,'2026-06-16 06:48:52'),(42,1,'order_status','Đơn hàng #156 đang được giao','Đơn hàng đã được giao cho đơn vị vận chuyển.','/ho-so/don-hang/156',156,'order',0,'2026-06-16 06:49:23'),(43,1,'order_status','Đơn hàng #158 đang được xử lý','Cửa hàng đang chuẩn bị hàng cho bạn.','/ho-so/don-hang/158',158,'order',0,'2026-06-16 07:09:08'),(44,1,'order_status','Đơn hàng #158 đang được giao','Đơn hàng đã được giao cho đơn vị vận chuyển.','/ho-so/don-hang/158',158,'order',0,'2026-06-16 07:09:13'),(45,1,'order_status','Đơn hàng #156 đang được xử lý','Cửa hàng đang chuẩn bị hàng cho bạn.','/ho-so/don-hang/156',156,'order',0,'2026-06-16 07:20:14'),(46,1,'order_status','Đơn hàng #159 đang được giao','Đơn hàng đã được giao cho đơn vị vận chuyển.','/ho-so/don-hang/159',159,'order',0,'2026-06-16 07:21:36'),(47,1,'order_status','Đơn hàng #160 đã được xác nhận','Đơn hàng của bạn đang được xử lý bởi cửa hàng.','/ho-so/don-hang/160',160,'order',0,'2026-06-16 07:29:57'),(48,26,'order_status','Đơn hàng #162 đã được xác nhận','Đơn hàng của bạn đang được xử lý bởi cửa hàng.','/ho-so/don-hang/162',162,'order',0,'2026-06-16 08:03:19'),(49,1,'order_status','Đơn hàng #163 đã được xác nhận','Đơn hàng của bạn đang được xử lý bởi cửa hàng.','/ho-so/don-hang/163',163,'order',0,'2026-06-16 08:56:18'),(50,1,'order_status','Đơn hàng #164 đã được xác nhận','Đơn hàng của bạn đang được xử lý bởi cửa hàng.','/ho-so/don-hang/164',164,'order',0,'2026-06-16 09:03:05'),(51,30,'order_status','Đơn hàng #166 đã được xác nhận','Đơn hàng của bạn đang được xử lý bởi cửa hàng.','/ho-so/don-hang/166',166,'order',0,'2026-06-17 11:06:28'),(52,30,'order_status','Đơn hàng #167 đã được xác nhận','Đơn hàng của bạn đang được xử lý bởi cửa hàng.','/ho-so/don-hang/167',167,'order',0,'2026-06-18 16:48:58');
/*!40000 ALTER TABLE `user_notifications` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT 'customer',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `facebook_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `google_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `login_attempts` int DEFAULT '0',
  `lockout_until` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `is_email_verified` tinyint(1) DEFAULT '0',
  `locked_reason` varchar(500) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `email` (`email`) USING BTREE,
  KEY `idx_users_status` (`status`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'TaiPlatForm','test@gmail.com','e10adc3949ba59abbe56e057f20f883e','0999988887','USER','active','2026-01-19 15:29:44','2026-06-16 08:55:51',NULL,NULL,0,NULL,NULL,0,NULL),(22,'MANAGER','MANAGER@gmail.com','005f47cddf568dacb8d03e20ba682cf9','0332991661','MANAGER','active','2026-05-30 18:46:14','2026-05-30 18:51:45',NULL,NULL,0,NULL,NULL,0,NULL),(23,'STAFF_ORDER','STAFF_ORDER@gmail.com','005f47cddf568dacb8d03e20ba682cf9','0332991664','STAFF_ORDER','active','2026-05-30 18:49:45','2026-05-30 18:51:40',NULL,NULL,0,NULL,NULL,0,NULL),(24,'STAFF_CONTENT','STAFF_CONTENT@gmail.com','005f47cddf568dacb8d03e20ba682cf9','0332991664','STAFF_CONTENT','active','2026-05-30 18:50:23','2026-05-30 18:51:35',NULL,NULL,0,NULL,NULL,0,NULL),(25,'admin','admin@gmail.com','005f47cddf568dacb8d03e20ba682cf9','0332991664','ADMIN','active','2026-05-30 18:51:02','2026-06-16 06:27:40',NULL,NULL,0,NULL,NULL,0,NULL),(26,'Thúy Quỳnh','chauthithuyquynh2019@gmail.com','e7a82385fcef4020396ce7af972fd47d','','USER','active','2026-06-02 14:07:59','2026-06-16 03:00:05',NULL,'116918513405296513325',0,NULL,NULL,0,NULL),(27,'TaiPlatForm','taiplatform69@gmail.com','3799a40af02d431cff1d35f38d84f95c',NULL,'user','active','2026-06-02 16:16:34','2026-06-16 02:44:27',NULL,'100440059100524242624',0,NULL,NULL,1,NULL),(28,'Tài Chu Tấn','23130280@st.hcmuaf.edu.vn','',NULL,'user','active','2026-06-02 17:42:52','2026-06-02 17:42:52',NULL,'110421303411772693738',0,NULL,NULL,0,NULL),(29,'Phát Lý Đức','23130229@st.hcmuaf.edu.vn','',NULL,'user','active','2026-06-04 14:31:06','2026-06-04 14:31:06',NULL,'105362846938357529095',0,NULL,NULL,0,NULL),(30,'Ly Phat','lyphat0101@gmail.com','31e57ada965269c9ca841075822d083e',NULL,'user','active','2026-06-04 14:31:30','2026-06-16 06:06:58',NULL,'106472562664895973906',0,NULL,NULL,1,NULL),(31,'Hoàng Long','1641805956967981@facebook.com','',NULL,'USER','active','2026-06-04 15:24:08','2026-06-04 15:24:08','1641805956967981',NULL,0,NULL,NULL,0,NULL),(32,'lyphat','lyphat1234@gmail.com','10b363b8a00453bed35fc6f059c8066f','0911112222','user','active','2026-06-04 15:47:15','2026-06-04 15:47:15',NULL,NULL,0,NULL,NULL,0,NULL),(33,'LyPhat','lydphat@gmail.com','10b363b8a00453bed35fc6f059c8066f','0933334444','user','active','2026-06-04 15:51:13','2026-06-04 15:51:13',NULL,NULL,0,NULL,NULL,0,NULL),(34,'Tài','1647122389774305@facebook.com','','','USER','active','2026-06-11 08:41:22','2026-06-16 02:55:05','1647122389774305',NULL,0,NULL,NULL,0,NULL);
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `wishlists`
--

DROP TABLE IF EXISTS `wishlists`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `wishlists` (
  `id` int NOT NULL AUTO_INCREMENT,
  `user_id` int NOT NULL,
  `product_id` int NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `unique_user_product` (`user_id`,`product_id`) USING BTREE,
  KEY `product_id` (`product_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  CONSTRAINT `wishlists_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `wishlists_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `wishlists`
--

LOCK TABLES `wishlists` WRITE;
/*!40000 ALTER TABLE `wishlists` DISABLE KEYS */;
INSERT INTO `wishlists` VALUES (50,1,183,'2026-06-04 15:31:24'),(51,1,184,'2026-06-04 15:31:24'),(52,1,179,'2026-06-04 15:31:25'),(53,1,178,'2026-06-04 15:31:26'),(54,1,177,'2026-06-04 15:31:27'),(55,1,189,'2026-06-04 15:31:57'),(63,25,114,'2026-06-10 17:58:31'),(64,1,187,'2026-06-11 08:09:38'),(65,1,181,'2026-06-11 08:09:54'),(66,1,182,'2026-06-11 08:09:54'),(67,1,180,'2026-06-11 08:09:55'),(68,25,48,'2026-06-14 11:07:49'),(69,25,96,'2026-06-14 11:07:51'),(70,25,107,'2026-06-14 11:07:56'),(75,26,189,'2026-06-14 18:34:02'),(77,26,186,'2026-06-14 18:34:03');
/*!40000 ALTER TABLE `wishlists` ENABLE KEYS */;
UNLOCK TABLES;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-06-24  4:28:53
