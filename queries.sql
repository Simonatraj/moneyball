-- Finds the average player salary by year, rounded to two decimal places, sorted from most recent to oldest.
SELECT year, ROUND(AVG(salary),2) AS "average salary" FROM salaries
GROUP BY year
ORDER BY YEAR DESC;


-- Shows Cal Ripken Jr.’s salary history by year (for the player born in 1960), sorted from most recent to oldest.
SELECT salaries.year, salaries.salary FROM salaries
JOIN players ON players.id = salaries.player_id
WHERE players.first_name LIKE '%Cal%' AND players.last_name LIKE '%Ripken%'
ORDER BY year DESC;


-- Displays Ken Griffey Jr.’s home run totals by year (born in 1969), sorted from most recent to oldest.
SELECT year, HR FROM performances
WHERE player_id = (
    SELECT id from players
    WHERE (first_name = 'Ken' AND last_name = 'Griffey') AND birth_year = 1969
)
ORDER BY year DESC;


-- Lists the 50 players with the lowest salaries in 2001, sorted by salary, then alphabetically by name, and by player ID if needed.
SELECT players.first_name, players.last_name, salaries.salary FROM players
JOIN salaries ON salaries.player_id = players.id
WHERE year = 2001
ORDER BY salary, first_name
LIMIT 50;


-- Shows all teams that Satchel Paige played for throughout his career.
SELECT teams.name FROM teams
JOIN performances ON performances.team_id = teams.id
JOIN players ON players.id = performances.player_id
WHERE players.last_name = 'Paige';


-- Shows the top 5 teams with the highest total hits in 2001, sorted by total hits in descending order.
SELECT teams.name, SUM(performances.H) AS "total hits" FROM teams
JOIN performances ON performances.team_id = teams.id
WHERE performances.year = 2001
GROUP BY performances.team_id
ORDER BY "total hits" DESC
LIMIT 5;


-- Finds the player who received the highest salary ever in Major League Baseball history.
SELECT first_name, last_name FROM players
WHERE id = (
    SELECT player_id FROM salaries
    WHERE salary = (
        SELECT MAX(salary) FROM salaries
    )
);


-- Displays the 2001 salary of the player who hit the most home runs that year.
SELECT salary FROM salaries
JOIN performances ON performances.player_id = salaries.player_id
WHERE salaries.year = 2001 AND performances.HR = (
    SELECT MAX(HR) FROM performances
);


-- Lists the 5 teams with the lowest average salaries in 2001, rounded to two decimal places and sorted from lowest to highest.
SELECT teams.name, ROUND(AVG(salaries.salary),2) AS  "average salary" FROM teams
JOIN salaries ON salaries.team_id = teams.id
WHERE salaries.year = 2001
GROUP BY teams.id
ORDER BY "average salary"
LIMIT 5;


-- Lists each player's name, salary, home runs, and year, sorted by player ID, then by year, and by home runs and salary when needed.
SELECT players.first_name, players.last_name, salaries.salary, salaries.year, performances.HR
FROM players
JOIN salaries ON salaries.player_id = players.id
JOIN performances ON performances.player_id = players.id AND performances.year = salaries.year
ORDER BY players.id ASC, salaries.year DESC, performances.HR DESC, salaries.salary DESC;


-- Finds the 10 most cost-effective players (least dollars per hit) in 2001, excluding players with 0 hits and sorting by value.
SELECT players.first_name, players.last_name, (salaries.salary/performances.H) AS "dollars per hit"
FROM players
JOIN salaries ON salaries.player_id = players.id
JOIN performances ON performances.player_id = players.id AND performances.year = salaries.year
WHERE performances.year = 2001 AND performances.H > 0
ORDER BY "dollars per hit", first_name, last_name
LIMIT 10;


-- Finds players who are in both the 10 least expensive per hit and per RBI in 2001, sorted alphabetically by name.
SELECT first_name,last_name FROM (
    SELECT players.first_name, players.last_name FROM players
    JOIN salaries ON salaries.player_id = players.id
    JOIN performances ON performances.player_id = players.id AND performances.year = salaries.year
    WHERE performances.H > 0 AND salaries.year = 2001
    ORDER BY salaries.salary/performances.H
    LIMIT 10
)
INTERSECT
SELECT first_name, last_name FROM (
    SELECT players.first_name, players.last_name FROM players
    JOIN salaries ON salaries.player_id = players.id
    JOIN performances ON performances.player_id = players.id AND performances.year = salaries.year
    WHERE performances.RBI > 0 AND salaries.year = 2001
    ORDER BY salaries.salary/performances.RBI
    LIMIT 10
)
ORDER BY last_name;
