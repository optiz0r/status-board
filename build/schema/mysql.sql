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
-- Table structure for table `settings`
--

DROP TABLE IF EXISTS `settings`;
CREATE TABLE IF NOT EXISTS `settings` (
  `name` varchar(255) NOT NULL,
  `value` text NOT NULL,
  `type` enum('bool','int','float','string','array(string)','hash') DEFAULT 'string',
  PRIMARY KEY (`name`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`name`, `value`, `type`) VALUES
('debug.display_exceptions', '1', 'bool'),
('cache.base_dir', '/dev/shm/status-board/', 'string'),
('logging.plugins', 'Database\nFlatFile', 'array(string)'),
('logging.Database', 'webui', 'array(string)'),
('logging.Database.webui.table', 'log', 'string'),
('logging.Database.webui.severity', 'debug\ninfo\nwarning\ndebug', 'array(string)'),
('logging.Database.webui.category', 'webui\ndefault', 'array(string)'),
('logging.FlatFile', 'tmp', 'array(string)'),
('logging.FlatFile.tmp.filename', '/tmp/status-board.log', 'string'),
('logging.FlatFile.tmp.format', '%timestamp% %hostname%:%pid% %progname%:%file%[%line%] %message%', 'string'),
('logging.FlatFile.tmp.severity', 'debug\ninfo\nwarning\nerror', 'array(string)'),
('logging.FlatFile.tmp.category', 'webui\ndefault', 'array(string)'),
('templates.tmp_path', '/var/tmp/status-board/', 'string');

--
-- Table structure for table `log`
--

DROP TABLE IF EXISTS `log`;
CREATE TABLE IF NOT EXISTS `log` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `level` varchar(32) NOT NULL,
  `category` varchar(32) NOT NULL,
  `ctime` int(11) NOT NULL,
  `pid` int(11) NOT NULL,
  `hostname` varchar(32) NOT NULL,
  `progname` varchar(64) NOT NULL,
  `file` text NOT NULL,
  `line` int(11) NOT NULL,
  `message` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `service`;
CREATE TABLE IF NOT EXISTS `service` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Table structure for table `service`
--

DROP TABLE IF EXISTS `site`;
CREATE TABLE IF NOT EXISTS `site` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service` int(10) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;


--
-- Table structure for table `incident`
--

DROP TABLE IF EXISTS `incident`;
CREATE TABLE IF NOT EXISTS `incident` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `site` int(10) unsigned NOT NULL,
  `reference` varchar(32) NOT NULL,
  `description` text NOT NULL,
  `start_time` int(10) NOT NULL,
  `estimated_end_time` int(10) NULL,
  `actual_end_time` int(10) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Table structure for table `incidentstatus`
--

DROP TABLE IF EXISTS `incidentstatus`;
CREATE TABLE IF NOT EXISTS `incidentstatus` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `incident` int(10) unsigned NOT NULL,
  `status` int(10) unsigned NOT NULL,
  `ctime` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Table structure for view `incidentstatus_current_int`
--

DROP VIEW IF EXISTS `incidentstatus_current_int`;
CREATE VIEW `incidentstatus_current_int` AS (
  SELECT
    `incidentstatus`.`incident` AS `incident`,
    MAX(`incidentstatus`.`id`) AS `latest`
  FROM 
    `incidentstatus`
  GROUP BY 
    `incidentstatus`.`incident`
);

--
-- Table structure for view `incidentstatus_current`
--

DROP VIEW IF EXISTS `incidentstatus_current`;
CREATE VIEW `incidentstatus_current` AS (
  SELECT 
    `is`.`id` AS `id`,
    `is`.`incident` AS `incident`,
    `is`.`status` AS `status`,
    `is`.`ctime` AS `ctime`
  FROM (
    `incidentstatus` AS `is`
    JOIN `incidentstatus_current_int` AS `isci`
  )
  WHERE (
    (`isci`.`incident` = `is`.`incident`)
    AND (`is`.`id` = `isci`.`latest`)
  )
);

--
-- Table structure for view `incidentstatus_open`
--

DROP VIEW IF EXISTS `incident_open`;
CREATE VIEW `incident_open` AS (
  SELECT 
    `i`.* 
  FROM
    `incident` AS `i`
    JOIN `incidentstatus_current` AS `isc`
    ON `i`.`id` = `isc`.`incident`
  WHERE
    `isc`.`status` IN (1,2,3,4)
);
