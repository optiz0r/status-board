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
-- Add new field for homepage display mode
--
INSERT INTO `settings` (`name`, `value`, `type`) VALUES
('overview.display_mode', 'service', 'string'),
('incident.reference_default', 'I', 'string');

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
-- Table structure for view `siteservice_names`
--

DROP VIEW IF EXISTS `siteservice_names`;
CREATE VIEW `siteservice_names` AS (
  SELECT
    `ss`.*,
    `si`.`name` AS `site_name`,
    `se`.`name` AS `service_name`
  FROM
    `siteservice` AS `ss`
    LEFT JOIN `site` AS `si` ON `ss`.`site` = `si`.`id`
    LEFT JOIN `service` AS `se` ON `ss`.`service` = `se`.`id`
);

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
-- Table structure for view `site_unmatchedincidents`
--
DROP VIEW IF EXISTS `site_unmatchedincidents`;
CREATE VIEW `site_unmatchedincidents` AS (
  SELECT DISTINCT
    `si`.*,
    `i`.`id` AS `incident`
  FROM
    `site` AS `si`
    CROSS JOIN `incident` AS `i`
    LEFT JOIN `siteservice` AS `ss` ON `ss`.`site` =  `si`.`id`
    LEFT JOIN `siteserviceincident` AS `ssi` ON
      `ssi`.`siteservice` = `ss`.`id`
      AND `ssi`.`incident` = `i`.`id`
  WHERE
    `ssi`.`id` IS NULL
);

--
-- Table structure for view `site_unmatchedincidents`
--
DROP VIEW IF EXISTS `service_unmatchedincidents`;
CREATE VIEW `service_unmatchedincidents` AS (
  SELECT DISTINCT
    `se`.*,
    `i`.`id` AS `incident`
  FROM
    `service` AS `se`
    CROSS JOIN `incident` AS `i`
    LEFT JOIN `siteservice` AS `ss` ON `ss`.`service` =  `se`.`id`
    LEFT JOIN `siteserviceincident` AS `ssi` ON
      `ssi`.`siteservice` = `ss`.`id`
      AND `ssi`.`incident` = `i`.`id`
  WHERE
    `ssi`.`id` IS NULL
);

--
-- Table structure for view `site_unmatchedserviceincidents`
--
DROP VIEW IF EXISTS `site_unmatchedserviceincidents`;
CREATE VIEW `site_unmatchedserviceincidents` AS (
  SELECT DISTINCT
    `si`.*,
    `se`.`id` AS `service`,
    `i`.`id` AS `incident`
  FROM
    `site` AS `si`
    CROSS JOIN `incident` AS `i`
    LEFT JOIN `siteservice` AS `ss` ON `ss`.`site` =  `si`.`id`
    LEFT JOIN `service` AS `se` ON `ss`.`service` = `se`.`id`
    LEFT JOIN `siteserviceincident` AS `ssi` ON
      `ssi`.`siteservice` = `ss`.`id`
      AND `ssi`.`incident` = `i`.`id`
  WHERE
    `ssi`.`id` IS NULL
);

--
-- Table structure for view `service_unmatchedsiteincidents`
--
DROP VIEW IF EXISTS `service_unmatchedsiteincidents`;
CREATE VIEW `service_unmatchedsiteincidents` AS (
  SELECT DISTINCT
    `se`.*,
    `si`.`id` AS `site`,
    `i`.`id` AS `incident`
  FROM
    `service` AS `se`
    CROSS JOIN `incident` AS `i`
    LEFT JOIN `siteservice` AS `ss` ON `ss`.`service` =  `se`.`id`
    LEFT JOIN `site` AS `si` ON `ss`.`site` = `si`.`id`
    LEFT JOIN `siteserviceincident` AS `ssi` ON
      `ssi`.`siteservice` = `ss`.`id`
      AND `ssi`.`incident` = `i`.`id`
  WHERE
    `ssi`.`id` IS NULL
);

