-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: Oct 25, 2025 at 12:58 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `riderekta_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `contact_messages`
--

CREATE TABLE `contact_messages` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `surname` varchar(100) NOT NULL,
  `email` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `reply` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact_messages`
--

INSERT INTO `contact_messages` (`id`, `user_id`, `name`, `surname`, `email`, `message`, `reply`, `created_at`) VALUES
(1, 1, 'f', 'ff', 'test@gmail.com', 'helylesfa', NULL, '2025-10-13 05:53:49'),
(2, 1, 'gh', 'vv', 'test@gmail.com', 'vv', NULL, '2025-10-13 14:05:38'),
(3, 1, 'guest', 'guest', 'test@gmail.com', 'hello I would like to reach out', 'ok', '2025-10-13 14:50:21'),
(4, 2, 'chubby', 'dog', 'blackpink@gmail.com', 'arf', 'meow', '2025-10-13 15:02:19'),
(5, 1, 'yesha', 'lao', 'test@gmail.com', 'hello', NULL, '2025-10-15 07:26:55'),
(6, 1, 'john', 'johnyyy', 'test@gmail.com', 'hello', NULL, '2025-10-20 11:49:08'),
(7, 1, 'vb', 'hg', 'test@gmail.com', 'bb', NULL, '2025-10-20 15:34:55');

-- --------------------------------------------------------

--
-- Table structure for table `content`
--

CREATE TABLE `content` (
  `id` int(11) NOT NULL,
  `about_title` varchar(255) DEFAULT NULL,
  `about_subtitle` varchar(255) DEFAULT NULL,
  `about_text1` text DEFAULT NULL,
  `about_text2` text DEFAULT NULL,
  `about_footer` text DEFAULT NULL,
  `team_text` text DEFAULT NULL,
  `benefits_intro` text DEFAULT NULL,
  `benefits_highlights` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `content`
--

INSERT INTO `content` (`id`, `about_title`, `about_subtitle`, `about_text1`, `about_text2`, `about_footer`, `team_text`, `benefits_intro`, `benefits_highlights`) VALUES
(1, 'RIDEREKTA', 'Your E-Bike\'s New Navigator', 'Eco-Friendly Navigation for All', 'Get safe and legal e-bike routes that avoid highways and prioritize rider safety.', 'Continuous Improvement: Give feedback directly and help improve local routes for everyone\'s satisfaction.', 'Riderekta is built by a dedicated team of innovators, developers, and cyclists who believe in safer, smarter transportation.', 'Riderekta is an e-bike navigation app designed to simplify daily rides and improve route safety.', 'Optimized routes, safe lanes, and community features for every e-bike rider.');

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `message` text NOT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `message`, `attachment`, `created_at`) VALUES
(1, 'Suggestion: improve Ur app lol', '1760190291_1759248792835.jpg', '2025-10-11 13:44:51'),
(2, 'Suggestion: improve Ur app lol', '1760190291_1759248792835.jpg', '2025-10-11 13:44:51'),
(3, 'Suggestion: improve Ur app lol', '1760190293_1759248792835.jpg', '2025-10-11 13:44:53'),
(4, 'Suggestion: improve Ur app lol', '1760190294_1759248792835.jpg', '2025-10-11 13:44:54'),
(5, 'Suggestion: improve Ur app lol', '1760190296_1759248792835.jpg', '2025-10-11 13:44:56'),
(6, 'Bug Report:', '1760196333_20251001_164814.jpg', '2025-10-11 15:25:33'),
(7, 'Bug Report: buf', '1760196363_20251001_164814.jpg', '2025-10-11 15:26:03'),
(8, 'Bug Report: buf', '1760196374_20251001_164814.jpg', '2025-10-11 15:26:14'),
(9, 'Bug Report: buf', '1760196377_20251001_164814.jpg', '2025-10-11 15:26:17'),
(10, 'Bug Report: buf', '1760196388_20251001_164814.jpg', '2025-10-11 15:26:28'),
(11, 'Bug Report: buf', '1760196389_20251001_164814.jpg', '2025-10-11 15:26:29'),
(12, 'Bug Report: buf', '1760196395_20251001_164814.jpg', '2025-10-11 15:26:35'),
(13, 'Bug Report: buf', '1760196404_20251001_164814.jpg', '2025-10-11 15:26:44'),
(14, 'Bug Report: buf', '1760196405_20251001_164814.jpg', '2025-10-11 15:26:45'),
(15, 'Bug Report: buf', '1760196407_20251001_164814.jpg', '2025-10-11 15:26:47'),
(17, 'Suggestion: yes', '1760196799_Screenshot_20251011_232217.jpg', '2025-10-11 15:33:19'),
(18, 'ed', '', '2025-10-13 05:13:55'),
(19, 'Suggestion: hfnd', '', '2025-10-13 14:14:27'),
(20, 'Bug Report:', '', '2025-10-20 11:50:29'),
(21, 'Suggestion:', '', '2025-10-20 15:34:37');

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` int(11) NOT NULL,
  `author` varchar(100) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `content` text DEFAULT NULL,
  `likes` int(11) DEFAULT 0,
  `comments` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `author`, `title`, `content`, `likes`, `comments`, `created_at`) VALUES
(1, 'Anonymous', 'Title', 'Content', 0, 0, '2025-10-10 02:54:45'),
(2, 'test', 'Hello', 'What\'s in my minf', 0, 0, '2025-10-10 03:04:21'),
(3, 'test', 'ffff', 'ff', 0, 0, '2025-10-13 05:19:22'),
(4, 'guest', 'hello', 'jeje', 0, 0, '2025-10-13 14:09:39');

-- --------------------------------------------------------

--
-- Table structure for table `route_history`
--

CREATE TABLE `route_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `startName` varchar(255) DEFAULT NULL,
  `endName` varchar(255) DEFAULT NULL,
  `distance` varchar(50) DEFAULT NULL,
  `duration` varchar(50) DEFAULT NULL,
  `timestamp` varchar(50) DEFAULT NULL,
  `startLat` double DEFAULT NULL,
  `startLon` double DEFAULT NULL,
  `endLat` double DEFAULT NULL,
  `endLon` double DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `route_history`
