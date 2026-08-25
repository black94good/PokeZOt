-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 05/07/2025 às 05:41
-- Versão do servidor: 10.4.32-MariaDB
-- Versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `curso`
--

-- --------------------------------------------------------

--
-- Estrutura para tabela `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL,
  `name` varchar(32) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL,
  `premdays` int(11) NOT NULL DEFAULT 0,
  `lastday` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `email` varchar(255) NOT NULL DEFAULT '',
  `key` varchar(20) NOT NULL DEFAULT '0',
  `blocked` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'internal usage',
  `warnings` int(11) NOT NULL DEFAULT 0,
  `group_id` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `accounts`
--

INSERT INTO `accounts` (`id`, `name`, `password`, `premdays`, `lastday`, `email`, `key`, `blocked`, `warnings`, `group_id`) VALUES
(1, '1', '1', 65535, 0, '', '0', 0, 0, 1),
(2, 'god', '21298df8a3277357ee55b01df9530b535cf08ec1', 0, 1751683974, '', '0', 0, 0, 1);

--
-- Acionadores `accounts`
--
DELIMITER $$
CREATE TRIGGER `ondelete_accounts` BEFORE DELETE ON `accounts` FOR EACH ROW BEGIN
	DELETE FROM `bans` WHERE `type` IN (3, 4) AND `value` = OLD.`id`;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `account_viplist`
--

CREATE TABLE `account_viplist` (
  `account_id` int(11) NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `player_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `bans`
--

CREATE TABLE `bans` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` tinyint(1) NOT NULL COMMENT '1 - ip banishment, 2 - namelock, 3 - account banishment, 4 - notation, 5 - deletion',
  `value` int(10) UNSIGNED NOT NULL COMMENT 'ip address (integer), player guid or account number',
  `param` int(10) UNSIGNED NOT NULL DEFAULT 4294967295 COMMENT 'used only for ip banishment mask (integer)',
  `active` tinyint(1) NOT NULL DEFAULT 1,
  `expires` int(11) NOT NULL,
  `added` int(10) UNSIGNED NOT NULL,
  `admin_id` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `comment` text NOT NULL,
  `reason` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `action` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `statement` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `environment_killers`
--

CREATE TABLE `environment_killers` (
  `kill_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `global_storage`
--

