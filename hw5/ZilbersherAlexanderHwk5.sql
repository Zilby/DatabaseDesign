USE `starwarsfinalzilbershera`;

/* 1. Write a procedure track_character(character) that accepts a character name and returns a result
set that contains a list of the movie scenes the character is in. For each movie, track the total
number of scenes and the planet where the character appears. The result set should contain the
character’s name, the planet name, the movie name, and the sum of the movie scene length for
that specific planet in that movie for that character. */

DELIMITER //

DROP PROCEDURE IF EXISTS track_character//
CREATE PROCEDURE track_character
(
	name VARCHAR(45)
)
BEGIN
	SELECT characters.character_name, planet_name, title, departure - arrival AS screen_time
	FROM timetable 
		INNER JOIN characters
			ON characters.character_name = timetable.character_name
		INNER JOIN movies
			ON movies.movie_id = timetable.movie_id
	WHERE characters.character_name = name
	ORDER BY characters.character_name, timetable.movie_id;
END//

-- CALL track_character('yoda');

/*2. Write a procedure track_planet(planet) that accepts a planet name and returns a result set that
contain the planet name, the movie name, and the number of characters that appear on that planet
during that movie.*/

DROP PROCEDURE IF EXISTS track_planet//
CREATE PROCEDURE track_planet
(
	planet VARCHAR(45)
)
BEGIN
	SELECT DISTINCT planets.planet_name, movies.title, COUNT(DISTINCT characters.character_name) AS characters
	FROM timetable
		INNER JOIN characters
			ON characters.character_name = timetable.character_name
		INNER JOIN planets
			ON planets.planet_name = timetable.planet_name
		INNER JOIN movies 
			ON movies.movie_id = timetable.movie_id
	WHERE planets.planet_name = planet
	GROUP BY planets.planet_name, movies.title;
END//

-- CALL track_planet('Tatooine');

/*3. Write a function named planet_hopping(character). It accepts a character name and returns the
number of planets the character has appeared on.*/

DROP FUNCTION IF EXISTS planet_hopping//
CREATE FUNCTION planet_hopping
(
	name VARCHAR(45)
)
RETURNS INT
BEGIN
	DECLARE planets_visited INT;
	SELECT DISTINCT COUNT(DISTINCT timetable.planet_name) INTO planets_visited
	FROM characters
		INNER JOIN timetable
			ON characters.character_name = timetable.character_name
	WHERE characters.character_name = name
	GROUP BY characters.character_name;
    
    RETURN(planets_visited);
END//

-- SELECT planet_hopping('Luke Skywalker');

/*4. Write a function named planet_most_visited(character) that accepts a character name and returns
the name of the planet where the character appeared the most ( as measured in scene counts).*/

DROP FUNCTION IF EXISTS planet_most_visited//
CREATE FUNCTION planet_most_visited
(
	name VARCHAR(45)
)
RETURNS VARCHAR(45)
BEGIN
	DECLARE most_visited VARCHAR(45);
	SELECT planets.planet_name INTO most_visited
	FROM characters
		INNER JOIN timetable
			ON characters.character_name = timetable.character_name
		INNER JOIN planets
			ON planets.planet_name = timetable.planet_name
	WHERE characters.character_name = name
	GROUP BY planets.planet_name
    ORDER BY COUNT(planets.planet_name) DESC
	LIMIT 1;
    
    RETURN(most_visited);
END//

-- SELECT planet_most_visited('C-3 PO');

/*5. Write a function named home_affiliation_same(character) that accepts a character name and
returns TRUE if the character has the same affiliation as his home planet, FALSE if the character
has a different affiliation than his home planet or NULL if the home planet or the affiliation is not
known.*/

