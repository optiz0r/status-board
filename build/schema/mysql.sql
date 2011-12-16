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
-- Creation: Sep 24, 2010 at 07:22 PM
-- Last update: Dec 04, 2011 at 01:19 PM
-- Last check: Aug 20, 2011 at 10:32 PM
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
-- Creation: Aug 20, 2011 at 10:32 PM
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

