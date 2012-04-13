--
-- Constraints for table `incident`
--
ALTER TABLE `incident`
  DROP FOREIGN KEY `incident_ibfk_1`;

--
-- Constraints for table `site`
--
ALTER TABLE `site`
  DROP FOREIGN KEY `site_ibfk_1`;

--
-- alter table structure for table `site`
--
ALTER TABLE  `site` DROP  `service`;

--
-- Alter table structure for table `incident`
--
ALTER TABLE  `incident` DROP  `site`;


--
-- Table structure for table `siteservice`
--
DROP TABLE IF EXISTS `siteservice`;
CREATE TABLE IF NOT EXISTS `siteservice` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `service` int(10) unsigned NOT NULL,
  `site` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;


--
-- Table structure for table `siteserviceincident`
--
DROP TABLE IF EXISTS `siteserviceincident`;
CREATE TABLE IF NOT EXISTS `siteserviceincident` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `siteservice` int(10) unsigned NOT NULL,
  `incident` int(10) unsigned NOT NULL,
  `description` text NOT NULL,
  `ctime` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `siteservice` (`siteservice`),
  KEY `incident` (`incident`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 ;

--
-- Table structure for view `incident_open`
--
DROP VIEW IF EXISTS `incident_open`;
CREATE VIEW `incident_open` AS (
  SELECT 
    `i`.*,
    `ssi`.`id` as `siteserviceincident`,
    `ss`.`id` as `siteservice`,
    `ss`.`service` as `service`,
    `ss`.`site` as `site`,
    `isc`.`ctime`
  FROM
    `incident` AS `i`
    JOIN `incidentstatus_current` AS `isc` ON `i`.`id` = `isc`.`incident`
    JOIN `siteserviceincident` AS `ssi` ON `i`.`id` = `ssi`.`incident`
    JOIN `siteservice` AS `ss` ON `ssi`.`siteservice` = `ss`.`id`
  WHERE
    `isc`.`status` IN (1,2,3,4)
);

--
-- Table structure for view `incident_closedtime`
--
DROP VIEW IF EXISTS `incident_closedtime`;
CREATE VIEW `incident_closedtime` AS (
  SELECT 
    `i`.`incident` AS `incident`,
    `ssi`.`id` as `siteserviceincident`,
    `ss`.`id` as `siteservice`,
    `ss`.`service` as `service`,
    `ss`.`site` as `site`,
    `i`.`ctime` AS `ctime`
  FROM
    `incidentstatus` AS `i`
    JOIN `siteserviceincident` AS `ssi` ON `i`.`id` = `ssi`.`incident`
    JOIN `siteservice` AS `ss` ON `ssi`.`siteservice` = `ss`.`id`
  WHERE 
    `status` = 0
);

--
-- Table structure for view `incident_opentimes`
--
DROP VIEW IF EXISTS `incident_opentimes`;
CREATE VIEW `incident_opentimes` AS (
  SELECT
    `i`.*,
    `ssi`.`id` as `siteserviceincident`,
    `ss`.`id` as `siteservice`,
    `ss`.`service` as `service`,
    `ss`.`site` as `site`,
    IFNULL(`t`.`ctime`, 0xffffffff+0) AS `ctime`
  FROM
    `incident` as `i`
    LEFT JOIN `incident_closedtime` AS `t` ON `i`.`id`=`t`.`incident` 
    JOIN `siteserviceincident` AS `ssi` ON `i`.`id` = `ssi`.`incident`      
    JOIN `siteservice` AS `ss` ON `ssi`.`siteservice` = `ss`.`id`
);


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