DROP FUNCTION IF EXISTS home_affiliation_same//
CREATE FUNCTION home_affiliation_same
(
	name VARCHAR(45)
)
RETURNS BOOLEAN
BEGIN
	DECLARE same BOOLEAN;
	IF EXISTS (SELECT characters.character_name 
					FROM characters JOIN planets
						ON characters.homeworld = planets.planet_name
					WHERE characters.character_name = name AND 
						characters.affiliation = planets.affiliation)
		THEN SET same = TRUE;
	ELSEIF EXISTS (SELECT characters.character_name 
					FROM characters JOIN planets
						ON characters.homeworld = planets.planet_name
					WHERE characters.character_name = name AND 
						characters.homeworld = 'Unknown')
		THEN SET same = NULL;
	ELSE
		SET same = FALSE;
	END IF;
    RETURN(same);
END//

-- SELECT home_affiliation_same('Han Solo');
-- SELECT home_affiliation_same('Yoda');
-- SELECT home_affiliation_same('Luke Skywalker');

/*6. Write a function named planet_in_num_movies() that accepts a planet’s name as an argument and
returns the number of movies that the planet appeared in.*/

DROP FUNCTION IF EXISTS planet_in_num_movies//
CREATE FUNCTION planet_in_num_movies
(
	planet VARCHAR(45)
)
RETURNS INT
BEGIN
	DECLARE movie_appearances INT;
	SELECT DISTINCT COUNT(DISTINCT timetable.movie_id) INTO movie_appearances
	FROM planets
		INNER JOIN timetable
			ON planets.planet_name = timetable.planet_name
	WHERE planets.planet_name = planet
	GROUP BY planets.planet_name;
    
    RETURN(movie_appearances);
END//

-- SELECT planet_in_num_movies('Death Star');

/*7. Write a procedure named character_with_affiliation(affiliation) that accepts an affiliation and
returns the character records (all fields associated with the character) with that affiliation.*/

DROP PROCEDURE IF EXISTS character_with_affiliation//
CREATE PROCEDURE character_with_affiliation
(
	affiliation VARCHAR(45)
)
BEGIN
	SELECT DISTINCT character_name, race, homeworld, affiliation
	FROM characters
	WHERE characters.affiliation = affiliation
	GROUP BY character_name;
END//

-- CALL character_with_affiliation('rebels');

/*8. Write a trigger that updates the field scenes_in_db for the movie records in the Movies table. The
field should contain the maximum scene number found in the timetable table for that movie. Call
the trigger timetable_after_insert. Insert the following records into the database. Insert records
into the timetable table that places 'Chewbacca’, and ‘Princess Leia’ on 'Endor' in scenes 11
through 12 for movie 3. Ensure that the scenesinDB is properly updated for this data.*/

-- Didn't have time to find syntax error before submission :[
/*
DROP TRIGGER IF EXISTS timetable_after_insert//
CREATE TRIGGER timetable_after_insert
AFTER INSERT ON timetable 
FOR EACH ROW
BEGIN
    UPDATE movies
    SET movies.scenes_in_db = COUNT(timetable.time_id)
    FROM movies JOIN timetable
    ON timetable.movie_id = movies.movie_id    
END//

INSERT INTO timetable VALUES 
('Chewbacca', 'Endor', 3, 11, 12, DEFAULT)//
INSERT INTO timetable VALUES 
('Princess Leia', 'Endor', 3, 11, 12, DEFAULT)//
*/

/*9. Create and execute a prepared statement from the SQL workbench that calls track_character with
the argument ‘Princess Leia’. Use a user session variable to pass the argument to the
function.*/

PREPARE track_character_statement
FROM 'CALL track_character(?)' //
SET @var1 = 'Princess Leia'//
-- EXECUTE track_character_statement USING @var1//
DEALLOCATE PREPARE track_character_statement//


/*10. Create and execute a prepared statement that calls planet_in_num_movies() with the argument
‘Bespin’. Once again use a user session variable to pass the argument to the function.*/

PREPARE planet_in_num_movies_statement
FROM 'SELECT planet_in_num_movies(?)' //
SET @var2 = 'Bespin'//
-- EXECUTE planet_in_num_movies_statement USING @var2//
DEALLOCATE PREPARE planet_in_num_movies_statement//