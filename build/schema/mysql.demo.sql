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
-- Dumping data for table `settings`
--

UPDATE `settings` SET `value`='Example Status Board' WHERE `name`='site.title';

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

INSERT INTO `site` (`id`, `name`, `description`) VALUES
(1, 'Local', 'Local systems'),
(2, 'Offsite', 'Offsite systems');

--
-- Dumping data for table `siteservice`
--

INSERT INTO `siteservice` (`id`,`service`,`site`) VALUES
(1, 1, 1),
(2, 2, 2),
(3, 3, 2),
(4, 4, 1),
(5, 4, 2),
(6, 5, 1),
(7, 5, 2);

--
-- Dumping data for table `incident`
--

INSERT INTO `incident` (`id`, `site`, `reference`, `description`, `start_time`, `estimated_end_time`, `actual_end_time`) VALUES
(1, 'UK:0001', 'Intermittent packetloss on primary internet connection', 1324079805, 1324079805, NULL),
(2, 'UK:0002', 'Full outage', 1324079805, 1324079805, NULL),
(3, 'UK:0003', 'DNS zone maintenance', 1324082411, 1324082411, NULL);

--
-- Dumping data for table `siteserviceincident`
--

INSERT INTO `siteserviceincident` (`id`, `siteservice`, `incident`, `description`, `ctime`) VALUES
(1, 1, 1, 'Initial classification', 1324079864),
(2, 1, 2, 'Initial classification', 1324079864),
(3, 4, 3, 'Initial classification', 1324082426),
(4, 5, 3, 'Initial classification', 1324082426);

--
-- Dumping data for table `incidentstatus`
--

INSERT INTO `incidentstatus` (`id`, `incident`, `status`, `description`, `ctime`) VALUES
(1, 1, 2, 'Initial classification', 1324079864),
(2, 2, 4, 'Initial classification', 1324079864),
(4, 3, 1, 'Initial classification', 1324082426);
(3, 1, 3, 'Status upgraded due to increasing impact from the ongoing issue.', 1324080307),

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
(2, 2, 2, 1324211572);

--
-- Dumping data for table `permission`
--

INSERT INTO `permission` (`id`, `name`, `description`) VALUES
(2, 'Update Status Boards', 'Permission to add/edit/delete any service or site.'),
(3, 'Update Incidents', 'Permission to create and update the status of any incident.'),
(4, 'View Status Boards', 'Permission to view the status of all services and sites, and details of any incident.'),
(5, 'Manage Users', 'Permission to manage user accounts.');

--
-- Dumping data for table `grouppermission`
--

INSERT INTO `grouppermission` (`id`, `group`, `permission`, `added`) VALUES
(2, 1, 2, 1324211935),
(3, 1, 3, 1324211935),
(4, 1, 4, 1324211935),
(5, 2, 4, 1324211935);

