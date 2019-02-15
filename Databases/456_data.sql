\pset footer off 
\echo 

DROP TABLE IF EXISTS fundamentals;
DROP TABLE IF EXISTS prices;
DROP TABLE IF EXISTS securities;

CREATE TABLE securities (
    symbol TEXT,
    company TEXT,
    sector TEXT,
    sub_industry TEXT,
    initial_trade_date TEXT
);

CREATE TABLE fundamentals (
    id INTEGER,
    symbol TEXT,
    year_ending TEXT,
    cash_and_cash_equivalents FLOAT,
    earnings_before_interest_and_taxes FLOAT,
    gross_margin INTEGER,
    net_income FLOAT,
    total_assets FLOAT,
    total_liabilities FLOAT,
    total_revenue FLOAT,
    year INTEGER,
    earnings_per_share FLOAT,
    shares_outstanding FLOAT
);

CREATE TABLE prices (
    tdate DATE,
    symbol TEXT,
    open FLOAT,
    close FLOAT,
    low FLOAT,
    high FLOAT,
    volume INTEGER
);

\COPY securities FROM 'securities.csv' DELIMITER ',' CSV;
\COPY fundamentals FROM 'fundamentals.csv' DELIMITER ',' CSV;
\COPY prices FROM 'prices.csv' DELIMITER ',' CSV;
    
\pset footer off
\echo '\n'


-- Get last business (trading) day of the year for each year (the last day we have data for in the data set).
CREATE TEMP TABLE partitioned_dates AS
SELECT 
    tdate, 
    ROW_NUMBER() OVER (PARTITION BY DATE_TRUNC('year', tdate) ORDER BY tdate DESC) AS num
    -- could use LAST_VALUE() or FIRST_VALUE() here ...
FROM prices
WHERE symbol LIKE 'A%'  -- Speedup hack - don't need to check every single symbol. (30ms vs 371ms)
;


