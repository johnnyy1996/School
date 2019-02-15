-- The database is not normalized because the country table contains nulls, therefore violating first normal form and all higher normal forms. It can be normalized if all of the nulls are eliminated.

-- 1. What are the top ten countries by economic activity (Gross National Product - ‘gnp’).

SELECT
    name,
    gnp
FROM 
    country 
ORDER BY gnp DESC 
LIMIT 10;

-- 2. What are the top ten countries by GNP per capita?

SELECT 
    name,
    gnp,
    population,
    COALESCE(gnp / NULLIF(population, 0), 0) AS GNP_per_capita
FROM
    country 
ORDER BY GNP_per_capita DESC
LIMIT 10;

-- 3. What are the ten most densely populated countries, and ten least densely populated countries?

SELECT
    name,
    population
FROM
    country
ORDER BY population DESC
LIMIT 10;

SELECT
    name,
    population
FROM
    country
ORDER BY population
LIMIT 10;

-- 4. What different forms of government are represented in this data?

SELECT 
    DISTINCT governmentform AS different_forms_of_government
FROM
    country;
    
-- Which forms of government are most frequent? 

SELECT
    governmentform,
    COUNT(*) AS frequency
FROM
    country
GROUP BY governmentform
ORDER BY frequency DESC;

-- 5. Which countries have the highest life expectancy?

SELECT
    name AS Country,
    lifeexpectancy AS Life_Expectancy
FROM
    country
WHERE lifeexpectancy IS NOT NULL
ORDER BY lifeexpectancy DESC
LIMIT 10;

-- 6. What are the top ten countries by total population, and what is the official language spoken there?

SELECT
    a.name AS Country,
    a.population AS Population,
    b.language AS Official_Language
FROM country a
    INNER JOIN countrylanguage b
        ON a.code = b.countrycode
WHERE b.isofficial='t'
ORDER BY population DESC
LIMIT 10;

-- 7. What are the top ten most populated cities – along with which country they are in, and what continent they are on? 
SELECT
    a.name AS City,
    a.population AS Population,
    b.name AS Country,
    b.continent AS Continent
FROM city a
    INNER JOIN country b
        ON a.countrycode = b.code
ORDER BY population DESC
LIMIT 10;
    

-- 8. What is the official language of the top ten cities you found in Question #7?

SELECT
    a.name AS City,
    a.population AS Population,
    b.name AS Country,
    b.continent AS Continent,
    c.language AS Official_Language
FROM city a
    INNER JOIN countrylanguage c
    USING(countrycode)
    INNER JOIN country b
        ON a.countrycode = b.code
WHERE c.isofficial='t'
ORDER BY population DESC
LIMIT 10;

-- 9. Which of the cities from Question #7 are capitals of their country?

SELECT
    Country,
    City AS Capital
FROM(
    SELECT
        a.name AS City,
        a.population AS Population,
        b.name AS Country,
        a.id AS ID,
        b.capital AS Capital
    FROM city a
        INNER JOIN country b
            ON a.countrycode = b.code
    ORDER BY population DESC
    LIMIT 10) AS c
WHERE c.ID = c.Capital;

-- 10. . For the cities found in Question#9, what percentage of the country’s population lives in the capital city? 

SELECT
    Country,
    Country_Population,
    City,
    City_Population,
    (CAST(City_Population AS FLOAT) / CAST(Country_Population AS FLOAT)) * 100 AS Percent_of_Country_Population
FROM(
    SELECT
        b.name AS Country,
        b.population AS Country_Population,
        b.capital AS Capital,
        a.name AS City,
        a.population AS City_Population,
        a.id AS ID
    FROM city a
        INNER JOIN country b
            ON a.countrycode = b.code
    ORDER BY City_Population DESC
    LIMIT 10) AS c
WHERE c.ID = c.Capital
ORDER BY City_Population DESC;

-- 10. For the cities found in Question#7, what percentage of the country’s population lives in the capital city? 

-- SELECT
--     b.name AS Country,
--     b.population AS Country_Population,
--     a.name AS City,
--     a.population AS City_Population,
--     (CAST(a.population AS FLOAT) / CAST(b.population AS FLOAT)) * 100 AS Percent_of_Country_Population
-- FROM city a
--     INNER JOIN country b
--         ON a.countrycode = b.code
-- ORDER BY City_Population DESC
-- LIMIT 10;