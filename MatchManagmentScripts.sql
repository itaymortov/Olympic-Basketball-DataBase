USE OlympicLeagueSchema;
#Match Management

DROP PROCEDURE IF EXISTS `getListOfRefereeByGameID`;
#1.	Get List of referees by givin game id
DELIMITER $$
create procedure getListOfRefereeByGameID (IN gameID INT)
BEGIN
        
        Select p.*, e.Role
        FROM Referee r, Game g, Employee e, Person p, Staff s
        Where gameID = g.Game_ID and s.Staff_ID = g.Staff_Staff_ID and s.Staff_ID = r.Staff_Staff_ID and r.Employee_EmployeeId = e.EmployeeId and e.Person_ID = p.ID
        group by ID
		;
        
END $$
DELIMITER ;

call getListOfRefereeByGameID(4);
###################################################

DROP PROCEDURE IF EXISTS `getAgeAvgOfGameID`;
#2.	Get the age average of specific game
DELIMITER $$
create procedure getAgeAvgOfGameID (IN gameid int)
BEGIN
        Select Avg(Age)
        From Game, Player, Person
        Where ID = Person_ID and Game_ID = gameid and (Team_A = Team_Nationality or Team_B = Team_Nationality)
        ;        
END $$
DELIMITER ;

call getAgeAvgOfGameID(3);
###################################################

DROP PROCEDURE IF EXISTS `getTotalPointsByGameID`;
#3.	Get total points by game ID
DELIMITER $$
create procedure getTotalPointsByGameID (IN gameid int)
BEGIN
        Select Sum(TeamAScore + TeamBScore) 'Total Score'
        From Game
        Where Game_ID = gameid
        ;        
END $$
DELIMITER ;

call getTotalPointsByGameID(2);
###################################################

DROP PROCEDURE IF EXISTS `getGamesFromTime`;
#4.	Get all games from a time
DELIMITER $$
create procedure getGamesFromTime (IN fromtime TIME)
BEGIN
        Select Game.*
        From Game
        Where CAST(Game.date_time AS TIME) >= fromtime
        Order by CAST(Game.date_time AS TIME)
        ;
END $$
DELIMITER ;

call getGamesFromTime('12:00:00');
###################################################

DROP PROCEDURE IF EXISTS `getCountPlaysTogetherByTeamsName`;
#5.	Get how many times 2 teams play with each other
DELIMITER $$
create procedure getCountPlaysTogetherByTeamsName (IN nationA VARCHAR(255), IN nationB VARCHAR(255))
BEGIN
        
        Select Count(Game_ID) 'Plays together', nationA 'Team A', nationB 'Team B'
        FROM Game
        Where (nationA = Team_A and nationB = Team_B) or (nationA = Team_B and nationB = Team_A)
		;
        
END $$
DELIMITER ;

call getCountPlaysTogetherByTeamsName("Russia", "Israel");
###################################################

DROP PROCEDURE IF EXISTS `getCoachStaffByGameID`;
#6. get Coaches staff by game ID
DELIMITER $$
CREATE PROCEDURE getCoachStaffByGameID (IN GameID int)
BEGIN
	
    select staff.Staff_ID, coach.Employee_EmployeeId, person.FirstName, person.LastName
    from game, staff,coach,person,employee,team
    where GameID = game.Game_ID and game.Winner = team.Nationality and team.Staff_Staff_ID = staff.Staff_ID and coach.Staff_Staff_ID = staff.Staff_ID and coach.Employee_EmployeeId = employee.EmployeeId and employee.Person_ID = person.ID
    group by coach.Employee_EmployeeId;
    
END$$
DELIMITER ;

call getCoachStaffByGameID(1);
###################################################
 
#7. get players played by givin specific date
DROP PROCEDURE IF EXISTS `getPlayerPlayedByDate`;
DELIMITER $$
CREATE PROCEDURE getPlayerPlayedByDate (IN datePlay DATE)
BEGIN
	
    select player.Team_Nationality as nationality, player.Player_Number, person.FirstName, person.LastName
    from game, player,person,employee,team
    where datePlay = cast(game.Date_Time as date) and (player.Team_Nationality = game.Team_A or player.Team_Nationality = game.Team_B) and player.Person_ID = person.ID
    group by player.Player_Number
    order by nationality;
    
END$$
DELIMITER ;

call getPlayerPlayedByDate("2022-5-13");
###################################################

DROP PROCEDURE IF EXISTS `getTeamByStaff`;
#8. Get a team by staff id
DELIMITER $$
CREATE PROCEDURE getTeamByStaff (IN staffID int)
BEGIN
	
    select team.*
    from team
    where staffID = team.Staff_Staff_ID
    group by team.Nationality
    ;
    
END$$
DELIMITER ;

call getTeamByStaff(5354);
###################################################

DROP PROCEDURE IF EXISTS `getListOfPlayersByPosAndGame`;
#9. Get list of players by givin position and game id
DELIMITER $$
CREATE PROCEDURE getListOfPlayersByPosAndGame (IN gameID int,IN Pos VARCHAR(40))
BEGIN
	
    select player.Team_Nationality,player.Player_Number,Person.FirstName,Person.LastName,player.Position
    from player,game,person
    where gameID = game.Game_ID and (player.Team_Nationality = game.Team_A or player.Team_Nationality = game.Team_B) and Player.Person_ID = person.ID and Pos = player.Position
     group by player.Player_Number
    ;
    
