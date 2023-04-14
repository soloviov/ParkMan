SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS `countries`;
CREATE TABLE `countries` (
  `id` smallint(3) unsigned zerofill NOT NULL,
  `alpha2` char(2) NOT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `countries` (`id`, `alpha2`, `name`) VALUES
(246, 'FI', 'Finland'),
(276, 'DE', 'Germany'),
(826, 'GB', 'United Kingdom '),
(840, 'US', 'United States');

DROP TABLE IF EXISTS `currencies`;
CREATE TABLE `currencies` (
  `id` smallint(3) unsigned zerofill NOT NULL,
  `code` char(3) NOT NULL,
  `symbol` varchar(10) DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `currencies` (`id`, `code`, `symbol`, `name`) VALUES
(840, 'USD', '$', 'United States dollar'),
(978, 'EUR', '€', 'Euro');

DROP TABLE IF EXISTS `owners`;
CREATE TABLE `owners` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `owners` (`id`, `name`) VALUES
(1, 'AutoPark'),
(2, 'Parkkitalo OY');

DROP TABLE IF EXISTS `garages`;
CREATE TABLE `garages` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `hourly_price` decimal(5,2) unsigned NOT NULL,
  `currency_id` smallint(3) unsigned zerofill NOT NULL,
  `contact_email` varchar(60) DEFAULT NULL,
  `point` point NOT NULL,
  `country_id` smallint(3) unsigned zerofill NOT NULL,
  `owner_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_garages_1` (`country_id`),
  KEY `fk_garages_2` (`owner_id`),
  KEY `fk_garages_3` (`currency_id`),
  SPATIAL KEY `ix_garages_1` (`point`),
  CONSTRAINT `fk_garages_1` FOREIGN KEY (`country_id`) REFERENCES `countries` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_garages_2` FOREIGN KEY (`owner_id`) REFERENCES `owners` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_garages_3` FOREIGN KEY (`currency_id`) REFERENCES `currencies` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `garages` (`id`, `name`, `hourly_price`, `currency_id`, `contact_email`, `point`, `country_id`, `owner_id`) VALUES
(1, 'Garage1', 2.00, 978, 'testemail@testautopark.fi', POINT(24.9323710661316, 60.1686078476241), 246, 1),
(2, 'Garage2', 1.50, 978, 'testemail@testautopark.fi', POINT(24.939453, 60.162562), 246, 1),
(3, 'Garage3', 3.00, 978, 'testemail@testautopark.fi', POINT(24.9381781682007, 60.1644499664551), 246, 1),
(4, 'Garage4', 3.00, 978, 'testemail@testautopark.fi', POINT(24.9353742599487, 60.1652193588528), 246, 1),
(5, 'Garage5', 3.00, 978, 'testemail@testautopark.fi', POINT(24.9215856620244, 60.1716742949007), 246, 1),
(6, 'Garage6', 2.00, 978, 'testemail@testautopark.fi', POINT(24.9301629520454, 60.1686739014875), 246, 2);

SET FOREIGN_KEY_CHECKS = 1;
