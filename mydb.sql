-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema education_management
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `education_management`;

-- -----------------------------------------------------
-- Schema education_management
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `education_management` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `education_management`;

-- -----------------------------------------------------
-- Table `education_management`.`departments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`departments` (
  `departmentId` INT NOT NULL AUTO_INCREMENT,
  `departmentName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`departmentId`),
  UNIQUE INDEX `departmentName_UNIQUE` (`departmentName` ASC)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `education_management`.`batch`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`batch` (
  `batchId` INT NOT NULL AUTO_INCREMENT,
  `batch` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`batchId`),
  UNIQUE INDEX `batch_UNIQUE` (`batch` ASC)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `education_management`.`staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`staff` (
  `staffId` VARCHAR(10) NOT NULL,
  `name` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `password` VARCHAR(255) NOT NULL,
  `status` ENUM('Enrolled', 'Not Enrolled') NOT NULL DEFAULT 'Not Enrolled',
  PRIMARY KEY (`staffId`)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `education_management`.`students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`students` (
  `studentId` VARCHAR(10) NOT NULL,
  `name` VARCHAR(45) NULL,
  `password` VARCHAR(255) NOT NULL,
  `email` VARCHAR(45) NULL,
  `departmentId` INT NULL,
  `batchId` INT NULL,
  `status` ENUM('Enrolled', 'Not Enrolled') NOT NULL DEFAULT 'Not Enrolled',
  PRIMARY KEY (`studentId`),
  INDEX `fk_students_department_idx` (`departmentId` ASC),
  INDEX `fk_students_batch_idx` (`batchId` ASC),
  CONSTRAINT `fk_students_department`
    FOREIGN KEY (`departmentId`)
    REFERENCES `education_management`.`departments` (`departmentId`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_students_batch`
    FOREIGN KEY (`batchId`)
    REFERENCES `education_management`.`batch` (`batchId`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `education_management`.`notice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`notice` (
  `noticeId` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `description` TEXT NOT NULL,
  `date` DATE NOT NULL,
  `staffId` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`noticeId`),
  INDEX `fk_notice_staff_idx` (`staffId` ASC),
  CONSTRAINT `fk_notice_staff`
    FOREIGN KEY (`staffId`)
    REFERENCES `education_management`.`staff` (`staffId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `education_management`.`notice_departments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`notice_departments` (
  `noticeId` INT NOT NULL,
  `departmentId` INT NOT NULL,
  PRIMARY KEY (`noticeId`, `departmentId`),
  INDEX `fk_notice_dept_department_idx` (`departmentId` ASC),
  CONSTRAINT `fk_notice_dept_notice`
    FOREIGN KEY (`noticeId`)
    REFERENCES `education_management`.`notice` (`noticeId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notice_dept_department`
    FOREIGN KEY (`departmentId`)
    REFERENCES `education_management`.`departments` (`departmentId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `education_management`.`notice_batches`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`notice_batches` (
  `noticeId` INT NOT NULL,
  `batchId` INT NOT NULL,
  PRIMARY KEY (`noticeId`, `batchId`),
  INDEX `fk_notice_batch_batch_idx` (`batchId` ASC),
  CONSTRAINT `fk_notice_batch_notice`
    FOREIGN KEY (`noticeId`)
    REFERENCES `education_management`.`notice` (`noticeId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notice_batch`
    FOREIGN KEY (`batchId`)
    REFERENCES `education_management`.`batch` (`batchId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;