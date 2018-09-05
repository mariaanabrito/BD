-- Script de criação do modelo físico --

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `PolkaTerra` DEFAULT CHARACTER SET utf8 ;
USE `PolkaTerra` ;

-- Tabela Cliente
CREATE TABLE IF NOT EXISTS `PolkaTerra`.`Cliente` (
  `num_cc` INT NOT NULL,
  `email` VARCHAR(45) NULL,
  `nome` VARCHAR(20) NOT NULL,
  `apelido` VARCHAR(20) NOT NULL,
  unique (`email`),
  PRIMARY KEY (`num_cc`),
  UNIQUE INDEX `num_cc_UNIQUE` (`num_cc` ASC))
ENGINE = InnoDB;

-- Tabela Viagem
CREATE TABLE IF NOT EXISTS `PolkaTerra`.`Viagem` (
  `id_viagem` VARCHAR(8) NOT NULL,
  `preço` DECIMAL(5,2) UNSIGNED NOT NULL,
  `origem` VARCHAR(45) NOT NULL,
  `destino` VARCHAR(45) NOT NULL,
  `hora` TIME NOT NULL,
  `tipo` enum('N', 'I') NOT NULL,
  unique (`origem`, `destino`, `hora`),
  PRIMARY KEY (`id_viagem`),
  UNIQUE INDEX `id_viagem_UNIQUE` (`id_viagem` ASC))
ENGINE = InnoDB;

-- Tabela Reserva
CREATE TABLE IF NOT EXISTS `PolkaTerra`.`Reserva` (
  `id_reserva` INT NOT NULL AUTO_INCREMENT,
  `lugar` VARCHAR(2) NOT NULL,
  `id_cliente` INT NOT NULL,
  `id_viagem` VARCHAR(8) NOT NULL,
  `data` DATE NOT NULL,
  unique(`lugar`,`id_viagem`,`data`),
  PRIMARY KEY (`id_reserva`),
  UNIQUE INDEX `id_UNIQUE` (`id_reserva` ASC),
  INDEX `fk_client_id_idx` (`id_cliente` ASC),
  INDEX `fd_id_viagem_idx` (`id_viagem` ASC),
  CONSTRAINT `fk_id_cliente`
    FOREIGN KEY (`id_cliente`)
    REFERENCES `PolkaTerra`.`Cliente` (`num_cc`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fd_id_viagem`
    FOREIGN KEY (`id_viagem`)
    REFERENCES `PolkaTerra`.`Viagem` (`id_viagem`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Tabela Comboio
CREATE TABLE IF NOT EXISTS `PolkaTerra`.`Comboio` (
  `id_comboio` INT NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`id_comboio`),
  UNIQUE INDEX `id_comboio_UNIQUE` (`id_comboio` ASC))
ENGINE = InnoDB;

-- Tabela Lugar
CREATE TABLE IF NOT EXISTS `PolkaTerra`.`Lugar` (
  `id_comboio` INT NOT NULL,
  `número` VARCHAR(2) NOT NULL,
  `classe` INT NOT NULL,
  `carruagem` VARCHAR(1) NOT NULL,
  `preço` DECIMAL(5,2) UNSIGNED NOT NULL,
  PRIMARY KEY (`número`, `id_comboio`),
  INDEX `fk_id_comboio_idx` (`id_comboio` ASC),
  CONSTRAINT `fk_id_comboio`
    FOREIGN KEY (`id_comboio`)
    REFERENCES `PolkaTerra`.`Comboio` (`id_comboio`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

-- Tabela ViagemComboio
CREATE TABLE IF NOT EXISTS `PolkaTerra`.`ViagemComboio` (
  `id_comboio` INT NOT NULL,
  `id_viagem` VARCHAR(8) NOT NULL,
  `data` DATE NOT NULL,
  unique(`id_viagem`,`data`),
  PRIMARY KEY (`id_comboio`, `id_viagem`, `data`),
  INDEX `fk_ViagemComboio_2_idx` (`id_viagem` ASC),
  CONSTRAINT `fk_ViagemComboio_1`
    FOREIGN KEY (`id_comboio`)
    REFERENCES `PolkaTerra`.`Comboio` (`id_comboio`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_ViagemComboio_2`
    FOREIGN KEY (`id_viagem`)
    REFERENCES `PolkaTerra`.`Viagem` (`id_viagem`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
