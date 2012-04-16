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
('auth', 'Database', 'string'),
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
('templates.tmp_path', '/var/tmp/status-board/', 'string'),
('site.title', 'Status Board', 'string'),
('sessions', 1, 'bool'),
('sessions.path', '/', 'string');

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
  `name` varchar(32) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `service` (`service`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Table structure for view `site_unmatchedservices`
--
DROP VIEW IF EXISTS `site_unmatchedservices`;
CREATE VIEW `site_unmatchedservices` AS (
  SELECT
    `si`.*,
    `se`.`id` AS `service`
  FROM
    `site` AS `si`
    CROSS JOIN `service` AS `se`
    LEFT JOIN `siteservice` AS `ss`
      ON `ss`.`site` = `si`.`id`
      AND `ss`.`service` = `se`.`id`
  WHERE
    `ss`.`id` IS NULL
);

--
-- Table structure for view `service_unmatchedsites`
--
DROP VIEW IF EXISTS `service_unmatchedsites`;
CREATE VIEW `service_unmatchedsites` AS (
  SELECT
    `se`.*,
    `si`.`id` AS `site`
  FROM
    `site` AS `si`
    CROSS JOIN `service` AS `se`
    LEFT JOIN `siteservice` AS `ss`
      ON `ss`.`site` = `si`.`id`
      AND `ss`.`service` = `se`.`id`
  WHERE
    `ss`.`id` IS NULL
);

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
  PRIMARY KEY (`id`),
  KEY `site` (`site`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Table structure for table `siteserviceincident`
--
DROP TABLE IF EXISTS `siteserviceincident`;
CREATE TABLE IF NOT EXISTS `siteserviceincident` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service` int(10) unsigned NOT NULL,
  `site` int(10) unsigned NOT NULL,
  `incident` int(10) unsigned NOT NULL,
  `description` text NOT NULL,
  `ctime` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `site` (`site`),
  KEY `service` (`service`),
  KEY `incident` (`incident`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Table structure for table `incidentstatus`
--
DROP TABLE IF EXISTS `incidentstatus`;
CREATE TABLE IF NOT EXISTS `incidentstatus` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `incident` int(10) unsigned NOT NULL,
  `status` int(10) unsigned NOT NULL,
  `description` text NOT NULL,
  `ctime` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `incident` (`incident`)
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
-- Table structure for view incident_open
--
DROP VIEW IF EXISTS `incident_open`;
CREATE VIEW `incident_open` AS (
  SELECT DISTINCT
    `i`.*,
    `isc`.`ctime`
  FROM
    `incident` AS `i`
    LEFT JOIN `incidentstatus_current` AS `isc` ON `i`.`id` = `isc`.`incident`
  WHERE
    `isc`.`status` IN (1,2,3,4)
);

--
-- Table structure for view incident_open_service
--
DROP VIEW IF EXISTS `incident_open_service`;
CREATE VIEW `incident_open_service` AS (
  SELECT DISTINCT
    `i`.*,
    `ss`.`service` as `service`,
    `isc`.`ctime`
  FROM
    `incident` AS `i`
    LEFT JOIN `incidentstatus_current` AS `isc` ON `i`.`id` = `isc`.`incident`
    LEFT JOIN `siteserviceincident` AS `ssi` ON `i`.`id` = `ssi`.`incident`
    LEFT JOIN `siteservice` AS `ss` ON `ssi`.`siteservice` = `ss`.`id`
  WHERE
    `isc`.`status` IN (1,2,3,4)
    AND `ss`.`service` IS NOT NULL
);

--
-- Table structure for view incident_open_site
--
DROP VIEW IF EXISTS `incident_open_site`;
CREATE VIEW `incident_open_site` AS (
  SELECT DISTINCT
    `i`.*,
    `ss`.`site` as `site`,
    `isc`.`ctime`
  FROM
    `incident` AS `i`
    LEFT JOIN `incidentstatus_current` AS `isc` ON `i`.`id` = `isc`.`incident`
    LEFT JOIN `siteserviceincident` AS `ssi` ON `i`.`id` = `ssi`.`incident`
    LEFT JOIN `siteservice` AS `ss` ON `ssi`.`siteservice` = `ss`.`id`
  WHERE
    `isc`.`status` IN (1,2,3,4)
    AND `ss`.`site` IS NOT NULL
);

--
-- Table structure for view incident_open_site
--
DROP VIEW IF EXISTS `incident_open_siteservice`;
CREATE VIEW `incident_open_siteservice` AS (
  SELECT DISTINCT
    `i`.*,
    `ss`.`id` as `siteservice`,
    `isc`.`ctime`
  FROM
    `incident` AS `i`
    LEFT JOIN `incidentstatus_current` AS `isc` ON `i`.`id` = `isc`.`incident`
    LEFT JOIN `siteserviceincident` AS `ssi` ON `i`.`id` = `ssi`.`incident`
    LEFT JOIN `siteservice` AS `ss` ON `ssi`.`siteservice` = `ss`.`id`
  WHERE
    `isc`.`status` IN (1,2,3,4)
    AND `ss`.`id` IS NOT NULL
);

--
-- Table structure for view `incident_closedtime`
--
DROP VIEW IF EXISTS `incident_closedtime`;
CREATE VIEW `incident_closedtime` AS (
  SELECT 
    `i`.`incident` AS `incident`,
    `i`.`ctime` AS `ctime`
  FROM
    `incidentstatus` AS `i`
  WHERE 
    `status` = 0
);

--
-- Table structure for view `incident_opentimes_site`
--
DROP VIEW IF EXISTS `incident_opentimes_site`;
CREATE VIEW `incident_opentimes_site` AS (
  SELECT
    `i`.*,
    `ss`.`site` as `site`,
    IFNULL(`t`.`ctime`, 0xffffffff+0) AS `ctime`
  FROM
    `incident` as `i`
    LEFT JOIN `incident_closedtime` AS `t` ON `i`.`id`=`t`.`incident` 
    JOIN `siteserviceincident` AS `ssi` ON `i`.`id` = `ssi`.`incident`      
    JOIN `siteservice` AS `ss` ON `ssi`.`siteservice` = `ss`.`id`
);

--
-- Table structure for view `incident_opentimes_service`
--
DROP VIEW IF EXISTS `incident_opentimes_service`;
CREATE VIEW `incident_opentimes_service` AS (
  SELECT
    `i`.*,
    `ss`.`service` as `service`,
    IFNULL(`t`.`ctime`, 0xffffffff+0) AS `ctime`
  FROM
    `incident` as `i`
    LEFT JOIN `incident_closedtime` AS `t` ON `i`.`id`=`t`.`incident` 
    JOIN `siteserviceincident` AS `ssi` ON `i`.`id` = `ssi`.`incident`      
    JOIN `siteservice` AS `ss` ON `ssi`.`siteservice` = `ss`.`id`
);

--
-- Table structure for view `incident_opentimes_siteservice`
--
DROP VIEW IF EXISTS `incident_opentimes_siteservice`;
CREATE VIEW `incident_opentimes_siteservice` AS (
  SELECT
    `i`.*,
    `ss`.`id` as `siteservice`,
    IFNULL(`t`.`ctime`, 0xffffffff+0) AS `ctime`
  FROM
    `incident` as `i`
    LEFT JOIN `incident_closedtime` AS `t` ON `i`.`id`=`t`.`incident` 
    JOIN `siteserviceincident` AS `ssi` ON `i`.`id` = `ssi`.`incident`      
    JOIN `siteservice` AS `ss` ON `ssi`.`siteservice` = `ss`.`id`
);

--
-- Table structure for table `user`
--
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` char(40) NOT NULL,
  `fullname` varchar(255) NULL,
  `email` varchar(255) NULL,
  `last_login` int(10) NULL,
  `last_password_change` int(10) NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Dumping data for table `user`
--
INSERT INTO `user` (`id`, `username`, `password`, `fullname`, `email`, `last_login`, `last_password_change`) VALUES
(1, 'admin', '5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8', 'Administrator', NULL, NULL, 1324211456);

--
-- Table structure for table `group`
--
DROP TABLE IF EXISTS `group`;
CREATE TABLE IF NOT EXISTS `group` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Dumping data for table `group`
--
INSERT INTO `group` (`id`, `name`, `description`) VALUES
(1, 'admins', 'Administrative users will full control over the status boards.');

--
-- Table structure for table `usergroup`
--
DROP TABLE IF EXISTS `usergroup`;
CREATE TABLE IF NOT EXISTS `usergroup` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user` int(10) unsigned NOT NULL,
  `group` int(10) unsigned NOT NULL,
  `added` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`,`group`),
  KEY `group` (`group`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Dumping data for table `usergroup`
--
INSERT INTO `usergroup` (`id`, `user`, `group`, `added`) VALUES
(1, 1, 1, 1324211572);

--
-- Table structure for view `groups_by_user`
--
DROP VIEW IF EXISTS `groups_by_user`;
CREATE VIEW `groups_by_user` AS (
  SELECT 
    `u`.`id` AS `user`,
    `g`.*
  FROM
    `usergroup` as `ug`
    LEFT JOIN `user` AS `u` ON `ug`.`user`=`u`.`id`
    LEFT JOIN `group` AS `g` ON `ug`.`group`=`g`.`id`
);

--
-- Table structure for table `permission`
--
DROP TABLE IF EXISTS `permission`;
CREATE TABLE IF NOT EXISTS `permission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `description` text NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Dumping data for table `permission`
--
INSERT INTO `permission` (`id`, `name`, `description`) VALUES
(1, 'Administrator', 'Full administrative rights.');


--
-- Table structure for table `grouppermission`
--
DROP TABLE IF EXISTS `grouppermission`;
CREATE TABLE IF NOT EXISTS `grouppermission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `group` int(10) unsigned NOT NULL,
  `permission` int(10) unsigned NOT NULL,
  `added` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `group` (`group`,`permission`),
  KEY `permission` (`permission`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Dumping data for table `grouppermission`
--
INSERT INTO `grouppermission` (`id`, `group`, `permission`, `added`) VALUES
(1, 1, 1, 1324211935);

--
-- Table structure for view `permissions_by_group`
--
DROP VIEW IF EXISTS `permissions_by_group`;
CREATE VIEW `permissions_by_group` AS (
  SELECT 
    `g`.`id` AS `group`,
    `p`.*
  FROM
    `grouppermission` as `gp`
    LEFT JOIN `group` AS `g` ON `gp`.`group`=`g`.`id`
    LEFT JOIN `permission` AS `p` on `gp`.`permission`=`p`.`id`
);

--
-- Table structure for view `permissions_by_user`
--
DROP VIEW IF EXISTS `permissions_by_user`;
CREATE VIEW `permissions_by_user` AS (
  SELECT 
    `u`.`id` AS `user`,
    `p`.*
  FROM
    `usergroup` as `ug`
    LEFT JOIN `user` AS `u` ON `ug`.`user`=`u`.`id`
    LEFT JOIN `permissions_by_group` AS `p` on `ug`.`group`=`p`.`group`
);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `siteservice`
--
ALTER TABLE `siteservice`
  ADD CONSTRAINT `site_ibfk_1` FOREIGN KEY (`site`) REFERENCES `site` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `service_ibfk_1` FOREIGN KEY (`service`) REFERENCES `service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `siteserviceincident`
--
ALTER TABLE `siteserviceincident`
  ADD CONSTRAINT `siteservice_ibfk_1` FOREIGN KEY (`siteservice`) REFERENCES `siteservice` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `incident_ibfk_1` FOREIGN KEY (`incident`) REFERENCES `incident` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `grouppermission`
--
ALTER TABLE `grouppermission`
  ADD CONSTRAINT `grouppermission_ibfk_2` FOREIGN KEY (`permission`) REFERENCES `permission` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `grouppermission_ibfk_1` FOREIGN KEY (`group`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `incident`
--
ALTER TABLE `incident`
  ADD CONSTRAINT `incident_ibfk_1` FOREIGN KEY (`site`) REFERENCES `site` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `incidentstatus`
--
ALTER TABLE `incidentstatus`
  ADD CONSTRAINT `incidentstatus_ibfk_1` FOREIGN KEY (`incident`) REFERENCES `incident` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `site`
--
ALTER TABLE `site`
  ADD CONSTRAINT `site_ibfk_1` FOREIGN KEY (`service`) REFERENCES `service` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `usergroup`
--
ALTER TABLE `usergroup`
  ADD CONSTRAINT `usergroup_ibfk_2` FOREIGN KEY (`group`) REFERENCES `group` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `usergroup_ibfk_1` FOREIGN KEY (`user`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
