SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `supermarket` DEFAULT CHARACTER SET latin1 ;
USE `supermarket` ;

-- -----------------------------------------------------
-- Table `supermarket`.`measures`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `supermarket`.`measures` (
  `Id` INT(11) NOT NULL ,
  `MeasureName` VARCHAR(45) NULL DEFAULT NULL ,
  PRIMARY KEY (`Id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `supermarket`.`vendors`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `supermarket`.`vendors` (
  `Id` INT(11) NOT NULL ,
  `VendorName` VARCHAR(45) NULL DEFAULT NULL ,
  PRIMARY KEY (`Id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;


-- -----------------------------------------------------
-- Table `supermarket`.`products`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `supermarket`.`products` (
  `Id` INT(11) NOT NULL ,
  `ProductName` VARCHAR(45) NOT NULL ,
  `BasePrice` DECIMAL(6,2) NOT NULL ,
  `vendors_Id` INT(11) NOT NULL ,
  `measures_Id` INT(11) NOT NULL ,
  PRIMARY KEY (`Id`) ,
  INDEX `fk_products_vendors_idx` (`vendors_Id` ASC) ,
  INDEX `fk_products_measures1_idx` (`measures_Id` ASC) ,
  CONSTRAINT `fk_products_vendors`
    FOREIGN KEY (`vendors_Id` )
    REFERENCES `supermarket`.`vendors` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_products_measures1`
    FOREIGN KEY (`measures_Id` )
    REFERENCES `supermarket`.`measures` (`Id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = latin1;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