--
-- Table structure for view `siteservice_incident`
--
DROP VIEW IF EXISTS `siteservice_incident`;
CREATE VIEW `siteservice_incident` AS (
  SELECT
    `ss`.*,
    `ssi`.`incident` AS `incident`
  FROM
    `siteserviceincident` AS `ssi`
    LEFT JOIN `siteservice` AS `ss` ON `ssi`.`siteservice` = `ss`.`id`
);

--
-- Table structure for view incident_futuremaintenance
--
DROP VIEW IF EXISTS `incident_futuremaintenance`;
CREATE VIEW `incident_futuremaintenance` AS (
  SELECT DISTINCT
    `i`.*
  FROM
    `incident` AS `i`
    LEFT JOIN `incidentstatus_current` AS `isc` ON `i`.`id` = `isc`.`incident`
  WHERE
    `isc`.`status` = 1
    AND `i`.`start_time` > UNIX_TIMESTAMP()
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
    AND `i`.`start_time` <= UNIX_TIMESTAMP()
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
    AND `i`.`start_time` <= UNIX_TIMESTAMP()
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
    AND `i`.`start_time` <= UNIX_TIMESTAMP()
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
    AND `i`.`start_time` <= UNIX_TIMESTAMP()
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
  SELECT DISTINCT
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
  SELECT DISTINCT
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
  SELECT DISTINCT
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
-- Table structure for view `users_by_group`
--
DROP VIEW IF EXISTS `users_by_group`;
CREATE VIEW `users_by_group` AS (
  SELECT 
    `g`.`id` AS `group`,
    `u`.*
  FROM
    `usergroup` as `ug`
    LEFT JOIN `user` AS `u` ON `ug`.`user`=`u`.`id`
    LEFT JOIN `group` AS `g` ON `ug`.`group`=`g`.`id`
);

--
-- Table structure for view `user_unmatchedgroups`
--
DROP VIEW IF EXISTS `user_unmatchedgroups`;
CREATE VIEW `user_unmatchedgroups` AS (
  SELECT 
    `g`.`id` AS `group`,
    `u`.*
  FROM
    `user` AS `u`
    CROSS JOIN `group` as `g`
    LEFT JOIN `usergroup` AS `ug` ON
        `ug`.`group` = `g`.`id`
        AND `ug`.`user` = `u`.`id`
    WHERE
        `ug`.`id` IS NULL
);

--
-- Table structure for view `group_unmatchedusers`
--
DROP VIEW IF EXISTS `group_unmatchedusers`;
CREATE VIEW `group_unmatchedusers` AS (
  SELECT 
    `u`.`id` AS `user`,
    `g`.*
  FROM
    `group` AS `g`
    CROSS JOIN `user` as `u`
    LEFT JOIN `usergroup` AS `ug` ON
        `ug`.`group` = `g`.`id`
        AND `ug`.`user` = `u`.`id`
    WHERE
        `ug`.`id` IS NULL
);

--
-- Table structure for view `permission_unmatchedgroups`
--
DROP VIEW IF EXISTS `permission_unmatchedgroups`;
CREATE VIEW `permission_unmatchedgroups` AS (
  SELECT DISTINCT
    `p`.*,
    `g`.`id` AS `group`
  FROM
    `permission` AS `p`
    CROSS JOIN `group` AS `g`
    LEFT JOIN `grouppermission` AS `gp` ON
      `gp`.`group` = `g`.`id`
      AND `gp`.`permission` = `p`.`id`
  WHERE
    `gp`.`id` IS NULL
);

--
-- Table structure for view `permission_unmatchedusers`
--
DROP VIEW IF EXISTS `permission_unmatchedusers`;
CREATE VIEW `permission_unmatchedusers` AS (
  SELECT DISTINCT
    `p`.*,
    `u`.`id` AS `user`
  FROM
    `permission` AS `p`
    CROSS JOIN `user` AS `u`
    LEFT JOIN `usergroup` AS `ug` ON `ug`.`user` = `u`.`id`
    LEFT JOIN `group` AS `g` ON `ug`.`group` = `g`.`id`
    LEFT JOIN `grouppermission` AS `gp` ON
      `gp`.`group` = `g`.`id`
      AND `gp`.`permission` = `p`.`id`
  WHERE
    `gp`.`id` IS NULL
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
