
CREATE SCHEMA IF NOT EXISTS OlympicLeagueSchema; 
USE OlympicLeagueSchema;


DROP TABLE IF EXISTS `PlayedIn`;
DROP TABLE IF EXISTS `Game`;
DROP TABLE IF EXISTS `Employee`;
DROP TABLE IF EXISTS `Player`;
DROP TABLE IF EXISTS `Person`;
DROP TABLE IF EXISTS `Team`;
DROP TABLE IF EXISTS `Staff`;
DROP TABLE IF EXISTS `OlympicLeague`;


CREATE TABLE Person (
  `ID` INT NOT NULL,
  `FirstName` VARCHAR(45) NULL,
  `LastName` VARCHAR(45) NULL,
  `Gender` VARCHAR(45) NULL,
  `Age` INT NULL,
  `Phone` INT NULL,
  PRIMARY KEY (`ID`))
ENGINE = InnoDB;


CREATE TABLE Staff (
  `Staff_ID` INT NOT NULL,
  PRIMARY KEY (`Staff_ID`))
ENGINE = InnoDB;


CREATE TABLE OlympicLeague (
  `League_ID` INT NOT NULL,
  `Location` VARCHAR(255) NULL,
  `DateOfStart` DATE NULL,
  `DateOfEnd` DATE NULL,
  `Fan_Count` INT NULL,
  PRIMARY KEY (`League_ID`))
ENGINE = InnoDB;


