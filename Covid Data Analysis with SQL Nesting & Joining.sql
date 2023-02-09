CREATE TABLE countries (
  country_id INT PRIMARY KEY,
  country_name VARCHAR(50) NOT NULL,
  continent VARCHAR(50) NOT NULL
);

CREATE TABLE cases (
  case_id INT PRIMARY KEY,
  country_id INT,
  date DATE NOT NULL,
  cases INT NOT NULL,
  deaths INT NOT NULL,
  FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

CREATE TABLE population (
  population_id INT PRIMARY KEY,
  country_id INT,
  year INT NOT NULL,
  population INT NOT NULL,
  FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

INSERT INTO countries (country_id, country_name, continent)
VALUES (1, 'USA', 'North America'),
       (2, 'China', 'Asia'),
       (3, 'India', 'Asia'),
       (4, 'Indonesia', 'Asia'),
       (5, 'Brazil', 'South America');

INSERT INTO cases (case_id, country_id, date, cases, deaths)
VALUES (1, 1, '2022-01-01', 1000, 100),
       (2, 2, '2022-01-01', 2000, 200),
       (3, 3, '2022-01-01', 1500, 150),
       (4, 4, '2022-01-01', 1200, 120),
       (5, 5, '2022-01-01', 1700, 170);

INSERT INTO population (population_id, country_id, year, population)
VALUES (1, 1, 2022, 30000000),
       (2, 2, 2022, 100000000),
       (3, 3, 2022, 500000000),
       (4, 4, 2022, 300000000),
       (5, 5, 2022, 200000000);

CREATE VIEW covid_data AS
SELECT 
  countries.country_name, 
  cases.date, 
  SUM(cases.cases) AS total_cases, 
  AVG(cases.deaths) AS avg_deaths,
  SUM(population.population) AS total_population,
  (CASE 
    WHEN SUM(cases.cases) > 1500 THEN 'High'
    ELSE 'Low'
  END) AS case_level
FROM cases
LEFT JOIN countries
ON cases.country_id = countries.country_id
LEFT JOIN population
ON cases.country_id = population.country_id AND cases.date = population.year
GROUP BY countries.country_name, cases.date
HAVING SUM(cases.cases) > 1500;

UPDATE cases
SET cases = 2000
WHERE country_id = 1;

DELETE FROM cases
WHERE country_id = 5;

SELECT *
FROM covid_data
ORDER BY total_cases DESC
LIMIT 3;
