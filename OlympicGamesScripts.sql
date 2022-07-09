USE OlympicLeagueSchema;


DROP PROCEDURE IF EXISTS `getGameWidestScoreGap`;
#1.	Get Game with the widest score gap
DELIMITER $$
create procedure getGameWidestScoreGap ()
BEGIN
        
        Select Game_id, Game.Date_Time, Team_A, Team_B, Winner, abs(TeamBScore - TeamAScore) ScoreGap
        FROM Game
        Order By ScoreGap desc
        limit 1
		;
        
END $$
DELIMITER ;

call getGameWidestScoreGap();
###################################################

DROP PROCEDURE IF EXISTS `getTeamAndTotalPointsByNation`;
#2. Get team and their total points by Team Nationality
DELIMITER $$
create procedure getTeamAndTotalPointsByNation (IN nation varchar(255))
BEGIN
        
		Select Nation, SUM(totalScore) totalScore
        From
        (
        Select SUM(TeamAScore) totalScore FROM Game WHERE nation = Team_A
        UNION
        Select SUM(TeamBScore) totalScore FROM Game WHERE nation = Team_B
        )s;
        
END $$
DELIMITER ;

call getTeamAndTotalPointsByNation("Israel");
###################################################


DROP PROCEDURE IF EXISTS `getTeamMostWins`;
#3. Show the team that got the most wins
DELIMITER $$
create procedure getTeamMostWins ()
BEGIN
        
		Select Winner, MAX(wins) wins
        From
        (
        Select Winner, COUNT(Winner) wins
        FROM Game
        Group by Winner
        ORDER BY wins DESC
        )s;
        
END $$
DELIMITER ;

call getTeamMostWins();


DROP PROCEDURE IF EXISTS `getMostFoulsTeam`;
#4.	Get the team that do the most fouls
DELIMITER $$
create procedure getMostFoulsTeam ()
BEGIN
        
        Select Nationality, Max(TotalFouls) "Total Fouls" From
        (
        Select Team.Nationality, Sum(TotalFouls) TotalFouls
        FROM Team, Player
        Where Team_Nationality = Nationality
        GROUP BY Nationality
        ORDER BY TotalFouls DESC
        )s;
        
END $$
DELIMITER ;

call getMostFoulsTeam();
###################################################

DROP PROCEDURE IF EXISTS `getTeamLargestGapAge`;
#5.	Get the team with the the largest age gap between two players 
DELIMITER $$
create procedure getTeamLargestGapAge ()
BEGIN
        
        Select Team.Nationality, (Max(Age)- Min(Age)) AgeGap
        FROM Team, Player, Person
        Where Team_Nationality = Nationality and Person_ID = Person.ID
        GROUP BY Nationality
        Order By AgeGap desc
        limit 1
		;
        
END $$
DELIMITER ;

call getTeamLargestGapAge();
###################################################

DROP PROCEDURE IF EXISTS `getTallTeams`;
#6. Show the tallest player from all teams
DELIMITER $$
create procedure getTallTeams ()
BEGIN
        
		Select Team_Nationality, FirstName, LastName, Height as Max_Height
        From Player, Person
        where Height = (
			select Max(Height)
			from Player as p where p.Team_Nationality = Player.Team_Nationality
        ) and ID = Person_ID
        Group by Team_Nationality
        Order By Max_Height desc
        ;

END $$
DELIMITER ;

call getTallTeams();
###################################################

DROP PROCEDURE IF EXISTS `getAvgSalaryStaff`;
#7. Show the avarage salary for each staff
DELIMITER $$
create procedure getAvgSalaryStaff ()
BEGIN
        
		Select Staff_ID, avg(salary) as AvarageSalary
        From Staff s, Employee e , Referee r, Coach c
        Where (s.Staff_ID = r.Staff_Staff_ID and e.EmployeeId = r.Employee_EmployeeId) or (s.Staff_ID = c.Staff_Staff_ID and e.EmployeeId = c.Employee_EmployeeId)
        Group by Staff_ID
        ;
        
END $$
DELIMITER ;

call getAvgSalaryStaff();
###################################################

DROP PROCEDURE IF EXISTS `countEmpStaff`;
#8.	Count employees on Staff
DELIMITER $$
create procedure countEmpStaff ()
BEGIN
		
        Select StaffID, Count From(
        Select Staff_ID as StaffID, Count(Staff_ID) as Count From Staff, Referee Where Staff_ID = Staff_Staff_ID Group by Staff_ID
        union
        Select Staff_ID as StaffID, Count(Staff_ID) as Count From Staff, Coach Where Staff_ID = Staff_Staff_ID Group by Staff_ID
		)s;
        
END $$
DELIMITER ;

call countEmpStaff();
###################################################

DROP PROCEDURE IF EXISTS `getPlayerAndTeamByPhoneNumber`;
#9.	get the Player and team nation by cell phone number
DELIMITER $$
create procedure getPlayerAndTeamByPhoneNumber (IN phonenum int)
BEGIN
		
        Select FirstName, LastName, Team_Nationality, phonenum
        From Person, Player
        Where ID = Person_ID and phonenum = Phone
        ;
        