CREATE TABLE Team (
  `Nationality` VARCHAR(255) NOT NULL,
  `Points` INT NULL,
  `Staff_Staff_ID` INT NOT NULL,
  `OlympicLeague_League_ID` INT NOT NULL,
  PRIMARY KEY (`Nationality`, `Staff_Staff_ID`, `OlympicLeague_League_ID`),
  CONSTRAINT `fk_Team_Staff1`
    FOREIGN KEY (`Staff_Staff_ID`)
    REFERENCES `Staff` (`Staff_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Team_OlympicLeague1`
    FOREIGN KEY (`OlympicLeague_League_ID`)
    REFERENCES `OlympicLeague` (`League_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE Player (
  `Player_Number` INT NOT NULL,
  `Position` VARCHAR(20) NULL,
  `Weight` INT NULL,
  `Height` INT NULL,
  `TotalPoints` INT NULL,
  `TotalFouls` INT NULL,
  `Person_ID` INT NOT NULL,
  `Team_Nationality` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`Player_Number`, `Person_ID`, `Team_Nationality`),
  CONSTRAINT `fk_Player_Person`
    FOREIGN KEY (`Person_ID`)
    REFERENCES `Person` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Player_Team1`
    FOREIGN KEY (`Team_Nationality`)
    REFERENCES `Team` (`Nationality`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE Employee (
  `EmployeeId` INT NOT NULL,
  `Salary` INT NULL,
  `Role` VARCHAR(45) NULL,
  `Person_ID` INT NOT NULL,
  PRIMARY KEY (`EmployeeId`, `Person_ID`),
  CONSTRAINT `fk_Employee_Person1`
    FOREIGN KEY (`Person_ID`)
    REFERENCES `Person` (`ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


CREATE TABLE Game (
  `Game_ID` INT NOT NULL,
  `Date_Time` DATETIME NULL,
  `TeamAScore` INT NULL,
  `TeamBScore` INT NULL,
  `Winner` VARCHAR(255) NULL,
  `Team_A` VARCHAR(255) NOT NULL,
  `Team_B` VARCHAR(255) NOT NULL,
  `OlympicLeague_League_ID` INT NOT NULL,
  `Staff_Staff_ID` INT NOT NULL,
  PRIMARY KEY (`Game_ID`, `Team_A`, `Team_B`, `OlympicLeague_League_ID`, `Staff_Staff_ID`),
  CONSTRAINT `fk_Game_Team1`
    FOREIGN KEY (`Team_A`)
    REFERENCES `Team` (`Nationality`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Game_Team2`
    FOREIGN KEY (`Team_B`)
    REFERENCES `Team` (`Nationality`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Game_OlympicLeague1`
    FOREIGN KEY (`OlympicLeague_League_ID`)
    REFERENCES `OlympicLeague` (`League_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Game_Staff1`
    FOREIGN KEY (`Staff_Staff_ID`)
    REFERENCES `Staff` (`Staff_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

CREATE TABLE PlayedIn (
  `Player_Number` INT NOT NULL,
  `Game_ID` INT NOT NULL,
  `MinutesPlayed` INT NULL,
  PRIMARY KEY (`Player_Number`,`Game_ID`),
  CONSTRAINT `Player_Numberfk`
    FOREIGN KEY (`Player_Number`)
    REFERENCES `Player` (`Player_Number`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
	CONSTRAINT `fk_Game_ID2`
	FOREIGN KEY (`Game_ID`)
    REFERENCES `Game` (`Game_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;

INSERT INTO OlympicLeague VALUES
(100,'Israel','2022-05-08', '2022-06-08', 0);

INSERT INTO Person VALUES
(19182, 'Darnell', 'Keller', 'Male', 38, 0598171),
(12105, 'Harper', 'Valentine', 'Male', 34, 0545421),
(18537, 'Nathaniel', 'Lynch', 'Male', 25, 0549086),
(13385, 'Elliott', 'Cross', 'Male', 20, 0578750),
(14070, 'Trystan', 'Duke', 'Male', 18, 0594805),
(15088, 'Bailey', 'Werner', 'Male', 26, 0515169),
(14332, 'Fabian', 'Frederick', 'Male', 38, 0532049),
(13839, 'Jimmy', 'Mcmahon', 'Male', 33, 0570298),
(11327, 'Ethen', 'Santos', 'Male', 19, 0597603),
(19096, 'Giancarlo', 'Little', 'Male', 34, 0519804),
(18272, 'Messiah', 'Horne', 'Male', 33, 0510558),
(19572, 'Hayden', 'Good', 'Male', 28, 0536107),
(12596, 'Riley', 'Salas', 'Male', 31, 0539705),
(16511, 'Rocco', 'Reid', 'Male', 28, 0526120),
(17819, 'Rafael', 'Snow', 'Male', 20, 0576450),
(11066, 'Antoine', 'Robinson', 'Male', 31, 0539911),
(19107, 'Dexter', 'Lutz', 'Male', 25, 0569360),
(15794, 'Draven', 'Hamilton', 'Male', 28, 0584997),
(19654, 'Harrison', 'Lamb', 'Male', 22, 0535614),
(11279, 'Stephen', 'Sherman', 'Male', 28, 0510378),
(10377, 'Lane', 'Meadows', 'Male', 20, 0568356),
(13625, 'Javier', 'Greer', 'Male', 28, 0541692);

INSERT INTO Employee VALUES
(2204, 15390, 'HEADCOACH', 12596),
(2882, 17061, 'MAINREF', 11279),
(8127, 14087, 'MAINREF', 12105),
(4011, 19661, 'MAINREF', 13625),
(6635, 19902, 'MAINREF', 14070),
(5245, 19430, 'HEADCOACH', 10377),
(3796, 15367, 'HEADCOACH', 13839);

INSERT INTO Staff VALUES
(5114),
(4545),
(5205);

INSERT INTO Staff VALUES
(5934),
(5354),
(5935);

INSERT INTO Team VALUES
('Belize', NULL, 5934, 100),
('Israel', NULL, 5935, 100),
('Russia', NULL, 5354, 100);

INSERT INTO Player VALUES
(6610, 'PF', 80, 196, 42, 5, 14332, 'Russia'),
(9012, 'C', 110, 225, 43, 1, 18272, 'Russia'),
(8010, 'SF', 85, 213, 46, 5, 15794, 'Russia'),
(2441, 'PG', 109, 225, 32, 7, 11066, 'Russia'),
(8355, 'SG', 112, 220, 54, 3, 17819, 'Russia'),
(7863, 'C', 111, 209, 66, 5, 18537, 'Israel'),
(5461, 'SF', 94, 207, 29, 5, 11327, 'Israel'),
(4822, 'PG', 91, 221, 67, 6, 19182, 'Israel'),
(9385, 'PF', 90, 202, 17, 2, 15088, 'Israel'),
(3075, 'SG', 96, 198, 17, 8, 13385, 'Israel'),
(3669, 'C', 97, 197, 1, 2, 19096, 'Belize'),
(4600, 'PF', 86, 207, 40, 7, 16511, 'Belize'),
(4794, 'SF', 80, 210, 12, 9, 19107, 'Belize'),
(5747, 'PG', 95, 196, 60, 0, 19654, 'Belize'),
(8812, 'SG', 115, 215, 41, 9, 19572, 'Belize');

INSERT INTO Game VALUES
(00, '2022-5-12 8:19:51', 122, 34, 'Russia', 'Russia', 'Israel', 100, 5114),
(01, '2022-5-13 14:50:5', 124, 146, 'Israel', 'Belize', 'Israel', 100, 5205),
(02, '2022-5-14 5:4:29', 110, 99, 'Russia', 'Russia', 'Belize', 100, 4545),
(03, '2022-5-15 12:18:1', 59, 39, 'Israel', 'Israel', 'Belize', 100, 5205),
(04, '2022-5-16 19:5:49', 69, 45, 'Israel', 'Israel', 'Russia', 100, 4545),
(05, '2022-5-17 21:18:32', 139, 136, 'Belize', 'Belize', 'Russia', 100, 5114);

insert INTO PlayedIn values 
(6610,00,28), 
(6610,02,25), 
(6610,05,31);



