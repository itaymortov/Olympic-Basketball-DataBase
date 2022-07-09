USE OlympicLeagueSchema;

#1.	Get list of games by Team Nationality
DELIMITER $$
DROP PROCEDURE IF EXISTS `getListGamesByNation`;
create procedure getListGamesByNation (IN nation varchar(255))
BEGIN
		Select Game.*
		FROM Game
		where nation = Team_A or nation = Team_B;
END $$
DELIMITER ;

call getListGamesByNation("Israel");
###################################################

#2.	Get list of games by Winner
DELIMITER $$
DROP PROCEDURE IF EXISTS `getListGamesByWinner`;
create procedure getListGamesByWinner (IN winner varchar(255))
BEGIN
		Select Game.*
		FROM Game
		where winner = Game.winner;
END $$
DELIMITER ;

call getListGamesByWinner("Israel");
###################################################

DROP PROCEDURE IF EXISTS `getListOfGamesFromDate`;
#3.	Get list of games from a specific date
DELIMITER $$
create procedure getListOfGamesFromDate (IN fromdate DATE)
BEGIN
        
        Select Game.*
        FROM Game
        Where CAST(Game.date_time AS DATE) = fromdate
        
		;
        
END $$
DELIMITER ;

call getListOfGamesFromDate("2022-05-13");
###################################################

DROP PROCEDURE IF EXISTS `getListOfGamesFromDateToDate`;
#4.	Get list of games from date to date
DELIMITER $$
create procedure getListOfGamesFromDateToDate (IN fromdate DATE, IN todate DATE)
BEGIN
        
        Select Game.*
        FROM Game
        Where CAST(Game.date_time AS DATE) >= fromdate and CAST(Game.date_time AS DATE) <= todate
		;
        
END $$
DELIMITER ;

call getListOfGamesFromDateToDate("2022-05-12", "2022-05-13");
###################################################

DROP PROCEDURE IF EXISTS `getTeamByPlayerName`;
#5.	Get Team by player name
DELIMITER $$
create procedure getTeamByPlayerName (IN fname VARCHAR(255), IN lname VARCHAR(255))
BEGIN
        
        Select Team_Nationality, fname 'First Name', lname 'Last Name'
        FROM Player pl, Person pe
        Where pl.Person_ID = pe.ID and fname = pe.FirstName and lname = pe.LastName
		;
        
END $$
DELIMITER ;

call getTeamByPlayerName("Fabian", "Frederick");
###################################################

DROP PROCEDURE IF EXISTS `getFirstLastGameByTeam`;
#6.	Get First and Last games by team nation
DELIMITER $$
create procedure getFirstLastGameByTeam (IN nation VARCHAR(255))
BEGIN
        
        Select nation, min(a.Date_Time) 'first', max(a.Date_Time) 'last'
		FROM Game a
		where (nation = a.Team_A or nation = a.Team_B)
		;
        
END $$
DELIMITER ;

call getFirstLastGameByTeam("Israel");
###################################################

DROP PROCEDURE IF EXISTS `getGamesByPlayerName`;
#7.	Get Games by player name
DELIMITER $$
create procedure getGamesByPlayerName (IN fname VARCHAR(255), IN lname VARCHAR(255))
BEGIN
        
        Select Game.*, Team_Nationality, fname 'First Name', lname 'Last Name'
        FROM Player pl, Person pe, Game
        Where pl.Person_ID = pe.ID and fname = pe.FirstName and lname = pe.LastName and (Team_Nationality = Team_A or Team_Nationality = Team_B)
		;
        
END $$
DELIMITER ;

call getGamesByPlayerName("Fabian", "Frederick");
###################################################

DROP PROCEDURE IF EXISTS `getNationPlayers`;
#8. Get players by givin nation
DELIMITER $$
create procedure getNationPlayers (IN nation VARCHAR(255))
BEGIN
        
        Select player.Player_Number as 'Player number', person.FirstName as 'First name', person.LastName as 'Last name',player.Position , player.Team_Nationality as country
        FROM Player, Person, Team
        Where nation = team.Nationality and team.Nationality = player.Team_Nationality and player.Person_ID = person.ID
		group by player.Player_Number;
        
END $$
DELIMITER ;

call getNationPlayers("Israel");
###################################################

DROP PROCEDURE IF EXISTS `getPlayerPosByNumber`;
#9. Get role of player by player number
DELIMITER $$
create procedure getPlayerPosByNumber (IN Pnumber int)
BEGIN
        
        Select Player.Player_Number as 'Player number', person.FirstName as 'First name', person.LastName as 'Last name' , player.Team_Nationality as country, player.Position
        FROM Player, Person
        Where Pnumber = player.Player_Number and person.ID = player.Person_ID
		group by player.Player_Number;
        
END $$
DELIMITER ;

call getPlayerPosByNumber(4600);
###################################################

DROP PROCEDURE IF EXISTS `getGameByNationPlaying`;
#10. Get game details by two nations
DELIMITER $$
create procedure getGameByNationPlaying (IN nation1 VARCHAR(255),IN nation2 VARCHAR(255))
BEGIN
        
        Select game.*
        FROM game
        Where (nation1 = game.Team_B and nation2 = game.Team_A) or (nation1 = game.Team_A and nation2 = game.Team_B)
		group by game.Game_ID;
        
END $$
DELIMITER ;

call getGameByNationPlaying("Israel","Russia");
###################################################


############Buy Ticket by fan######################
DROP PROCEDURE IF EXISTS `buyTickets`;
DELIMITER $$
CREATE PROCEDURE buyTickets (IN olympicID INT, IN fans INT)
BEGIN

		
        
        IF (SELECT League_ID FROM OlympicLeague WHERE League_ID = olympicID) is NULL
        Then
        (
			SELECT 'Olympic NOT FOUND, try to enter another Olympic ID' as ''
        );
        else
        UPDATE OlympicLeague
		SET Fan_Count = Fan_Count + fans
		WHERE League_ID = olympicID
		;
        SELECT OlympicLeague.*
        FROM OlympicLeague
        WHERE League_ID = olympicID
        ;        
		END IF;

END$$
DELIMITER ;

call buyTickets(100, 5);
###################################################




