END $$
DELIMITER ;

call getPlayerAndTeamByPhoneNumber(0549086);
###################################################

DROP PROCEDURE IF EXISTS `getTeamsThatScoreMoreThan`;
#10. Get teams and filter by total points
DELIMITER $$
create procedure getTeamsThatScoreMoreThan (IN points int)
BEGIN
        
        Select * From(
        Select Team_A Team, sum(suma) TotalScore From(
		Select Team_A, sum(TeamAScore) suma From game Group by Team_A
        union
        Select Team_B, sum(TeamBScore) suma From game Group by Team_B
        )s
        group by Team_A
        )d
        Where TotalScore >= points
        ;
        
END $$
DELIMITER ;

call getTeamsThatScoreMoreThan(280);
###################################################

###################################################
DROP PROCEDURE IF EXISTS `deleteRefereeEmployee`;
DELIMITER $$
CREATE PROCEDURE deleteRefereeEmployee (IN employeeID int)
del:BEGIN

	DELETE FROM referee r WHERE r.Employee_EmployeeId = employeeID;
	DELETE FROM employee e WHERE e.EmployeeId = employeeID;
    
    
END$$
DELIMITER ;


call deleteRefereeEmployee(4011);
###################################################

###################################################
DROP PROCEDURE IF EXISTS `addPlayer`;
DELIMITER $$
CREATE PROCEDURE addPlayer (IN pID int, IN firstname varchar(255), IN lastname varchar(255), IN gend varchar(255), IN age int, IN phone int, IN Player_Number int, IN Position varchar(255), IN Weight int, IN Height int, IN TotalPoints int, IN TotalFouls int, IN Team_Nationality varchar(255))
be:BEGIN
    ## Check Person id exist in system
	IF (checkNationality(Team_Nationality) != 1)
        Then
			SELECT 'Nationality do not exist in system, try to enter another' as '';
	ELSEIF (checkPlayerNumberExist(Player_Number))
		Then
			SELECT 'Player Number exist in system, try to enter another' as '';
            
            LEAVE be;
        END IF;
		## Check Person id exist in system
		IF (checkIDExist(pID))
        Then
			SELECT 'ID exist in system, try to enter person ID' as '';
            LEAVE be;
        END IF;
        	call addPerson(pID, firstname, lastname, gend, age, phone);
			insert into Player (Player.Player_Number, Player.Position, Player.Weight, Player.Height, Player.TotalPoints, Player.TotalFouls, Player.Person_ID, Player.Team_Nationality) values
            (Player_Number, Position, Weight, Height, TotalPoints, TotalFouls, pID, Team_Nationality);
			SELECT Player.* FROM Player where Player.Player_Number = Player_Number;
END$$
DELIMITER ;


call addPlayer(5312333, 'Elliott', 'Young', 'Male', 23, 0544949, 51234399, "PG", 95, 212, 56, 5, "Israel");
###################################################

###################################################
DROP PROCEDURE IF EXISTS `addPerson`;
DELIMITER $$
CREATE PROCEDURE addPerson (IN ID int, IN firstname varchar(255), IN lastname varchar(255), IN gend varchar(255), IN age int, IN phone int)
beg:BEGIN        
			insert into Person (Person.ID, FirstName, LastName, Gender, Person.Age, Phone) values (ID, firstname, lastname, gend, age, phone);
			SELECT person.* FROM person where Person.ID = ID;

END$$
DELIMITER ;
###################################################

###################################################
DROP FUNCTION IF EXISTS `checkIDExist`;
#. Check Person id exist in system
DELIMITER //
CREATE FUNCTION checkIDExist( ID int )
RETURNS BOOL
READS SQL DATA
DETERMINISTIC
BEGIN
DECLARE exist BOOL;

 SELECT EXISTS( SELECT * FROM Person WHERE Person.ID = ID)
	INTO exist;
	RETURN exist;
    
END; //

DELIMITER ;
###################################################

###################################################
DROP FUNCTION IF EXISTS `checkNationality`;
#. Check Person id exist in system
DELIMITER //
CREATE FUNCTION checkNationality( nationality varchar(255) )
RETURNS BOOL
READS SQL DATA
DETERMINISTIC
BEGIN
DECLARE exist BOOL;

 SELECT EXISTS( SELECT * FROM team WHERE team.Nationality = nationality)
	INTO exist;
	RETURN exist;
    
END; //

DELIMITER ;
###################################################

###################################################
DROP FUNCTION IF EXISTS `checkPlayerNumberExist`;
#. Check Person id exist in system
DELIMITER //
CREATE FUNCTION checkPlayerNumberExist( PlayerNumber int )
RETURNS BOOL
READS SQL DATA
DETERMINISTIC
BEGIN
DECLARE exist BOOL;

 SELECT EXISTS( SELECT * FROM player WHERE Player_Number = PlayerNumber)
	INTO exist;
	RETURN exist;
    
END; //

DELIMITER ;
###################################################
