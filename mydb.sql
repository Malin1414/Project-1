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
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`departmentId`),
  UNIQUE INDEX `departmentName_UNIQUE` (`departmentName` ASC)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `education_management`.`year`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`year` (
  `yearId` INT NOT NULL AUTO_INCREMENT,
  `year` INT NOT NULL,
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`yearId`),
  UNIQUE INDEX `year_UNIQUE` (`year` ASC)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `education_management`.`faculty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`faculty` (
  `staffId` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(255) NOT NULL COMMENT 'Store hashed passwords only',
  `departmentId` INT NULL,
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`staffId`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  INDEX `fk_faculty_department_idx` (`departmentId` ASC),
  CONSTRAINT `fk_faculty_department`
    FOREIGN KEY (`departmentId`)
    REFERENCES `education_management`.`departments` (`departmentId`)
    ON DELETE SET NULL
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `education_management`.`students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`students` (
  `studentId` VARCHAR(45) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(255) NOT NULL COMMENT 'Store hashed passwords only',
  `departmentId` INT NOT NULL,
  `yearId` INT NOT NULL,
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`studentId`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC),
  INDEX `fk_students_department_idx` (`departmentId` ASC),
  INDEX `fk_students_year_idx` (`yearId` ASC),
  CONSTRAINT `fk_students_department`
    FOREIGN KEY (`departmentId`)
    REFERENCES `education_management`.`departments` (`departmentId`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  CONSTRAINT `fk_students_year`
    FOREIGN KEY (`yearId`)
    REFERENCES `education_management`.`year` (`yearId`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `education_management`.`admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`admin` (
  `adminId` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `password` VARCHAR(255) NOT NULL COMMENT 'Store hashed passwords only',
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`adminId`),
  UNIQUE INDEX `email_UNIQUE` (`email` ASC)
) ENGINE = InnoDB;

-- -----------------------------------------------------
-- Table `education_management`.`notice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`notice` (
  `noticeId` INT NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) NOT NULL,
  `description` TEXT NOT NULL,
  `date` DATE NOT NULL,
  `staffId` VARCHAR(45) NOT NULL,
  `createdAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updatedAt` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`noticeId`),
  INDEX `fk_notice_faculty_idx` (`staffId` ASC),
  CONSTRAINT `fk_notice_faculty`
    FOREIGN KEY (`staffId`)
    REFERENCES `education_management`.`faculty` (`staffId`)
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
-- Table `education_management`.`notice_years`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `education_management`.`notice_years` (
  `noticeId` INT NOT NULL,
  `yearId` INT NOT NULL,
  PRIMARY KEY (`noticeId`, `yearId`),
  INDEX `fk_notice_year_year_idx` (`yearId` ASC),
  CONSTRAINT `fk_notice_year_notice`
    FOREIGN KEY (`noticeId`)
    REFERENCES `education_management`.`notice` (`noticeId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_notice_year_year`
    FOREIGN KEY (`yearId`)
    REFERENCES `education_management`.`year` (`yearId`)
    ON DELETE CASCADE
    ON UPDATE CASCADE
) ENGINE = InnoDB;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;