USE `starwarsfinalzilbershera`;

/* Question 1:

My original StarWars schema is actually identical to the given schema
except for the names of the columns and foreign keys. I chose to preface
all of my column names with the table name, followed by the column's name, 
which I found useful for identifying where a column was located at a glance. 
I did however rename my columns even if they were a foreign key originating 
from another table, which I think the given schema does better since it's easier
to put together where the column's data was originally stored. Aside from that
the only notable difference was my naming convention of fk_name rather than 
name_fk for my foreign keys, but that was all I could find. 
*/

-- Question 2

SELECT characters.character_name, planet_name, title, departure - arrival AS screen_time
FROM timetable 
	INNER JOIN characters
		ON characters.character_name = timetable.character_name
	INNER JOIN movies
		ON movies.movie_id = timetable.movie_id
ORDER BY characters.character_name, timetable.movie_id

-- Question 3

SELECT DISTINCT characters.character_name, COUNT(DISTINCT timetable.planet_name) AS planets_visited 
FROM characters
	INNER JOIN timetable
		ON characters.character_name = timetable.character_name
GROUP BY characters.character_name

-- Question 4

SELECT COUNT(DISTINCT characters.character_name) AS appeared_in_desert
FROM timetable
	INNER JOIN characters
		ON characters.character_name = timetable.character_name
	INNER JOIN planets
		ON planets.planet_name = timetable.planet_name
WHERE planet_type = 'desert'

-- Question 5
SELECT planets.planet_name, COUNT(DISTINCT characters.character_name) AS most_visited
FROM timetable
	INNER JOIN characters
		ON characters.character_name = timetable.character_name
	INNER JOIN planets
		ON planets.planet_name = timetable.planet_name
GROUP BY planets.planet_name
ORDER BY most_visited DESC
LIMIT 1

-- Question 6

SELECT planets.planet_name
FROM timetable
	INNER JOIN characters
		ON characters.character_name = timetable.character_name
	INNER JOIN planets
		ON planets.planet_name = timetable.planet_name
GROUP BY planets.planet_name
HAVING COUNT(DISTINCT characters.character_name) = (SELECT COUNT(DISTINCT character_name) FROM characters)

-- Question 7

DROP TABLE IF EXISTS `Movie1Timings`;
CREATE TABLE `Movie1Timings`
	AS SELECT * FROM timetable WHERE movie_id = 1
    
-- Question 8

SELECT movies.title, SUM(departure - arrival) as screentime
FROM timetable
	INNER JOIN characters
		ON characters.character_name = timetable.character_name
	INNER JOIN movies
		ON movies.movie_id = timetable.movie_id
WHERE characters.character_name = 'Lando Calrissian'
GROUP BY movies.title
ORDER BY SUM(departure - arrival) DESC
LIMIT 1

-- Question 9

SELECT DISTINCT planets.planet_type, GROUP_CONCAT(DISTINCT characters.character_name)
FROM timetable
	INNER JOIN characters
		ON characters.character_name = timetable.character_name
	INNER JOIN planets
		ON planets.planet_name = timetable.planet_name
GROUP BY planets.planet_type

-- Question 10

SELECT planets.planet_type, COUNT(DISTINCT characters.character_name) AS least_visited
FROM timetable
	INNER JOIN characters
		ON characters.character_name = timetable.character_name
	INNER JOIN planets
		ON planets.planet_name = timetable.planet_name
WHERE timetable.movie_id = 2
GROUP BY planets.planet_type
ORDER BY least_visited ASC
LIMIT 1

-- Question 11

SELECT COUNT(DISTINCT characters.character_name) FROM characters 
WHERE characters.affiliation = 'rebels' 

-- Question 12

DROP TABLE IF EXISTS `RebelsinMovie1Timings`;
CREATE TABLE `RebelsinMovie1Timings`
	AS SELECT timetable.* FROM 
    timetable INNER JOIN characters
    ON timetable.character_name = characters.character_name 
    WHERE movie_id = 1 AND characters.affiliation = 'rebels'

-- Question 13

SELECT characters.character_name FROM characters INNER JOIN planets
ON characters.homeworld = planets.planet_name
WHERE characters.affiliation = planets.affiliation

