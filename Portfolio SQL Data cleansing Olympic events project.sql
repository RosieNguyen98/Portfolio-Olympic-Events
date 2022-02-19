SELECT *
FROM athlete_events;
-- ORDER BY Year, Season, Sport, Medal;


-- Change M and F to Male and Female in Sex
SELECT Sex,
(CASE WHEN Sex = 'M' THEN 'Male'
      ELSE 'Female'
END) AS Sex
FROM athlete_events;

UPDATE athlete_events
SET Sex = (CASE WHEN Sex = 'M' THEN 'Male'
                ELSE 'Female'
           END);
           
-- Group age into different age group
SELECT Age,
(CASE WHEN age < 18 THEN "Under 18"
      WHEN age BETWEEN 18 AND 25 THEN "18-25"
      WHEN age BETWEEN 25 AND 30 THEN "25-30"
      ELSE "Over 30"
END) AS Age
FROM athlete_events;

ALTER TABLE athlete_events
ADD COLUMN age_group varchar(55) AFTER age;

UPDATE athlete_events
SET age_group = (CASE WHEN age < 18 THEN "Under 18"
      WHEN age BETWEEN 18 AND 25 THEN "18-25"
      WHEN age BETWEEN 25 AND 30 THEN "25-30"
      ELSE "Over 30"
END);

-- Split up NOC into Nation code and Country
SELECT SUBSTRING_INDEX(NOC, ",", 1) AS Nation_code,
       SUBSTRING_INDEX(NOC, ",", -1) AS Country
FROM athlete_events;

ALTER TABLE athlete_events
ADD COLUMN Nation_code varchar(55) AFTER NOC;

UPDATE athlete_events
SET Nation_code = SUBSTRING_INDEX(NOC, ",", 1);

ALTER TABLE athlete_events
ADD COLUMN Country varchar(255) AFTER Nation_code;

UPDATE athlete_events
SET Country = SUBSTRING_INDEX(NOC, ",", -1);

-- Split up Game into Year and Season
SELECT SUBSTRING_INDEX(Game, ",", 1) AS Year,
       SUBSTRING_INDEX(Game, ",", -1) AS Season
FROM athlete_events;

ALTER TABLE athlete_events
ADD COLUMN Year INT AFTER Game;

UPDATE athlete_events
SET Year = SUBSTRING_INDEX(Game, ",", 1);

ALTER TABLE athlete_events
ADD COLUMN Season varchar(55) AFTER Year;

UPDATE athlete_events
SET Season = SUBSTRING_INDEX(Game, ",", -1);

-- Change NA to No medal in Medal
SELECT Medal,
(CASE WHEN Medal = 'NA' THEN 'No medal'
     ELSE Medal
END)
FROM athlete_events;

UPDATE athlete_events
SET Medal = (CASE WHEN Medal = 'NA' THEN 'No medal'
                  ELSE Medal
             END);

-- Delete unescessary column
ALTER TABLE athlete_events
DROP COLUMN NOC;

ALTER TABLE athlete_events
DROP COLUMN Game;

-- Check duplicate or not
WITH ROW_NUM AS(
SELECT *,
ROW_NUMBER() OVER 
(PARTITION BY Name,
			  Sex,
              Age, 
              Nation_code,
              Year,
              Sport,
              Event,
              Medal) row_num
FROM athlete_events
ORDER BY ID
)

SELECT *
FROM ROW_NUM
WHERE row_num > 1
