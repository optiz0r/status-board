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

--
-- Dumping data for table `site`
--

INSERT INTO `site` (`id`, `service`, `name`, `description`) VALUES
(1, 1, 'Local', 'Local Internet access'),
(2, 2, 'Offsite', 'Offsite web services'),
(3, 3, 'Offsite', 'Offsite email services'),
(4, 4, 'Local', 'Primary DNS services'),
(5, 4, 'Offsite', 'Backup DNS services'),
(6, 5, 'Local', 'Local LDAP services'),
(7, 5, 'Offsite', 'Offsite LDAP services');

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `username`, `password`, `fullname`, `email`, `last_login`, `last_password_change`) VALUES
(2, 'guest', '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', 'Guest', NULL, NULL, 1324211553);

--
-- Dumping data for table `group`
--

INSERT INTO `group` (`id`, `name`, `description`) VALUES
(2, 'readonly', 'Basic group with read only access to the status boards.');

--
-- Dumping data for table `usergroup`
--

INSERT INTO `usergroup` (`id`, `user`, `group`, `added`) VALUES
(1, 1, 1, 1324211572),
(2, 2, 2, 1324211572);

--
-- Dumping data for table `permission`
--

INSERT INTO `permission` (`id`, `name`, `description`) VALUES
(2, 'Update Status Boards', 'Permission to add/edit/delete any service or site.');
(3, 'Update Incidents', 'Permission to create and update the status of any incident.'),
(4, 'View Status Boards', 'Permission to view the status of all services and sites, and details of any incident.'),

--
-- Dumping data for table `grouppermissions`
--

INSERT INTO `grouppermissions` (`id`, `group`, `permission`, `added`) VALUES
(2, 1, 2, 1324211935),
(3, 1, 3, 1324211935),
(4, 1, 4, 1324211935),
(5, 2, 4, 1324211935);