--

INSERT INTO `route_history` (`id`, `user_id`, `startName`, `endName`, `distance`, `duration`, `timestamp`, `startLat`, `startLon`, `endLat`, `endLon`) VALUES
(1, 1, '4, Brahms Street, Ideal Subdivision, Commonwealth, 2nd District, Quezon City, Eastern Manila District, Metro Manila, 1121, Philippines', '10, Brahms Street, Ideal Subdivision, Commonwealth, 2nd District, Quezon City, Eastern Manila District, Metro Manila, 1121, Philippines', '0.0357', '0.086666666666667', '2025-10-21T00:26:33.666442', 14.699735, 121.0735994, 14.699849384952039, 121.0740113873047),
(2, 1, '10, Brahms Street, Ideal Subdivision, Commonwealth, 2nd District, Quezon City, Eastern Manila District, Metro Manila, 1121, Philippines', 'Aduana Street, New Intramuros Village Park, Matandang Balara, 3rd District, Quezon City, Eastern Manila District, Metro Manila, 1119, Philippines', '6.6097', '10.338333333333', '2025-10-21T01:03:16.913278', 14.6997716, 121.0740452, 14.670605909509028, 121.0735932138007),
(3, 1, '10, Brahms Street, Ideal Subdivision, Commonwealth, 2nd District, Quezon City, Eastern Manila District, Metro Manila, 1121, Philippines', 'Aduana Street, New Intramuros Village Park, Matandang Balara, 3rd District, Quezon City, Eastern Manila District, Metro Manila, 1119, Philippines', '6.6097', '10.338333333333', '2025-10-21T01:03:39.410601', 14.6997716, 121.0740452, 14.670605909509028, 121.0735932138007),
(4, 1, '4, Brahms Street, Ideal Subdivision, Commonwealth, 2nd District, Quezon City, Eastern Manila District, Metro Manila, 1121, Philippines', 'Mapúa University, 658, Muralla Street, Barangay 658, Intramuros, Fifth District, Manila, Capital District, Metro Manila, 1002, Philippines', '21.1017', '29.046666666667', '2025-10-21T01:20:12.843688', 14.6997032, 121.0735455, 14.5905004, 120.9780808),
(5, 1, '4, Brahms Street, Ideal Subdivision, Commonwealth, 2nd District, Quezon City, Eastern Manila District, Metro Manila, 1121, Philippines', 'Liszt Street, Ideal Subdivision, Commonwealth, 2nd District, Quezon City, Eastern Manila District, Metro Manila, 1121, Philippines', '0.4526', '1.245', '2025-10-21T01:40:05.879431', 14.6997319, 121.0735631, 14.698886925421988, 121.07647752871095),
(6, 11, '4, Brahms Street, Ideal Subdivision, Commonwealth, 2nd District, Quezon City, Eastern Manila District, Metro Manila, 1121, Philippines', 'Rowhouse Street, Commonwealth, 2nd District, Quezon City, Eastern Manila District, Metro Manila, 1121, Philippines', '3.2775', '7.8016666666667', '2025-10-21T16:41:46.133733', 14.6997169, 121.0735686, 14.698532458650869, 121.07755114394533),
(7, 11, '4, Brahms Street, Ideal Subdivision, Commonwealth, 2nd District, Quezon City, Eastern Manila District, Metro Manila, 1121, Philippines', 'Rowhouse Street, Commonwealth, 2nd District, Quezon City, Eastern Manila District, Metro Manila, 1121, Philippines', '3.2775', '7.8016666666667', '2025-10-21T16:41:54.425462', 14.6997169, 121.0735686, 14.698532458650869, 121.07755114394533),
(8, 1, 'Mapúa University Makati, Kakarong Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', 'Tayum, Abra, Cordillera Administrative Region, 2803, Philippines', '420.0924', '401.34666666667', '2025-10-22T14:10:46.247582', 14.5662418, 121.0155272, 17.6180712, 120.6535488),
(9, 1, 'Mapúa University Makati, Kakarong Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', 'Navotas, Northern Manila District, Metro Manila, Philippines', '20.0915', '25.295', '2025-10-22T14:11:19.644907', 14.5663512, 121.0155077, 14.5343549, 121.0514518),
(10, 1, 'Mapúa University Makati, Kakarong Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', 'McDonald\'s, Upper McKinley Road, Woodridge I, Pinagsama, Taguig District 2, Taguig, Southern Manila District, Metro Manila, 1634, Philippines', '15.9294', '23.546666666667', '2025-10-22T14:11:20.549692', 14.5663512, 121.0155077, 14.5343549, 121.0514518),
(11, 1, 'Mapúa University Makati, Kakarong Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', 'McDonald\'s, Upper McKinley Road, Woodridge I, Pinagsama, Taguig District 2, Taguig, Southern Manila District, Metro Manila, 1634, Philippines', '6.3446', '9.9583333333333', '2025-10-22T14:11:24.246885', 14.5663512, 121.0155077, 14.5343549, 121.0514518),
(12, 1, 'Mapúa University Makati, Kakarong Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', 'Mapúa University Makati, Kakarong Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', '0.0022', '0.0033333333333333', '2025-10-22T14:11:59.911670', 14.56633, 121.0154803, 14.56633000931423, 121.01550227574897),
(13, 1, 'Mapúa University Makati, Kakarong Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', 'Mapúa University Makati, Kakarong Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', '0.1993', '0.53', '2025-10-22T14:12:02.733978', 14.56633, 121.0154803, 14.56633000931423, 121.01550227574897),
(14, 1, 'Mapúa University Makati, Kakarong Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', 'Mapúa University Makati, Kakarong Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', '0.0023', '0.005', '2025-10-22T14:12:03.668704', 14.56633, 121.0154803, 14.566578219885463, 121.0155982321016),
(15, 1, 'Mapúa University Makati, Kakarong Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', 'Pablo Ocampo Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', '0.0108', '0.02', '2025-10-22T14:12:06.670322', 14.56633, 121.0154803, 14.566578219885463, 121.0155982321016),
(16, 1, 'Mapúa University Makati, Kakarong Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', 'Pablo Ocampo Street, Santa Cruz, District I, Makati, Southern Manila District, Metro Manila, 1205, Philippines', '0.0108', '0.02', '2025-10-22T14:12:22.746125', 14.56633, 121.0154803, 14.566578219885463, 121.0155982321016);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `password` varchar(100) NOT NULL,
  `isActive` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `mobile`, `password`, `isActive`) VALUES
(1, 'test', 'test@gmail.com', '102921918', '1234', 1),
(2, NULL, 'blackpink@gmail.com', NULL, '1234', 1),
(6, 'john', 'john@gmail.com', '727271', '$2y$10$A48jpM4ggljT6OVqQ87ar.5mGcBnrGRTGVsv/G1HGKlADZ/ELVPnq', 1),
(7, 'cat', 'cat@gmail.com', '727372', '$2y$10$nbJmfs591PeRvfFoAQwlqeazZF/rBPKrsUZ3C3Nc3fpilbGLEpB0m', 1),
(10, 'John doe', 'doe@gmail.com', '838282', '123', 1),
(11, 'stew', 'stew@gmail.com', '1282992', 'stew', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_contact_user` (`user_id`);

--
-- Indexes for table `content`
--
ALTER TABLE `content`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `route_history`
--
ALTER TABLE `route_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `contact_messages`
--
ALTER TABLE `contact_messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `content`
--
ALTER TABLE `content`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `route_history`
--
ALTER TABLE `route_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `contact_messages`
--
ALTER TABLE `contact_messages`
  ADD CONSTRAINT `fk_contact_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `route_history`
--
ALTER TABLE `route_history`
  ADD CONSTRAINT `route_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
