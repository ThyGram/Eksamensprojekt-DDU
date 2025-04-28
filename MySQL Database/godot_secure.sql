-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Vært: 127.0.0.1
-- Genereringstid: 28. 04 2025 kl. 15:43:04
-- Serverversion: 5.7.14
-- PHP-version: 7.0.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `godot_secure`
--
CREATE DATABASE IF NOT EXISTS `godot_secure` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `godot_secure`;

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `nonces`
--

DROP TABLE IF EXISTS `nonces`;
CREATE TABLE `nonces` (
  `ip_address` varchar(255) CHARACTER SET utf8 NOT NULL,
  `nonce` char(64) COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Data dump for tabellen `nonces`
--

INSERT INTO `nonces` (`ip_address`, `nonce`) VALUES
('::1', '6394fdbc24b53318aff0445754ed317ce397958be82744c497cc0b0a8679bf94');

-- --------------------------------------------------------

--
-- Struktur-dump for tabellen `players`
--

DROP TABLE IF EXISTS `players`;
CREATE TABLE `players` (
  `id` int(11) NOT NULL,
  `username` varchar(25) CHARACTER SET utf8mb4 NOT NULL,
  `passkey` varchar(25) CHARACTER SET utf8mb4 NOT NULL,
  `displayname` varchar(20) CHARACTER SET utf8mb4 NOT NULL,
  `highscore` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Data dump for tabellen `players`
--

INSERT INTO `players` (`id`, `username`, `passkey`, `displayname`, `highscore`) VALUES
(1, 'Secret', 'password', 'Big Man', 10000),
(3, '13234Albert', '932njfnjsoi#E#', 'xXx_Ghost_xXx', 1000),
(4, 'man', 'myth', 'THE MYTH', 500),
(7, 'The Man', 'SecretMan', 'Him', 50000);

--
-- Begrænsninger for dumpede tabeller
--

--
-- Indeks for tabel `nonces`
--
ALTER TABLE `nonces`
  ADD UNIQUE KEY `ip_address` (`ip_address`);

--
-- Indeks for tabel `players`
--
ALTER TABLE `players`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `displayname` (`displayname`);

--
-- Brug ikke AUTO_INCREMENT for slettede tabeller
--

--
-- Tilføj AUTO_INCREMENT i tabel `players`
--
ALTER TABLE `players`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