END$$
DELIMITER ;

call getListOfPlayersByPosAndGame(1,'PG');
###################################################

DROP PROCEDURE IF EXISTS `getTallestPlayerInMatch`;
#10. Get tallest player by givin game ID
DELIMITER $$
CREATE PROCEDURE getTallestPlayerInMatch(IN gameID int)
BEGIN
	
    select player.Team_Nationality,player.Player_Number,Person.FirstName,Person.LastName,max(player.Height) as 'heightest'
	from player,game,person
    where gameID = game.Game_ID and (player.Team_Nationality = game.Team_A or player.Team_Nationality = game.Team_B) and Player.Person_ID = person.ID 
    group by Team_Nationality
    order by heightest desc
    limit 1
    ;
    
END$$
DELIMITER ;

call getTallestPlayerInMatch(2);




###################################################
DROP FUNCTION IF EXISTS `checkOlympicIDExist`;
#. Check Olympic id exist in system
DELIMITER //
CREATE FUNCTION checkOlympicIDExist( ID int )
RETURNS BOOL
READS SQL DATA
DETERMINISTIC
BEGIN
DECLARE exist BOOL;

 SELECT EXISTS( SELECT * FROM OlympicLeague WHERE League_ID = ID)
	INTO exist;
	RETURN exist;
    
END; //

DELIMITER ;
###################################################


###################################################
DROP PROCEDURE IF EXISTS `addGame`;
DELIMITER $$
CREATE PROCEDURE addGame (IN date_time DATETIME, IN Team_A varchar(255), IN Team_B varchar(255), IN OlympicID int, IN StaffID int)
beg:BEGIN
	DECLARE lastID INT;
    DECLARE startDate DATE;
    DECLARE endDate DATE;
    
    
    ## Check Olympic id exist in system
     IF (!checkOlympicIDExist(OlympicID))
        Then
			SELECT 'Olympic NOT FOUND, try to enter another Olympic ID' as '';
            LEAVE beg;
        END IF;
        
    ## Check that input date is between olympic start date to olympic end date
    SET startDate = 
		(
			Select DateOfStart
            From OlympicLeague
            Where League_ID = OlympicID
        );
	SET endDate = 
		(
			Select DateOfEnd
            From OlympicLeague
            Where League_ID = OlympicID
        );
    IF CAST(date_time AS DATE) >= startDate and CAST(date_time AS DATE) <= endDate
    THEN
			SET lastID = (SELECT max(Game_ID) 
					   FROM Game) + 1;
					   
			insert into Game (Game_ID, date_time, Team_A, Team_B, OlympicLeague_League_ID, Staff_Staff_ID) values (lastID, date_time, Team_A, Team_B, OlympicID, StaffID);
			SELECT game.* FROM game where lastID = Game_ID;
    ELSE
		(
			SELECT 'The input date should be between the beginning of the Olympics to the end' as ''
		);
    
    END IF;

END$$
DELIMITER ;

call addGame('2022-5-25 5:00:00', "Israel", "Russia", 100, 4545);
###################################################

###################################################
DROP PROCEDURE IF EXISTS `updateScore`;
DELIMITER $$
CREATE PROCEDURE updateScore (IN G_ID int, IN AScore int, IN BScore int)
BEGIN
	DECLARE con INT;
    SET con = 
		(
        SELECT TeamAScore or TeamBScore
		FROM Game
		WHERE GAME_ID = G_ID
        );
        
	IF con is not null or con = 1
		THEN 
        (
        SELECT 'ERROR: A result has been set for this game, Please enter another Game ID' as ''
		union SELECT "List of game's id that result has not been set" as ''
		union SELECT GAME_ID FROM Game WHERE Winner is NULL
		);
	ELSE
    
		UPDATE Game
		SET TeamAScore = AScore, TeamBScore = BScore, Winner = if (AScore > BScore, Team_A, Team_B)
		WHERE GAME_ID = G_ID
		;
        
		SELECT "The score was set successfully, The winner is: " as ''
        union
        SELECT Winner
        From Game
        Where GAME_ID = G_ID
        ;
	END IF;
           
END$$
DELIMITER ;

call updateScore(6, 142, 214);


DROP PROCEDURE IF EXISTS `CalculateWinner`;
DELIMITER $$
CREATE PROCEDURE CalculateWinner (IN LeagueID int)
BEGIN

	Declare winnerName varchar(255);
	Declare winnerPoints int;

	update team as t, (
    
			SELECT count(winner) as cWin, team.Nationality as nation
			FROM Game, OlympicLeague, team
			WHERE LeagueID = OlympicLeague.League_ID and Game.winner = team.Nationality
			group by team.Nationality
			)s
            SET t.Points = cWin * 3
            where nation = t.Nationality;
            
			SET winnerName = (
            SELECT team.Nationality
            From team
            order by team.points desc
            limit 1
			);
            
            SET winnerPoints = (
            SELECT team.points
            From team
            order by team.points desc
            limit 1
			);
            
            SELECT concat('The winner of leauge ', LeagueID, ' is: ' , winnerName, ' with total score of ', winnerPoints) as '';
            
            
END$$
DELIMITER ;

call CalculateWinner(100);