-- Set up list of last TRADING DAY of year (not last DAY - last TRADING DAY - that's IN the DATA !).
CREATE TEMP TABLE year_ends AS
SELECT tdate AS year_ends
FROM partitioned_dates
WHERE num = 1
ORDER BY tdate DESC
;


-- View them - check it:
-- SELECT * FROM year_ends;


-- Get the stock year ending prices:
CREATE TEMP TABLE year_end_prices AS
SELECT 
    symbol, tdate, close
FROM
    prices
WHERE tdate IN 
    (SELECT * FROM year_ends)
ORDER BY symbol, tdate DESC
;

-- SELECT * FROM year_end_prices;

-- SELECT * FROM top_companies;


-- Queries to find the commonalities of the top companies


SELECT 
    a.company,
    b.year,
    (b.total_assets - b.total_liabilities) AS net_worth
FROM
    top_companies a
    INNER JOIN fundamentals b
    USING(symbol)
ORDER BY net_worth DESC;

SELECT
    company,
    year AS sales_year,
    net_income AS current_year_income,
    LAG(net_income,1,0::double precision) OVER (PARTITION BY company ORDER BY year) AS previous_year_income,
    (net_income - LAG(net_income,1,0::double precision) OVER (PARTITION BY company ORDER BY year)) AS income_change
FROM
    fundamentals
    INNER JOIN securities
    USING(symbol)
WHERE company IN (SELECT company FROM top_companies);
    
SELECT
    company,
    year AS sales_year,
    total_revenue AS current_year_revenue,
    LAG(total_revenue,1,0::double precision) OVER (PARTITION BY company ORDER BY year) AS previous_year_revenue,
    (total_revenue - LAG(total_revenue,1,0::double precision) OVER (PARTITION BY company ORDER BY year)) AS revenue_change
FROM
    fundamentals
    INNER JOIN securities
    USING(symbol)
WHERE company IN (SELECT company FROM top_companies);

SELECT
    company,
    year AS sales_year,
    earnings_per_share AS current_year_earnings_per_share,
    LAG(earnings_per_share,1,0::double precision) OVER (PARTITION BY company ORDER BY year) AS previous_year_earnings_per_share,
    (earnings_per_share - LAG(earnings_per_share,1,0::double precision) OVER (PARTITION BY company ORDER BY year)) AS earnings_per_share_change
FROM
    fundamentals
    INNER JOIN securities
    USING(symbol)
WHERE company IN (SELECT company FROM top_companies);

SELECT
    c.company,
    b.year,
    a.tdate,
    a.close AS share_price,
    b.earnings_per_share,
    (a.close / b.earnings_per_share) AS price_to_earnings_ratio
FROM year_end_prices a
    INNER JOIN fundamentals b
    USING(symbol)
    INNER JOIN securities c
    USING(symbol)
WHERE EXTRACT(YEAR FROM tdate) = year AND c.company IN (SELECT company FROM top_companies);

SELECT
    a.company,
    b.year,
    b.cash_and_cash_equivalents,
    b.total_liabilities,
    (b.cash_and_cash_equivalents - b.total_liabilities) AS total
FROM securities a
    INNER JOIN fundamentals b
    USING (symbol)
WHERE a.company IN (SELECT company FROM top_companies);


-- Queries to find the companies that share the commonalities of the top companies (From the list of all companies)


SELECT 
    a.company,
    b.year,
    (b.total_assets - b.total_liabilities) AS net_worth
FROM
    securities a
    INNER JOIN fundamentals b
    USING(symbol)
WHERE b.year = '2016' AND (b.total_assets - b.total_liabilities) > 77259000    
ORDER BY net_worth DESC;

SELECT
    company,
    year AS sales_year,
    net_income AS current_year_income,
    LAG(net_income,1,0::double precision) OVER (PARTITION BY company ORDER BY year) AS previous_year_income,
    (net_income - LAG(net_income,1,0::double precision) OVER (PARTITION BY company ORDER BY year)) AS income_change
FROM
    fundamentals
    INNER JOIN securities
    USING(symbol)
WHERE year IN (2015,2016)
ORDER BY income_change DESC;

SELECT
    b.company,
    a.year AS sales_year,
    a.total_revenue AS current_year_revenue,
    LAG(a.total_revenue,1,0::double precision) OVER (PARTITION BY b.company ORDER BY a.year) AS previous_year_revenue,
    (a.total_revenue - LAG(a.total_revenue,1,0::double precision) OVER (PARTITION BY b.company ORDER BY a.year)) AS revenue_change
FROM
    fundamentals a
    INNER JOIN securities b
    USING(symbol)
WHERE year IN (2015,2016)
ORDER BY revenue_change DESC;

SELECT
    b.company,
    a.year AS sales_year,
    a.earnings_per_share AS current_year_earnings_per_share,
    LAG(a.earnings_per_share,1,0::double precision) OVER (PARTITION BY b.company ORDER BY a.year) AS previous_year_earnings_per_share,
    (a.earnings_per_share - LAG(a.earnings_per_share,1,0::double precision) OVER (PARTITION BY b.company ORDER BY a.year)) AS earnings_per_share_change
FROM
    fundamentals a
    INNER JOIN securities b
    USING(symbol)
WHERE year IN (2015,2016)
ORDER BY earnings_per_share_change DESC;

SELECT
    c.company,
    b.year,
    a.tdate,
    a.close AS share_price,
    b.earnings_per_share,
    (a.close / b.earnings_per_share) AS price_to_earnings_ratio
FROM year_end_prices a
    INNER JOIN fundamentals b
    USING(symbol)
    INNER JOIN securities c
    USING(symbol)
WHERE EXTRACT(YEAR FROM tdate) = year AND year = '2016'
ORDER BY price_to_earnings_ratio ASC;

SELECT
    a.company,
    b.year,
    b.cash_and_cash_equivalents,
    b.total_liabilities,
    (b.cash_and_cash_equivalents - b.total_liabilities) AS total
FROM securities a
    INNER JOIN fundamentals b
    USING (symbol)
WHERE year = '2016'
ORDER BY total DESC;


-- SELECT * FROM securities WHERE company IN ('The Walt Disney Company', 'QUALCOMM Inc.', 'FedEx Corporation', 'McKesson Corp.', 'Becton Dickinson', 'Applied Materials Inc', 'JM Smucker', 'D. R. Horton', 'News Corp. Class A', 'Constellation Brands');


-- Queries to find exact numbers of choosen companies


SELECT 
    a.company,
    b.year,
    (b.total_assets - b.total_liabilities) AS net_worth
FROM
    securities a
    INNER JOIN fundamentals b
    USING(symbol)
WHERE company IN ('The Walt Disney Company', 'QUALCOMM Inc.', 'FedEx Corporation', 'McKesson Corp.', 'Becton Dickinson', 'Applied Materials Inc', 'JM Smucker', 'D. R. Horton', 'News Corp. Class A', 'Constellation Brands') AND b.year = '2016' AND (b.total_assets - b.total_liabilities) > 77259000   
ORDER BY net_worth DESC;

SELECT
    company,
    year AS sales_year,
    net_income AS current_year_income,
    LAG(net_income,1,0::double precision) OVER (PARTITION BY company ORDER BY year) AS previous_year_income,
    (net_income - LAG(net_income,1,0::double precision) OVER (PARTITION BY company ORDER BY year)) AS income_change
FROM
    fundamentals
    INNER JOIN securities
    USING(symbol)
WHERE company IN ('The Walt Disney Company', 'QUALCOMM Inc.', 'FedEx Corporation', 'McKesson Corp.', 'Becton Dickinson', 'Applied Materials Inc', 'JM Smucker', 'D. R. Horton', 'News Corp. Class A', 'Constellation Brands') AND year IN (2015,2016)
ORDER BY income_change DESC;

SELECT
    b.company,
    a.year AS sales_year,
    a.total_revenue AS current_year_revenue,
    LAG(a.total_revenue,1,0::double precision) OVER (PARTITION BY b.company ORDER BY a.year) AS previous_year_revenue,
    (a.total_revenue - LAG(a.total_revenue,1,0::double precision) OVER (PARTITION BY b.company ORDER BY a.year)) AS revenue_change
FROM
    fundamentals a
    INNER JOIN securities b
    USING(symbol)
WHERE company IN ('The Walt Disney Company', 'QUALCOMM Inc.', 'FedEx Corporation', 'McKesson Corp.', 'Becton Dickinson', 'Applied Materials Inc', 'JM Smucker', 'D. R. Horton', 'News Corp. Class A', 'Constellation Brands') AND year IN (2015,2016)
ORDER BY revenue_change DESC;

SELECT
    b.company,
    a.year AS sales_year,
    a.earnings_per_share AS current_year_earnings_per_share,
    LAG(a.earnings_per_share,1,0::double precision) OVER (PARTITION BY b.company ORDER BY a.year) AS previous_year_earnings_per_share,
    (a.earnings_per_share - LAG(a.earnings_per_share,1,0::double precision) OVER (PARTITION BY b.company ORDER BY a.year)) AS earnings_per_share_change
FROM
    fundamentals a
    INNER JOIN securities b
    USING(symbol)
WHERE company IN ('The Walt Disney Company', 'QUALCOMM Inc.', 'FedEx Corporation', 'McKesson Corp.', 'Becton Dickinson', 'Applied Materials Inc', 'JM Smucker', 'D. R. Horton', 'News Corp. Class A', 'Constellation Brands') AND year IN (2015,2016)
ORDER BY earnings_per_share_change DESC;

SELECT
    c.company,
    b.year,
    a.tdate,
    a.close AS share_price,
    b.earnings_per_share,
    (a.close / b.earnings_per_share) AS price_to_earnings_ratio
FROM year_end_prices a
    INNER JOIN fundamentals b
    USING(symbol)
    INNER JOIN securities c
    USING(symbol)
WHERE EXTRACT(YEAR FROM tdate) = year AND year = '2016' AND company IN ('The Walt Disney Company', 'QUALCOMM Inc.', 'FedEx Corporation', 'McKesson Corp.', 'Becton Dickinson', 'Applied Materials Inc', 'JM Smucker', 'D. R. Horton', 'News Corp. Class A', 'Constellation Brands')
ORDER BY price_to_earnings_ratio ASC;

SELECT
    a.company,
    b.year,
    b.cash_and_cash_equivalents,
    b.total_liabilities,
    (b.cash_and_cash_equivalents - b.total_liabilities) AS total
FROM securities a
    INNER JOIN fundamentals b
    USING (symbol)
WHERE company IN ('The Walt Disney Company', 'QUALCOMM Inc.', 'FedEx Corporation', 'McKesson Corp.', 'Becton Dickinson', 'Applied Materials Inc', 'JM Smucker', 'D. R. Horton', 'News Corp. Class A', 'Constellation Brands') AND year = '2016'
ORDER BY total DESC;

CREATE TEMP TABLE final_choices AS