CREATE TABLE `global_storage` (
  `key` int(10) UNSIGNED NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `value` varchar(255) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guilds`
--

CREATE TABLE `guilds` (
  `id` int(11) NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `ownerid` int(11) NOT NULL,
  `creationdata` int(11) NOT NULL,
  `motd` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Acionadores `guilds`
--
DELIMITER $$
CREATE TRIGGER `oncreate_guilds` AFTER INSERT ON `guilds` FOR EACH ROW BEGIN
	INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Leader', 3, NEW.`id`);
	INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Vice-Leader', 2, NEW.`id`);
	INSERT INTO `guild_ranks` (`name`, `level`, `guild_id`) VALUES ('Member', 1, NEW.`id`);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ondelete_guilds` BEFORE DELETE ON `guilds` FOR EACH ROW BEGIN
	UPDATE `players` SET `guildnick` = '', `rank_id` = 0 WHERE `rank_id` IN (SELECT `id` FROM `guild_ranks` WHERE `guild_id` = OLD.`id`);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guild_invites`
--

CREATE TABLE `guild_invites` (
  `player_id` int(11) NOT NULL DEFAULT 0,
  `guild_id` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `guild_ranks`
--

CREATE TABLE `guild_ranks` (
  `id` int(11) NOT NULL,
  `guild_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `level` int(11) NOT NULL COMMENT '1 - leader, 2 - vice leader, 3 - member'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `houses`
--

CREATE TABLE `houses` (
  `id` int(10) UNSIGNED NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `owner` int(11) NOT NULL,
  `paid` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `warnings` int(11) NOT NULL DEFAULT 0,
  `lastwarning` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `town` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `size` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `price` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `rent` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `doors` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `beds` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `tiles` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `guild` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `clear` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `houses`
--

INSERT INTO `houses` (`id`, `world_id`, `owner`, `paid`, `warnings`, `lastwarning`, `name`, `town`, `size`, `price`, `rent`, `doors`, `beds`, `tiles`, `guild`, `clear`) VALUES
(127, 0, 0, 0, 0, 0, 'Viridian House #127', 6, 134, 378000, 0, 5, 0, 189, 0, 0),
(128, 0, 0, 0, 0, 0, 'Viridian House #128', 6, 134, 362000, 0, 4, 0, 181, 0, 0),
(129, 0, 0, 0, 0, 0, 'Viridian House #129', 6, 150, 478000, 0, 5, 0, 239, 0, 0),
(130, 0, 0, 0, 0, 0, 'Viridian House #130', 6, 78, 274000, 0, 2, 0, 137, 0, 0),
(131, 0, 0, 0, 0, 0, 'Viridian House #131', 6, 65, 252000, 0, 2, 0, 126, 0, 0),
(132, 0, 0, 0, 0, 0, 'Viridian House #132', 6, 56, 200000, 0, 2, 0, 100, 0, 0),
(133, 0, 0, 0, 0, 0, 'Viridian House #133', 6, 40, 142000, 0, 1, 0, 71, 0, 0),
(134, 0, 0, 0, 0, 0, 'Viridian House #134', 6, 78, 374000, 0, 3, 0, 187, 0, 0),
(135, 0, 0, 0, 0, 0, 'Viridian House #135', 6, 20, 152000, 0, 2, 0, 76, 0, 0),
(136, 0, 0, 0, 0, 0, 'Viridian House #136', 6, 20, 84000, 0, 0, 0, 42, 0, 0),
(137, 0, 0, 0, 0, 0, 'Viridian House #137', 6, 54, 148000, 0, 1, 0, 74, 0, 0),
(138, 0, 0, 0, 0, 0, 'Viridian House #138', 6, 56, 304000, 0, 1, 0, 152, 0, 0),
(139, 0, 0, 0, 0, 0, 'Viridian House #139', 6, 70, 282000, 0, 1, 0, 141, 0, 0),
(140, 0, 0, 0, 0, 0, 'Viridian House #140', 6, 54, 214000, 0, 3, 0, 107, 0, 0),
(141, 0, 0, 0, 0, 0, 'Viridian House #141', 6, 54, 170000, 0, 3, 0, 85, 0, 0),
(143, 0, 0, 0, 0, 0, 'Pewter House #143', 8, 50, 162000, 0, 1, 0, 81, 0, 0),
(144, 0, 0, 0, 0, 0, 'Pewter House #144', 8, 65, 206000, 0, 2, 0, 103, 0, 0),
(145, 0, 0, 0, 0, 0, 'Pewter House #145', 8, 78, 282000, 0, 2, 0, 141, 0, 0),
(146, 0, 0, 0, 0, 0, 'Pewter House #146', 8, 67, 226000, 0, 2, 0, 113, 0, 0),
(147, 0, 0, 0, 0, 0, 'Pewter House #147', 8, 66, 228000, 0, 2, 0, 114, 0, 0),
(148, 0, 0, 0, 0, 0, 'Pewter House #148', 8, 38, 112000, 0, 1, 0, 56, 0, 0),
(149, 0, 0, 0, 0, 0, 'Pewter House #149', 8, 28, 204000, 0, 1, 0, 102, 0, 0),
(150, 0, 0, 0, 0, 0, 'Pewter House #150', 8, 24, 94000, 0, 1, 0, 47, 0, 0),
(151, 0, 0, 0, 0, 0, 'Pewter House #151', 8, 49, 160000, 0, 1, 0, 80, 0, 0),
(152, 0, 0, 0, 0, 0, 'Pewter House #152', 8, 98, 322000, 0, 1, 0, 161, 0, 0),
(153, 0, 0, 0, 0, 0, 'Pewter House #153', 8, 98, 356000, 0, 2, 0, 178, 0, 0),
(154, 0, 0, 0, 0, 0, 'Pewter House #154', 8, 110, 336000, 0, 2, 0, 168, 0, 0),
(155, 0, 0, 0, 0, 0, 'Pewter House #155', 8, 48, 154000, 0, 2, 0, 77, 0, 0),
(156, 0, 0, 0, 0, 0, 'Pewter House #156', 8, 48, 214000, 0, 1, 0, 107, 0, 0),
(157, 0, 0, 0, 0, 0, 'Pewter House #157', 8, 36, 230000, 0, 1, 0, 115, 0, 0),
(158, 0, 0, 0, 0, 0, 'Pewter House #158', 8, 42, 132000, 0, 1, 0, 66, 0, 0),
(160, 0, 0, 0, 0, 0, 'Cerulean House #160', 2, 51, 312000, 0, 4, 0, 156, 0, 0),
(161, 0, 0, 0, 0, 0, 'Cerulean House #161', 2, 25, 112000, 0, 1, 0, 56, 0, 0),
(162, 0, 0, 0, 0, 0, 'Cerulean House #162', 2, 25, 84000, 0, 1, 0, 42, 0, 0),
(163, 0, 0, 0, 0, 0, 'Cerulean House #163', 2, 38, 230000, 0, 3, 0, 115, 0, 0),
(164, 0, 0, 0, 0, 0, 'Cerulean House #164', 2, 25, 112000, 0, 2, 0, 56, 0, 0),
(165, 0, 0, 0, 0, 0, 'Cerulean House #165', 2, 52, 204000, 0, 2, 0, 102, 0, 0),
(166, 0, 0, 0, 0, 0, 'Cerulean House #166', 2, 40, 134000, 0, 2, 0, 67, 0, 0),
(167, 0, 0, 0, 0, 0, 'Cerulean House #167', 2, 95, 344000, 0, 3, 0, 172, 0, 0),
(168, 0, 0, 0, 0, 0, 'Cerulean House #168', 2, 78, 756000, 0, 3, 0, 378, 0, 0),
(169, 0, 0, 0, 0, 0, 'Cerulean House #169', 2, 75, 280000, 0, 2, 0, 140, 0, 0),
(171, 0, 0, 0, 0, 0, 'Cerulean House #171', 2, 22, 74000, 0, 1, 0, 37, 0, 0),
(172, 0, 0, 0, 0, 0, 'Cerulean House #172', 2, 125, 440000, 0, 3, 0, 220, 0, 0),
(173, 0, 0, 0, 0, 0, 'Cerulean House #173', 2, 50, 196000, 0, 1, 0, 98, 0, 0),
(174, 0, 0, 0, 0, 0, 'Cerulean House #174', 2, 10, 56000, 0, 1, 0, 28, 0, 0),
(176, 0, 0, 0, 0, 0, 'Cerulean House #176', 2, 21, 84000, 0, 2, 0, 42, 0, 0),
(177, 0, 0, 0, 0, 0, 'Cerulean House #177', 2, 21, 90000, 0, 2, 0, 45, 0, 0),
(178, 0, 0, 0, 0, 0, 'Cerulean House #178', 2, 21, 98000, 0, 2, 0, 49, 0, 0),
(179, 0, 0, 0, 0, 0, 'Cerulean House #179', 2, 24, 100000, 0, 1, 0, 50, 0, 0),
(180, 0, 0, 0, 0, 0, 'Cerulean House #180', 2, 20, 96000, 0, 2, 0, 48, 0, 0),
(181, 0, 0, 0, 0, 0, 'Cerulean House #181', 2, 20, 82000, 0, 2, 0, 41, 0, 0),
(182, 0, 0, 0, 0, 0, 'Cerulean House #182', 2, 65, 240000, 0, 1, 0, 120, 0, 0),
(183, 0, 0, 0, 0, 0, 'Celadon House #183', 5, 72, 238000, 0, 1, 0, 119, 0, 0),
(184, 0, 0, 0, 0, 0, 'Celadon House #184', 5, 70, 240000, 0, 2, 0, 120, 0, 0),
(185, 0, 0, 0, 0, 0, 'Celadon House #185', 5, 69, 232000, 0, 2, 0, 116, 0, 0),
(186, 0, 0, 0, 0, 0, 'Celadon House #186', 5, 70, 232000, 0, 2, 0, 116, 0, 0),
(187, 0, 0, 0, 0, 0, 'Celadon House #187', 5, 80, 240000, 0, 1, 0, 120, 0, 0),
(188, 0, 0, 0, 0, 0, 'Celadon House #188', 5, 80, 240000, 0, 1, 0, 120, 0, 0),
(189, 0, 0, 0, 0, 0, 'Celadon House #189', 5, 80, 226000, 0, 1, 0, 113, 0, 0),
(190, 0, 0, 0, 0, 0, 'Celadon House #190', 5, 81, 210000, 0, 1, 0, 105, 0, 0),
(191, 0, 0, 0, 0, 0, 'Celadon House #191', 5, 122, 364000, 0, 2, 0, 182, 0, 0),
(192, 0, 0, 0, 0, 0, 'Celadon House #192', 5, 133, 398000, 0, 2, 0, 199, 0, 0),
(193, 0, 0, 0, 0, 0, 'Celadon House #193', 5, 128, 402000, 0, 3, 0, 201, 0, 0),
(194, 0, 0, 0, 0, 0, 'Celadon House #194', 5, 130, 376000, 0, 2, 0, 188, 0, 0),
(195, 0, 0, 0, 0, 0, 'Celadon House #195', 5, 44, 128000, 0, 1, 0, 64, 0, 0),
(196, 0, 0, 0, 0, 0, 'Celadon House #196', 5, 152, 416000, 0, 2, 0, 208, 0, 0),
(197, 0, 0, 0, 0, 0, 'Celadon House #197', 5, 123, 466000, 0, 4, 0, 233, 0, 0),
(198, 0, 0, 0, 0, 0, 'Celadon House #198', 5, 98, 268000, 0, 1, 0, 134, 0, 0),
(199, 0, 0, 0, 0, 0, 'Celadon House #199', 5, 124, 358000, 0, 1, 0, 179, 0, 0),
(200, 0, 0, 0, 0, 0, 'Celadon House #200', 5, 49, 148000, 0, 1, 0, 74, 0, 0),
(201, 0, 0, 0, 0, 0, 'Celadon House #201', 5, 85, 268000, 0, 3, 0, 134, 0, 0),
(202, 0, 0, 0, 0, 0, 'Celadon House #202', 5, 110, 310000, 0, 2, 0, 155, 0, 0),
(203, 0, 0, 0, 0, 0, 'Celadon House #203', 5, 105, 302000, 0, 3, 0, 151, 0, 0),
(204, 0, 0, 0, 0, 0, 'Celadon House #204', 5, 84, 288000, 0, 3, 0, 144, 0, 0),
(205, 0, 0, 0, 0, 0, 'Celadon House #205', 5, 66, 200000, 0, 1, 0, 100, 0, 0),
(206, 0, 0, 0, 0, 0, 'Celadon House #206', 5, 110, 334000, 0, 2, 0, 167, 0, 0),
(207, 0, 0, 0, 0, 0, 'Celadon House #207', 5, 63, 196000, 0, 2, 0, 98, 0, 0),
(208, 0, 0, 0, 0, 0, 'Celadon House #208', 5, 260, 822000, 0, 4, 0, 411, 0, 0),
(209, 0, 0, 0, 0, 0, 'Celadon House #209', 5, 138, 466000, 0, 4, 0, 233, 0, 0),
(210, 0, 0, 0, 0, 0, 'Celadon House #210', 5, 137, 432000, 0, 4, 0, 216, 0, 0),
(211, 0, 0, 0, 0, 0, 'Celadon House #211', 5, 126, 464000, 0, 4, 0, 232, 0, 0),
(212, 0, 0, 0, 0, 0, 'Celadon House #212', 5, 83, 250000, 0, 1, 0, 125, 0, 0),
(213, 0, 0, 0, 0, 0, 'Saffron House #213', 1, 28, 106000, 0, 1, 0, 53, 0, 0),
(216, 0, 0, 0, 0, 0, 'Saffron House #216', 1, 49, 142000, 0, 1, 0, 71, 0, 0),
(217, 0, 0, 0, 0, 0, 'Saffron House #217', 1, 49, 160000, 0, 1, 0, 80, 0, 0),
(218, 0, 0, 0, 0, 0, 'Saffron House #218', 1, 49, 158000, 0, 1, 0, 79, 0, 0),
(219, 0, 0, 0, 0, 0, 'Saffron House #219', 1, 56, 186000, 0, 2, 0, 93, 0, 0),
(220, 0, 0, 0, 0, 0, 'Saffron House #220', 1, 20, 82000, 0, 1, 0, 41, 0, 0),
(221, 0, 0, 0, 0, 0, 'Saffron House #221', 1, 35, 106000, 0, 1, 0, 53, 0, 0),
(222, 0, 0, 0, 0, 0, 'Saffron House #222', 1, 36, 120000, 0, 2, 0, 60, 0, 0),
(223, 0, 0, 0, 0, 0, 'Saffron House #223', 1, 40, 120000, 0, 1, 0, 60, 0, 0),
(224, 0, 0, 0, 0, 0, 'Saffron House #224', 1, 24, 96000, 0, 1, 0, 48, 0, 0),
(225, 0, 0, 0, 0, 0, 'Saffron House #225', 1, 53, 224000, 0, 0, 4, 112, 0, 0),
(226, 0, 0, 0, 0, 0, 'Saffron House #226', 1, 64, 218000, 0, 0, 6, 109, 0, 0),
(227, 0, 0, 0, 0, 0, 'Saffron House #227', 1, 35, 114000, 0, 2, 0, 57, 0, 0),
(228, 0, 0, 0, 0, 0, 'Saffron House #228', 1, 35, 136000, 0, 2, 0, 68, 0, 0),
(229, 0, 0, 0, 0, 0, 'Saffron House #229', 1, 35, 108000, 0, 1, 0, 54, 0, 0),
(230, 0, 0, 0, 0, 0, 'Saffron House #230', 1, 35, 122000, 0, 1, 0, 61, 0, 0),
(231, 0, 0, 0, 0, 0, 'Saffron House #231', 1, 70, 202000, 0, 2, 0, 101, 0, 0),
(232, 0, 0, 0, 0, 0, 'Saffron House #232', 1, 35, 110000, 0, 1, 0, 55, 0, 0),
(233, 0, 0, 0, 0, 0, 'Saffron House #233', 1, 55, 162000, 0, 2, 0, 81, 0, 0),
(234, 0, 0, 0, 0, 0, 'Saffron House #234', 1, 80, 240000, 0, 2, 0, 120, 0, 0),
(235, 0, 0, 0, 0, 0, 'Saffron House #235', 1, 45, 112000, 0, 2, 0, 56, 0, 0),
(236, 0, 0, 0, 0, 0, 'Saffron House #236', 1, 54, 170000, 0, 1, 0, 85, 0, 0),
(237, 0, 0, 0, 0, 0, 'Saffron House #237', 1, 142, 448000, 0, 1, 2, 224, 0, 0),
(238, 0, 0, 0, 0, 0, 'Saffron House #238', 1, 76, 328000, 0, 1, 2, 164, 0, 0),
(239, 0, 0, 0, 0, 0, 'Saffron House #239', 1, 202, 672000, 0, 5, 2, 336, 0, 0),
(240, 0, 0, 0, 0, 0, 'Saffron House #240', 1, 97, 308000, 0, 1, 0, 154, 0, 0),
(241, 0, 0, 0, 0, 0, 'Saffron House #241', 1, 98, 284000, 0, 1, 0, 142, 0, 0),
(242, 0, 0, 0, 0, 0, 'Saffron House #242', 1, 72, 240000, 0, 1, 0, 120, 0, 0),
(243, 0, 0, 0, 0, 0, 'Saffron House #243', 1, 98, 316000, 0, 0, 0, 158, 0, 0),
(245, 0, 0, 0, 0, 0, 'Saffron House #245', 1, 69, 236000, 0, 1, 2, 118, 0, 0),
(248, 0, 0, 0, 0, 0, 'Saffron House #248', 1, 0, 30000, 0, 0, 0, 15, 0, 0),
(250, 0, 0, 0, 0, 0, 'Saffron House #250', 1, 125, 320000, 0, 1, 8, 160, 0, 0),
(251, 0, 0, 0, 0, 0, 'Saffron House #251', 1, 16, 56000, 0, 1, 2, 28, 0, 0),
(252, 0, 0, 0, 0, 0, 'Saffron House #252', 1, 23, 84000, 0, 1, 2, 42, 0, 0),
(253, 0, 0, 0, 0, 0, 'Saffron House #253', 1, 18, 82000, 0, 1, 2, 41, 0, 0),
(254, 0, 0, 0, 0, 0, 'Saffron House #254', 1, 45, 142000, 0, 0, 2, 71, 0, 0),
(255, 0, 0, 0, 0, 0, 'Saffron House #255', 1, 54, 160000, 0, 0, 2, 80, 0, 0),
(256, 0, 0, 0, 0, 0, 'Saffron House #256', 1, 16, 56000, 0, 1, 0, 28, 0, 0),
(257, 0, 0, 0, 0, 0, 'Saffron House #257', 1, 18, 60000, 0, 1, 2, 30, 0, 0),
(258, 0, 0, 0, 0, 0, 'Saffron House #258', 1, 18, 70000, 0, 1, 2, 35, 0, 0),
(259, 0, 0, 0, 0, 0, 'Saffron House #259', 1, 56, 202000, 0, 3, 2, 101, 0, 0),
(260, 0, 0, 0, 0, 0, 'Saffron House #260', 1, 26, 84000, 0, 1, 2, 42, 0, 0),
(261, 0, 0, 0, 0, 0, 'Saffron House #261', 1, 40, 140000, 0, 4, 4, 70, 0, 0),
(262, 0, 0, 0, 0, 0, 'Saffron House #262', 1, 33, 120000, 0, 1, 2, 60, 0, 0),
(263, 0, 0, 0, 0, 0, 'Saffron House #263', 1, 19, 68000, 0, 1, 2, 34, 0, 0),
(264, 0, 0, 0, 0, 0, 'Saffron House #264', 1, 56, 200000, 0, 3, 2, 100, 0, 0),
(265, 0, 0, 0, 0, 0, 'Saffron House #265', 1, 170, 526000, 0, 6, 0, 263, 0, 0),
(267, 0, 0, 0, 0, 0, 'Saffron House #267', 1, 132, 524000, 0, 4, 8, 262, 0, 0),
(268, 0, 0, 0, 0, 0, 'Saffron House #268', 1, 133, 416000, 0, 1, 2, 208, 0, 0),
(269, 0, 0, 0, 0, 0, 'Saffron House #269', 1, 134, 422000, 0, 1, 2, 211, 0, 0),
(270, 0, 0, 0, 0, 0, 'Vermilion House #270', 7, 120, 386000, 0, 4, 2, 193, 0, 0),
(271, 0, 0, 0, 0, 0, 'Vermilion House #271', 7, 288, 866000, 0, 4, 2, 433, 0, 0),
(272, 0, 0, 0, 0, 0, 'Vermilion House #272', 7, 102, 334000, 0, 3, 2, 167, 0, 0),
(273, 0, 0, 0, 0, 0, 'Vermilion House #273', 7, 134, 394000, 0, 2, 2, 197, 0, 0),
(274, 0, 0, 0, 0, 0, 'Vermilion House #274', 7, 160, 462000, 0, 2, 2, 231, 0, 0),
(275, 0, 0, 0, 0, 0, 'Vermilion House #275', 7, 142, 456000, 0, 2, 2, 228, 0, 0),
(276, 0, 0, 0, 0, 0, 'Vermilion House #276', 7, 81, 272000, 0, 4, 2, 136, 0, 0),
(277, 0, 0, 0, 0, 0, 'Vermilion House #277', 7, 68, 212000, 0, 2, 2, 106, 0, 0),
(278, 0, 0, 0, 0, 0, 'Vermilion House #278', 7, 86, 278000, 0, 3, 0, 139, 0, 0),
(279, 0, 0, 0, 0, 0, 'Vermilion House #279', 7, 93, 296000, 0, 2, 2, 148, 0, 0),
(280, 0, 0, 0, 0, 0, 'Fuchsia House #280', 4, 94, 320000, 0, 1, 4, 160, 0, 0),
(281, 0, 0, 0, 0, 0, 'Fuchsia House #281', 4, 135, 594000, 0, 6, 10, 297, 0, 0),
(282, 0, 0, 0, 0, 0, 'Fuchsia House #282', 4, 41, 152000, 0, 1, 2, 76, 0, 0),
(283, 0, 0, 0, 0, 0, 'Fuchsia House #283', 4, 47, 158000, 0, 1, 2, 79, 0, 0),
(284, 0, 0, 0, 0, 0, 'Fuchsia House #284', 4, 47, 162000, 0, 1, 2, 81, 0, 0),
(285, 0, 0, 0, 0, 0, 'Fuchsia House #285', 4, 40, 142000, 0, 1, 2, 71, 0, 0),
(286, 0, 0, 0, 0, 0, 'Fuchsia House #286', 4, 281, 1010000, 0, 13, 20, 505, 0, 0),
(287, 0, 0, 0, 0, 0, 'Fuchsia House #287', 4, 110, 412000, 0, 5, 0, 206, 0, 0),
(288, 0, 0, 0, 0, 0, 'Fuchsia House #288', 4, 186, 670000, 0, 5, 0, 335, 0, 0),
(289, 0, 0, 0, 0, 0, 'Fuchsia House #289', 4, 156, 536000, 0, 5, 0, 268, 0, 0),
(290, 0, 0, 0, 0, 0, 'Fuchsia House #290', 4, 20, 84000, 0, 1, 0, 42, 0, 0),
(291, 0, 0, 0, 0, 0, 'Fuchsia House #291', 4, 336, 1152000, 0, 9, 0, 576, 0, 0),
(292, 0, 0, 0, 0, 0, 'Fuchsia House #292', 4, 111, 424000, 0, 5, 0, 212, 0, 0),
(293, 0, 0, 0, 0, 0, 'Fuchsia House #293', 4, 63, 278000, 0, 1, 0, 139, 0, 0),
(294, 0, 0, 0, 0, 0, 'Fuchsia House #294', 4, 44, 182000, 0, 1, 0, 91, 0, 0),
(295, 0, 0, 0, 0, 0, 'Fuchsia House #295', 4, 148, 476000, 0, 1, 0, 238, 0, 0),
(296, 0, 0, 0, 0, 0, 'Fuchsia House #296', 4, 139, 448000, 0, 3, 0, 224, 0, 0),
(297, 0, 0, 0, 0, 0, 'Fuchsia House #297', 4, 197, 684000, 0, 9, 0, 342, 0, 0),
(298, 0, 0, 0, 0, 0, 'Fuchsia House #298', 4, 150, 594000, 0, 9, 0, 297, 0, 0),
(299, 0, 0, 0, 0, 0, 'Cinnabar House #299', 10, 46, 150000, 0, 1, 0, 75, 0, 0),
(300, 0, 0, 0, 0, 0, 'Cinnabar House #300', 10, 83, 208000, 0, 1, 0, 104, 0, 0),
(301, 0, 0, 0, 0, 0, 'Cinnabar House #301', 10, 62, 196000, 0, 1, 0, 98, 0, 0),
(302, 0, 0, 0, 0, 0, 'Cinnabar House #302', 10, 38, 144000, 0, 0, 0, 72, 0, 0),
(304, 0, 0, 0, 0, 0, 'Cinnabar House #304', 10, 111, 370000, 0, 4, 0, 185, 0, 0),
(305, 0, 0, 0, 0, 0, 'Cinnabar House #305', 10, 19, 80000, 0, 1, 0, 40, 0, 0),
(306, 0, 0, 0, 0, 0, 'Cinnabar House #306', 10, 79, 292000, 0, 4, 0, 146, 0, 0),
(307, 0, 0, 0, 0, 0, 'Unnamed House #307', 6, 56, 184000, 0, 2, 0, 92, 0, 0),
(308, 0, 0, 0, 0, 0, 'Unnamed House #308', 3, 45, 122000, 0, 2, 0, 61, 0, 0),
(309, 0, 0, 0, 0, 0, 'Unnamed House #309', 3, 40, 110000, 0, 2, 0, 55, 0, 0),
(310, 0, 0, 0, 0, 0, 'Unnamed House #310', 3, 42, 114000, 0, 0, 0, 57, 0, 0),
(311, 0, 0, 0, 0, 0, 'Unnamed House #311', 3, 42, 130000, 0, 0, 0, 65, 0, 0),
(312, 0, 0, 0, 0, 0, '', 0, 57, 158000, 0, 1, 2, 79, 0, 0),
(313, 0, 0, 0, 0, 0, '', 0, 163, 492000, 0, 5, 4, 246, 0, 0),
(314, 0, 0, 0, 0, 0, '', 0, 83, 248000, 0, 2, 2, 124, 0, 0),
(315, 0, 0, 0, 0, 0, '', 0, 63, 180000, 0, 1, 2, 90, 0, 0),
(316, 0, 0, 0, 0, 0, '', 0, 65, 194000, 0, 2, 4, 97, 0, 0),
(317, 0, 0, 0, 0, 0, '', 0, 85, 300000, 0, 2, 4, 150, 0, 0),
(318, 0, 0, 0, 0, 0, '', 0, 201, 480000, 0, 3, 4, 240, 0, 0),
(319, 0, 0, 0, 0, 0, '', 0, 15, 80000, 0, 1, 0, 40, 0, 0),
(320, 0, 0, 0, 0, 0, '', 0, 93, 334000, 0, 3, 2, 167, 0, 0),
(321, 0, 0, 0, 0, 0, '', 0, 47, 150000, 0, 0, 2, 75, 0, 0),
(322, 0, 0, 0, 0, 0, '', 0, 33, 104000, 0, 1, 2, 52, 0, 0),
(323, 0, 0, 0, 0, 0, '', 0, 33, 96000, 0, 1, 2, 48, 0, 0),
(324, 0, 0, 0, 0, 0, '', 0, 39, 110000, 0, 0, 2, 55, 0, 0),
(325, 0, 0, 0, 0, 0, '', 0, 55, 144000, 0, 1, 2, 72, 0, 0),
(326, 0, 0, 0, 0, 0, '', 0, 65, 170000, 0, 1, 2, 85, 0, 0),
(327, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 6, 4, 508, 0, 0),
(487, 0, 0, 0, 0, 0, '', 0, 14, 58000, 0, 2, 2, 29, 0, 0),
(488, 0, 0, 0, 0, 0, '', 0, 25, 74000, 0, 2, 2, 37, 0, 0),
(489, 0, 0, 0, 0, 0, '', 0, 19, 62000, 0, 2, 2, 31, 0, 0),
(490, 0, 0, 0, 0, 0, '', 0, 42, 140000, 0, 1, 2, 70, 0, 0),
(491, 0, 0, 0, 0, 0, '', 0, 20, 70000, 0, 1, 2, 35, 0, 0),
(492, 0, 0, 0, 0, 0, '', 0, 13, 46000, 0, 1, 2, 23, 0, 0),
(493, 0, 0, 0, 0, 0, '', 0, 13, 46000, 0, 1, 2, 23, 0, 0),
(494, 0, 0, 0, 0, 0, '', 0, 23, 60000, 0, 0, 2, 30, 0, 0),
(495, 0, 0, 0, 0, 0, '', 0, 18, 60000, 0, 1, 2, 30, 0, 0),
(496, 0, 0, 0, 0, 0, '', 0, 29, 98000, 0, 0, 2, 49, 0, 0),
(497, 0, 0, 0, 0, 0, '', 0, 43, 136000, 0, 0, 4, 68, 0, 0),
(498, 0, 0, 0, 0, 0, '', 0, 41, 126000, 0, 1, 2, 63, 0, 0),
(499, 0, 0, 0, 0, 0, '', 0, 10, 40000, 0, 1, 2, 20, 0, 0),
(500, 0, 0, 0, 0, 0, '', 0, 14, 50000, 0, 1, 2, 25, 0, 0),
(501, 0, 0, 0, 0, 0, '', 0, 14, 50000, 0, 0, 2, 25, 0, 0),
(502, 0, 0, 0, 0, 0, '', 0, 10, 40000, 0, 0, 2, 20, 0, 0),
(503, 0, 0, 0, 0, 0, '', 0, 23, 68000, 0, 1, 0, 34, 0, 0),
(504, 0, 0, 0, 0, 0, '', 0, 28, 84000, 0, 0, 2, 42, 0, 0),
(505, 0, 0, 0, 0, 0, '', 0, 28, 80000, 0, 1, 2, 40, 0, 0),
(506, 0, 0, 0, 0, 0, '', 0, 22, 60000, 0, 0, 2, 30, 0, 0),
(507, 0, 0, 0, 0, 0, '', 0, 22, 68000, 0, 0, 2, 34, 0, 0),
(508, 0, 0, 0, 0, 0, '', 0, 33, 108000, 0, 1, 2, 54, 0, 0),
(509, 0, 0, 0, 0, 0, '', 0, 40, 128000, 0, 2, 2, 64, 0, 0),
(510, 0, 0, 0, 0, 0, '', 0, 46, 128000, 0, 0, 1, 64, 0, 0),
(511, 0, 0, 0, 0, 0, '', 0, 36, 106000, 0, 2, 0, 53, 0, 0),
(512, 0, 0, 0, 0, 0, '', 0, 36, 112000, 0, 2, 0, 56, 0, 0),
(513, 0, 0, 0, 0, 0, '', 0, 25, 76000, 0, 0, 2, 38, 0, 0),
(514, 0, 0, 0, 0, 0, '', 0, 18, 60000, 0, 1, 2, 30, 0, 0),
(515, 0, 0, 0, 0, 0, '', 0, 27, 90000, 0, 2, 2, 45, 0, 0),
(517, 0, 0, 0, 0, 0, '', 0, 15, 58000, 0, 2, 2, 29, 0, 0),
(518, 0, 0, 0, 0, 0, '', 0, 18, 62000, 0, 1, 2, 31, 0, 0),
(519, 0, 0, 0, 0, 0, '', 0, 18, 60000, 0, 1, 2, 30, 0, 0),
(520, 0, 0, 0, 0, 0, '', 0, 24, 70000, 0, 1, 2, 35, 0, 0),
(521, 0, 0, 0, 0, 0, '', 0, 16, 52000, 0, 1, 2, 26, 0, 0),
(522, 0, 0, 0, 0, 0, '', 0, 21, 72000, 0, 0, 2, 36, 0, 0),
(523, 0, 0, 0, 0, 0, '', 0, 23, 70000, 0, 0, 2, 35, 0, 0),
(524, 0, 0, 0, 0, 0, '', 0, 18, 60000, 0, 1, 2, 30, 0, 0),
(525, 0, 0, 0, 0, 0, '', 0, 14, 50000, 0, 0, 2, 25, 0, 0),
(526, 0, 0, 0, 0, 0, '', 0, 10, 38000, 0, 0, 2, 19, 0, 0),
(527, 0, 0, 0, 0, 0, '', 0, 18, 60000, 0, 0, 2, 30, 0, 0),
(528, 0, 0, 0, 0, 0, '', 0, 13, 48000, 0, 1, 2, 24, 0, 0),
(529, 0, 0, 0, 0, 0, '', 0, 20, 74000, 0, 1, 2, 37, 0, 0),
(530, 0, 0, 0, 0, 0, '', 0, 21, 48000, 0, 0, 2, 24, 0, 0),
(531, 0, 0, 0, 0, 0, '', 0, 18, 66000, 0, 2, 2, 33, 0, 0),
(532, 0, 0, 0, 0, 0, '', 0, 12, 56000, 0, 1, 2, 28, 0, 0),
(533, 0, 0, 0, 0, 0, '', 0, 18, 60000, 0, 1, 2, 30, 0, 0),
(534, 0, 0, 0, 0, 0, '', 0, 14, 50000, 0, 1, 2, 25, 0, 0),
(535, 0, 0, 0, 0, 0, '', 0, 25, 70000, 0, 1, 2, 35, 0, 0),
(536, 0, 0, 0, 0, 0, '', 0, 18, 72000, 0, 1, 2, 36, 0, 0),
(537, 0, 0, 0, 0, 0, '', 0, 14, 50000, 0, 1, 1, 25, 0, 0),
(538, 0, 0, 0, 0, 0, '', 0, 17, 64000, 0, 0, 2, 32, 0, 0),
(539, 0, 0, 0, 0, 0, '', 0, 32, 142000, 0, 3, 2, 71, 0, 0),
(540, 0, 0, 0, 0, 0, '', 0, 17, 50000, 0, 1, 2, 25, 0, 0),
(541, 0, 0, 0, 0, 0, '', 0, 12, 44000, 0, 2, 2, 22, 0, 0),
(542, 0, 0, 0, 0, 0, '', 0, 16, 64000, 0, 2, 2, 32, 0, 0),
(543, 0, 0, 0, 0, 0, '', 0, 14, 60000, 0, 2, 2, 30, 0, 0),
(544, 0, 0, 0, 0, 0, '', 0, 25, 82000, 0, 2, 2, 41, 0, 0),
(545, 0, 0, 0, 0, 0, '', 0, 22, 82000, 0, 1, 2, 41, 0, 0),
(546, 0, 0, 0, 0, 0, '', 0, 18, 66000, 0, 2, 2, 33, 0, 0),
(547, 0, 0, 0, 0, 0, '', 0, 11, 42000, 0, 0, 2, 21, 0, 0),
(548, 0, 0, 0, 0, 0, '', 0, 18, 56000, 0, 1, 2, 28, 0, 0),
(549, 0, 0, 0, 0, 0, '', 0, 24, 58000, 0, 0, 2, 29, 0, 0),
(550, 0, 0, 0, 0, 0, '', 0, 34, 114000, 0, 1, 2, 57, 0, 0),
(551, 0, 0, 0, 0, 0, '', 0, 25, 94000, 0, 1, 2, 47, 0, 0),
(552, 0, 0, 0, 0, 0, '', 0, 42, 140000, 0, 1, 2, 70, 0, 0),
(553, 0, 0, 0, 0, 0, '', 0, 54, 234000, 0, 0, 2, 117, 0, 0),
(554, 0, 0, 0, 0, 0, '', 0, 41, 134000, 0, 1, 2, 67, 0, 0),
(555, 0, 0, 0, 0, 0, '', 0, 18, 66000, 0, 1, 2, 33, 0, 0),
(556, 0, 0, 0, 0, 0, '', 0, 24, 100000, 0, 1, 2, 50, 0, 0),
(557, 0, 0, 0, 0, 0, '', 0, 86, 300000, 0, 1, 2, 150, 0, 0),
(558, 0, 0, 0, 0, 0, '', 0, 82, 334000, 0, 1, 4, 167, 0, 0),
(559, 0, 0, 0, 0, 0, '', 0, 17, 70000, 0, 1, 2, 35, 0, 0),
(560, 0, 0, 0, 0, 0, '', 0, 27, 88000, 0, 2, 0, 44, 0, 0),
(561, 0, 0, 0, 0, 0, '', 0, 36, 118000, 0, 1, 0, 59, 0, 0),
(562, 0, 0, 0, 0, 0, '', 0, 29, 88000, 0, 1, 0, 44, 0, 0),
(563, 0, 0, 0, 0, 0, '', 0, 18, 56000, 0, 1, 0, 28, 0, 0),
(564, 0, 0, 0, 0, 0, '', 0, 18, 56000, 0, 1, 0, 28, 0, 0),
(565, 0, 0, 0, 0, 0, '', 0, 18, 56000, 0, 1, 0, 28, 0, 0),
(566, 0, 0, 0, 0, 0, '', 0, 36, 98000, 0, 0, 0, 49, 0, 0),
(567, 0, 0, 0, 0, 0, '', 0, 48, 126000, 0, 1, 0, 63, 0, 0),
(568, 0, 0, 0, 0, 0, '', 0, 37, 218000, 0, 0, 0, 109, 0, 0),
(569, 0, 0, 0, 0, 0, '', 0, 42, 112000, 0, 0, 0, 56, 0, 0),
(570, 0, 0, 0, 0, 0, '', 0, 36, 100000, 0, 0, 0, 50, 0, 0),
(571, 0, 0, 0, 0, 0, '', 0, 38, 110000, 0, 0, 0, 55, 0, 0),
(572, 0, 0, 0, 0, 0, '', 0, 36, 120000, 0, 2, 0, 60, 0, 0),
(573, 0, 0, 0, 0, 0, '', 0, 32, 96000, 0, 1, 0, 48, 0, 0),
(574, 0, 0, 0, 0, 0, '', 0, 36, 100000, 0, 0, 0, 50, 0, 0),
(575, 0, 0, 0, 0, 0, '', 0, 69, 302000, 0, 0, 0, 151, 0, 0),
(576, 0, 0, 0, 0, 0, '', 0, 40, 182000, 0, 0, 0, 91, 0, 0),
(577, 0, 0, 0, 0, 0, '', 0, 60, 154000, 0, 1, 0, 77, 0, 0),
(578, 0, 0, 0, 0, 0, '', 0, 57, 168000, 0, 1, 2, 84, 0, 0),
(579, 0, 0, 0, 0, 0, '', 0, 4, 38000, 0, 1, 2, 19, 0, 0),
(580, 0, 0, 0, 0, 0, '', 0, 4, 24000, 0, 1, 2, 12, 0, 0),
(581, 0, 0, 0, 0, 0, '', 0, 4, 24000, 0, 1, 2, 12, 0, 0),
(582, 0, 0, 0, 0, 0, '', 0, 4, 24000, 0, 1, 2, 12, 0, 0),
(583, 0, 0, 0, 0, 0, '', 0, 4, 24000, 0, 1, 2, 12, 0, 0),
(584, 0, 0, 0, 0, 0, '', 0, 74, 256000, 0, 2, 9, 128, 0, 0),
(585, 0, 0, 0, 0, 0, '', 0, 74, 256000, 0, 1, 10, 128, 0, 0),
(586, 0, 0, 0, 0, 0, '', 0, 19, 64000, 0, 0, 2, 32, 0, 0),
(587, 0, 0, 0, 0, 0, '', 0, 17, 56000, 0, 0, 1, 28, 0, 0),
(588, 0, 0, 0, 0, 0, '', 0, 13, 44000, 0, 1, 2, 22, 0, 0),
(589, 0, 0, 0, 0, 0, '', 0, 17, 56000, 0, 1, 1, 28, 0, 0),
(590, 0, 0, 0, 0, 0, '', 0, 12, 44000, 0, 1, 1, 22, 0, 0),
(591, 0, 0, 0, 0, 0, '', 0, 16, 56000, 0, 1, 2, 28, 0, 0),
(592, 0, 0, 0, 0, 0, '', 0, 19, 64000, 0, 0, 2, 32, 0, 0),
(593, 0, 0, 0, 0, 0, '', 0, 20, 64000, 0, 0, 1, 32, 0, 0),
(594, 0, 0, 0, 0, 0, '', 0, 17, 56000, 0, 0, 1, 28, 0, 0),
(595, 0, 0, 0, 0, 0, '', 0, 14, 56000, 0, 1, 1, 28, 0, 0),
(596, 0, 0, 0, 0, 0, '', 0, 17, 56000, 0, 1, 1, 28, 0, 0),
(597, 0, 0, 0, 0, 0, '', 0, 12, 46000, 0, 1, 1, 23, 0, 0),
(598, 0, 0, 0, 0, 0, '', 0, 17, 56000, 0, 1, 1, 28, 0, 0),
(599, 0, 0, 0, 0, 0, '', 0, 20, 64000, 0, 1, 1, 32, 0, 0),
(600, 0, 0, 0, 0, 0, '', 0, 67, 210000, 0, 0, 3, 105, 0, 0),
(601, 0, 0, 0, 0, 0, '', 0, 19, 60000, 0, 1, 1, 30, 0, 0),
(602, 0, 0, 0, 0, 0, '', 0, 19, 60000, 0, 1, 1, 30, 0, 0),
(603, 0, 0, 0, 0, 0, '', 0, 14, 54000, 0, 1, 1, 27, 0, 0),
(604, 0, 0, 0, 0, 0, '', 0, 7, 38000, 0, 1, 2, 19, 0, 0),
(605, 0, 0, 0, 0, 0, '', 0, 8, 44000, 0, 1, 2, 22, 0, 0),
(606, 0, 0, 0, 0, 0, '', 0, 11, 40000, 0, 1, 1, 20, 0, 0),
(607, 0, 0, 0, 0, 0, '', 0, 11, 40000, 0, 1, 1, 20, 0, 0),
(608, 0, 0, 0, 0, 0, '', 0, 8, 32000, 0, 1, 1, 16, 0, 0),
(609, 0, 0, 0, 0, 0, '', 0, 32, 100000, 0, 1, 4, 50, 0, 0),
(610, 0, 0, 0, 0, 0, '', 0, 10, 32000, 0, 1, 2, 16, 0, 0),
(611, 0, 0, 0, 0, 0, '', 0, 16, 70000, 0, 1, 2, 35, 0, 0),
(612, 0, 0, 0, 0, 0, '', 0, 16, 68000, 0, 1, 2, 34, 0, 0),
(613, 0, 0, 0, 0, 0, '', 0, 86, 310000, 0, 1, 8, 155, 0, 0),
(614, 0, 0, 0, 0, 0, '', 0, 11, 40000, 0, 1, 1, 20, 0, 0),
(615, 0, 0, 0, 0, 0, '', 0, 11, 40000, 0, 1, 1, 20, 0, 0),
(616, 0, 0, 0, 0, 0, '', 0, 15, 50000, 0, 1, 1, 25, 0, 0),
(617, 0, 0, 0, 0, 0, '', 0, 169, 632000, 0, 5, 15, 316, 0, 0),
(618, 0, 0, 0, 0, 0, '', 0, 11, 40000, 0, 0, 1, 20, 0, 0),
(619, 0, 0, 0, 0, 0, '', 0, 15, 50000, 0, 0, 1, 25, 0, 0),
(620, 0, 0, 0, 0, 0, '', 0, 11, 40000, 0, 0, 1, 20, 0, 0),
(621, 0, 0, 0, 0, 0, '', 0, 59, 196000, 0, 0, 3, 98, 0, 0),
(622, 0, 0, 0, 0, 0, '', 0, 8, 32000, 0, 1, 1, 16, 0, 0),
(623, 0, 0, 0, 0, 0, '', 0, 11, 40000, 0, 1, 1, 20, 0, 0),
(624, 0, 0, 0, 0, 0, '', 0, 11, 50000, 0, 1, 1, 25, 0, 0),
(625, 0, 0, 0, 0, 0, '', 0, 104, 368000, 0, 1, 6, 184, 0, 0),
(626, 0, 0, 0, 0, 0, '', 0, 11, 40000, 0, 0, 1, 20, 0, 0),
(627, 0, 0, 0, 0, 0, '', 0, 15, 50000, 0, 0, 1, 25, 0, 0),
(628, 0, 0, 0, 0, 0, '', 0, 11, 40000, 0, 0, 1, 20, 0, 0),
(629, 0, 0, 0, 0, 0, '', 0, 82, 240000, 0, 0, 2, 120, 0, 0),
(630, 0, 0, 0, 0, 0, '', 0, 57, 200000, 0, 3, 6, 100, 0, 0),
(631, 0, 0, 0, 0, 0, '', 0, 80, 210000, 0, 0, 0, 105, 0, 0),
(632, 0, 0, 0, 0, 0, '', 0, 36, 98000, 0, 0, 0, 49, 0, 0),
(633, 0, 0, 0, 0, 0, '', 0, 42, 112000, 0, 1, 0, 56, 0, 0),
(634, 0, 0, 0, 0, 0, '', 0, 36, 98000, 0, 1, 0, 49, 0, 0),
(635, 0, 0, 0, 0, 0, '', 0, 42, 112000, 0, 1, 0, 56, 0, 0),
(636, 0, 0, 0, 0, 0, '', 0, 42, 112000, 0, 1, 0, 56, 0, 0),
(637, 0, 0, 0, 0, 0, '', 0, 49, 128000, 0, 1, 0, 64, 0, 0),
(638, 0, 0, 0, 0, 0, '', 0, 42, 112000, 0, 0, 0, 56, 0, 0),
(639, 0, 0, 0, 0, 0, '', 0, 49, 128000, 0, 0, 0, 64, 0, 0),
(640, 0, 0, 0, 0, 0, '', 0, 49, 128000, 0, 1, 0, 64, 0, 0),
(641, 0, 0, 0, 0, 0, '', 0, 42, 112000, 0, 1, 0, 56, 0, 0),
(642, 0, 0, 0, 0, 0, '', 0, 49, 128000, 0, 0, 0, 64, 0, 0),
(643, 0, 0, 0, 0, 0, '', 0, 42, 112000, 0, 0, 0, 56, 0, 0),
(644, 0, 0, 0, 0, 0, '', 0, 42, 112000, 0, 0, 0, 56, 0, 0),
(645, 0, 0, 0, 0, 0, '', 0, 49, 128000, 0, 0, 0, 64, 0, 0),
(647, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 60, 0, 0),
(648, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 72, 0, 0),
(649, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 96, 0, 0),
(650, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 120, 0, 0),
(651, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 198, 0, 0),
(652, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 160, 0, 0),
(653, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 96, 0, 0),
(654, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 128, 0, 0),
(655, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 139, 0, 0),
(656, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 126, 0, 0),
(657, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 84, 0, 0),
(658, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 84, 0, 0),
(659, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 84, 0, 0),
(660, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 84, 0, 0),
(661, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 84, 0, 0),
(662, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 82, 0, 0),
(663, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 84, 0, 0),
(664, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 78, 0, 0),
(665, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 84, 0, 0),
(666, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 149, 0, 0),
(667, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 115, 0, 0),
(668, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 108, 0, 0),
(669, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 152, 0, 0),
(670, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 4, 0, 210, 0, 0),
(671, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 184, 0, 0),
(672, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 144, 0, 0),
(673, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 194, 0, 0),
(674, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 133, 0, 0),
(675, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 98, 0, 0),
(676, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 49, 0, 0),
(677, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 105, 0, 0),
(678, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 1, 0, 56, 0, 0),
(679, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 2, 0, 147, 0, 0),
(680, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 3, 0, 162, 0, 0),
(681, 0, 0, 0, 0, 0, 'Forgotten headquarter (Flat 1, Area 42)', 0, 0, 0, 0, 3, 0, 162, 0, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `house_auctions`
--

CREATE TABLE `house_auctions` (
  `house_id` int(10) UNSIGNED NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `player_id` int(11) NOT NULL,
  `bid` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `limit` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `endtime` bigint(20) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `house_data`
--

CREATE TABLE `house_data` (
  `house_id` int(10) UNSIGNED NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `data` longblob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `house_lists`
--

CREATE TABLE `house_lists` (
  `house_id` int(10) UNSIGNED NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `listid` int(11) NOT NULL,
  `list` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `killers`
--

CREATE TABLE `killers` (
  `id` int(11) NOT NULL,
  `death_id` int(11) NOT NULL,
  `final_hit` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `unjustified` tinyint(1) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `players`
--

CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `group_id` int(11) NOT NULL DEFAULT 1,
  `account_id` int(11) NOT NULL DEFAULT 0,
  `level` int(11) NOT NULL DEFAULT 1,
  `vocation` int(11) NOT NULL DEFAULT 0,
  `health` int(11) NOT NULL DEFAULT 150,
  `healthmax` int(11) NOT NULL DEFAULT 150,
  `experience` bigint(20) NOT NULL DEFAULT 0,
  `lookbody` int(11) NOT NULL DEFAULT 0,
  `lookfeet` int(11) NOT NULL DEFAULT 0,
  `lookhead` int(11) NOT NULL DEFAULT 0,
  `looklegs` int(11) NOT NULL DEFAULT 0,
  `looktype` int(11) NOT NULL DEFAULT 136,
  `lookaddons` int(11) NOT NULL DEFAULT 0,
  `maglevel` int(11) NOT NULL DEFAULT 0,
  `mana` int(11) NOT NULL DEFAULT 0,
  `manamax` int(11) NOT NULL DEFAULT 0,
  `manaspent` int(11) NOT NULL DEFAULT 0,
  `soul` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `town_id` int(11) NOT NULL DEFAULT 0,
  `posx` int(11) NOT NULL DEFAULT 0,
  `posy` int(11) NOT NULL DEFAULT 0,
  `posz` int(11) NOT NULL DEFAULT 0,
  `conditions` blob NOT NULL,
  `cap` int(11) NOT NULL DEFAULT 0,
  `sex` int(11) NOT NULL DEFAULT 0,
  `lastlogin` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `lastip` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `save` tinyint(1) NOT NULL DEFAULT 1,
  `skull` tinyint(1) UNSIGNED NOT NULL DEFAULT 0,
  `skulltime` int(11) NOT NULL DEFAULT 0,
  `rank_id` int(11) NOT NULL DEFAULT 0,
  `guildnick` varchar(255) NOT NULL DEFAULT '',
  `lastlogout` bigint(20) UNSIGNED NOT NULL DEFAULT 0,
  `blessings` tinyint(2) NOT NULL DEFAULT 0,
  `balance` bigint(20) NOT NULL DEFAULT 0,
  `stamina` bigint(20) NOT NULL DEFAULT 151200000 COMMENT 'stored in miliseconds',
  `direction` int(11) NOT NULL DEFAULT 2,
  `loss_experience` int(11) NOT NULL DEFAULT 100,
  `loss_mana` int(11) NOT NULL DEFAULT 100,
  `loss_skills` int(11) NOT NULL DEFAULT 100,
  `loss_containers` int(11) NOT NULL DEFAULT 100,
  `loss_items` int(11) NOT NULL DEFAULT 100,
  `premend` int(11) NOT NULL DEFAULT 0 COMMENT 'NOT IN USE BY THE SERVER',
  `online` tinyint(1) NOT NULL DEFAULT 0,
  `marriage` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `promotion` int(11) NOT NULL DEFAULT 0,
  `deleted` tinyint(1) NOT NULL DEFAULT 0,
  `description` varchar(255) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `players`
--

INSERT INTO `players` (`id`, `name`, `world_id`, `group_id`, `account_id`, `level`, `vocation`, `health`, `healthmax`, `experience`, `lookbody`, `lookfeet`, `lookhead`, `looklegs`, `looktype`, `lookaddons`, `maglevel`, `mana`, `manamax`, `manaspent`, `soul`, `town_id`, `posx`, `posy`, `posz`, `conditions`, `cap`, `sex`, `lastlogin`, `lastip`, `save`, `skull`, `skulltime`, `rank_id`, `guildnick`, `lastlogout`, `blessings`, `balance`, `stamina`, `direction`, `loss_experience`, `loss_mana`, `loss_skills`, `loss_containers`, `loss_items`, `premend`, `online`, `marriage`, `promotion`, `deleted`, `description`) VALUES
(1, 'Account Manager', 0, 1, 1, 1, 0, 150, 150, 0, 0, 0, 0, 0, 110, 0, 0, 0, 0, 0, 0, 0, 50, 50, 7, '', 400, 0, 0, 0, 0, 0, 0, 0, '', 0, 0, 0, 201660000, 0, 100, 100, 100, 100, 100, 0, 0, 0, 0, 0, ''),
(3, 'god', 0, 6, 2, 151, 1, 2400, 2400, 55145000, 86, 102, 27, 71, 511, 0, 0, 4, 6, 0, 0, 1, 1053, 1054, 7, '', 0, 0, 1751684169, 1354117657, 1, 0, 0, 0, '', 1751684074, 0, 0, 151200000, 2, 75, 100, 100, 100, 100, 0, 1, 0, 0, 0, '');

--
-- Acionadores `players`
--
DELIMITER $$
CREATE TRIGGER `oncreate_players` AFTER INSERT ON `players` FOR EACH ROW BEGIN
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 0, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 1, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 2, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 3, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 4, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 5, 10);
	INSERT INTO `player_skills` (`player_id`, `skillid`, `value`) VALUES (NEW.`id`, 6, 10);
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `ondelete_players` BEFORE DELETE ON `players` FOR EACH ROW BEGIN
	DELETE FROM `bans` WHERE `type` IN (2, 5) AND `value` = OLD.`id`;
	UPDATE `houses` SET `owner` = 0 WHERE `owner` = OLD.`id`;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_autoloot`
--

CREATE TABLE `player_autoloot` (
  `id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `on` int(11) NOT NULL DEFAULT 0,
  `player_id` int(11) NOT NULL,
  `autoloot_list` blob DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_deaths`
--

CREATE TABLE `player_deaths` (
  `id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL,
  `date` bigint(20) UNSIGNED NOT NULL,
  `level` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_depotitems`
--

CREATE TABLE `player_depotitems` (
  `player_id` int(11) NOT NULL,
  `sid` int(11) NOT NULL COMMENT 'any given range, eg. 0-100 is reserved for depot lockers and all above 100 will be normal items inside depots',
  `pid` int(11) NOT NULL DEFAULT 0,
  `itemtype` int(11) NOT NULL,
  `count` int(11) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_items`
--

CREATE TABLE `player_items` (
  `player_id` int(11) NOT NULL DEFAULT 0,
  `pid` int(11) NOT NULL DEFAULT 0,
  `sid` int(11) NOT NULL DEFAULT 0,
  `itemtype` int(11) NOT NULL DEFAULT 0,
  `count` int(11) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `player_items`
--

INSERT INTO `player_items` (`player_id`, `pid`, `sid`, `itemtype`, `count`, `attributes`) VALUES
(3, 1, 101, 2120, 1, ''),
(3, 2, 102, 2580, 1, ''),
(3, 3, 103, 1987, 1, ''),
(3, 4, 104, 2550, 1, ''),
(3, 5, 105, 1988, 1, ''),
(3, 6, 106, 2382, 1, ''),
(3, 7, 107, 11995, 1, ''),
(3, 8, 108, 13660, 1, 0x802a000500427566663102ffffffff0500427566663202ffffffff0500427566663302ffffffff05006164646f6e0200000000040062616c6c01060000006e6f726d616c090062616c6c6f72646572020100000004006275726e02ffffffff0700636f6e6675736502ffffffff0800646566656174656401020000006e6f0b006465736372697074696f6e0114000000436f6e7461696e732061205371756972746c652e080066616b65646573630114000000436f6e7461696e732061205371756972746c652e04006665617202ffffffff050068616e647302000000000500686170707902fa000000020068700201000000060068756e676572020500000005006c6565636802ffffffff04006d69737302ffffffff05006d6f766531010d00000063643a3137353136383434303706006d6f76653130010d00000063643a3137353136383434303706006d6f76653131010d00000063643a3137353136383434303706006d6f76653132010d00000063643a3137353136383434303706006d6f76653133010d00000063643a3137353136383434303706006d6f76653134010d00000063643a3137353136383434303706006d6f76653135010d00000063643a3137353136383434303705006d6f766532010d00000063643a3137353136383434303705006d6f766533010d00000063643a3137353136383434303705006d6f766534010d00000063643a3137353136383434303705006d6f766535010d00000063643a3137353136383434303705006d6f766536010d00000063643a3137353136383434303705006d6f766537010d00000063643a3137353136383434303705006d6f766538010d00000063643a3137353136383434303705006d6f766539010d00000063643a313735313638343430370800706172616c797a6502ffffffff0600706f69736f6e02ffffffff0400706f6b6501080000005371756972746c650900706f6b654c6576656c0201000000070073696c656e636502ffffffff0500736c65657002ffffffff0400736c6f7702ffffffff04007374756e02ffffffff0700746164706f727402db2e0000),
(3, 10, 109, 2547, 1, ''),
(3, 103, 110, 12924, 1, 0x802a000500427566663102ffffffff0500427566663202ffffffff0500427566663302ffffffff05006164646f6e0200000000040062616c6c01060000006e6f726d616c090062616c6c6f72646572020200000004006275726e02ffffffff0700636f6e6675736502ffffffff0800646566656174656401020000006e6f0b006465736372697074696f6e0116000000436f6e7461696e73206120436861726d616e6465722e080066616b65646573630116000000436f6e7461696e73206120436861726d616e6465722e04006665617202ffffffff050068616e647302000000000500686170707902fa000000020068700201000000060068756e676572020500000005006c6565636802ffffffff04006d69737302ffffffff05006d6f766531010d00000063643a3137353136383434303706006d6f76653130010d00000063643a3137353136383434303706006d6f76653131010d00000063643a3137353136383434303706006d6f76653132010d00000063643a3137353136383434303706006d6f76653133010d00000063643a3137353136383434303706006d6f76653134010d00000063643a3137353136383434303706006d6f76653135010d00000063643a3137353136383434303705006d6f766532010d00000063643a3137353136383434303705006d6f766533010d00000063643a3137353136383434303705006d6f766534010d00000063643a3137353136383434303705006d6f766535010d00000063643a3137353136383434303705006d6f766536010d00000063643a3137353136383434303705006d6f766537010d00000063643a3137353136383434303705006d6f766538010d00000063643a3137353136383434303705006d6f766539010d00000063643a313735313638343430370800706172616c797a6502ffffffff0600706f69736f6e02ffffffff0400706f6b65010a000000436861726d616e6465720900706f6b654c6576656c0201000000070073696c656e636502ffffffff0500736c65657002ffffffff0400736c6f7702ffffffff04007374756e02ffffffff0700746164706f727402d82e0000),
(3, 103, 111, 12906, 1, 0x802a000500427566663102ffffffff0500427566663202ffffffff0500427566663302ffffffff05006164646f6e0200000000040062616c6c01060000006e6f726d616c090062616c6c6f72646572020300000004006275726e02ffffffff0700636f6e6675736502ffffffff0800646566656174656401020000006e6f0b006465736372697074696f6e0115000000436f6e7461696e7320612042756c6261736175722e080066616b65646573630115000000436f6e7461696e7320612042756c6261736175722e04006665617202ffffffff050068616e647302000000000500686170707902fa000000020068700201000000060068756e676572020500000005006c6565636802ffffffff04006d69737302ffffffff05006d6f766531010d00000063643a3137353136383434303706006d6f76653130010d00000063643a3137353136383434303706006d6f76653131010d00000063643a3137353136383434303706006d6f76653132010d00000063643a3137353136383434303706006d6f76653133010d00000063643a3137353136383434303706006d6f76653134010d00000063643a3137353136383434303706006d6f76653135010d00000063643a3137353136383434303705006d6f766532010d00000063643a3137353136383434303705006d6f766533010d00000063643a3137353136383434303705006d6f766534010d00000063643a3137353136383434303705006d6f766535010d00000063643a3137353136383434303705006d6f766536010d00000063643a3137353136383434303705006d6f766537010d00000063643a3137353136383434303705006d6f766538010d00000063643a3137353136383434303705006d6f766539010d00000063643a313735313638343430370800706172616c797a6502ffffffff0600706f69736f6e02ffffffff0400706f6b65010900000042756c6261736175720900706f6b654c6576656c0201000000070073696c656e636502ffffffff0500736c65657002ffffffff0400736c6f7702ffffffff04007374756e02ffffffff0700746164706f727402d52e0000),
(3, 103, 112, 13302, 1, 0x801c000500427566663102ffffffff0500427566663202ffffffff0500427566663302ffffffff05006164646f6e0200000000040062616c6c010500000049636f6e65090062616c6c6f72646572020400000004006275726e02ffffffff0700636f6e6675736502ffffffff0b006465736372697074696f6e0113000000436f6e7461696e7320612050696467656f742e080066616b65646573630113000000436f6e7461696e7320612050696467656f742e04006665617202ffffffff060067656e64657202040000000500686170707902ff000000020068700201000000060068756e6765720205000000040069636f6e010300000079657305006c6565636802ffffffff04006d69737302ffffffff05006d6f72746101020000006e6f0800706172616c797a6502ffffffff0600706f69736f6e02ffffffff0400706f6b65010700000050696467656f740900706f6b654c6576656c0201000000070073696c656e636502ffffffff0500736c65657002ffffffff0400736c6f7702ffffffff04007374756e02ffffffff0700746164706f727402e62e0000),
(3, 103, 113, 12344, 100, 0x0f64),
(3, 103, 114, 2392, 100, 0x0f64),
(3, 105, 115, 12260, 1, ''),
(3, 105, 116, 12261, 1, ''),
(3, 105, 117, 12262, 1, ''),
(3, 105, 118, 12263, 1, ''),
(3, 105, 119, 12265, 1, ''),
(3, 105, 120, 12264, 1, ''),
(3, 105, 121, 12266, 1, ''),
(3, 105, 122, 12267, 1, '');

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_killers`
--

CREATE TABLE `player_killers` (
  `kill_id` int(11) NOT NULL,
  `player_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_namelocks`
--

CREATE TABLE `player_namelocks` (
  `player_id` int(11) NOT NULL DEFAULT 0,
  `name` varchar(255) NOT NULL,
  `new_name` varchar(255) NOT NULL,
  `date` bigint(20) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_skills`
--

CREATE TABLE `player_skills` (
  `player_id` int(11) NOT NULL DEFAULT 0,
  `skillid` tinyint(2) NOT NULL DEFAULT 0,
  `value` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `count` int(10) UNSIGNED NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `player_skills`
--

INSERT INTO `player_skills` (`player_id`, `skillid`, `value`, `count`) VALUES
(3, 0, 10, 0),
(3, 1, 10, 0),
(3, 2, 10, 0),
(3, 3, 10, 0),
(3, 4, 10, 0),
(3, 5, 10, 0),
(3, 6, 10, 0);

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_spells`
--

CREATE TABLE `player_spells` (
  `player_id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_storage`
--

CREATE TABLE `player_storage` (
  `player_id` int(11) NOT NULL DEFAULT 0,
  `key` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `value` varchar(255) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `player_storage`
--

INSERT INTO `player_storage` (`player_id`, `key`, `value`) VALUES
(3, 9211, '1751684412'),
(3, 19898, '0'),
(3, 54844, '720'),
(3, 61730, '0'),
(3, 72702, '0'),
(3, 91917, '1'),
(3, 665656, '1751684410'),
(3, 912351, '1751685022'),
(3, 999999, '1751683310');

-- --------------------------------------------------------

--
-- Estrutura para tabela `player_viplist`
--

CREATE TABLE `player_viplist` (
  `player_id` int(11) NOT NULL,
  `vip_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `server_config`
--

CREATE TABLE `server_config` (
  `config` varchar(35) NOT NULL DEFAULT '',
  `value` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `server_config`
--

INSERT INTO `server_config` (`config`, `value`) VALUES
('db_version', 23),
('encryption', 2);

-- --------------------------------------------------------

--
-- Estrutura para tabela `server_motd`
--

CREATE TABLE `server_motd` (
  `id` int(10) UNSIGNED NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `text` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `server_motd`
--

INSERT INTO `server_motd` (`id`, `world_id`, `text`) VALUES
(1, 0, 'Welcome to The Forgotten Server!'),
(2, 0, 'Bem vindo ao poke curso');

-- --------------------------------------------------------

--
-- Estrutura para tabela `server_record`
--

CREATE TABLE `server_record` (
  `record` int(11) NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `timestamp` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `server_record`
--

INSERT INTO `server_record` (`record`, `world_id`, `timestamp`) VALUES
(0, 0, 0),
(1, 0, 1713447428);

-- --------------------------------------------------------

--
-- Estrutura para tabela `server_reports`
--

CREATE TABLE `server_reports` (
  `id` int(11) NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `player_id` int(11) NOT NULL DEFAULT 1,
  `posx` int(11) NOT NULL DEFAULT 0,
  `posy` int(11) NOT NULL DEFAULT 0,
  `posz` int(11) NOT NULL DEFAULT 0,
  `timestamp` bigint(20) NOT NULL DEFAULT 0,
  `report` text NOT NULL,
  `reads` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura para tabela `tiles`
--

CREATE TABLE `tiles` (
  `id` int(10) UNSIGNED NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `house_id` int(10) UNSIGNED NOT NULL,
  `x` int(5) UNSIGNED NOT NULL,
  `y` int(5) UNSIGNED NOT NULL,
  `z` tinyint(2) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `tiles`
--

INSERT INTO `tiles` (`id`, `world_id`, `house_id`, `x`, `y`, `z`) VALUES
(0, 0, 127, 767, 1075, 7),
(1, 0, 127, 764, 1078, 7),
(2, 0, 127, 764, 1083, 7),
(3, 0, 127, 766, 1081, 7),
(4, 0, 127, 766, 1085, 7),
(5, 0, 127, 774, 1072, 7),
(6, 0, 127, 776, 1078, 7),
(7, 0, 127, 769, 1083, 7),
(8, 0, 127, 776, 1081, 7),
(9, 0, 127, 773, 1085, 7),
(10, 0, 128, 764, 1073, 6),
(11, 0, 128, 767, 1076, 6),
(12, 0, 128, 769, 1068, 6),
(13, 0, 128, 770, 1079, 6),
(14, 0, 128, 770, 1083, 6),
(15, 0, 128, 776, 1081, 6),
(16, 0, 129, 767, 1097, 5),
(17, 0, 129, 765, 1099, 7),
(18, 0, 129, 767, 1103, 7),
(19, 0, 129, 768, 1090, 6),
(20, 0, 129, 771, 1092, 5),
(21, 0, 129, 771, 1095, 5),
(22, 0, 129, 771, 1093, 6),
(23, 0, 129, 768, 1097, 5),
(24, 0, 129, 770, 1097, 5),
(25, 0, 129, 769, 1096, 6),
(26, 0, 129, 771, 1098, 6),
(27, 0, 129, 771, 1096, 7),
(28, 0, 129, 771, 1098, 7),
(29, 0, 129, 768, 1100, 6),
(30, 0, 129, 771, 1100, 7),
(31, 0, 130, 758, 1090, 7),
(32, 0, 130, 755, 1093, 7),
(33, 0, 130, 755, 1095, 7),
(34, 0, 130, 759, 1094, 6),
(35, 0, 130, 763, 1093, 7),
(36, 0, 131, 763, 1099, 7),
(37, 0, 131, 755, 1100, 7),
(38, 0, 131, 759, 1100, 6),
(39, 0, 131, 758, 1103, 7),
(40, 0, 131, 761, 1103, 7),
(41, 0, 132, 746, 1095, 7),
(42, 0, 132, 748, 1093, 7),
(43, 0, 132, 746, 1098, 7),
(44, 0, 132, 751, 1096, 7),
(45, 0, 132, 751, 1098, 7),
(46, 0, 132, 749, 1101, 7),
(47, 0, 133, 739, 1091, 7),
(48, 0, 134, 730, 1095, 7),
(49, 0, 134, 726, 1097, 7),
(50, 0, 134, 726, 1099, 7),
(51, 0, 134, 728, 1099, 6),
(52, 0, 134, 730, 1099, 6),
(53, 0, 134, 732, 1099, 6),
(54, 0, 134, 733, 1097, 7),
(55, 0, 134, 726, 1101, 7),
(56, 0, 134, 728, 1103, 7),
(57, 0, 134, 730, 1103, 7),
(58, 0, 134, 733, 1101, 7),
(59, 0, 135, 729, 1077, 7),
(60, 0, 135, 729, 1079, 7),
(61, 0, 135, 732, 1081, 7),
(62, 0, 135, 733, 1081, 7),
(63, 0, 135, 737, 1081, 7),
(64, 0, 136, 739, 1077, 7),
(65, 0, 136, 739, 1080, 7),
(66, 0, 137, 729, 1070, 7),
(67, 0, 137, 738, 1068, 7),
(68, 0, 137, 729, 1072, 7),
(69, 0, 138, 715, 1078, 7),
(70, 0, 138, 718, 1080, 7),
(71, 0, 138, 723, 1078, 7),
(72, 0, 138, 723, 1079, 7),
(73, 0, 138, 722, 1080, 7),
(74, 0, 139, 723, 1069, 7),
(75, 0, 139, 723, 1071, 7),
(76, 0, 139, 715, 1072, 7),
(77, 0, 140, 718, 1089, 6),
(78, 0, 140, 719, 1091, 7),
(79, 0, 140, 720, 1089, 6),
(80, 0, 140, 722, 1088, 7),
(81, 0, 141, 717, 1095, 7),
(82, 0, 141, 718, 1097, 6),
(83, 0, 141, 718, 1099, 6),
(84, 0, 141, 716, 1102, 6),
(85, 0, 141, 717, 1102, 7),
(86, 0, 141, 720, 1098, 7),
(87, 0, 141, 720, 1100, 7),
(88, 0, 143, 727, 822, 7),
(89, 0, 144, 719, 826, 6),
(90, 0, 144, 721, 826, 7),
(91, 0, 145, 719, 833, 6),
(92, 0, 145, 717, 836, 7),
(93, 0, 146, 730, 834, 6),
(94, 0, 146, 731, 836, 7),
(95, 0, 147, 737, 834, 6),
(96, 0, 147, 737, 836, 7),
(97, 0, 148, 745, 838, 7),
(98, 0, 149, 735, 846, 7),
(99, 0, 150, 735, 852, 7),
(100, 0, 151, 704, 852, 7),
(101, 0, 152, 695, 852, 7),
(102, 0, 153, 695, 862, 6),
(103, 0, 153, 699, 862, 7),
(104, 0, 154, 695, 870, 6),
(105, 0, 154, 700, 870, 7),
(106, 0, 155, 732, 862, 7),
(107, 0, 155, 736, 865, 7),
(108, 0, 156, 747, 871, 7),
(109, 0, 157, 743, 874, 7),
(110, 0, 158, 676, 862, 6),
(111, 0, 160, 1031, 899, 7),
(112, 0, 160, 1032, 899, 6),
(113, 0, 160, 1033, 899, 6),
(114, 0, 160, 1034, 899, 6),
(115, 0, 160, 1035, 897, 6),
(116, 0, 160, 1035, 898, 6),
(117, 0, 160, 1035, 899, 7),
(118, 0, 160, 1037, 898, 7),
(119, 0, 160, 1034, 901, 7),
(120, 0, 160, 1035, 901, 7),
(121, 0, 161, 1040, 900, 7),
(122, 0, 161, 1040, 902, 7),
(123, 0, 161, 1046, 901, 7),
(124, 0, 161, 1046, 902, 7),
(125, 0, 162, 1040, 907, 7),
(126, 0, 162, 1046, 905, 7),
(127, 0, 162, 1046, 906, 7),
(128, 0, 162, 1046, 907, 7),
(129, 0, 162, 1040, 909, 7),
(130, 0, 163, 1040, 900, 6),
(131, 0, 163, 1042, 902, 6),
(132, 0, 163, 1046, 901, 6),
(133, 0, 163, 1043, 904, 6),
(134, 0, 163, 1044, 907, 6),
(135, 0, 163, 1046, 905, 6),
(136, 0, 163, 1040, 908, 6),
(137, 0, 163, 1044, 908, 6),
(138, 0, 163, 1044, 909, 6),
(139, 0, 164, 1028, 905, 7),
(140, 0, 164, 1031, 905, 7),
(141, 0, 164, 1028, 911, 7),
(142, 0, 164, 1029, 908, 7),
(143, 0, 164, 1030, 911, 7),
(144, 0, 164, 1032, 911, 7),
(145, 0, 164, 1033, 908, 7),
(146, 0, 164, 1033, 909, 7),
(147, 0, 165, 1040, 918, 7),
(148, 0, 165, 1040, 919, 7),
(149, 0, 165, 1042, 916, 7),
(150, 0, 165, 1043, 916, 7),
(151, 0, 165, 1045, 919, 7),
(152, 0, 165, 1047, 916, 7),
(153, 0, 165, 1048, 918, 7),
(154, 0, 165, 1048, 919, 7),
(155, 0, 165, 1043, 921, 7),
(156, 0, 165, 1047, 921, 7),
(157, 0, 166, 1053, 921, 7),
(158, 0, 166, 1050, 924, 7),
(159, 0, 166, 1050, 925, 7),
(160, 0, 166, 1052, 927, 7),
(161, 0, 166, 1053, 927, 7),
(162, 0, 166, 1054, 927, 7),
(163, 0, 166, 1056, 919, 7),
(164, 0, 166, 1056, 924, 7),
(165, 0, 166, 1056, 925, 7),
(166, 0, 167, 1062, 923, 6),
(167, 0, 167, 1062, 923, 7),
(168, 0, 167, 1064, 921, 7),
(169, 0, 167, 1065, 921, 7),
(170, 0, 167, 1067, 921, 7),
(171, 0, 167, 1068, 923, 7),
(172, 0, 167, 1062, 927, 6),
(173, 0, 167, 1062, 927, 7),
(174, 0, 167, 1066, 926, 7),
(175, 0, 167, 1072, 923, 6),
(176, 0, 167, 1072, 923, 7),
(177, 0, 167, 1072, 927, 6),
(178, 0, 167, 1072, 927, 7),
(179, 0, 167, 1065, 928, 6),
(180, 0, 167, 1065, 928, 7),
(181, 0, 167, 1069, 928, 6),
(182, 0, 167, 1069, 928, 7),
(183, 0, 168, 1028, 923, 7),
(184, 0, 168, 1035, 923, 6),
(185, 0, 168, 1033, 921, 7),
(186, 0, 168, 1038, 923, 7),
(187, 0, 168, 1028, 925, 7),
(188, 0, 168, 1031, 927, 7),
(189, 0, 168, 1034, 927, 6),
(190, 0, 168, 1035, 924, 6),
(191, 0, 168, 1035, 925, 6),
(192, 0, 168, 1033, 926, 7),
(193, 0, 168, 1037, 927, 7),
(194, 0, 168, 1038, 924, 7),
(195, 0, 168, 1038, 925, 7),
(196, 0, 169, 1040, 935, 7),
(197, 0, 169, 1042, 933, 7),
(198, 0, 169, 1043, 933, 7),
(199, 0, 169, 1046, 933, 7),
(200, 0, 169, 1049, 935, 7),
(201, 0, 169, 1040, 938, 7),
(202, 0, 169, 1045, 938, 7),
(203, 0, 169, 1046, 939, 7),
(204, 0, 169, 1047, 939, 7),
(205, 0, 169, 1049, 937, 7),
(206, 0, 171, 1056, 940, 7),
(207, 0, 171, 1057, 945, 7),
(208, 0, 172, 1055, 940, 6),
(209, 0, 172, 1060, 934, 7),
(210, 0, 172, 1060, 935, 7),
(211, 0, 172, 1063, 932, 7),
(212, 0, 172, 1065, 934, 7),
(213, 0, 172, 1062, 937, 6),
(214, 0, 172, 1064, 937, 6),
(215, 0, 172, 1066, 937, 6),
(216, 0, 172, 1068, 939, 6),
(217, 0, 172, 1068, 939, 7),
(218, 0, 172, 1057, 940, 6),
(219, 0, 172, 1059, 941, 6),
(220, 0, 172, 1062, 942, 6),
(221, 0, 172, 1062, 942, 7),
(222, 0, 172, 1067, 942, 6),
(223, 0, 172, 1067, 942, 7),
(224, 0, 172, 1068, 940, 6),
(225, 0, 172, 1068, 940, 7),
(226, 0, 172, 1057, 945, 6),
(227, 0, 173, 1092, 926, 6),
(228, 0, 173, 1092, 926, 7),
(229, 0, 173, 1093, 926, 7),
(230, 0, 173, 1089, 928, 6),
(231, 0, 173, 1089, 931, 6),
(232, 0, 173, 1089, 928, 7),
(233, 0, 173, 1089, 931, 7),
(234, 0, 173, 1095, 928, 6),
(235, 0, 173, 1095, 931, 6),
(236, 0, 173, 1095, 928, 7),
(237, 0, 173, 1095, 931, 7),
(238, 0, 173, 1091, 932, 6),
(239, 0, 173, 1091, 932, 7),
(240, 0, 173, 1094, 932, 6),
(241, 0, 173, 1094, 932, 7),
(242, 0, 174, 1098, 921, 7),
(243, 0, 174, 1100, 921, 7),
(244, 0, 174, 1096, 924, 7),
(245, 0, 174, 1100, 924, 7),
(246, 0, 176, 1085, 915, 7),
(247, 0, 176, 1087, 913, 7),
(248, 0, 176, 1087, 919, 7),
(249, 0, 176, 1089, 914, 7),
(250, 0, 176, 1089, 915, 7),
(251, 0, 176, 1088, 919, 7),
(252, 0, 177, 1077, 913, 7),
(253, 0, 177, 1077, 914, 7),
(254, 0, 177, 1079, 915, 7),
(255, 0, 177, 1081, 912, 7),
(256, 0, 177, 1079, 919, 7),
(257, 0, 177, 1080, 919, 7),
(258, 0, 178, 1079, 910, 6),
(259, 0, 178, 1080, 910, 6),
(260, 0, 178, 1077, 913, 6),
(261, 0, 178, 1077, 914, 6),
(262, 0, 178, 1079, 915, 6),
(263, 0, 178, 1081, 912, 6),
(264, 0, 178, 1079, 919, 6),
(265, 0, 178, 1080, 919, 6),
(266, 0, 179, 1087, 910, 6),
(267, 0, 179, 1085, 916, 6),
(268, 0, 179, 1087, 919, 6),
(269, 0, 179, 1088, 910, 6),
(270, 0, 179, 1089, 914, 6),
(271, 0, 179, 1089, 915, 6),
(272, 0, 179, 1088, 919, 6),
(273, 0, 180, 1077, 914, 5),
(274, 0, 180, 1077, 915, 5),
(275, 0, 180, 1079, 913, 5),
(276, 0, 180, 1080, 916, 5),
(277, 0, 181, 1086, 913, 5),
(278, 0, 181, 1086, 916, 5),
(279, 0, 181, 1089, 914, 5),
(280, 0, 181, 1089, 915, 5),
(281, 0, 182, 1084, 859, 5),
(282, 0, 182, 1086, 856, 5),
(283, 0, 182, 1088, 859, 5),
(284, 0, 182, 1091, 856, 5),
(285, 0, 182, 1094, 859, 5),
(286, 0, 183, 856, 1106, 5),
(287, 0, 183, 856, 1107, 5),
(288, 0, 183, 856, 1106, 6),
(289, 0, 183, 856, 1107, 6),
(290, 0, 183, 858, 1109, 5),
(291, 0, 183, 859, 1109, 5),
(292, 0, 183, 858, 1109, 6),
(293, 0, 183, 859, 1109, 6),
(294, 0, 183, 866, 1107, 5),
(295, 0, 183, 866, 1107, 6),
(296, 0, 183, 864, 1109, 5),
(297, 0, 183, 865, 1109, 5),
(298, 0, 183, 864, 1109, 6),
(299, 0, 183, 865, 1109, 6),
(300, 0, 184, 879, 1099, 6),
(301, 0, 184, 879, 1103, 6),
(302, 0, 184, 873, 1105, 6),
(303, 0, 184, 873, 1106, 6),
(304, 0, 184, 875, 1108, 6),
(305, 0, 184, 876, 1108, 6),
(306, 0, 184, 884, 1105, 6),
(307, 0, 184, 884, 1106, 6),
(308, 0, 184, 882, 1108, 6),
(309, 0, 184, 883, 1108, 6),
(310, 0, 185, 875, 1086, 6),
(311, 0, 185, 876, 1086, 6),
(312, 0, 185, 881, 1086, 6),
(313, 0, 185, 882, 1086, 6),
(314, 0, 185, 873, 1090, 6),
(315, 0, 185, 873, 1091, 6),
(316, 0, 185, 877, 1092, 6),
(317, 0, 185, 879, 1095, 6),
(318, 0, 185, 884, 1088, 6),
(319, 0, 185, 884, 1089, 6),
(320, 0, 186, 875, 1086, 5),
(321, 0, 186, 876, 1086, 5),
(322, 0, 186, 881, 1086, 5),
(323, 0, 186, 882, 1086, 5),
(324, 0, 186, 873, 1091, 5),
(325, 0, 186, 873, 1092, 5),
(326, 0, 186, 879, 1093, 5),
(327, 0, 186, 884, 1088, 5),
(328, 0, 186, 884, 1089, 5),
(329, 0, 186, 881, 1095, 5),
(330, 0, 187, 879, 1099, 5),
(331, 0, 187, 873, 1105, 5),
(332, 0, 187, 873, 1106, 5),
(333, 0, 187, 875, 1108, 5),
(334, 0, 187, 876, 1108, 5),
(335, 0, 187, 884, 1105, 5),
(336, 0, 187, 884, 1106, 5),
(337, 0, 187, 882, 1108, 5),
(338, 0, 187, 883, 1108, 5),
(339, 0, 188, 879, 1099, 4),
(340, 0, 188, 873, 1105, 4),
(341, 0, 188, 873, 1106, 4),
(342, 0, 188, 875, 1108, 4),
(343, 0, 188, 876, 1108, 4),
(344, 0, 188, 884, 1105, 4),
(345, 0, 188, 884, 1106, 4),
(346, 0, 188, 882, 1108, 4),
(347, 0, 188, 883, 1108, 4),
(348, 0, 189, 875, 1086, 4),
(349, 0, 189, 876, 1086, 4),
(350, 0, 189, 873, 1091, 4),
(351, 0, 189, 873, 1092, 4),
(352, 0, 189, 884, 1089, 4),
(353, 0, 189, 880, 1095, 4),
(354, 0, 190, 889, 1093, 4),
(355, 0, 190, 890, 1093, 4),
(356, 0, 190, 886, 1105, 4),
(357, 0, 190, 886, 1106, 4),
(358, 0, 190, 892, 1107, 4),
(359, 0, 191, 890, 1100, 3),
(360, 0, 191, 893, 1104, 3),
(361, 0, 191, 888, 1108, 3),
(362, 0, 191, 898, 1096, 3),
(363, 0, 191, 898, 1097, 3),
(364, 0, 191, 897, 1105, 3),
(365, 0, 191, 898, 1104, 3),
(366, 0, 192, 888, 1093, 5),
(367, 0, 192, 889, 1093, 5),
(368, 0, 192, 895, 1093, 5),
(369, 0, 192, 892, 1101, 5),
(370, 0, 192, 886, 1105, 5),
(371, 0, 192, 886, 1106, 5),
(372, 0, 192, 895, 1106, 5),
(373, 0, 192, 888, 1108, 5),
(374, 0, 192, 891, 1108, 5),
(375, 0, 192, 892, 1108, 5),
(376, 0, 192, 896, 1093, 5),
(377, 0, 192, 898, 1096, 5),
(378, 0, 192, 898, 1097, 5),
(379, 0, 192, 898, 1104, 5),
(380, 0, 192, 898, 1105, 5),
(381, 0, 193, 888, 1093, 6),
(382, 0, 193, 889, 1093, 6),
(383, 0, 193, 894, 1093, 6),
(384, 0, 193, 895, 1093, 6),
(385, 0, 193, 886, 1096, 6),
(386, 0, 193, 886, 1097, 6),
(387, 0, 193, 895, 1098, 6),
(388, 0, 193, 889, 1103, 6),
(389, 0, 193, 886, 1105, 6),
(390, 0, 193, 886, 1106, 6),
(391, 0, 193, 888, 1108, 6),
(392, 0, 193, 890, 1108, 6),
(393, 0, 193, 892, 1108, 6),
(394, 0, 193, 893, 1108, 6),
(395, 0, 193, 898, 1096, 6),
(396, 0, 193, 898, 1097, 6),
(397, 0, 193, 898, 1104, 6),
(398, 0, 193, 898, 1105, 6),
(399, 0, 194, 908, 1095, 5),
(400, 0, 194, 908, 1095, 6),
(401, 0, 194, 910, 1095, 6),
(402, 0, 194, 906, 1098, 5),
(403, 0, 194, 906, 1099, 5),
(404, 0, 194, 906, 1098, 6),
(405, 0, 194, 906, 1099, 6),
(406, 0, 194, 906, 1103, 5),
(407, 0, 194, 906, 1103, 6),
(408, 0, 194, 906, 1104, 5),
(409, 0, 194, 906, 1104, 6),
(410, 0, 194, 908, 1106, 5),
(411, 0, 194, 908, 1106, 6),
(412, 0, 194, 911, 1106, 6),
(413, 0, 194, 913, 1106, 6),
(414, 0, 195, 895, 1105, 4),
(415, 0, 195, 898, 1096, 4),
(416, 0, 195, 898, 1097, 4),
(417, 0, 195, 897, 1105, 4),
(418, 0, 195, 898, 1104, 4),
(419, 0, 196, 916, 1095, 5),
(420, 0, 196, 916, 1095, 6),
(421, 0, 196, 918, 1095, 6),
(422, 0, 196, 923, 1102, 5),
(423, 0, 196, 923, 1103, 5),
(424, 0, 196, 923, 1102, 6),
(425, 0, 196, 923, 1103, 6),
(426, 0, 196, 918, 1106, 6),
(427, 0, 196, 921, 1106, 6),
(428, 0, 196, 922, 1106, 6),
(429, 0, 197, 904, 1082, 5),
(430, 0, 197, 905, 1082, 5),
(431, 0, 197, 904, 1082, 6),
(432, 0, 197, 905, 1082, 6),
(433, 0, 197, 897, 1087, 5),
(434, 0, 197, 904, 1087, 5),
(435, 0, 197, 905, 1087, 5),
(436, 0, 197, 904, 1087, 6),
(437, 0, 197, 905, 1087, 6),
(438, 0, 197, 908, 1085, 5),
(439, 0, 197, 908, 1086, 5),
(440, 0, 197, 908, 1086, 6),
(441, 0, 197, 910, 1087, 6),
(442, 0, 197, 898, 1089, 6),
(443, 0, 197, 898, 1090, 6),
(444, 0, 198, 929, 1103, 5),
(445, 0, 198, 930, 1103, 5),
(446, 0, 198, 925, 1107, 6),
(447, 0, 198, 927, 1111, 5),
(448, 0, 198, 925, 1108, 6),
(449, 0, 198, 927, 1111, 6),
(450, 0, 198, 933, 1107, 5),
(451, 0, 198, 933, 1107, 6),
(452, 0, 198, 931, 1111, 5),
(453, 0, 198, 929, 1111, 6),
(454, 0, 198, 931, 1111, 6),
(455, 0, 198, 933, 1108, 5),
(456, 0, 198, 933, 1108, 6),
(457, 0, 199, 927, 1118, 5),
(458, 0, 199, 928, 1118, 5),
(459, 0, 199, 928, 1118, 6),
(460, 0, 199, 929, 1118, 6),
(461, 0, 199, 933, 1118, 5),
(462, 0, 199, 932, 1118, 6),
(463, 0, 199, 933, 1118, 6),
(464, 0, 199, 936, 1119, 5),
(465, 0, 199, 925, 1125, 5),
(466, 0, 199, 925, 1126, 5),
(467, 0, 199, 925, 1125, 6),
(468, 0, 199, 925, 1126, 6),
(469, 0, 199, 934, 1122, 5),
(470, 0, 199, 934, 1122, 6),
(471, 0, 199, 931, 1126, 5),
(472, 0, 199, 931, 1127, 5),
(473, 0, 199, 931, 1126, 6),
(474, 0, 199, 931, 1127, 6),
(475, 0, 200, 918, 1130, 6),
(476, 0, 200, 918, 1131, 6),
(477, 0, 200, 921, 1128, 6),
(478, 0, 200, 923, 1128, 6),
(479, 0, 200, 924, 1128, 6),
(480, 0, 200, 918, 1134, 6),
(481, 0, 200, 918, 1135, 6),
(482, 0, 200, 923, 1135, 6),
(483, 0, 200, 927, 1132, 6),
(484, 0, 201, 910, 1130, 6),
(485, 0, 201, 904, 1135, 6),
(486, 0, 201, 907, 1134, 6),
(487, 0, 201, 916, 1135, 6),
(488, 0, 201, 904, 1136, 6),
(489, 0, 201, 910, 1137, 6),
(490, 0, 201, 906, 1141, 6),
(491, 0, 201, 907, 1141, 6),
(492, 0, 201, 916, 1136, 6),
(493, 0, 202, 910, 1119, 6),
(494, 0, 202, 913, 1114, 6),
(495, 0, 202, 916, 1117, 6),
(496, 0, 202, 916, 1118, 6),
(497, 0, 202, 904, 1120, 6),
(498, 0, 202, 904, 1121, 6),
(499, 0, 202, 910, 1126, 6),
(500, 0, 203, 907, 1114, 5),
(501, 0, 203, 908, 1114, 5),
(502, 0, 203, 910, 1117, 5),
(503, 0, 203, 916, 1117, 5),
(504, 0, 203, 907, 1120, 5),
(505, 0, 203, 910, 1126, 5),
(506, 0, 204, 910, 1130, 5),
(507, 0, 204, 904, 1135, 5),
(508, 0, 204, 908, 1133, 5),
(509, 0, 204, 916, 1135, 5),
(510, 0, 204, 904, 1136, 5),
(511, 0, 204, 906, 1137, 5),
(512, 0, 204, 916, 1136, 5),
(513, 0, 205, 910, 1130, 4),
(514, 0, 205, 904, 1135, 4),
(515, 0, 205, 904, 1136, 4),
(516, 0, 206, 904, 1122, 4),
(517, 0, 206, 904, 1123, 4),
(518, 0, 206, 910, 1120, 4),
(519, 0, 206, 910, 1126, 4),
(520, 0, 206, 916, 1123, 4),
(521, 0, 207, 884, 1119, 6),
(522, 0, 207, 886, 1116, 6),
(523, 0, 207, 887, 1116, 6),
(524, 0, 207, 889, 1116, 6),
(525, 0, 207, 894, 1118, 6),
(526, 0, 207, 884, 1120, 6),
(527, 0, 207, 894, 1120, 6),
(528, 0, 207, 886, 1124, 6),
(529, 0, 207, 887, 1124, 6),
(530, 0, 207, 892, 1124, 6),
(531, 0, 207, 893, 1124, 6),
(532, 0, 208, 886, 1126, 5),
(533, 0, 208, 887, 1126, 5),
(534, 0, 208, 886, 1126, 6),
(535, 0, 208, 887, 1126, 6),
(536, 0, 208, 892, 1126, 6),
(537, 0, 208, 893, 1126, 6),
(538, 0, 208, 894, 1131, 5),
(539, 0, 208, 894, 1131, 6),
(540, 0, 208, 881, 1132, 5),
(541, 0, 208, 881, 1133, 5),
(542, 0, 208, 881, 1132, 6),
(543, 0, 208, 881, 1133, 6),
(544, 0, 208, 885, 1135, 5),
(545, 0, 208, 886, 1135, 5),
(546, 0, 208, 887, 1133, 6),
(547, 0, 208, 888, 1132, 5),
(548, 0, 208, 891, 1135, 5),
(549, 0, 208, 889, 1135, 6),
(550, 0, 208, 891, 1135, 6),
(551, 0, 208, 892, 1135, 5),
(552, 0, 208, 894, 1132, 5),
(553, 0, 208, 892, 1135, 6),
(554, 0, 208, 894, 1132, 6),
(555, 0, 208, 876, 1137, 6),
(556, 0, 208, 894, 1137, 6),
(557, 0, 208, 894, 1138, 6),
(558, 0, 209, 874, 1118, 6),
(559, 0, 209, 874, 1119, 6),
(560, 0, 209, 878, 1116, 6),
(561, 0, 209, 882, 1118, 6),
(562, 0, 209, 882, 1119, 6),
(563, 0, 209, 874, 1122, 6),
(564, 0, 209, 879, 1121, 5),
(565, 0, 209, 878, 1121, 6),
(566, 0, 209, 876, 1128, 5),
(567, 0, 209, 877, 1128, 5),
(568, 0, 209, 876, 1128, 6),
(569, 0, 209, 877, 1128, 6),
(570, 0, 209, 882, 1123, 5),
(571, 0, 209, 882, 1123, 6),
(572, 0, 209, 882, 1124, 5),
(573, 0, 209, 882, 1124, 6),
(574, 0, 209, 880, 1128, 5),
(575, 0, 209, 881, 1128, 5),
(576, 0, 209, 880, 1128, 6),
(577, 0, 209, 881, 1128, 6),
(578, 0, 210, 864, 1119, 5),
(579, 0, 210, 865, 1119, 5),
(580, 0, 210, 864, 1119, 6),
(581, 0, 210, 862, 1125, 6),
(582, 0, 210, 862, 1133, 5),
(583, 0, 210, 862, 1133, 6),
(584, 0, 210, 867, 1121, 5),
(585, 0, 210, 867, 1122, 5),
(586, 0, 210, 867, 1121, 6),
(587, 0, 210, 867, 1122, 6),
(588, 0, 210, 864, 1125, 5),
(589, 0, 210, 866, 1125, 6),
(590, 0, 210, 867, 1130, 5),
(591, 0, 210, 867, 1130, 6),
(592, 0, 210, 867, 1131, 6),
(593, 0, 210, 866, 1133, 5),
(594, 0, 210, 866, 1133, 6),
(595, 0, 211, 855, 1119, 5),
(596, 0, 211, 853, 1119, 6),
(597, 0, 211, 856, 1119, 5),
(598, 0, 211, 858, 1119, 6),
(599, 0, 211, 849, 1121, 5),
(600, 0, 211, 849, 1122, 5),
(601, 0, 211, 849, 1121, 6),
(602, 0, 211, 849, 1122, 6),
(603, 0, 211, 852, 1123, 5),
(604, 0, 211, 852, 1123, 6),
(605, 0, 211, 852, 1127, 6),
(606, 0, 211, 853, 1127, 6),
(607, 0, 211, 856, 1124, 5),
(608, 0, 211, 857, 1124, 5),
(609, 0, 211, 858, 1124, 5),
(610, 0, 211, 857, 1124, 6),
(611, 0, 211, 857, 1129, 6),
(612, 0, 211, 858, 1129, 6),
(613, 0, 212, 862, 1085, 5),
(614, 0, 212, 863, 1085, 5),
(615, 0, 212, 858, 1090, 5),
(616, 0, 212, 858, 1091, 5),
(617, 0, 212, 866, 1088, 5),
(618, 0, 212, 866, 1089, 5),
(619, 0, 212, 866, 1088, 6),
(620, 0, 212, 866, 1089, 6),
(621, 0, 213, 1108, 1018, 7),
(622, 0, 216, 1090, 1031, 7),
(623, 0, 217, 1099, 1031, 7),
(624, 0, 218, 1076, 1042, 7),
(625, 0, 219, 1081, 1059, 7),
(626, 0, 219, 1085, 1061, 7),
(627, 0, 220, 1030, 1035, 7),
(628, 0, 221, 1039, 1031, 7),
(629, 0, 222, 1048, 1028, 7),
(630, 0, 222, 1048, 1031, 7),
(631, 0, 223, 1057, 1031, 7),
(632, 0, 224, 1064, 1021, 7),
(633, 0, 225, 1027, 1040, 7),
(634, 0, 225, 1027, 1041, 7),
(635, 0, 225, 1028, 1040, 7),
(636, 0, 225, 1028, 1041, 7),
(637, 0, 225, 1028, 1043, 7),
(638, 0, 225, 1035, 1043, 7),
(639, 0, 225, 1030, 1045, 7),
(640, 0, 225, 1032, 1047, 7),
(641, 0, 225, 1033, 1045, 7),
(642, 0, 226, 1027, 1054, 7),
(643, 0, 226, 1027, 1055, 7),
(644, 0, 226, 1033, 1053, 7),
(645, 0, 226, 1031, 1057, 7),
(646, 0, 226, 1036, 1059, 7),
(647, 0, 226, 1037, 1059, 7),
(648, 0, 226, 1036, 1060, 7),
(649, 0, 226, 1037, 1060, 7),
(650, 0, 227, 1029, 1052, 6),
(651, 0, 227, 1031, 1052, 6),
(652, 0, 227, 1026, 1056, 6),
(653, 0, 227, 1026, 1059, 6),
(654, 0, 227, 1029, 1057, 6),
(655, 0, 227, 1029, 1061, 6),
(656, 0, 228, 1035, 1052, 6),
(657, 0, 228, 1035, 1055, 6),
(658, 0, 228, 1036, 1052, 6),
(659, 0, 228, 1038, 1056, 6),
(660, 0, 228, 1038, 1059, 6),
(661, 0, 228, 1035, 1061, 6),
(662, 0, 229, 1026, 1041, 6),
(663, 0, 229, 1026, 1046, 6),
(664, 0, 229, 1029, 1047, 6),
(665, 0, 229, 1031, 1047, 6),
(666, 0, 230, 1038, 1041, 6),
(667, 0, 230, 1035, 1047, 6),
(668, 0, 230, 1036, 1047, 6),
(669, 0, 230, 1038, 1045, 6),
(670, 0, 231, 1038, 1041, 5),
(671, 0, 231, 1033, 1044, 5),
(672, 0, 231, 1036, 1047, 5),
(673, 0, 232, 1032, 1052, 5),
(674, 0, 233, 1035, 1054, 5),
(675, 0, 233, 1032, 1059, 5),
(676, 0, 233, 1038, 1056, 5),
(677, 0, 233, 1038, 1059, 5),
(678, 0, 233, 1029, 1061, 5),
(679, 0, 234, 1037, 1035, 6),
(680, 0, 234, 1041, 1030, 6),
(681, 0, 234, 1044, 1035, 6),
(682, 0, 234, 1046, 1033, 6),
(683, 0, 234, 1046, 1034, 6),
(684, 0, 235, 1048, 1031, 6),
(685, 0, 235, 1049, 1031, 6),
(686, 0, 235, 1050, 1031, 6),
(687, 0, 235, 1051, 1028, 6),
(688, 0, 236, 1023, 1063, 7),
(689, 0, 236, 1051, 1033, 6),
(690, 0, 236, 1051, 1034, 6),
(691, 0, 236, 1053, 1035, 6),
(692, 0, 236, 1061, 1035, 6),
(693, 0, 236, 1062, 1034, 6),
(694, 0, 237, 1046, 1066, 6),
(695, 0, 237, 1048, 1064, 6),
(696, 0, 237, 1047, 1069, 7),
(697, 0, 237, 1047, 1070, 7),
(698, 0, 237, 1049, 1071, 6),
(699, 0, 237, 1053, 1071, 6),
(700, 0, 237, 1052, 1068, 7),
(701, 0, 238, 1058, 1064, 6),
(702, 0, 238, 1063, 1064, 6),
(703, 0, 238, 1064, 1065, 7),
(704, 0, 238, 1064, 1066, 7),
(705, 0, 238, 1058, 1071, 6),
(706, 0, 238, 1059, 1068, 7),
(707, 0, 238, 1063, 1071, 6),
(708, 0, 239, 1074, 1064, 6),
(709, 0, 239, 1077, 1064, 6),
(710, 0, 239, 1079, 1066, 6),
(711, 0, 239, 1072, 1068, 6),
(712, 0, 239, 1072, 1070, 6),
(713, 0, 239, 1072, 1068, 7),
(714, 0, 239, 1079, 1070, 6),
(715, 0, 239, 1076, 1071, 7),
(716, 0, 239, 1073, 1072, 7),
(717, 0, 239, 1073, 1073, 7),
(718, 0, 239, 1076, 1074, 6),
(719, 0, 239, 1072, 1076, 7),
(720, 0, 240, 1080, 1049, 6),
(721, 0, 240, 1085, 1049, 6),
(722, 0, 240, 1086, 1051, 6),
(723, 0, 240, 1078, 1053, 7),
(724, 0, 240, 1086, 1055, 6),
(725, 0, 240, 1080, 1057, 6),
(726, 0, 240, 1085, 1057, 6),
(727, 0, 241, 1076, 1018, 6),
(728, 0, 241, 1080, 1018, 6),
(729, 0, 241, 1074, 1022, 7),
(730, 0, 241, 1082, 1020, 6),
(731, 0, 241, 1074, 1024, 6),
(732, 0, 241, 1082, 1025, 6),
(733, 0, 242, 1074, 1029, 7),
(734, 0, 242, 1076, 1031, 6),
(735, 0, 242, 1082, 1031, 6),
(736, 0, 242, 1084, 1028, 6),
(737, 0, 242, 1084, 1030, 6),
(738, 0, 243, 1103, 1044, 6),
(739, 0, 243, 1103, 1052, 6),
(740, 0, 243, 1107, 1044, 6),
(741, 0, 243, 1105, 1044, 7),
(742, 0, 243, 1109, 1046, 6),
(743, 0, 243, 1109, 1051, 6),
(744, 0, 243, 1108, 1052, 6),
(745, 0, 245, 1006, 1059, 6),
(746, 0, 245, 1004, 1058, 7),
(747, 0, 245, 1004, 1059, 7),
(748, 0, 245, 1005, 1057, 7),
(749, 0, 245, 1002, 1063, 6),
(750, 0, 245, 1006, 1062, 6),
(751, 0, 245, 1004, 1063, 7),
(752, 0, 245, 1007, 1063, 7),
(753, 0, 248, 1021, 1055, 7),
(754, 0, 248, 1020, 1063, 7),
(755, 0, 248, 1024, 1058, 7),
(756, 0, 248, 1024, 1061, 7),
(757, 0, 250, 1019, 1056, 7),
(758, 0, 250, 1019, 1057, 7),
(759, 0, 250, 1020, 1056, 7),
(760, 0, 250, 1020, 1057, 7),
(761, 0, 250, 1010, 1078, 7),
(762, 0, 250, 1010, 1079, 7),
(763, 0, 250, 1011, 1078, 7),
(764, 0, 250, 1011, 1079, 7),
(765, 0, 250, 1015, 1082, 7),
(766, 0, 251, 1020, 1086, 7),
(767, 0, 251, 1020, 1087, 7),
(768, 0, 251, 1021, 1084, 7),
(769, 0, 252, 1024, 1085, 7),
(770, 0, 252, 1024, 1086, 7),
(771, 0, 252, 1029, 1087, 7),
(772, 0, 253, 1024, 1091, 7),
(773, 0, 253, 1024, 1092, 7),
(774, 0, 253, 1029, 1093, 7),
(775, 0, 254, 1032, 1094, 7),
(776, 0, 254, 1038, 1093, 7),
(777, 0, 254, 1038, 1094, 7),
(778, 0, 255, 1038, 1085, 7),
(779, 0, 255, 1038, 1086, 7),
(780, 0, 255, 1033, 1089, 7),
(781, 0, 256, 1023, 1093, 6),
(782, 0, 256, 1026, 1095, 6),
(783, 0, 256, 1028, 1093, 6),
(784, 0, 257, 1032, 1095, 6),
(785, 0, 257, 1034, 1093, 6),
(786, 0, 257, 1032, 1096, 6),
(787, 0, 258, 1038, 1095, 6),
(788, 0, 258, 1038, 1096, 6),
(789, 0, 258, 1040, 1093, 6),
(790, 0, 258, 1040, 1098, 6),
(791, 0, 259, 1020, 1085, 6),
(792, 0, 259, 1020, 1086, 6),
(793, 0, 259, 1021, 1084, 6),
(794, 0, 259, 1023, 1087, 6),
(795, 0, 259, 1019, 1088, 6),
(796, 0, 259, 1021, 1091, 6),
(797, 0, 259, 1026, 1084, 6),
(798, 0, 259, 1028, 1087, 6),
(799, 0, 259, 1031, 1084, 6),
(800, 0, 259, 1031, 1089, 6),
(801, 0, 260, 1035, 1085, 6),
(802, 0, 260, 1035, 1086, 6),
(803, 0, 260, 1036, 1084, 6),
(804, 0, 260, 1039, 1084, 6),
(805, 0, 260, 1039, 1089, 6),
(806, 0, 261, 1034, 1093, 5),
(807, 0, 261, 1036, 1094, 5),
(808, 0, 261, 1036, 1095, 5),
(809, 0, 261, 1039, 1094, 5),
(810, 0, 261, 1039, 1095, 5),
(811, 0, 261, 1033, 1098, 5),
(812, 0, 261, 1037, 1098, 5),
(813, 0, 261, 1043, 1095, 5),
(814, 0, 261, 1040, 1098, 5),
(815, 0, 261, 1043, 1097, 5),
(816, 0, 262, 1039, 1085, 5),
(817, 0, 262, 1039, 1086, 5),
(818, 0, 262, 1037, 1091, 5),
(819, 0, 263, 1030, 1085, 5),
(820, 0, 263, 1030, 1086, 5),
(821, 0, 263, 1034, 1088, 5),
(822, 0, 264, 1020, 1085, 5),
(823, 0, 264, 1020, 1086, 5),
(824, 0, 264, 1023, 1087, 5),
(825, 0, 264, 1019, 1088, 5),
(826, 0, 264, 1021, 1091, 5),
(827, 0, 264, 1023, 1093, 5),
(828, 0, 264, 1026, 1084, 5),
(829, 0, 264, 1026, 1089, 5),
(830, 0, 264, 1028, 1092, 5),
(831, 0, 265, 1050, 1079, 6),
(832, 0, 265, 1044, 1081, 6),
(833, 0, 265, 1052, 1081, 6),
(834, 0, 265, 1044, 1086, 6),
(835, 0, 265, 1051, 1084, 7),
(836, 0, 265, 1052, 1084, 6),
(837, 0, 265, 1052, 1086, 6),
(838, 0, 265, 1056, 1084, 7),
(839, 0, 265, 1046, 1089, 6),
(840, 0, 265, 1049, 1089, 6),
(841, 0, 265, 1054, 1089, 6),
(842, 0, 267, 1067, 1094, 5),
(843, 0, 267, 1068, 1094, 5),
(844, 0, 267, 1067, 1096, 5),
(845, 0, 267, 1068, 1096, 5),
(846, 0, 267, 1068, 1098, 5),
(847, 0, 267, 1070, 1101, 5),
(848, 0, 267, 1072, 1094, 5),
(849, 0, 267, 1072, 1095, 5),
(850, 0, 267, 1074, 1094, 5),
(851, 0, 267, 1074, 1095, 5),
(852, 0, 267, 1073, 1097, 5),
(853, 0, 267, 1073, 1103, 5),
(854, 0, 267, 1065, 1105, 7),
(855, 0, 268, 1066, 1095, 6),
(856, 0, 268, 1066, 1098, 7),
(857, 0, 268, 1070, 1098, 7),
(858, 0, 268, 1066, 1100, 6),
(859, 0, 268, 1068, 1102, 6),
(860, 0, 268, 1075, 1095, 6),
(861, 0, 268, 1073, 1102, 6),
(862, 0, 268, 1075, 1100, 6),
(863, 0, 268, 1074, 1100, 7),
(864, 0, 268, 1074, 1101, 7),
(865, 0, 269, 1068, 1082, 6),
(866, 0, 269, 1070, 1083, 7),
(867, 0, 269, 1066, 1084, 6),
(868, 0, 269, 1066, 1087, 7),
(869, 0, 269, 1070, 1084, 7),
(870, 0, 269, 1073, 1082, 6),
(871, 0, 269, 1075, 1085, 6),
(872, 0, 269, 1066, 1091, 6),
(873, 0, 269, 1070, 1088, 7),
(874, 0, 269, 1075, 1091, 6),
(875, 0, 270, 1074, 1215, 7),
(876, 0, 270, 1087, 1213, 7),
(877, 0, 270, 1087, 1214, 7),
(878, 0, 270, 1078, 1219, 7),
(879, 0, 270, 1074, 1222, 7),
(880, 0, 270, 1083, 1222, 7),
(881, 0, 270, 1085, 1220, 7),
(882, 0, 270, 1076, 1224, 7),
(883, 0, 270, 1079, 1224, 7),
(884, 0, 270, 1081, 1224, 7),
(885, 0, 270, 1086, 1224, 7),
(886, 0, 270, 1088, 1218, 7),
(887, 0, 271, 1095, 1226, 7),
(888, 0, 271, 1102, 1226, 7),
(889, 0, 271, 1092, 1228, 7),
(890, 0, 271, 1092, 1231, 7),
(891, 0, 271, 1098, 1230, 7),
(892, 0, 271, 1092, 1235, 7),
(893, 0, 271, 1095, 1233, 7),
(894, 0, 271, 1092, 1237, 7),
(895, 0, 271, 1098, 1236, 7),
(896, 0, 271, 1105, 1237, 7),
(897, 0, 271, 1105, 1238, 7),
(898, 0, 272, 1092, 1243, 7),
(899, 0, 272, 1099, 1243, 7),
(900, 0, 272, 1092, 1246, 7),
(901, 0, 272, 1105, 1241, 7),
(902, 0, 272, 1105, 1242, 7),
(903, 0, 272, 1106, 1244, 7),
(904, 0, 272, 1092, 1249, 7),
(905, 0, 272, 1096, 1249, 7),
(906, 0, 273, 1092, 1251, 7),
(907, 0, 273, 1096, 1255, 7),
(908, 0, 273, 1093, 1257, 7),
(909, 0, 273, 1093, 1258, 7),
(910, 0, 273, 1095, 1259, 7),
(911, 0, 273, 1100, 1259, 7),
(912, 0, 273, 1102, 1257, 7),
(913, 0, 274, 1087, 1252, 7),
(914, 0, 274, 1080, 1258, 7),
(915, 0, 274, 1080, 1259, 7),
(916, 0, 274, 1084, 1256, 7),
(917, 0, 274, 1089, 1252, 7),
(918, 0, 275, 1068, 1258, 7),
(919, 0, 275, 1068, 1259, 7),
(920, 0, 275, 1071, 1260, 7),
(921, 0, 275, 1072, 1252, 7),
(922, 0, 275, 1074, 1252, 7),
(923, 0, 275, 1076, 1252, 7),
(924, 0, 275, 1073, 1256, 7),
(925, 0, 275, 1076, 1260, 7),
(926, 0, 276, 1080, 1267, 7),
(927, 0, 276, 1087, 1267, 7),
(928, 0, 276, 1087, 1273, 7),
(929, 0, 276, 1093, 1265, 7),
(930, 0, 276, 1093, 1266, 7),
(931, 0, 276, 1092, 1271, 7),
(932, 0, 276, 1094, 1268, 7),
(933, 0, 276, 1091, 1276, 7),
(934, 0, 277, 1064, 1271, 7),
(935, 0, 277, 1066, 1269, 7),
(936, 0, 277, 1069, 1271, 7),
(937, 0, 277, 1062, 1272, 7),
(938, 0, 277, 1062, 1273, 7),
(939, 0, 277, 1075, 1271, 7),
(940, 0, 278, 1057, 1277, 7),
(941, 0, 278, 1057, 1279, 7),
(942, 0, 278, 1063, 1279, 7),
(943, 0, 278, 1070, 1278, 7),
(944, 0, 278, 1077, 1279, 7),
(945, 0, 278, 1060, 1281, 7),
(946, 0, 278, 1066, 1281, 7),
(947, 0, 278, 1074, 1281, 7),
(948, 0, 279, 1039, 1222, 7),
(949, 0, 279, 1031, 1224, 7),
(950, 0, 279, 1031, 1227, 7),
(951, 0, 279, 1039, 1225, 7),
(952, 0, 279, 1035, 1231, 7),
(953, 0, 279, 1039, 1228, 7),
(954, 0, 279, 1032, 1232, 7),
(955, 0, 279, 1032, 1233, 7),
(956, 0, 279, 1034, 1236, 7),
(957, 0, 279, 1036, 1236, 7),
(958, 0, 280, 1194, 1314, 6),
(959, 0, 280, 1194, 1314, 7),
(960, 0, 280, 1196, 1315, 7),
(961, 0, 280, 1190, 1316, 6),
(962, 0, 280, 1191, 1319, 6),
(963, 0, 280, 1190, 1316, 7),
(964, 0, 280, 1198, 1316, 6),
(965, 0, 280, 1198, 1317, 6),
(966, 0, 280, 1198, 1318, 6),
(967, 0, 280, 1196, 1316, 7),
(968, 0, 280, 1198, 1316, 7),
(969, 0, 280, 1190, 1321, 6),
(970, 0, 280, 1191, 1320, 6),
(971, 0, 280, 1190, 1321, 7),
(972, 0, 280, 1193, 1322, 6),
(973, 0, 280, 1193, 1322, 7),
(974, 0, 280, 1198, 1321, 6),
(975, 0, 280, 1196, 1322, 7),
(976, 0, 280, 1198, 1321, 7),
(977, 0, 281, 1201, 1314, 6),
(978, 0, 281, 1202, 1314, 6),
(979, 0, 281, 1203, 1314, 6),
(980, 0, 281, 1202, 1314, 7),
(981, 0, 281, 1205, 1314, 6),
(982, 0, 281, 1204, 1315, 7),
(983, 0, 281, 1211, 1315, 6),
(984, 0, 281, 1210, 1314, 7),
(985, 0, 281, 1211, 1315, 7),
(986, 0, 281, 1200, 1316, 6),
(987, 0, 281, 1201, 1319, 6),
(988, 0, 281, 1200, 1317, 7),
(989, 0, 281, 1201, 1319, 7),
(990, 0, 281, 1204, 1316, 5),
(991, 0, 281, 1204, 1319, 5),
(992, 0, 281, 1207, 1316, 6),
(993, 0, 281, 1204, 1316, 7),
(994, 0, 281, 1204, 1318, 7),
(995, 0, 281, 1206, 1316, 7),
(996, 0, 281, 1210, 1318, 6),
(997, 0, 281, 1211, 1316, 6),
(998, 0, 281, 1210, 1318, 7),
(999, 0, 281, 1211, 1316, 7),
(1000, 0, 281, 1212, 1316, 6),
(1001, 0, 281, 1212, 1316, 7),
(1002, 0, 281, 1201, 1320, 6),
(1003, 0, 281, 1202, 1322, 6),
(1004, 0, 281, 1201, 1320, 7),
(1005, 0, 281, 1202, 1322, 7),
(1006, 0, 281, 1203, 1322, 7),
(1007, 0, 281, 1205, 1322, 6),
(1008, 0, 281, 1205, 1322, 7),
(1009, 0, 282, 1176, 1315, 7),
(1010, 0, 282, 1172, 1319, 7),
(1011, 0, 282, 1173, 1316, 7),
(1012, 0, 282, 1173, 1317, 7),
(1013, 0, 282, 1180, 1319, 7),
(1014, 0, 282, 1176, 1322, 7),
(1015, 0, 283, 1176, 1326, 7),
(1016, 0, 283, 1172, 1330, 7),
(1017, 0, 283, 1173, 1331, 7),
(1018, 0, 283, 1180, 1330, 7),
(1019, 0, 283, 1173, 1332, 7),
(1020, 0, 283, 1176, 1334, 7),
(1021, 0, 284, 1176, 1326, 6),
(1022, 0, 284, 1172, 1330, 6),
(1023, 0, 284, 1173, 1331, 6),
(1024, 0, 284, 1180, 1330, 6),
(1025, 0, 284, 1173, 1332, 6),
(1026, 0, 284, 1176, 1334, 6),
(1027, 0, 285, 1173, 1317, 6),
(1028, 0, 285, 1173, 1318, 6),
(1029, 0, 285, 1176, 1322, 6),
(1030, 0, 286, 1183, 1330, 7),
(1031, 0, 286, 1183, 1337, 6),
(1032, 0, 286, 1183, 1338, 6),
(1033, 0, 286, 1182, 1338, 7),
(1034, 0, 286, 1183, 1337, 7),
(1035, 0, 286, 1183, 1338, 7),
(1036, 0, 286, 1183, 1340, 6),
(1037, 0, 286, 1183, 1340, 7),
(1038, 0, 286, 1186, 1331, 7),
(1039, 0, 286, 1191, 1330, 7),
(1040, 0, 286, 1184, 1335, 6),
(1041, 0, 286, 1185, 1335, 7),
(1042, 0, 286, 1186, 1332, 7),
(1043, 0, 286, 1189, 1333, 5),
(1044, 0, 286, 1188, 1332, 6),
(1045, 0, 286, 1190, 1335, 6),
(1046, 0, 286, 1189, 1334, 7),
(1047, 0, 286, 1189, 1335, 7),
(1048, 0, 286, 1191, 1333, 7),
(1049, 0, 286, 1192, 1332, 5),
(1050, 0, 286, 1192, 1333, 5),
(1051, 0, 286, 1194, 1333, 5),
(1052, 0, 286, 1192, 1332, 6),
(1053, 0, 286, 1192, 1333, 6),
(1054, 0, 286, 1193, 1332, 6),
(1055, 0, 286, 1193, 1332, 7),
(1056, 0, 286, 1193, 1335, 7),
(1057, 0, 286, 1184, 1337, 4),
(1058, 0, 286, 1184, 1338, 4),
(1059, 0, 286, 1185, 1336, 5),
(1060, 0, 286, 1186, 1337, 5),
(1061, 0, 286, 1186, 1338, 5),
(1062, 0, 286, 1187, 1338, 6),
(1063, 0, 286, 1190, 1336, 4),
(1064, 0, 286, 1188, 1339, 5),
(1065, 0, 286, 1191, 1336, 5),
(1066, 0, 286, 1188, 1338, 7),
(1067, 0, 286, 1193, 1337, 5),
(1068, 0, 286, 1193, 1338, 5),
(1069, 0, 286, 1192, 1337, 6),
(1070, 0, 286, 1192, 1338, 6),
(1071, 0, 286, 1193, 1339, 6),
(1072, 0, 286, 1193, 1339, 7),
(1073, 0, 286, 1184, 1341, 4),
(1074, 0, 286, 1184, 1341, 5),
(1075, 0, 286, 1189, 1341, 4),
(1076, 0, 286, 1193, 1341, 5),
(1077, 0, 286, 1194, 1340, 5),
(1078, 0, 286, 1192, 1340, 6),
(1079, 0, 286, 1192, 1340, 7),
(1080, 0, 287, 1179, 1345, 6),
(1081, 0, 287, 1179, 1345, 7),
(1082, 0, 287, 1183, 1347, 6),
(1083, 0, 287, 1182, 1347, 7),
(1084, 0, 287, 1179, 1351, 6),
(1085, 0, 287, 1179, 1351, 7),
(1086, 0, 287, 1180, 1352, 6),
(1087, 0, 287, 1180, 1352, 7),
(1088, 0, 287, 1186, 1344, 6),
(1089, 0, 287, 1184, 1345, 7),
(1090, 0, 287, 1188, 1344, 7),
(1091, 0, 287, 1187, 1351, 6),
(1092, 0, 287, 1187, 1351, 7),
(1093, 0, 287, 1186, 1352, 6),
(1094, 0, 287, 1186, 1352, 7),
(1095, 0, 288, 1168, 1343, 5),
(1096, 0, 288, 1169, 1343, 6),
(1097, 0, 288, 1169, 1343, 7),
(1098, 0, 288, 1175, 1343, 7),
(1099, 0, 288, 1165, 1346, 5),
(1100, 0, 288, 1165, 1346, 6),
(1101, 0, 288, 1165, 1346, 7),
(1102, 0, 288, 1167, 1348, 6),
(1103, 0, 288, 1167, 1348, 7),
(1104, 0, 288, 1172, 1346, 5),
(1105, 0, 288, 1173, 1346, 6),
(1106, 0, 288, 1172, 1346, 7),
(1107, 0, 288, 1177, 1345, 6),
(1108, 0, 288, 1177, 1345, 7),
(1109, 0, 288, 1170, 1348, 5),
(1110, 0, 288, 1170, 1348, 6),
(1111, 0, 288, 1170, 1348, 7),
(1112, 0, 288, 1175, 1348, 7),
(1113, 0, 288, 1172, 1353, 6),
(1114, 0, 288, 1174, 1354, 6),
(1115, 0, 288, 1172, 1353, 7),
(1116, 0, 288, 1174, 1354, 7),
(1117, 0, 288, 1175, 1354, 7),
(1118, 0, 288, 1177, 1353, 6),
(1119, 0, 288, 1177, 1353, 7),
(1120, 0, 289, 1162, 1350, 6),
(1121, 0, 289, 1162, 1350, 7),
(1122, 0, 289, 1167, 1353, 6),
(1123, 0, 289, 1167, 1352, 7),
(1124, 0, 289, 1160, 1356, 6),
(1125, 0, 289, 1163, 1356, 7),
(1126, 0, 289, 1167, 1358, 6),
(1127, 0, 289, 1167, 1358, 7),
(1128, 0, 289, 1170, 1352, 7),
(1129, 0, 289, 1162, 1360, 6),
(1130, 0, 289, 1163, 1360, 6),
(1131, 0, 289, 1165, 1360, 6),
(1132, 0, 289, 1167, 1361, 7),
(1133, 0, 289, 1162, 1364, 7),
(1134, 0, 289, 1165, 1364, 7),
(1135, 0, 290, 1210, 1370, 7),
(1136, 0, 290, 1213, 1368, 7),
(1137, 0, 290, 1213, 1373, 7),
(1138, 0, 290, 1216, 1372, 7),
(1139, 0, 291, 1203, 1343, 6),
(1140, 0, 291, 1205, 1341, 5),
(1141, 0, 291, 1205, 1341, 6),
(1142, 0, 291, 1211, 1343, 4),
(1143, 0, 291, 1209, 1341, 5),
(1144, 0, 291, 1209, 1341, 6),
(1145, 0, 291, 1211, 1343, 6),
(1146, 0, 291, 1200, 1347, 5),
(1147, 0, 291, 1203, 1347, 5),
(1148, 0, 291, 1200, 1347, 6),
(1149, 0, 291, 1211, 1347, 4),
(1150, 0, 291, 1208, 1346, 6),
(1151, 0, 291, 1203, 1349, 6),
(1152, 0, 291, 1206, 1351, 4),
(1153, 0, 291, 1205, 1349, 5),
(1154, 0, 291, 1207, 1351, 6),
(1155, 0, 291, 1209, 1348, 4),
(1156, 0, 291, 1211, 1350, 4),
(1157, 0, 291, 1211, 1348, 5),
(1158, 0, 291, 1211, 1350, 5),
(1159, 0, 291, 1211, 1348, 6),
(1160, 0, 291, 1211, 1349, 6),
(1161, 0, 291, 1211, 1350, 6),
(1162, 0, 291, 1203, 1354, 5),
(1163, 0, 291, 1203, 1354, 6),
(1164, 0, 291, 1207, 1354, 5),
(1165, 0, 291, 1211, 1355, 5),
(1166, 0, 291, 1211, 1355, 6),
(1167, 0, 291, 1207, 1356, 4),
(1168, 0, 291, 1205, 1356, 5),
(1169, 0, 291, 1205, 1356, 6),
(1170, 0, 291, 1210, 1356, 4),
(1171, 0, 291, 1210, 1356, 5),
(1172, 0, 291, 1210, 1356, 6),
(1173, 0, 292, 1214, 1341, 5),
(1174, 0, 292, 1220, 1335, 6),
(1175, 0, 292, 1216, 1339, 5),
(1176, 0, 292, 1217, 1337, 6),
(1177, 0, 292, 1220, 1339, 5),
(1178, 0, 292, 1222, 1339, 6),
(1179, 0, 292, 1224, 1337, 6),
(1180, 0, 292, 1226, 1339, 6),
(1181, 0, 292, 1217, 1341, 6),
(1182, 0, 292, 1222, 1341, 5),
(1183, 0, 292, 1214, 1344, 5),
(1184, 0, 292, 1214, 1345, 6),
(1185, 0, 292, 1216, 1346, 5),
(1186, 0, 292, 1219, 1346, 5),
(1187, 0, 292, 1216, 1346, 6),
(1188, 0, 292, 1219, 1346, 6),
(1189, 0, 292, 1220, 1345, 5),
(1190, 0, 293, 1219, 1354, 6),
(1191, 0, 293, 1217, 1357, 6),
(1192, 0, 293, 1218, 1359, 6),
(1193, 0, 293, 1224, 1357, 6),
(1194, 0, 294, 1225, 1351, 6),
(1195, 0, 295, 1233, 1339, 5),
(1196, 0, 295, 1236, 1337, 5),
(1197, 0, 295, 1236, 1337, 6),
(1198, 0, 295, 1233, 1343, 5),
(1199, 0, 295, 1233, 1341, 6),
(1200, 0, 295, 1241, 1343, 5),
(1201, 0, 295, 1241, 1343, 6),
(1202, 0, 295, 1235, 1345, 5),
(1203, 0, 295, 1235, 1345, 6),
(1204, 0, 295, 1240, 1345, 5),
(1205, 0, 295, 1240, 1345, 6),
(1206, 0, 296, 1238, 1318, 6),
(1207, 0, 296, 1238, 1322, 6),
(1208, 0, 296, 1236, 1324, 6),
(1209, 0, 296, 1240, 1327, 5),
(1210, 0, 296, 1243, 1324, 6),
(1211, 0, 296, 1236, 1330, 6),
(1212, 0, 296, 1245, 1330, 6),
(1213, 0, 296, 1238, 1332, 6),
(1214, 0, 296, 1241, 1332, 6),
(1215, 0, 297, 1215, 1311, 5),
(1216, 0, 297, 1217, 1311, 4),
(1217, 0, 297, 1219, 1308, 4),
(1218, 0, 297, 1219, 1308, 5),
(1219, 0, 297, 1219, 1311, 6),
(1220, 0, 297, 1221, 1308, 4),
(1221, 0, 297, 1220, 1311, 5),
(1222, 0, 297, 1222, 1308, 5),
(1223, 0, 297, 1217, 1314, 4),
(1224, 0, 297, 1218, 1314, 5),
(1225, 0, 297, 1216, 1314, 6),
(1226, 0, 297, 1222, 1314, 5),
(1227, 0, 297, 1225, 1312, 5),
(1228, 0, 297, 1225, 1312, 6),
(1229, 0, 297, 1225, 1314, 6),
(1230, 0, 297, 1219, 1318, 4),
(1231, 0, 297, 1216, 1318, 5),
(1232, 0, 297, 1219, 1318, 5),
(1233, 0, 297, 1216, 1318, 6),
(1234, 0, 297, 1219, 1316, 6),
(1235, 0, 297, 1223, 1316, 4),
(1236, 0, 297, 1225, 1316, 5),
(1237, 0, 297, 1225, 1316, 6),
(1238, 0, 298, 1250, 1321, 7),
(1239, 0, 298, 1252, 1323, 7),
(1240, 0, 298, 1256, 1323, 7),
(1241, 0, 298, 1250, 1325, 7),
(1242, 0, 298, 1252, 1326, 5),
(1243, 0, 298, 1252, 1327, 6),
(1244, 0, 298, 1253, 1325, 6),
(1245, 0, 298, 1254, 1325, 7),
(1246, 0, 298, 1258, 1325, 5),
(1247, 0, 298, 1259, 1325, 6),
(1248, 0, 298, 1256, 1327, 7),
(1249, 0, 298, 1258, 1325, 7),
(1250, 0, 298, 1260, 1326, 5),
(1251, 0, 298, 1260, 1326, 6),
(1252, 0, 298, 1260, 1326, 7),
(1253, 0, 298, 1250, 1329, 7),
(1254, 0, 298, 1252, 1329, 5),
(1255, 0, 298, 1254, 1330, 5),
(1256, 0, 298, 1252, 1328, 7),
(1257, 0, 298, 1256, 1330, 5),
(1258, 0, 298, 1258, 1330, 5),
(1259, 0, 298, 1256, 1329, 6),
(1260, 0, 298, 1258, 1329, 7),
(1261, 0, 298, 1260, 1329, 5),
(1262, 0, 298, 1252, 1332, 6),
(1263, 0, 298, 1254, 1333, 6),
(1264, 0, 298, 1252, 1332, 7),
(1265, 0, 298, 1254, 1333, 7),
(1266, 0, 298, 1259, 1333, 6),
(1267, 0, 298, 1256, 1333, 7),
(1268, 0, 298, 1259, 1333, 7),
(1269, 0, 298, 1260, 1332, 6),
(1270, 0, 298, 1260, 1332, 7),
(1271, 0, 299, 826, 1371, 7),
(1272, 0, 299, 829, 1371, 7),
(1273, 0, 299, 833, 1367, 7),
(1274, 0, 299, 832, 1371, 7),
(1275, 0, 299, 833, 1368, 7),
(1276, 0, 299, 833, 1369, 7),
(1277, 0, 300, 839, 1367, 7),
(1278, 0, 300, 844, 1364, 7),
(1279, 0, 300, 839, 1369, 7),
(1280, 0, 300, 839, 1373, 7),
(1281, 0, 300, 841, 1375, 7),
(1282, 0, 301, 844, 1372, 6),
(1283, 0, 302, 841, 1381, 7),
(1284, 0, 302, 845, 1381, 7),
(1285, 0, 302, 839, 1385, 7),
(1286, 0, 302, 849, 1381, 7),
(1287, 0, 302, 849, 1385, 7),
(1288, 0, 304, 833, 1398, 7),
(1289, 0, 304, 834, 1398, 7),
(1290, 0, 304, 836, 1398, 7),
(1291, 0, 304, 839, 1398, 7),
(1292, 0, 304, 832, 1400, 7),
(1293, 0, 304, 835, 1403, 7),
(1294, 0, 304, 832, 1405, 7),
(1295, 0, 304, 835, 1407, 7),
(1296, 0, 304, 841, 1411, 7),
(1297, 0, 305, 836, 1420, 7),
(1298, 0, 306, 833, 1429, 7),
(1299, 0, 306, 837, 1430, 7),
(1300, 0, 306, 841, 1428, 7),
(1301, 0, 306, 841, 1431, 7),
(1302, 0, 307, 710, 1095, 7),
(1303, 0, 307, 712, 1095, 7),
(1304, 0, 307, 707, 1097, 7),
(1305, 0, 307, 707, 1100, 7),
(1306, 0, 307, 712, 1102, 7),
(1307, 0, 308, 1200, 1056, 7),
(1308, 0, 308, 1205, 1059, 7),
(1309, 0, 308, 1200, 1062, 7),
(1310, 0, 308, 1202, 1062, 7),
(1311, 0, 309, 1214, 1056, 7),
(1312, 0, 309, 1211, 1062, 7),
(1313, 0, 309, 1214, 1062, 7),
(1314, 0, 309, 1218, 1059, 7),
(1315, 0, 309, 1217, 1062, 7),
(1316, 0, 310, 1234, 1060, 7),
(1317, 0, 311, 1234, 1049, 7),
(1318, 0, 311, 1234, 1051, 7),
(1319, 0, 311, 1234, 1053, 7);

-- --------------------------------------------------------

--
-- Estrutura para tabela `tile_items`
--

CREATE TABLE `tile_items` (
  `tile_id` int(10) UNSIGNED NOT NULL,
  `world_id` tinyint(2) UNSIGNED NOT NULL DEFAULT 0,
  `sid` int(11) NOT NULL,
  `pid` int(11) NOT NULL DEFAULT 0,
  `itemtype` int(11) NOT NULL,
  `count` int(11) NOT NULL DEFAULT 0,
  `attributes` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Despejando dados para a tabela `tile_items`
--

INSERT INTO `tile_items` (`tile_id`, `world_id`, `sid`, `pid`, `itemtype`, `count`, `attributes`) VALUES
(0, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313237272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1, 0, 1, 0, 6437, 1, ''),
(2, 0, 1, 0, 6437, 1, ''),
(3, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313237272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373830303020676f6c6420636f696e732e0600646f6f7269640204000000),
(4, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313237272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373830303020676f6c6420636f696e732e0600646f6f7269640203000000),
(5, 0, 1, 0, 6437, 1, ''),
(6, 0, 1, 0, 6437, 1, ''),
(7, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313237272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373830303020676f6c6420636f696e732e0600646f6f7269640205000000),
(8, 0, 1, 0, 6437, 1, ''),
(9, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313237272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(10, 0, 1, 0, 6437, 1, ''),
(11, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313238272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033363230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(12, 0, 1, 0, 6436, 1, ''),
(13, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313238272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033363230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(14, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313238272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033363230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(15, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313238272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033363230303020676f6c6420636f696e732e0600646f6f7269640205000000),
(16, 0, 1, 0, 6436, 1, ''),
(17, 0, 1, 0, 6437, 1, ''),
(18, 0, 1, 0, 6436, 1, ''),
(19, 0, 1, 0, 6436, 1, ''),
(20, 0, 1, 0, 6437, 1, ''),
(21, 0, 1, 0, 6437, 1, ''),
(22, 0, 1, 0, 6437, 1, ''),
(23, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313239272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034373830303020676f6c6420636f696e732e0600646f6f7269640204000000),
(24, 0, 1, 0, 6436, 1, ''),
(25, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313239272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034373830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(26, 0, 1, 0, 6437, 1, ''),
(27, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313239272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034373830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(28, 0, 1, 0, 6437, 1, ''),
(29, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313239272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034373830303020676f6c6420636f696e732e0600646f6f7269640203000000),
(30, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313239272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034373830303020676f6c6420636f696e732e0600646f6f7269640205000000),
(31, 0, 1, 0, 6436, 1, ''),
(32, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313330272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032373430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(33, 0, 1, 0, 6437, 1, ''),
(34, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313330272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032373430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(35, 0, 1, 0, 6437, 1, ''),
(36, 0, 1, 0, 6437, 1, ''),
(37, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313331272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032353230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(38, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313331272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032353230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(39, 0, 1, 0, 6436, 1, ''),
(40, 0, 1, 0, 6436, 1, ''),
(41, 0, 1, 0, 6437, 1, ''),
(42, 0, 1, 0, 6436, 1, ''),
(43, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313332272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(44, 0, 1, 0, 6437, 1, ''),
(45, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313332272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(46, 0, 1, 0, 6436, 1, ''),
(47, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313333272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031343230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(48, 0, 1, 0, 6436, 1, ''),
(49, 0, 1, 0, 6437, 1, ''),
(50, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313334272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373430303020676f6c6420636f696e732e0600646f6f7269640204000000),
(51, 0, 1, 0, 6436, 1, ''),
(52, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313334272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(53, 0, 1, 0, 6436, 1, ''),
(54, 0, 1, 0, 6437, 1, ''),
(55, 0, 1, 0, 6437, 1, ''),
(56, 0, 1, 0, 6436, 1, ''),
(57, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313334272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(58, 0, 1, 0, 6437, 1, ''),
(59, 0, 1, 0, 6437, 1, ''),
(60, 0, 1, 0, 6437, 1, ''),
(61, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313335272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031353230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(62, 0, 1, 0, 6436, 1, ''),
(63, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313335272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031353230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(64, 0, 1, 0, 6437, 1, ''),
(65, 0, 1, 0, 6437, 1, ''),
(66, 0, 1, 0, 6437, 1, ''),
(67, 0, 1, 0, 6436, 1, ''),
(68, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313337272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031343830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(69, 0, 1, 0, 6437, 1, ''),
(70, 0, 1, 0, 6436, 1, ''),
(71, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313338272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033303430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(72, 0, 1, 0, 6437, 1, ''),
(73, 0, 1, 0, 6436, 1, ''),
(74, 0, 1, 0, 6437, 1, ''),
(75, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313339272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032383230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(76, 0, 1, 0, 6437, 1, ''),
(77, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313430272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032313430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(78, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313430272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032313430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(79, 0, 1, 0, 6436, 1, ''),
(80, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313430272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032313430303020676f6c6420636f696e732e0600646f6f7269640204000000),
(81, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313431272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031373030303020676f6c6420636f696e732e0600646f6f7269640203000000),
(82, 0, 1, 0, 6437, 1, ''),
(83, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313431272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031373030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(84, 0, 1, 0, 6436, 1, ''),
(85, 0, 1, 0, 6436, 1, ''),
(86, 0, 1, 0, 6437, 1, ''),
(87, 0, 1, 0, 1219, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027566972696469616e20486f7573652023313431272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031373030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(88, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313433272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031363230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(89, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313434272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(90, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313434272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(91, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313435272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032383230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(92, 0, 1, 0, 5119, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313435272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032383230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(93, 0, 1, 0, 5120, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313436272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032323630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(94, 0, 1, 0, 5119, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313436272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032323630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(95, 0, 1, 0, 5119, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313437272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032323830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(96, 0, 1, 0, 5119, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313437272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032323830303020676f6c6420636f696e732e0600646f6f7269640203000000),
(97, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313438272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031313230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(98, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313439272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(99, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015b00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313530272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320393430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(100, 0, 1, 0, 5119, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313531272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031363030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(101, 0, 1, 0, 5119, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313532272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033323230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(102, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313533272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033353630303020676f6c6420636f696e732e0600646f6f7269640203000000),
(103, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313533272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033353630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(104, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313534272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033333630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(105, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313534272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033333630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(106, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313535272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031353430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(107, 0, 1, 0, 5119, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313535272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031353430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(108, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313536272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032313430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(109, 0, 1, 0, 5119, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313537272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032333030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(110, 0, 1, 0, 5128, 1, 0x8002000b006465736372697074696f6e015c00000049742062656c6f6e677320746f20686f757365202750657774657220486f7573652023313538272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031333230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(111, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313630272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033313230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(112, 0, 1, 0, 5303, 1, ''),
(113, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313630272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033313230303020676f6c6420636f696e732e0600646f6f7269640205000000),
(114, 0, 1, 0, 5303, 1, ''),
(115, 0, 1, 0, 5304, 1, ''),
(116, 0, 1, 0, 5304, 1, ''),
(117, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313630272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033313230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(118, 0, 1, 0, 5304, 1, ''),
(119, 0, 1, 0, 5303, 1, ''),
(120, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313630272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033313230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(121, 0, 1, 0, 5304, 1, ''),
(122, 0, 1, 0, 5304, 1, ''),
(123, 0, 1, 0, 5304, 1, ''),
(124, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313631272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031313230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(125, 0, 1, 0, 5304, 1, ''),
(126, 0, 1, 0, 5304, 1, ''),
(127, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313632272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320383430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(128, 0, 1, 0, 5304, 1, ''),
(129, 0, 1, 0, 5304, 1, ''),
(130, 0, 1, 0, 5304, 1, ''),
(131, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313633272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032333030303020676f6c6420636f696e732e0600646f6f7269640204000000),
(132, 0, 1, 0, 5304, 1, ''),
(133, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313633272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032333030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(134, 0, 1, 0, 5304, 1, ''),
(135, 0, 1, 0, 5304, 1, ''),
(136, 0, 1, 0, 5304, 1, ''),
(137, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313633272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032333030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(138, 0, 1, 0, 5304, 1, ''),
(139, 0, 1, 0, 5303, 1, ''),
(140, 0, 1, 0, 5303, 1, ''),
(141, 0, 1, 0, 5303, 1, ''),
(142, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313634272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031313230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(143, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313634272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031313230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(144, 0, 1, 0, 5303, 1, ''),
(145, 0, 1, 0, 5304, 1, ''),
(146, 0, 1, 0, 5304, 1, ''),
(147, 0, 1, 0, 5304, 1, ''),
(148, 0, 1, 0, 5304, 1, ''),
(149, 0, 1, 0, 5303, 1, ''),
(150, 0, 1, 0, 5303, 1, ''),
(151, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313635272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(152, 0, 1, 0, 5303, 1, ''),
(153, 0, 1, 0, 5304, 1, ''),
(154, 0, 1, 0, 5304, 1, ''),
(155, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313635272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(156, 0, 1, 0, 5303, 1, ''),
(157, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313636272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031333430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(158, 0, 1, 0, 5304, 1, ''),
(159, 0, 1, 0, 5304, 1, ''),
(160, 0, 1, 0, 5303, 1, ''),
(161, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313636272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031333430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(162, 0, 1, 0, 5303, 1, ''),
(163, 0, 1, 0, 5304, 1, ''),
(164, 0, 1, 0, 5304, 1, ''),
(165, 0, 1, 0, 5304, 1, ''),
(166, 0, 1, 0, 5304, 1, ''),
(167, 0, 1, 0, 5304, 1, ''),
(168, 0, 1, 0, 5303, 1, ''),
(169, 0, 1, 0, 5303, 1, ''),
(170, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313637272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033343430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(171, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313637272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033343430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(172, 0, 1, 0, 5304, 1, ''),
(173, 0, 1, 0, 5304, 1, ''),
(174, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313637272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033343430303020676f6c6420636f696e732e0600646f6f7269640204000000),
(175, 0, 1, 0, 5304, 1, ''),
(176, 0, 1, 0, 5304, 1, ''),
(177, 0, 1, 0, 5304, 1, ''),
(178, 0, 1, 0, 5304, 1, ''),
(179, 0, 1, 0, 5303, 1, ''),
(180, 0, 1, 0, 5303, 1, ''),
(181, 0, 1, 0, 5303, 1, ''),
(182, 0, 1, 0, 5303, 1, ''),
(183, 0, 1, 0, 5304, 1, ''),
(184, 0, 1, 0, 5304, 1, ''),
(185, 0, 1, 0, 5303, 1, ''),
(186, 0, 1, 0, 5304, 1, ''),
(187, 0, 1, 0, 5304, 1, ''),
(188, 0, 1, 0, 5303, 1, ''),
(189, 0, 1, 0, 5303, 1, ''),
(190, 0, 1, 0, 5304, 1, ''),
(191, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313638272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732037353630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(192, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313638272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732037353630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(193, 0, 1, 0, 5303, 1, ''),
(194, 0, 1, 0, 5304, 1, ''),
(195, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313638272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732037353630303020676f6c6420636f696e732e0600646f6f7269640203000000),
(196, 0, 1, 0, 5304, 1, ''),
(197, 0, 1, 0, 5303, 1, ''),
(198, 0, 1, 0, 5303, 1, ''),
(199, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313639272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032383030303020676f6c6420636f696e732e0600646f6f7269640203000000),
(200, 0, 1, 0, 5304, 1, ''),
(201, 0, 1, 0, 5304, 1, ''),
(202, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313639272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032383030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(203, 0, 1, 0, 5303, 1, ''),
(204, 0, 1, 0, 5303, 1, ''),
(205, 0, 1, 0, 5304, 1, ''),
(206, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313731272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320373430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(207, 0, 1, 0, 5303, 1, ''),
(208, 0, 1, 0, 5303, 1, ''),
(209, 0, 1, 0, 5304, 1, ''),
(210, 0, 1, 0, 5304, 1, ''),
(211, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313732272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034343030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(212, 0, 1, 0, 5304, 1, ''),
(213, 0, 1, 0, 5303, 1, ''),
(214, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313732272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034343030303020676f6c6420636f696e732e0600646f6f7269640203000000),
(215, 0, 1, 0, 5303, 1, ''),
(216, 0, 1, 0, 5304, 1, ''),
(217, 0, 1, 0, 5304, 1, ''),
(218, 0, 1, 0, 5303, 1, ''),
(219, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313732272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034343030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(220, 0, 1, 0, 5303, 1, ''),
(221, 0, 1, 0, 5303, 1, ''),
(222, 0, 1, 0, 5303, 1, ''),
(223, 0, 1, 0, 5303, 1, ''),
(224, 0, 1, 0, 5304, 1, ''),
(225, 0, 1, 0, 5304, 1, ''),
(226, 0, 1, 0, 5303, 1, ''),
(227, 0, 1, 0, 5303, 1, ''),
(228, 0, 1, 0, 5303, 1, ''),
(229, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313733272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031393630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(230, 0, 1, 0, 5304, 1, ''),
(231, 0, 1, 0, 5304, 1, ''),
(232, 0, 1, 0, 5304, 1, ''),
(233, 0, 1, 0, 5304, 1, ''),
(234, 0, 1, 0, 5304, 1, ''),
(235, 0, 1, 0, 5304, 1, ''),
(236, 0, 1, 0, 5304, 1, ''),
(237, 0, 1, 0, 5304, 1, ''),
(238, 0, 1, 0, 5303, 1, ''),
(239, 0, 1, 0, 5303, 1, ''),
(240, 0, 1, 0, 5303, 1, ''),
(241, 0, 1, 0, 5303, 1, ''),
(242, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313734272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320353630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(243, 0, 1, 0, 5303, 1, ''),
(244, 0, 1, 0, 5303, 1, ''),
(245, 0, 1, 0, 5303, 1, ''),
(246, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313736272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320383430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(247, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313736272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320383430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(248, 0, 1, 0, 5303, 1, ''),
(249, 0, 1, 0, 5304, 1, ''),
(250, 0, 1, 0, 5304, 1, ''),
(251, 0, 1, 0, 5303, 1, ''),
(252, 0, 1, 0, 5304, 1, ''),
(253, 0, 1, 0, 5304, 1, ''),
(254, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313737272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320393030303020676f6c6420636f696e732e0600646f6f7269640203000000),
(255, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313737272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320393030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(256, 0, 1, 0, 5303, 1, ''),
(257, 0, 1, 0, 5303, 1, ''),
(258, 0, 1, 0, 5303, 1, ''),
(259, 0, 1, 0, 5303, 1, ''),
(260, 0, 1, 0, 5304, 1, ''),
(261, 0, 1, 0, 5304, 1, ''),
(262, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313738272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320393830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(263, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313738272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320393830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(264, 0, 1, 0, 5303, 1, ''),
(265, 0, 1, 0, 5303, 1, ''),
(266, 0, 1, 0, 5303, 1, ''),
(267, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313739272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031303030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(268, 0, 1, 0, 5303, 1, ''),
(269, 0, 1, 0, 5303, 1, ''),
(270, 0, 1, 0, 5304, 1, ''),
(271, 0, 1, 0, 5304, 1, ''),
(272, 0, 1, 0, 5303, 1, ''),
(273, 0, 1, 0, 5304, 1, ''),
(274, 0, 1, 0, 5304, 1, ''),
(275, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313830272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320393630303020676f6c6420636f696e732e0600646f6f7269640203000000),
(276, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313830272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320393630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(277, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313831272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320383230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(278, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313831272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320383230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(279, 0, 1, 0, 5304, 1, ''),
(280, 0, 1, 0, 5304, 1, ''),
(281, 0, 1, 0, 6436, 1, ''),
(282, 0, 1, 0, 1210, 1, ''),
(283, 0, 1, 0, 1212, 1, 0x8002000b006465736372697074696f6e015e00000049742062656c6f6e677320746f20686f7573652027436572756c65616e20486f7573652023313832272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032343030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(284, 0, 1, 0, 1210, 1, ''),
(285, 0, 1, 0, 6436, 1, ''),
(286, 0, 1, 0, 5304, 1, ''),
(287, 0, 1, 0, 5304, 1, ''),
(288, 0, 1, 0, 5304, 1, ''),
(289, 0, 1, 0, 5304, 1, ''),
(290, 0, 1, 0, 5303, 1, ''),
(291, 0, 1, 0, 5303, 1, ''),
(292, 0, 1, 0, 5303, 1, ''),
(293, 0, 1, 0, 5303, 1, ''),
(294, 0, 1, 0, 5304, 1, ''),
(295, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313833272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032333830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(296, 0, 1, 0, 5303, 1, ''),
(297, 0, 1, 0, 5303, 1, ''),
(298, 0, 1, 0, 5303, 1, ''),
(299, 0, 1, 0, 5303, 1, ''),
(300, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313834272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032343030303020676f6c6420636f696e732e0600646f6f7269640203000000),
(301, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313834272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032343030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(302, 0, 1, 0, 5304, 1, ''),
(303, 0, 1, 0, 5304, 1, ''),
(304, 0, 1, 0, 5303, 1, ''),
(305, 0, 1, 0, 5303, 1, ''),
(306, 0, 1, 0, 5304, 1, ''),
(307, 0, 1, 0, 5304, 1, ''),
(308, 0, 1, 0, 5303, 1, ''),
(309, 0, 1, 0, 5303, 1, ''),
(310, 0, 1, 0, 5303, 1, ''),
(311, 0, 1, 0, 5303, 1, ''),
(312, 0, 1, 0, 5303, 1, ''),
(313, 0, 1, 0, 5303, 1, ''),
(314, 0, 1, 0, 5304, 1, ''),
(315, 0, 1, 0, 5304, 1, ''),
(316, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313835272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032333230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(317, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313835272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032333230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(318, 0, 1, 0, 5304, 1, ''),
(319, 0, 1, 0, 5304, 1, ''),
(320, 0, 1, 0, 5303, 1, ''),
(321, 0, 1, 0, 5303, 1, ''),
(322, 0, 1, 0, 5303, 1, ''),
(323, 0, 1, 0, 5303, 1, ''),
(324, 0, 1, 0, 5304, 1, ''),
(325, 0, 1, 0, 5304, 1, ''),
(326, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313836272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032333230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(327, 0, 1, 0, 5304, 1, ''),
(328, 0, 1, 0, 5304, 1, ''),
(329, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313836272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032333230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(330, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313837272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032343030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(331, 0, 1, 0, 5304, 1, ''),
(332, 0, 1, 0, 5304, 1, ''),
(333, 0, 1, 0, 5303, 1, ''),
(334, 0, 1, 0, 5303, 1, ''),
(335, 0, 1, 0, 5304, 1, ''),
(336, 0, 1, 0, 5304, 1, ''),
(337, 0, 1, 0, 5303, 1, ''),
(338, 0, 1, 0, 5303, 1, ''),
(339, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313838272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032343030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(340, 0, 1, 0, 5304, 1, ''),
(341, 0, 1, 0, 5304, 1, ''),
(342, 0, 1, 0, 5303, 1, ''),
(343, 0, 1, 0, 5303, 1, ''),
(344, 0, 1, 0, 5304, 1, ''),
(345, 0, 1, 0, 5304, 1, ''),
(346, 0, 1, 0, 5303, 1, ''),
(347, 0, 1, 0, 5303, 1, ''),
(348, 0, 1, 0, 5303, 1, ''),
(349, 0, 1, 0, 5303, 1, ''),
(350, 0, 1, 0, 5304, 1, ''),
(351, 0, 1, 0, 5304, 1, ''),
(352, 0, 1, 0, 5304, 1, ''),
(353, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313839272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032323630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(354, 0, 1, 0, 5303, 1, ''),
(355, 0, 1, 0, 5303, 1, ''),
(356, 0, 1, 0, 5304, 1, ''),
(357, 0, 1, 0, 5304, 1, ''),
(358, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313930272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032313030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(359, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313931272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033363430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(360, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313931272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033363430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(361, 0, 1, 0, 5303, 1, ''),
(362, 0, 1, 0, 5304, 1, ''),
(363, 0, 1, 0, 5304, 1, ''),
(364, 0, 1, 0, 5303, 1, ''),
(365, 0, 1, 0, 5304, 1, ''),
(366, 0, 1, 0, 5303, 1, ''),
(367, 0, 1, 0, 5303, 1, ''),
(368, 0, 1, 0, 5303, 1, ''),
(369, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313932272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033393830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(370, 0, 1, 0, 5304, 1, ''),
(371, 0, 1, 0, 5304, 1, ''),
(372, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313932272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033393830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(373, 0, 1, 0, 5303, 1, ''),
(374, 0, 1, 0, 5303, 1, ''),
(375, 0, 1, 0, 5303, 1, ''),
(376, 0, 1, 0, 5303, 1, ''),
(377, 0, 1, 0, 5304, 1, ''),
(378, 0, 1, 0, 5304, 1, ''),
(379, 0, 1, 0, 5304, 1, ''),
(380, 0, 1, 0, 5304, 1, ''),
(381, 0, 1, 0, 5303, 1, ''),
(382, 0, 1, 0, 5303, 1, ''),
(383, 0, 1, 0, 5303, 1, ''),
(384, 0, 1, 0, 5303, 1, ''),
(385, 0, 1, 0, 5304, 1, ''),
(386, 0, 1, 0, 5304, 1, ''),
(387, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313933272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034303230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(388, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313933272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034303230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(389, 0, 1, 0, 5304, 1, ''),
(390, 0, 1, 0, 5304, 1, ''),
(391, 0, 1, 0, 5303, 1, ''),
(392, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313933272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034303230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(393, 0, 1, 0, 5303, 1, ''),
(394, 0, 1, 0, 5303, 1, ''),
(395, 0, 1, 0, 5304, 1, ''),
(396, 0, 1, 0, 5304, 1, ''),
(397, 0, 1, 0, 5304, 1, ''),
(398, 0, 1, 0, 5304, 1, ''),
(399, 0, 1, 0, 5303, 1, ''),
(400, 0, 1, 0, 5303, 1, ''),
(401, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313934272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373630303020676f6c6420636f696e732e0600646f6f7269640203000000),
(402, 0, 1, 0, 5304, 1, ''),
(403, 0, 1, 0, 5304, 1, ''),
(404, 0, 1, 0, 5304, 1, ''),
(405, 0, 1, 0, 5304, 1, ''),
(406, 0, 1, 0, 5304, 1, ''),
(407, 0, 1, 0, 5304, 1, ''),
(408, 0, 1, 0, 5304, 1, ''),
(409, 0, 1, 0, 5304, 1, ''),
(410, 0, 1, 0, 5303, 1, ''),
(411, 0, 1, 0, 5303, 1, ''),
(412, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313934272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(413, 0, 1, 0, 5303, 1, ''),
(414, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313935272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031323830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(415, 0, 1, 0, 5304, 1, ''),
(416, 0, 1, 0, 5304, 1, ''),
(417, 0, 1, 0, 5303, 1, ''),
(418, 0, 1, 0, 5304, 1, ''),
(419, 0, 1, 0, 5303, 1, ''),
(420, 0, 1, 0, 5303, 1, ''),
(421, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313936272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034313630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(422, 0, 1, 0, 5304, 1, ''),
(423, 0, 1, 0, 5304, 1, ''),
(424, 0, 1, 0, 5304, 1, ''),
(425, 0, 1, 0, 5304, 1, ''),
(426, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313936272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034313630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(427, 0, 1, 0, 5303, 1, ''),
(428, 0, 1, 0, 5303, 1, ''),
(429, 0, 1, 0, 5303, 1, ''),
(430, 0, 1, 0, 5303, 1, ''),
(431, 0, 1, 0, 5303, 1, ''),
(432, 0, 1, 0, 5303, 1, ''),
(433, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313937272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(434, 0, 1, 0, 5303, 1, ''),
(435, 0, 1, 0, 5303, 1, ''),
(436, 0, 1, 0, 5303, 1, ''),
(437, 0, 1, 0, 5303, 1, ''),
(438, 0, 1, 0, 5304, 1, ''),
(439, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313937272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363630303020676f6c6420636f696e732e0600646f6f7269640204000000),
(440, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313937272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363630303020676f6c6420636f696e732e0600646f6f7269640203000000),
(441, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313937272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(442, 0, 1, 0, 5304, 1, ''),
(443, 0, 1, 0, 5304, 1, ''),
(444, 0, 1, 0, 5303, 1, ''),
(445, 0, 1, 0, 5303, 1, ''),
(446, 0, 1, 0, 5304, 1, ''),
(447, 0, 1, 0, 5303, 1, ''),
(448, 0, 1, 0, 5304, 1, ''),
(449, 0, 1, 0, 5303, 1, ''),
(450, 0, 1, 0, 5304, 1, ''),
(451, 0, 1, 0, 5304, 1, ''),
(452, 0, 1, 0, 5303, 1, ''),
(453, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313938272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032363830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(454, 0, 1, 0, 5303, 1, ''),
(455, 0, 1, 0, 5304, 1, ''),
(456, 0, 1, 0, 5304, 1, ''),
(457, 0, 1, 0, 5303, 1, ''),
(458, 0, 1, 0, 5303, 1, ''),
(459, 0, 1, 0, 5303, 1, ''),
(460, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023313939272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033353830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(461, 0, 1, 0, 5303, 1, ''),
(462, 0, 1, 0, 5303, 1, ''),
(463, 0, 1, 0, 5303, 1, ''),
(464, 0, 1, 0, 5304, 1, ''),
(465, 0, 1, 0, 5304, 1, ''),
(466, 0, 1, 0, 5304, 1, ''),
(467, 0, 1, 0, 5304, 1, ''),
(468, 0, 1, 0, 5304, 1, ''),
(469, 0, 1, 0, 5304, 1, ''),
(470, 0, 1, 0, 5304, 1, ''),
(471, 0, 1, 0, 5304, 1, ''),
(472, 0, 1, 0, 5304, 1, ''),
(473, 0, 1, 0, 5304, 1, ''),
(474, 0, 1, 0, 5304, 1, ''),
(475, 0, 1, 0, 5304, 1, ''),
(476, 0, 1, 0, 5304, 1, ''),
(477, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323030272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031343830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(478, 0, 1, 0, 5303, 1, ''),
(479, 0, 1, 0, 5303, 1, ''),
(480, 0, 1, 0, 5304, 1, ''),
(481, 0, 1, 0, 5304, 1, ''),
(482, 0, 1, 0, 5303, 1, ''),
(483, 0, 1, 0, 5303, 1, ''),
(484, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323031272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032363830303020676f6c6420636f696e732e0600646f6f7269640204000000),
(485, 0, 1, 0, 5304, 1, ''),
(486, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323031272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032363830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(487, 0, 1, 0, 5304, 1, ''),
(488, 0, 1, 0, 5304, 1, ''),
(489, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323031272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032363830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(490, 0, 1, 0, 5303, 1, ''),
(491, 0, 1, 0, 5303, 1, ''),
(492, 0, 1, 0, 5304, 1, ''),
(493, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323032272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033313030303020676f6c6420636f696e732e0600646f6f7269640203000000),
(494, 0, 1, 0, 5303, 1, ''),
(495, 0, 1, 0, 5304, 1, ''),
(496, 0, 1, 0, 5304, 1, ''),
(497, 0, 1, 0, 5304, 1, ''),
(498, 0, 1, 0, 5304, 1, ''),
(499, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323032272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033313030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(500, 0, 1, 0, 5303, 1, ''),
(501, 0, 1, 0, 5303, 1, ''),
(502, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323033272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033303230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(503, 0, 1, 0, 5304, 1, ''),
(504, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323033272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033303230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(505, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323033272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033303230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(506, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323034272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032383830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(507, 0, 1, 0, 5304, 1, ''),
(508, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323034272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032383830303020676f6c6420636f696e732e0600646f6f7269640203000000),
(509, 0, 1, 0, 5304, 1, ''),
(510, 0, 1, 0, 5304, 1, ''),
(511, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323034272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032383830303020676f6c6420636f696e732e0600646f6f7269640204000000),
(512, 0, 1, 0, 5304, 1, ''),
(513, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323035272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(514, 0, 1, 0, 5304, 1, ''),
(515, 0, 1, 0, 5304, 1, ''),
(516, 0, 1, 0, 5304, 1, ''),
(517, 0, 1, 0, 5304, 1, '');
INSERT INTO `tile_items` (`tile_id`, `world_id`, `sid`, `pid`, `itemtype`, `count`, `attributes`) VALUES
(518, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323036272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033333430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(519, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323036272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033333430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(520, 0, 1, 0, 5304, 1, ''),
(521, 0, 1, 0, 5304, 1, ''),
(522, 0, 1, 0, 5303, 1, ''),
(523, 0, 1, 0, 5303, 1, ''),
(524, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323037272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031393630303020676f6c6420636f696e732e0600646f6f7269640203000000),
(525, 0, 1, 0, 5304, 1, ''),
(526, 0, 1, 0, 5304, 1, ''),
(527, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323037272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031393630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(528, 0, 1, 0, 5303, 1, ''),
(529, 0, 1, 0, 5303, 1, ''),
(530, 0, 1, 0, 5303, 1, ''),
(531, 0, 1, 0, 5303, 1, ''),
(532, 0, 1, 0, 5303, 1, ''),
(533, 0, 1, 0, 5303, 1, ''),
(534, 0, 1, 0, 5303, 1, ''),
(535, 0, 1, 0, 5303, 1, ''),
(536, 0, 1, 0, 5303, 1, ''),
(537, 0, 1, 0, 5303, 1, ''),
(538, 0, 1, 0, 5304, 1, ''),
(539, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323038272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732038323230303020676f6c6420636f696e732e0600646f6f7269640204000000),
(540, 0, 1, 0, 5304, 1, ''),
(541, 0, 1, 0, 5304, 1, ''),
(542, 0, 1, 0, 5304, 1, ''),
(543, 0, 1, 0, 5304, 1, ''),
(544, 0, 1, 0, 5303, 1, ''),
(545, 0, 1, 0, 5303, 1, ''),
(546, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323038272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732038323230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(547, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323038272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732038323230303020676f6c6420636f696e732e0600646f6f7269640205000000),
(548, 0, 1, 0, 5303, 1, ''),
(549, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323038272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732038323230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(550, 0, 1, 0, 5303, 1, ''),
(551, 0, 1, 0, 5303, 1, ''),
(552, 0, 1, 0, 5304, 1, ''),
(553, 0, 1, 0, 5303, 1, ''),
(554, 0, 1, 0, 5304, 1, ''),
(555, 0, 1, 0, 5303, 1, ''),
(556, 0, 1, 0, 5304, 1, ''),
(557, 0, 1, 0, 5304, 1, ''),
(558, 0, 1, 0, 5304, 1, ''),
(559, 0, 1, 0, 5304, 1, ''),
(560, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323039272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363630303020676f6c6420636f696e732e0600646f6f7269640204000000),
(561, 0, 1, 0, 5304, 1, ''),
(562, 0, 1, 0, 5304, 1, ''),
(563, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323039272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(564, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323039272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363630303020676f6c6420636f696e732e0600646f6f7269640205000000),
(565, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323039272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(566, 0, 1, 0, 5303, 1, ''),
(567, 0, 1, 0, 5303, 1, ''),
(568, 0, 1, 0, 5303, 1, ''),
(569, 0, 1, 0, 5303, 1, ''),
(570, 0, 1, 0, 5304, 1, ''),
(571, 0, 1, 0, 5304, 1, ''),
(572, 0, 1, 0, 5304, 1, ''),
(573, 0, 1, 0, 5304, 1, ''),
(574, 0, 1, 0, 5303, 1, ''),
(575, 0, 1, 0, 5303, 1, ''),
(576, 0, 1, 0, 5303, 1, ''),
(577, 0, 1, 0, 5303, 1, ''),
(578, 0, 1, 0, 5303, 1, ''),
(579, 0, 1, 0, 5303, 1, ''),
(580, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323130272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034333230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(581, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323130272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034333230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(582, 0, 1, 0, 5303, 1, ''),
(583, 0, 1, 0, 5303, 1, ''),
(584, 0, 1, 0, 5304, 1, ''),
(585, 0, 1, 0, 5304, 1, ''),
(586, 0, 1, 0, 5304, 1, ''),
(587, 0, 1, 0, 5304, 1, ''),
(588, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323130272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034333230303020676f6c6420636f696e732e0600646f6f7269640204000000),
(589, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323130272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034333230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(590, 0, 1, 0, 5304, 1, ''),
(591, 0, 1, 0, 5304, 1, ''),
(592, 0, 1, 0, 5304, 1, ''),
(593, 0, 1, 0, 5303, 1, ''),
(594, 0, 1, 0, 5303, 1, ''),
(595, 0, 1, 0, 5303, 1, ''),
(596, 0, 1, 0, 5303, 1, ''),
(597, 0, 1, 0, 5303, 1, ''),
(598, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323131272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(599, 0, 1, 0, 5304, 1, ''),
(600, 0, 1, 0, 5304, 1, ''),
(601, 0, 1, 0, 5304, 1, ''),
(602, 0, 1, 0, 5304, 1, ''),
(603, 0, 1, 0, 5303, 1, ''),
(604, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323131272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(605, 0, 1, 0, 5303, 1, ''),
(606, 0, 1, 0, 5303, 1, ''),
(607, 0, 1, 0, 5303, 1, ''),
(608, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323131272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(609, 0, 1, 0, 5303, 1, ''),
(610, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323131272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363430303020676f6c6420636f696e732e0600646f6f7269640204000000),
(611, 0, 1, 0, 5303, 1, ''),
(612, 0, 1, 0, 5303, 1, ''),
(613, 0, 1, 0, 5303, 1, ''),
(614, 0, 1, 0, 5303, 1, ''),
(615, 0, 1, 0, 5304, 1, ''),
(616, 0, 1, 0, 5304, 1, ''),
(617, 0, 1, 0, 5304, 1, ''),
(618, 0, 1, 0, 5304, 1, ''),
(619, 0, 1, 0, 5304, 1, ''),
(620, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202743656c61646f6e20486f7573652023323132272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032353030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(621, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202753616666726f6e20486f7573652023323133272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031303630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(622, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202753616666726f6e20486f7573652023323136272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031343230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(623, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202753616666726f6e20486f7573652023323137272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031363030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(624, 0, 1, 0, 11790, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031353830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(625, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031383630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(626, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031383630303020676f6c6420636f696e732e0600646f6f7269640203000000),
(627, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014a00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320383030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(628, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031303630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(629, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031323030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(630, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031323030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(631, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031323030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(632, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014a00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320393630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(633, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(634, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(635, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(636, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(637, 0, 1, 0, 1252, 1, ''),
(638, 0, 1, 0, 1252, 1, ''),
(639, 0, 1, 0, 1249, 1, ''),
(640, 0, 1, 0, 1252, 1, ''),
(641, 0, 1, 0, 1249, 1, ''),
(642, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(643, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(644, 0, 1, 0, 1253, 1, ''),
(645, 0, 1, 0, 1249, 1, ''),
(646, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(647, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(648, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(649, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(650, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031313430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(651, 0, 1, 0, 5303, 1, ''),
(652, 0, 1, 0, 5304, 1, ''),
(653, 0, 1, 0, 5304, 1, ''),
(654, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031313430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(655, 0, 1, 0, 5303, 1, ''),
(656, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031333630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(657, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031333630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(658, 0, 1, 0, 5303, 1, ''),
(659, 0, 1, 0, 5304, 1, ''),
(660, 0, 1, 0, 5304, 1, ''),
(661, 0, 1, 0, 5303, 1, ''),
(662, 0, 1, 0, 5304, 1, ''),
(663, 0, 1, 0, 5304, 1, ''),
(664, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031303830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(665, 0, 1, 0, 5303, 1, ''),
(666, 0, 1, 0, 5304, 1, ''),
(667, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031323230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(668, 0, 1, 0, 5303, 1, ''),
(669, 0, 1, 0, 5304, 1, ''),
(670, 0, 1, 0, 5304, 1, ''),
(671, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(672, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(673, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031313030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(674, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031363230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(675, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031363230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(676, 0, 1, 0, 5304, 1, ''),
(677, 0, 1, 0, 5304, 1, ''),
(678, 0, 1, 0, 5303, 1, ''),
(679, 0, 1, 0, 5303, 1, ''),
(680, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032343030303020676f6c6420636f696e732e0600646f6f7269640203000000),
(681, 0, 1, 0, 5303, 1, ''),
(682, 0, 1, 0, 5304, 1, ''),
(683, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032343030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(684, 0, 1, 0, 5303, 1, ''),
(685, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031313230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(686, 0, 1, 0, 5303, 1, ''),
(687, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031313230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(688, 0, 1, 0, 5303, 1, ''),
(689, 0, 1, 0, 5304, 1, ''),
(690, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031373030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(691, 0, 1, 0, 5303, 1, ''),
(692, 0, 1, 0, 5303, 1, ''),
(693, 0, 1, 0, 5304, 1, ''),
(694, 0, 1, 0, 5304, 1, ''),
(695, 0, 1, 0, 5303, 1, ''),
(696, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(697, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(698, 0, 1, 0, 5303, 1, ''),
(699, 0, 1, 0, 5303, 1, ''),
(700, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034343830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(701, 0, 1, 0, 5303, 1, ''),
(702, 0, 1, 0, 5303, 1, ''),
(703, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(704, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(705, 0, 1, 0, 5303, 1, ''),
(706, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033323830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(707, 0, 1, 0, 5303, 1, ''),
(708, 0, 1, 0, 5303, 1, ''),
(709, 0, 1, 0, 5303, 1, ''),
(710, 0, 1, 0, 5304, 1, ''),
(711, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036373230303020676f6c6420636f696e732e0600646f6f7269640205000000),
(712, 0, 1, 0, 5304, 1, ''),
(713, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036373230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(714, 0, 1, 0, 5304, 1, ''),
(715, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036373230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(716, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(717, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(718, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036373230303020676f6c6420636f696e732e0600646f6f7269640204000000),
(719, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036373230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(720, 0, 1, 0, 5303, 1, ''),
(721, 0, 1, 0, 5303, 1, ''),
(722, 0, 1, 0, 5304, 1, ''),
(723, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033303830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(724, 0, 1, 0, 5304, 1, ''),
(725, 0, 1, 0, 5303, 1, ''),
(726, 0, 1, 0, 5303, 1, ''),
(727, 0, 1, 0, 5303, 1, ''),
(728, 0, 1, 0, 5303, 1, ''),
(729, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032383430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(730, 0, 1, 0, 5304, 1, ''),
(731, 0, 1, 0, 5304, 1, ''),
(732, 0, 1, 0, 5304, 1, ''),
(733, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032343030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(734, 0, 1, 0, 5303, 1, ''),
(735, 0, 1, 0, 5303, 1, ''),
(736, 0, 1, 0, 5304, 1, ''),
(737, 0, 1, 0, 5304, 1, ''),
(738, 0, 1, 0, 5303, 1, ''),
(739, 0, 1, 0, 5303, 1, ''),
(740, 0, 1, 0, 5303, 1, ''),
(741, 0, 1, 0, 1252, 1, ''),
(742, 0, 1, 0, 5304, 1, ''),
(743, 0, 1, 0, 5304, 1, ''),
(744, 0, 1, 0, 5303, 1, ''),
(745, 0, 1, 0, 5304, 1, ''),
(746, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(747, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(748, 0, 1, 0, 5303, 1, ''),
(749, 0, 1, 0, 5303, 1, ''),
(750, 0, 1, 0, 5304, 1, ''),
(751, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032333630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(752, 0, 1, 0, 5303, 1, ''),
(753, 0, 1, 0, 5303, 1, ''),
(754, 0, 1, 0, 11793, 1, ''),
(755, 0, 1, 0, 5304, 1, ''),
(756, 0, 1, 0, 5304, 1, ''),
(757, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(758, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(759, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(760, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(761, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(762, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(763, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(764, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(765, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033323030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(766, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(767, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(768, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014a00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320353630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(769, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(770, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(771, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014a00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320383430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(772, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(773, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(774, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014a00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320383230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(775, 0, 1, 0, 1249, 1, ''),
(776, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(777, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(778, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(779, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(780, 0, 1, 0, 1249, 1, ''),
(781, 0, 1, 0, 5304, 1, ''),
(782, 0, 1, 0, 5303, 1, ''),
(783, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014a00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320353630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(784, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(785, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014a00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320363030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(786, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(787, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(788, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(789, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014a00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320373030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(790, 0, 1, 0, 5303, 1, ''),
(791, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(792, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(793, 0, 1, 0, 5303, 1, ''),
(794, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303230303020676f6c6420636f696e732e0600646f6f7269640204000000),
(795, 0, 1, 0, 5304, 1, ''),
(796, 0, 1, 0, 5303, 1, ''),
(797, 0, 1, 0, 5303, 1, ''),
(798, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(799, 0, 1, 0, 5303, 1, ''),
(800, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(801, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(802, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(803, 0, 1, 0, 5303, 1, ''),
(804, 0, 1, 0, 5303, 1, ''),
(805, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014a00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320383430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(806, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031343030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(807, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(808, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(809, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(810, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(811, 0, 1, 0, 5303, 1, ''),
(812, 0, 1, 0, 5303, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031343030303020676f6c6420636f696e732e0600646f6f7269640204000000),
(813, 0, 1, 0, 5304, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031343030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(814, 0, 1, 0, 5303, 1, ''),
(815, 0, 1, 0, 5304, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031343030303020676f6c6420636f696e732e0600646f6f7269640203000000),
(816, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(817, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(818, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031323030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(819, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(820, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(821, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014a00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320363830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(822, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(823, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(824, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303030303020676f6c6420636f696e732e0600646f6f7269640204000000),
(825, 0, 1, 0, 5304, 1, ''),
(826, 0, 1, 0, 5303, 1, ''),
(827, 0, 1, 0, 5304, 1, ''),
(828, 0, 1, 0, 5303, 1, ''),
(829, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(830, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(831, 0, 1, 0, 5303, 1, ''),
(832, 0, 1, 0, 5304, 1, ''),
(833, 0, 1, 0, 5304, 1, ''),
(834, 0, 1, 0, 5304, 1, ''),
(835, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035323630303020676f6c6420636f696e732e0600646f6f7269640203000000),
(836, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035323630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(837, 0, 1, 0, 5304, 1, ''),
(838, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035323630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(839, 0, 1, 0, 5303, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035323630303020676f6c6420636f696e732e0600646f6f7269640204000000),
(840, 0, 1, 0, 5303, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035323630303020676f6c6420636f696e732e0600646f6f7269640205000000),
(841, 0, 1, 0, 5303, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035323630303020676f6c6420636f696e732e0600646f6f7269640206000000),
(842, 0, 1, 0, 1760, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(843, 0, 1, 0, 1761, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(844, 0, 1, 0, 1760, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(845, 0, 1, 0, 1761, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(846, 0, 1, 0, 11799, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202753616666726f6e20486f7573652023323637272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035323430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(847, 0, 1, 0, 11797, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202753616666726f6e20486f7573652023323637272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035323430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(848, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(849, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(850, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(851, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(852, 0, 1, 0, 11799, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202753616666726f6e20486f7573652023323637272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035323430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(853, 0, 1, 0, 11799, 1, 0x8002000b006465736372697074696f6e015d00000049742062656c6f6e677320746f20686f757365202753616666726f6e20486f7573652023323637272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035323430303020676f6c6420636f696e732e0600646f6f7269640205000000),
(854, 0, 1, 0, 1250, 1, ''),
(855, 0, 1, 0, 5304, 1, ''),
(856, 0, 1, 0, 1250, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034313630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(857, 0, 1, 0, 1250, 1, ''),
(858, 0, 1, 0, 5304, 1, ''),
(859, 0, 1, 0, 5303, 1, ''),
(860, 0, 1, 0, 5304, 1, ''),
(861, 0, 1, 0, 5303, 1, ''),
(862, 0, 1, 0, 5304, 1, ''),
(863, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(864, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(865, 0, 1, 0, 5303, 1, ''),
(866, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(867, 0, 1, 0, 5304, 1, ''),
(868, 0, 1, 0, 1250, 1, ''),
(869, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(870, 0, 1, 0, 5303, 1, ''),
(871, 0, 1, 0, 5304, 1, ''),
(872, 0, 1, 0, 5304, 1, ''),
(873, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034323230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(874, 0, 1, 0, 5304, 1, ''),
(875, 0, 1, 0, 5304, 1, ''),
(876, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(877, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(878, 0, 1, 0, 1258, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033393030303020676f6c6420636f696e732e0600646f6f7269640205000000),
(879, 0, 1, 0, 5304, 1, ''),
(880, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033393030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(881, 0, 1, 0, 1258, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033393030303020676f6c6420636f696e732e0600646f6f7269640203000000),
(882, 0, 1, 0, 5303, 1, ''),
(883, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033393030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(884, 0, 1, 0, 5303, 1, ''),
(885, 0, 1, 0, 5303, 1, ''),
(886, 0, 1, 0, 5304, 1, ''),
(887, 0, 1, 0, 5303, 1, ''),
(888, 0, 1, 0, 5303, 1, ''),
(889, 0, 1, 0, 5304, 1, ''),
(890, 0, 1, 0, 5304, 1, ''),
(891, 0, 1, 0, 1250, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323731272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732038363630303020676f6c6420636f696e732e0600646f6f7269640204000000),
(892, 0, 1, 0, 1250, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323731272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732038363630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(893, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323731272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732038363630303020676f6c6420636f696e732e0600646f6f7269640203000000),
(894, 0, 1, 0, 5304, 1, ''),
(895, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732038363630303020676f6c6420636f696e732e0600646f6f7269640205000000),
(896, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(897, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(898, 0, 1, 0, 5304, 1, ''),
(899, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323732272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033333430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(900, 0, 1, 0, 5304, 1, ''),
(901, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(902, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(903, 0, 1, 0, 5304, 1, ''),
(904, 0, 1, 0, 1250, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323732272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033333430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(905, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323732272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033333430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(906, 0, 1, 0, 1250, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323733272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033393430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(907, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323733272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033393430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(908, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(909, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(910, 0, 1, 0, 5303, 1, ''),
(911, 0, 1, 0, 5303, 1, ''),
(912, 0, 1, 0, 5304, 1, ''),
(913, 0, 1, 0, 5303, 1, ''),
(914, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(915, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(916, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323734272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(917, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034363230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(918, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(919, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(920, 0, 1, 0, 5303, 1, ''),
(921, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323735272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034353630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(922, 0, 1, 0, 5303, 1, ''),
(923, 0, 1, 0, 5303, 1, ''),
(924, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323735272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034353630303020676f6c6420636f696e732e0600646f6f7269640203000000),
(925, 0, 1, 0, 5303, 1, ''),
(926, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323736272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032373230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(927, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323736272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032373230303020676f6c6420636f696e732e0600646f6f7269640204000000),
(928, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323736272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032373230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(929, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(930, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(931, 0, 1, 0, 1252, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323736272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032373230303020676f6c6420636f696e732e0600646f6f7269640205000000),
(932, 0, 1, 0, 5304, 1, ''),
(933, 0, 1, 0, 5303, 1, ''),
(934, 0, 1, 0, 5303, 1, ''),
(935, 0, 1, 0, 5304, 1, ''),
(936, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032313230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(937, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(938, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(939, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032313230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(940, 0, 1, 0, 5304, 1, ''),
(941, 0, 1, 0, 5304, 1, ''),
(942, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323738272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032373830303020676f6c6420636f696e732e0600646f6f7269640203000000),
(943, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e015f00000049742062656c6f6e677320746f20686f75736520275665726d696c696f6e20486f7573652023323738272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032373830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(944, 0, 1, 0, 1249, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032373830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(945, 0, 1, 0, 5303, 1, ''),
(946, 0, 1, 0, 5303, 1, ''),
(947, 0, 1, 0, 5303, 1, ''),
(948, 0, 1, 0, 1250, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032393630303020676f6c6420636f696e732e0600646f6f7269640203000000),
(949, 0, 1, 0, 5304, 1, ''),
(950, 0, 1, 0, 5304, 1, ''),
(951, 0, 1, 0, 5304, 1, ''),
(952, 0, 1, 0, 1253, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032393630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(953, 0, 1, 0, 5304, 1, ''),
(954, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(955, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(956, 0, 1, 0, 5303, 1, ''),
(957, 0, 1, 0, 5303, 1, ''),
(958, 0, 1, 0, 7025, 1, ''),
(959, 0, 1, 0, 7025, 1, ''),
(960, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(961, 0, 1, 0, 7026, 1, ''),
(962, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(963, 0, 1, 0, 7026, 1, ''),
(964, 0, 1, 0, 7026, 1, ''),
(965, 0, 1, 0, 7026, 1, ''),
(966, 0, 1, 0, 7026, 1, ''),
(967, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(968, 0, 1, 0, 7026, 1, ''),
(969, 0, 1, 0, 7026, 1, ''),
(970, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(971, 0, 1, 0, 7026, 1, ''),
(972, 0, 1, 0, 7025, 1, ''),
(973, 0, 1, 0, 7025, 1, ''),
(974, 0, 1, 0, 7026, 1, ''),
(975, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033323030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(976, 0, 1, 0, 7026, 1, ''),
(977, 0, 1, 0, 7025, 1, ''),
(978, 0, 1, 0, 7025, 1, ''),
(979, 0, 1, 0, 7025, 1, ''),
(980, 0, 1, 0, 7025, 1, ''),
(981, 0, 1, 0, 7025, 1, ''),
(982, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(983, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(984, 0, 1, 0, 7025, 1, ''),
(985, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(986, 0, 1, 0, 7026, 1, ''),
(987, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(988, 0, 1, 0, 7026, 1, ''),
(989, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(990, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640206000000),
(991, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640207000000);
INSERT INTO `tile_items` (`tile_id`, `world_id`, `sid`, `pid`, `itemtype`, `count`, `attributes`) VALUES
(992, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640205000000),
(993, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(994, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(995, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640204000000),
(996, 0, 1, 0, 7025, 1, ''),
(997, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(998, 0, 1, 0, 7025, 1, ''),
(999, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1000, 0, 1, 0, 7026, 1, ''),
(1001, 0, 1, 0, 7026, 1, ''),
(1002, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1003, 0, 1, 0, 7025, 1, ''),
(1004, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1005, 0, 1, 0, 7025, 1, ''),
(1006, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1007, 0, 1, 0, 7025, 1, ''),
(1008, 0, 1, 0, 7025, 1, ''),
(1009, 0, 1, 0, 7025, 1, ''),
(1010, 0, 1, 0, 7026, 1, ''),
(1011, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1012, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1013, 0, 1, 0, 7026, 1, ''),
(1014, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031353230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1015, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031353830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1016, 0, 1, 0, 7026, 1, ''),
(1017, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1018, 0, 1, 0, 7026, 1, ''),
(1019, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1020, 0, 1, 0, 7025, 1, ''),
(1021, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031363230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1022, 0, 1, 0, 7026, 1, ''),
(1023, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1024, 0, 1, 0, 7026, 1, ''),
(1025, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1026, 0, 1, 0, 7025, 1, ''),
(1027, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1028, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1029, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031343230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1030, 0, 1, 0, 7025, 1, ''),
(1031, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1032, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1033, 0, 1, 0, 7026, 1, ''),
(1034, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1035, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1036, 0, 1, 0, 7025, 1, ''),
(1037, 0, 1, 0, 7025, 1, ''),
(1038, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1039, 0, 1, 0, 7025, 1, ''),
(1040, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1041, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f7269640203000000),
(1042, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1043, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f7269640206000000),
(1044, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f7269640206000000),
(1045, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f7269640209000000),
(1046, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1047, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1048, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f726964020a000000),
(1049, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1050, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1051, 0, 1, 0, 7026, 1, ''),
(1052, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1053, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1054, 0, 1, 0, 7026, 1, ''),
(1055, 0, 1, 0, 7026, 1, ''),
(1056, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f726964020a000000),
(1057, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1058, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1059, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1060, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1061, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1062, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f7269640207000000),
(1063, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f7269640208000000),
(1064, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1065, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f7269640209000000),
(1066, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203130313030303020676f6c6420636f696e732e0600646f6f7269640205000000),
(1067, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1068, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1069, 0, 1, 0, 1754, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1070, 0, 1, 0, 1755, 1, 0x8001000b006465736372697074696f6e01190000004e6f626f647920697320736c656570696e672074686572652e),
(1071, 0, 1, 0, 7026, 1, ''),
(1072, 0, 1, 0, 7026, 1, ''),
(1073, 0, 1, 0, 7025, 1, ''),
(1074, 0, 1, 0, 7025, 1, ''),
(1075, 0, 1, 0, 7025, 1, ''),
(1076, 0, 1, 0, 7025, 1, ''),
(1077, 0, 1, 0, 7026, 1, ''),
(1078, 0, 1, 0, 7025, 1, ''),
(1079, 0, 1, 0, 7025, 1, ''),
(1080, 0, 1, 0, 7026, 1, ''),
(1081, 0, 1, 0, 7026, 1, ''),
(1082, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034313230303020676f6c6420636f696e732e0600646f6f7269640205000000),
(1083, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034313230303020676f6c6420636f696e732e0600646f6f7269640204000000),
(1084, 0, 1, 0, 7026, 1, ''),
(1085, 0, 1, 0, 7026, 1, ''),
(1086, 0, 1, 0, 7025, 1, ''),
(1087, 0, 1, 0, 7025, 1, ''),
(1088, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034313230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1089, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034313230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(1090, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034313230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1091, 0, 1, 0, 7026, 1, ''),
(1092, 0, 1, 0, 7026, 1, ''),
(1093, 0, 1, 0, 7025, 1, ''),
(1094, 0, 1, 0, 7025, 1, ''),
(1095, 0, 1, 0, 7025, 1, ''),
(1096, 0, 1, 0, 7025, 1, ''),
(1097, 0, 1, 0, 7025, 1, ''),
(1098, 0, 1, 0, 7025, 1, ''),
(1099, 0, 1, 0, 7026, 1, ''),
(1100, 0, 1, 0, 7026, 1, ''),
(1101, 0, 1, 0, 7026, 1, ''),
(1102, 0, 1, 0, 7025, 1, ''),
(1103, 0, 1, 0, 7025, 1, ''),
(1104, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036373030303020676f6c6420636f696e732e0600646f6f7269640205000000),
(1105, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036373030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1106, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036373030303020676f6c6420636f696e732e0600646f6f7269640204000000),
(1107, 0, 1, 0, 7026, 1, ''),
(1108, 0, 1, 0, 7026, 1, ''),
(1109, 0, 1, 0, 7025, 1, ''),
(1110, 0, 1, 0, 7025, 1, ''),
(1111, 0, 1, 0, 7025, 1, ''),
(1112, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036373030303020676f6c6420636f696e732e0600646f6f7269640203000000),
(1113, 0, 1, 0, 7026, 1, ''),
(1114, 0, 1, 0, 7025, 1, ''),
(1115, 0, 1, 0, 7026, 1, ''),
(1116, 0, 1, 0, 7025, 1, ''),
(1117, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036373030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1118, 0, 1, 0, 7026, 1, ''),
(1119, 0, 1, 0, 7026, 1, ''),
(1120, 0, 1, 0, 7025, 1, ''),
(1121, 0, 1, 0, 7025, 1, ''),
(1122, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035333630303020676f6c6420636f696e732e0600646f6f7269640206000000),
(1123, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035333630303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1124, 0, 1, 0, 7026, 1, ''),
(1125, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035333630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1126, 0, 1, 0, 7026, 1, ''),
(1127, 0, 1, 0, 7026, 1, ''),
(1128, 0, 1, 0, 7026, 1, ''),
(1129, 0, 1, 0, 7025, 1, ''),
(1130, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035333630303020676f6c6420636f696e732e0600646f6f7269640203000000),
(1131, 0, 1, 0, 7025, 1, ''),
(1132, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035333630303020676f6c6420636f696e732e0600646f6f7269640204000000),
(1133, 0, 1, 0, 7025, 1, ''),
(1134, 0, 1, 0, 7025, 1, ''),
(1135, 0, 1, 0, 7026, 1, ''),
(1136, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014a00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320383430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1137, 0, 1, 0, 7025, 1, ''),
(1138, 0, 1, 0, 7026, 1, ''),
(1139, 0, 1, 0, 7026, 1, ''),
(1140, 0, 1, 0, 7025, 1, ''),
(1141, 0, 1, 0, 7025, 1, ''),
(1142, 0, 1, 0, 7026, 1, ''),
(1143, 0, 1, 0, 7025, 1, ''),
(1144, 0, 1, 0, 7025, 1, ''),
(1145, 0, 1, 0, 7026, 1, ''),
(1146, 0, 1, 0, 7026, 1, ''),
(1147, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203131353230303020676f6c6420636f696e732e0600646f6f7269640206000000),
(1148, 0, 1, 0, 7026, 1, ''),
(1149, 0, 1, 0, 7026, 1, ''),
(1150, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203131353230303020676f6c6420636f696e732e0600646f6f7269640205000000),
(1151, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203131353230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1152, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203131353230303020676f6c6420636f696e732e0600646f6f726964020a000000),
(1153, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203131353230303020676f6c6420636f696e732e0600646f6f7269640207000000),
(1154, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203131353230303020676f6c6420636f696e732e0600646f6f7269640204000000),
(1155, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203131353230303020676f6c6420636f696e732e0600646f6f7269640209000000),
(1156, 0, 1, 0, 7026, 1, ''),
(1157, 0, 1, 0, 7026, 1, ''),
(1158, 0, 1, 0, 7026, 1, ''),
(1159, 0, 1, 0, 7026, 1, ''),
(1160, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203131353230303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1161, 0, 1, 0, 7026, 1, ''),
(1162, 0, 1, 0, 7026, 1, ''),
(1163, 0, 1, 0, 7026, 1, ''),
(1164, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014c00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f737473203131353230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(1165, 0, 1, 0, 7026, 1, ''),
(1166, 0, 1, 0, 7026, 1, ''),
(1167, 0, 1, 0, 7025, 1, ''),
(1168, 0, 1, 0, 7025, 1, ''),
(1169, 0, 1, 0, 7025, 1, ''),
(1170, 0, 1, 0, 7025, 1, ''),
(1171, 0, 1, 0, 7025, 1, ''),
(1172, 0, 1, 0, 7025, 1, ''),
(1173, 0, 1, 0, 7026, 1, ''),
(1174, 0, 1, 0, 7025, 1, ''),
(1175, 0, 1, 0, 7025, 1, ''),
(1176, 0, 1, 0, 7026, 1, ''),
(1177, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034323430303020676f6c6420636f696e732e0600646f6f7269640204000000),
(1178, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034323430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1179, 0, 1, 0, 7025, 1, ''),
(1180, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034323430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(1181, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034323430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1182, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034323430303020676f6c6420636f696e732e0600646f6f7269640205000000),
(1183, 0, 1, 0, 7026, 1, ''),
(1184, 0, 1, 0, 7026, 1, ''),
(1185, 0, 1, 0, 7025, 1, ''),
(1186, 0, 1, 0, 7025, 1, ''),
(1187, 0, 1, 0, 7025, 1, ''),
(1188, 0, 1, 0, 7025, 1, ''),
(1189, 0, 1, 0, 7026, 1, ''),
(1190, 0, 1, 0, 7025, 1, ''),
(1191, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032373830303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1192, 0, 1, 0, 7025, 1, ''),
(1193, 0, 1, 0, 7026, 1, ''),
(1194, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031383230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1195, 0, 1, 0, 7026, 1, ''),
(1196, 0, 1, 0, 7025, 1, ''),
(1197, 0, 1, 0, 7025, 1, ''),
(1198, 0, 1, 0, 7026, 1, ''),
(1199, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034373630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1200, 0, 1, 0, 7026, 1, ''),
(1201, 0, 1, 0, 7026, 1, ''),
(1202, 0, 1, 0, 7025, 1, ''),
(1203, 0, 1, 0, 7025, 1, ''),
(1204, 0, 1, 0, 7025, 1, ''),
(1205, 0, 1, 0, 7025, 1, ''),
(1206, 0, 1, 0, 7025, 1, ''),
(1207, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034343830303020676f6c6420636f696e732e0600646f6f7269640203000000),
(1208, 0, 1, 0, 7026, 1, ''),
(1209, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034343830303020676f6c6420636f696e732e0600646f6f7269640204000000),
(1210, 0, 1, 0, 7026, 1, ''),
(1211, 0, 1, 0, 7026, 1, ''),
(1212, 0, 1, 0, 7026, 1, ''),
(1213, 0, 1, 0, 7025, 1, ''),
(1214, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732034343830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1215, 0, 1, 0, 7026, 1, ''),
(1216, 0, 1, 0, 7026, 1, ''),
(1217, 0, 1, 0, 7025, 1, ''),
(1218, 0, 1, 0, 7025, 1, ''),
(1219, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036383430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1220, 0, 1, 0, 7025, 1, ''),
(1221, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036383430303020676f6c6420636f696e732e0600646f6f7269640208000000),
(1222, 0, 1, 0, 7025, 1, ''),
(1223, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036383430303020676f6c6420636f696e732e0600646f6f7269640207000000),
(1224, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036383430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1225, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036383430303020676f6c6420636f696e732e0600646f6f7269640204000000),
(1226, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036383430303020676f6c6420636f696e732e0600646f6f7269640206000000),
(1227, 0, 1, 0, 7026, 1, ''),
(1228, 0, 1, 0, 7026, 1, ''),
(1229, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036383430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(1230, 0, 1, 0, 7025, 1, ''),
(1231, 0, 1, 0, 7025, 1, ''),
(1232, 0, 1, 0, 7025, 1, ''),
(1233, 0, 1, 0, 7025, 1, ''),
(1234, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036383430303020676f6c6420636f696e732e0600646f6f7269640205000000),
(1235, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732036383430303020676f6c6420636f696e732e0600646f6f726964020a000000),
(1236, 0, 1, 0, 7026, 1, ''),
(1237, 0, 1, 0, 7026, 1, ''),
(1238, 0, 1, 0, 7025, 1, ''),
(1239, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640207000000),
(1240, 0, 1, 0, 7026, 1, ''),
(1241, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640208000000),
(1242, 0, 1, 0, 7026, 1, ''),
(1243, 0, 1, 0, 7026, 1, ''),
(1244, 0, 1, 0, 7025, 1, ''),
(1245, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(1246, 0, 1, 0, 7025, 1, ''),
(1247, 0, 1, 0, 7025, 1, ''),
(1248, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1249, 0, 1, 0, 7025, 1, ''),
(1250, 0, 1, 0, 7026, 1, ''),
(1251, 0, 1, 0, 7026, 1, ''),
(1252, 0, 1, 0, 7026, 1, ''),
(1253, 0, 1, 0, 7025, 1, ''),
(1254, 0, 1, 0, 7026, 1, ''),
(1255, 0, 1, 0, 7025, 1, ''),
(1256, 0, 1, 0, 6900, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640206000000),
(1257, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640209000000),
(1258, 0, 1, 0, 7025, 1, ''),
(1259, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640204000000),
(1260, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1261, 0, 1, 0, 7026, 1, ''),
(1262, 0, 1, 0, 7026, 1, ''),
(1263, 0, 1, 0, 7025, 1, ''),
(1264, 0, 1, 0, 7026, 1, ''),
(1265, 0, 1, 0, 7025, 1, ''),
(1266, 0, 1, 0, 7025, 1, ''),
(1267, 0, 1, 0, 6891, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732035393430303020676f6c6420636f696e732e0600646f6f7269640205000000),
(1268, 0, 1, 0, 7025, 1, ''),
(1269, 0, 1, 0, 7026, 1, ''),
(1270, 0, 1, 0, 7026, 1, ''),
(1271, 0, 1, 0, 6440, 1, ''),
(1272, 0, 1, 0, 6440, 1, ''),
(1273, 0, 1, 0, 6441, 1, ''),
(1274, 0, 1, 0, 6440, 1, ''),
(1275, 0, 1, 0, 5107, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031353030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1276, 0, 1, 0, 6441, 1, ''),
(1277, 0, 1, 0, 6441, 1, ''),
(1278, 0, 1, 0, 6440, 1, ''),
(1279, 0, 1, 0, 5107, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032303830303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1280, 0, 1, 0, 6441, 1, ''),
(1281, 0, 1, 0, 6440, 1, ''),
(1282, 0, 1, 0, 5098, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031393630303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1283, 0, 1, 0, 6440, 1, ''),
(1284, 0, 1, 0, 6440, 1, ''),
(1285, 0, 1, 0, 6441, 1, ''),
(1286, 0, 1, 0, 6440, 1, ''),
(1287, 0, 1, 0, 6440, 1, ''),
(1288, 0, 1, 0, 6440, 1, ''),
(1289, 0, 1, 0, 5098, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373030303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1290, 0, 1, 0, 6440, 1, ''),
(1291, 0, 1, 0, 6440, 1, ''),
(1292, 0, 1, 0, 6441, 1, ''),
(1293, 0, 1, 0, 5098, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1294, 0, 1, 0, 6441, 1, ''),
(1295, 0, 1, 0, 5098, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373030303020676f6c6420636f696e732e0600646f6f7269640203000000),
(1296, 0, 1, 0, 5107, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732033373030303020676f6c6420636f696e732e0600646f6f7269640204000000),
(1297, 0, 1, 0, 5098, 1, 0x8002000b006465736372697074696f6e014a00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f73747320383030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1298, 0, 1, 0, 5107, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032393230303020676f6c6420636f696e732e0600646f6f7269640201000000),
(1299, 0, 1, 0, 5107, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032393230303020676f6c6420636f696e732e0600646f6f7269640203000000),
(1300, 0, 1, 0, 5098, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032393230303020676f6c6420636f696e732e0600646f6f7269640204000000),
(1301, 0, 1, 0, 5098, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732032393230303020676f6c6420636f696e732e0600646f6f7269640205000000),
(1302, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031383430303020676f6c6420636f696e732e0600646f6f7269640203000000),
(1303, 0, 1, 0, 6436, 1, ''),
(1304, 0, 1, 0, 6437, 1, ''),
(1305, 0, 1, 0, 6437, 1, ''),
(1306, 0, 1, 0, 1221, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031383430303020676f6c6420636f696e732e0600646f6f7269640206000000),
(1307, 0, 1, 0, 1212, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031323230303020676f6c6420636f696e732e0600646f6f7269640204000000),
(1308, 0, 1, 0, 6439, 1, ''),
(1309, 0, 1, 0, 1212, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031323230303020676f6c6420636f696e732e0600646f6f7269640205000000),
(1310, 0, 1, 0, 6438, 1, ''),
(1311, 0, 1, 0, 1212, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031313030303020676f6c6420636f696e732e0600646f6f7269640205000000),
(1312, 0, 1, 0, 6438, 1, ''),
(1313, 0, 1, 0, 1212, 1, 0x8002000b006465736372697074696f6e014b00000049742062656c6f6e677320746f20686f7573652027272e204e6f626f6479206f776e73207468697320686f7573652e20497420636f7374732031313030303020676f6c6420636f696e732e0600646f6f7269640202000000),
(1314, 0, 1, 0, 6437, 1, ''),
(1315, 0, 1, 0, 6438, 1, ''),
(1316, 0, 1, 0, 1210, 1, ''),
(1317, 0, 1, 0, 6437, 1, ''),
(1318, 0, 1, 0, 1210, 1, ''),
(1319, 0, 1, 0, 6437, 1, '');

--
-- Índices para tabelas despejadas
--

--
-- Índices de tabela `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Índices de tabela `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD UNIQUE KEY `account_id_2` (`account_id`,`player_id`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `world_id` (`world_id`);

--
-- Índices de tabela `bans`
--
ALTER TABLE `bans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `type` (`type`,`value`),
  ADD KEY `active` (`active`);

--
-- Índices de tabela `environment_killers`
--
ALTER TABLE `environment_killers`
  ADD KEY `kill_id` (`kill_id`);

--
-- Índices de tabela `global_storage`
--
ALTER TABLE `global_storage`
  ADD UNIQUE KEY `key` (`key`,`world_id`);

--
-- Índices de tabela `guilds`
--
ALTER TABLE `guilds`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`,`world_id`);

--
-- Índices de tabela `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD UNIQUE KEY `player_id` (`player_id`,`guild_id`),
  ADD KEY `guild_id` (`guild_id`);

--
-- Índices de tabela `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD PRIMARY KEY (`id`),
  ADD KEY `guild_id` (`guild_id`);

--
-- Índices de tabela `houses`
--
ALTER TABLE `houses`
  ADD UNIQUE KEY `id` (`id`,`world_id`);

--
-- Índices de tabela `house_auctions`
--
ALTER TABLE `house_auctions`
  ADD UNIQUE KEY `house_id` (`house_id`,`world_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `house_data`
--
ALTER TABLE `house_data`
  ADD UNIQUE KEY `house_id` (`house_id`,`world_id`);

--
-- Índices de tabela `house_lists`
--
ALTER TABLE `house_lists`
  ADD UNIQUE KEY `house_id` (`house_id`,`world_id`,`listid`);

--
-- Índices de tabela `killers`
--
ALTER TABLE `killers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `death_id` (`death_id`);

--
-- Índices de tabela `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`,`deleted`),
  ADD KEY `account_id` (`account_id`),
  ADD KEY `group_id` (`group_id`),
  ADD KEY `online` (`online`),
  ADD KEY `deleted` (`deleted`);

--
-- Índices de tabela `player_autoloot`
--
ALTER TABLE `player_autoloot`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_autoloot_id` (`player_id`),
  ADD KEY `idx_player_id` (`player_id`);

--
-- Índices de tabela `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD PRIMARY KEY (`id`),
  ADD KEY `date` (`date`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`sid`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `player_items`
--
ALTER TABLE `player_items`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`sid`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `player_killers`
--
ALTER TABLE `player_killers`
  ADD KEY `kill_id` (`kill_id`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `player_skills`
--
ALTER TABLE `player_skills`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`skillid`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `player_spells`
--
ALTER TABLE `player_spells`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`name`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `player_storage`
--
ALTER TABLE `player_storage`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`key`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `player_viplist`
--
ALTER TABLE `player_viplist`
  ADD UNIQUE KEY `player_id_2` (`player_id`,`vip_id`),
  ADD KEY `player_id` (`player_id`),
  ADD KEY `vip_id` (`vip_id`);

--
-- Índices de tabela `server_config`
--
ALTER TABLE `server_config`
  ADD UNIQUE KEY `config` (`config`);

--
-- Índices de tabela `server_motd`
--
ALTER TABLE `server_motd`
  ADD UNIQUE KEY `id` (`id`,`world_id`);

--
-- Índices de tabela `server_record`
--
ALTER TABLE `server_record`
  ADD UNIQUE KEY `record` (`record`,`world_id`,`timestamp`);

--
-- Índices de tabela `server_reports`
--
ALTER TABLE `server_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `world_id` (`world_id`),
  ADD KEY `reads` (`reads`),
  ADD KEY `player_id` (`player_id`);

--
-- Índices de tabela `tiles`
--
ALTER TABLE `tiles`
  ADD UNIQUE KEY `id` (`id`,`world_id`),
  ADD KEY `x` (`x`,`y`,`z`),
  ADD KEY `house_id` (`house_id`,`world_id`);

--
-- Índices de tabela `tile_items`
--
ALTER TABLE `tile_items`
  ADD UNIQUE KEY `tile_id` (`tile_id`,`world_id`,`sid`),
  ADD KEY `sid` (`sid`);

--
-- AUTO_INCREMENT para tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de tabela `bans`
--
ALTER TABLE `bans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guilds`
--
ALTER TABLE `guilds`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `guild_ranks`
--
ALTER TABLE `guild_ranks`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `killers`
--
ALTER TABLE `killers`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT de tabela `player_autoloot`
--
ALTER TABLE `player_autoloot`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8618899;

--
-- AUTO_INCREMENT de tabela `player_deaths`
--
ALTER TABLE `player_deaths`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de tabela `server_reports`
--
ALTER TABLE `server_reports`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Restrições para tabelas despejadas
--

--
-- Restrições para tabelas `account_viplist`
--
ALTER TABLE `account_viplist`
  ADD CONSTRAINT `account_viplist_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `account_viplist_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `environment_killers`
--
ALTER TABLE `environment_killers`
  ADD CONSTRAINT `environment_killers_ibfk_1` FOREIGN KEY (`kill_id`) REFERENCES `killers` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guild_invites`
--
ALTER TABLE `guild_invites`
  ADD CONSTRAINT `guild_invites_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `guild_invites_ibfk_2` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `guild_ranks`
--
ALTER TABLE `guild_ranks`
  ADD CONSTRAINT `guild_ranks_ibfk_1` FOREIGN KEY (`guild_id`) REFERENCES `guilds` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `house_auctions`
--
ALTER TABLE `house_auctions`
  ADD CONSTRAINT `house_auctions_ibfk_1` FOREIGN KEY (`house_id`,`world_id`) REFERENCES `houses` (`id`, `world_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `house_auctions_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `house_data`
--
ALTER TABLE `house_data`
  ADD CONSTRAINT `house_data_ibfk_1` FOREIGN KEY (`house_id`,`world_id`) REFERENCES `houses` (`id`, `world_id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `house_lists`
--
ALTER TABLE `house_lists`
  ADD CONSTRAINT `house_lists_ibfk_1` FOREIGN KEY (`house_id`,`world_id`) REFERENCES `houses` (`id`, `world_id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `killers`
--
ALTER TABLE `killers`
  ADD CONSTRAINT `killers_ibfk_1` FOREIGN KEY (`death_id`) REFERENCES `player_deaths` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `players`
--
ALTER TABLE `players`
  ADD CONSTRAINT `players_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_deaths`
--
ALTER TABLE `player_deaths`
  ADD CONSTRAINT `player_deaths_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_depotitems`
--
ALTER TABLE `player_depotitems`
  ADD CONSTRAINT `player_depotitems_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_items`
--
ALTER TABLE `player_items`
  ADD CONSTRAINT `player_items_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_killers`
--
ALTER TABLE `player_killers`
  ADD CONSTRAINT `player_killers_ibfk_1` FOREIGN KEY (`kill_id`) REFERENCES `killers` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `player_killers_ibfk_2` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_namelocks`
--
ALTER TABLE `player_namelocks`
  ADD CONSTRAINT `player_namelocks_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_skills`
--
ALTER TABLE `player_skills`
  ADD CONSTRAINT `player_skills_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_spells`
--
ALTER TABLE `player_spells`
  ADD CONSTRAINT `player_spells_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_storage`
--
ALTER TABLE `player_storage`
  ADD CONSTRAINT `player_storage_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `player_viplist`
--
ALTER TABLE `player_viplist`
  ADD CONSTRAINT `player_viplist_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `player_viplist_ibfk_2` FOREIGN KEY (`vip_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `server_reports`
--
ALTER TABLE `server_reports`
  ADD CONSTRAINT `server_reports_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `tiles`
--
ALTER TABLE `tiles`
  ADD CONSTRAINT `tiles_ibfk_1` FOREIGN KEY (`house_id`,`world_id`) REFERENCES `houses` (`id`, `world_id`) ON DELETE CASCADE;

--
-- Restrições para tabelas `tile_items`
--
ALTER TABLE `tile_items`
  ADD CONSTRAINT `tile_items_ibfk_1` FOREIGN KEY (`tile_id`) REFERENCES `tiles` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
