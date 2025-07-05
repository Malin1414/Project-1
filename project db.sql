-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
-- -----------------------------------------------------
-- Schema webtechnology
-- -----------------------------------------------------
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`faculty`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`faculty` (
  `staffId` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  `password` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`staffId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`notice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`notice` (
  `noticeId` INT NOT NULL,
  `description` TEXT NULL,
  `date` DATE NULL,
  `title` VARCHAR(45) NULL,
  `faculty_staffId` INT NOT NULL,
  PRIMARY KEY (`noticeId`),
  INDEX `fk_notice_faculty1_idx` (`faculty_staffId`),
  CONSTRAINT `fk_notice_faculty1`
    FOREIGN KEY (`faculty_staffId`)
    REFERENCES `mydb`.`faculty` (`staffId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`admin` (
  `adminId` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `password` VARCHAR(45) NULL,
  `email` VARCHAR(45) NULL,
  PRIMARY KEY (`adminId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`departments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`departments` (
  `departmentId` INT NOT NULL,
  `departmentsName` VARCHAR(45) NULL,
  PRIMARY KEY (`departmentId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`year`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`year` (
  `yearId` INT NOT NULL,
  `year` INT NULL,
  PRIMARY KEY (`yearId`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`students`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`students` (
  `studentId` INT NOT NULL,
  `name` VARCHAR(45) NULL,
  `password` VARCHAR(45) NOT NULL,
  `email` VARCHAR(45) NULL,
  `departments_departmentId` INT NOT NULL,
  `year_yearId` INT NOT NULL,
  PRIMARY KEY (`studentId`),
  INDEX `fk_students_departments1_idx` (`departments_departmentId`),
  INDEX `fk_students_year1_idx` (`year_yearId`),
  CONSTRAINT `fk_students_departments1`
    FOREIGN KEY (`departments_departmentId`)
    REFERENCES `mydb`.`departments` (`departmentId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_students_year1`
    FOREIGN KEY (`year_yearId`)
    REFERENCES `mydb`.`year` (`yearId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mydb`.`year_has_notice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`year_has_notice` (
  `year_yearId` INT NOT NULL,
  `notice_noticeId` INT NOT NULL,
  PRIMARY KEY (`year_yearId`, `notice_noticeId`),
  INDEX `fk_year_has_notice_notice1_idx` (`notice_noticeId`),
  INDEX `fk_year_has_notice_year_idx` (`year_yearId`),
  CONSTRAINT `fk_year_has_notice_year`
    FOREIGN KEY (`year_yearId`)
    REFERENCES `mydb`.`year` (`yearId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_year_has_notice_notice1`
    FOREIGN KEY (`notice_noticeId`)
    REFERENCES `mydb`.`notice` (`noticeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;



-- -----------------------------------------------------
-- Table `mydb`.`departments_has_notice`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `mydb`.`departments_has_notice` (
  `departments_departmentId` INT NOT NULL,
  `notice_noticeId` INT NOT NULL,
  PRIMARY KEY (`departments_departmentId`, `notice_noticeId`),
  INDEX `fk_departments_has_notice_notice1_idx` (`notice_noticeId`),
  INDEX `fk_departments_has_notice_departments1_idx` (`departments_departmentId`),
  CONSTRAINT `fk_departments_has_notice_departments1`
    FOREIGN KEY (`departments_departmentId`)
    REFERENCES `mydb`.`departments` (`departmentId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_departments_has_notice_notice1`
    FOREIGN KEY (`notice_noticeId`)
    REFERENCES `mydb`.`notice` (`noticeId`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
) ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
