USE OlympicLeagueSchema;

DROP TABLE IF EXISTS `GameLog`;
DROP TABLE IF EXISTS `PersonLog`;
DROP TABLE IF EXISTS `RefereeLog`;
DROP TABLE IF EXISTS `PlayerLog`;
DROP TABLE IF EXISTS `TeamLog`;
DROP TABLE IF EXISTS `OlympicLeagueLog`;

CREATE TABLE OlympicLeagueLog (
  `new_League_ID` INT,
  `New_Location` VARCHAR(255) NULL,
  `Old_Location` VARCHAR(255) NULL,
  `New_DateOfStart` DATE NULL,
  `Old_DateOfStart` DATE NULL,
  `New_DateOfEnd` DATE NULL,
  `Old_DateOfEnd` DATE NULL,
  `New_Fan_Count` INT NULL,
  `Old_Fan_Count` INT NULL,
  command_ts timestamp,
  command varchar(40))
ENGINE = InnoDB;

CREATE TABLE PlayerLog (
  `New_Player_Number` INT NULL,
  `New_Position` VARCHAR(20) NULL,
  `New_Weight` INT NULL,
  `New_Height` INT NULL,
  `New_TotalPoints` INT NULL,
  `New_TotalFouls` INT NULL,
  `New_Person_ID` INT NULL,
  `New_Team_Nationality` VARCHAR(255) NULL,
  command_ts timestamp,
  command varchar(40)
)ENGINE = InnoDB;

CREATE TABLE PersonLog (
  `New_ID` INT NOT NULL,
  `New_FirstName` VARCHAR(45) NULL,
  `New_LastName` VARCHAR(45) NULL,
  `New_Gender` VARCHAR(45) NULL,
  `New_Age` INT NULL,
  `New_Phone` INT NULL,
command_ts timestamp,
  command varchar(40))
ENGINE = InnoDB;

CREATE TABLE GameLog (
  `New_Game_ID` INT NOT NULL,
  `New_Date_Time` DATETIME NULL,
  `Old_Date_Time` DATETIME NULL,
  `New_TeamAScore` INT NULL,
  `Old_TeamAScore` INT NULL,
  `New_TeamBScore` INT NULL,
  `Old_TeamBScore` INT NULL,
  `New_Winner` VARCHAR(255) NULL,
   `Old_Winner` VARCHAR(255) NULL,
  `New_Team_A` VARCHAR(255) NOT NULL,
  `New_Team_B` VARCHAR(255) NOT NULL,
  `New_OlympicLeague_League_ID` INT NOT NULL,
  `New_Staff_Staff_ID` INT NOT NULL,
  command_ts timestamp,
  command varchar(40))
ENGINE = InnoDB;

CREATE TABLE RefereeLog (
   `New_Employee_EmployeeId` INT ,
  `Old_Employee_EmployeeId` INT NOT NULL,
  `New_Staff_Staff_ID` INT ,
   `Old_Staff_Staff_ID` INT NOT NULL,
  command_ts timestamp,
  command varchar(40))
ENGINE = InnoDB;

CREATE TABLE TeamLog (
  `New_Nationality` VARCHAR(255) NOT NULL,
  `New_Points` INT,
  `New_Staff_Staff_ID` INT NOT NULL,
  `Old_Staff_Staff_ID` INT,
  `New_OlympicLeague_League_ID` INT,
  `Old_OlympicLeague_League_ID` INT,
  command_ts timestamp,
  command varchar(255))
ENGINE = InnoDB;


DROP TRIGGER IF EXISTS `TeamPointsUpdate_TRG`;
delimiter $
CREATE TRIGGER TeamPointsUpdate_TRG After UPDATE ON Team
FOR EACH ROW
BEGIN
 INSERT INTO TeamLog VALUES(new.Nationality,new.Points,new.Staff_Staff_ID, old.Staff_Staff_ID, new.OlympicLeague_League_ID, old.OlympicLeague_League_ID,now(),  concat( 'Team ',new.Nationality,' Points are: ' , new.Points));
END$
delimiter ;



DROP TRIGGER IF EXISTS `DeleteReferee`;
delimiter $
CREATE TRIGGER DeleteReferee BEFORE Delete ON Referee
FOR EACH ROW
BEGIN
 INSERT INTO Refereelog VALUES(NULL,old.Employee_EmployeeId,NULL,old.Staff_Staff_ID,now(),  concat('referee ',old.Employee_EmployeeId,' Deleted'));
END$
delimiter ;

DROP TRIGGER IF EXISTS `GameLogInsert_trg`;
delimiter $
CREATE TRIGGER GameLogInsert_trg BEFORE INSERT ON Game
FOR EACH ROW
BEGIN
 INSERT INTO GameLog VALUES(new.Game_ID,new.Date_Time,NULL, new.TeamAScore, NULL, new.TeamBScore, NULL, new.winner,NULL,new.Team_A,new.Team_B,new.OlympicLeague_League_ID,new.Staff_Staff_ID,now(),  concat('Game ',new.Game_ID,' Added'));
END$
delimiter ;


DROP TRIGGER IF EXISTS `GameLogUpdate_trg`;
delimiter $
CREATE TRIGGER GameLogUpdate_trg After UPDATE ON Game
FOR EACH ROW
BEGIN
 INSERT INTO GameLog VALUES(new.Game_ID,new.Date_Time,old.Date_Time, new.TeamAScore, old.TeamAScore, new.TeamBScore, old.TeamBScore, new.winner,old.winner,new.Team_A,new.Team_B,new.OlympicLeague_League_ID,new.Staff_Staff_ID,now(),  concat( 'Game ',new.Game_ID,' has been updated'));
END$
delimiter ;


DROP TRIGGER IF EXISTS `PersonInsert_trg`;
delimiter $
CREATE TRIGGER PersonInsert_trg After INSERT ON Person
FOR EACH ROW
BEGIN
 INSERT INTO PersonLog VALUES(new.ID,New.FirstName,New.LastName,New.Gender,new.Age,New.Phone,now(),  concat('Person ',new.FirstName,' ', new.LastName,' was added'));
END$
delimiter ;

DROP TRIGGER IF EXISTS `PlayerInsert_Trg`;
delimiter $
CREATE TRIGGER PlayerInsert_Trg AFTER INSERT ON Player
FOR EACH ROW
BEGIN
 INSERT INTO PlayerLog VALUES( new.Player_Number,new.Position,new.Weight,new.Height, new.TotalPoints, new.TotalFouls, new.Person_ID, new.Team_Nationality,now(), 'New player added');
END$
delimiter ;

DROP TRIGGER IF EXISTS `OlympicLeagueLog_BTrg`;
delimiter $
CREATE TRIGGER OlympicLeagueLog_BTrg BEFORE UPDATE ON OlympicLeague
FOR EACH ROW
BEGIN
 INSERT INTO OlympicLeagueLog VALUES( new.League_ID,NULL,old.Location, NULL, old.DateOfStart, NULL, old.DateOfEnd,NULL,old.Fan_Count ,now(), 'olympic league before update');
END$
delimiter ;

DROP TRIGGER IF EXISTS `OlympicLeagueLog_ATrg`;
delimiter $
CREATE TRIGGER OlympicLeagueLog_ATrg AFTER UPDATE ON OlympicLeague
FOR EACH ROW
BEGIN
 INSERT INTO OlympicLeagueLog VALUES(new.League_ID,new.Location ,old.Location,New.DateOfStart,old.DateOfStart, new.DateOfEnd, old.DateOfEnd,new.FAN_Count,old.Fan_Count ,now(), 'olympic league After update');
END$
delimiter ;


