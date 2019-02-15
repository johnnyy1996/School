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
SELECT * FROM year_ends;


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


-- One way to perform the annual return calc: (create this as a table to keep!).
CREATE TEMP TABLE annual_returns AS
SELECT 
    symbol, 
    tdate,
    close,
    LEAD(close) OVER (PARTITION BY symbol ORDER BY tdate DESC) AS last_yr_close, -- Not really necessary - just to view
    (close / (LEAD(close) OVER (PARTITION BY symbol ORDER BY tdate DESC)))::NUMERIC(10, 4) AS pct_return
FROM 
    year_end_prices
;


-- Voila!  The final thing we're looking for:
-- (now you have to make a decision as to which ones to keep).
SELECT
    * 
FROM 
    annual_returns
WHERE 
    pct_return IS NOT NULL
ORDER BY 
    pct_return DESC
LIMIT 
   70
OFFSET 10
;
