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
-- Table structure for view `service_unusedsites`
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
