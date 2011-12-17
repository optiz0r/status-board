-- phpMyAdmin SQL Dump
-- version 3.1.4
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Dec 16, 2011 at 01:27 AM
-- Server version: 5.1.53
-- PHP Version: 5.3.6-pl1-gentoo

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";

--
-- Database: `status-board`
--

-- --------------------------------------------------------

--
-- Dumping data for table `service`
--

INSERT INTO `service` (`id`, `name`, `description`) VALUES
(1, 'Internet', 'Shared Internet connection.'),
(2, 'Web', 'Hosted web servers'),
(3, 'Email', 'Hosted email services'),
(4, 'DNS', 'Hosted DNS services'),
(5, 'LDAP', 'Hosted directory services');

