-- pg_dump -U postgres -t securities -t fundamentals -t prices > backup.sql
-- pg_dump -U postgres -t top_companies > backup.sql
-- pg_dump -U postgres -t final_choices > backup.sql
-- psql -U postgres -f backup.sql

\pset footer off
\echo '\n'

CREATE TEMP TABLE partitioned_dates AS
SELECT
    tdate,
    ROW_NUMBER() OVER (PARTITION BY DATE_TRUNC('year', tdate) ORDER BY tdate DESC) AS num
FROM prices
WHERE symbol = 'A';

-- SELECT * FROM partitioned_dates;

CREATE TEMP TABLE year_ends AS
SELECT 
    tdate AS year_ends
FROM partitioned_dates
WHERE num = 1
ORDER BY tdate DESC;

-- SELECT * FROM year_ends;

CREATE TEMP TABLE year_end_prices AS
SELECT
    symbol, tdate, close
FROM
    prices
WHERE tdate IN
    (SELECT * FROM year_ends)
ORDER BY symbol, tdate DESC;

-- SELECT * FROM year_end_prices;

CREATE TEMP TABLE annual_returns AS
SELECT
    symbol,
    tdate,
    close,
    LEAD(close) OVER (PARTITION BY symbol ORDER BY tdate DESC) AS last_year_close,
    (close / (LEAD(close) OVER (PARTITION BY symbol ORDER BY tdate DESC)) - 1)::NUMERIC(10, 4) AS pct_return
FROM year_end_prices;

-- SELECT * FROM annual_returns;

CREATE VIEW portfolio AS
SELECT
    c.company,
    c.symbol,
    b.id,
    c.sector,
    a.tdate,
    a.close AS price,
    b.gross_margin,
    b.net_income,
    b.total_assets,
    b.total_liabilities,
    b.earnings_per_share
FROM year_end_prices a
    INNER JOIN fundamentals b
    USING(symbol)
    INNER JOIN securities c
    USING(symbol)
WHERE c.company IN ('The Walt Disney Company', 'QUALCOMM Inc.', 'FedEx Corporation', 'McKesson Corp.', 'Becton Dickinson', 'Applied Materials Inc', 'JM Smucker', 'D. R. Horton', 'News Corp. Class A', 'Constellation Brands') AND EXTRACT(YEAR FROM tdate) = year AND year = '2016';

SELECT * FROM portfolio;

-- psql -U postgres -tAF, -f Assignment_6.sql > output_file.csv

-- 2017 closing prices and percent return

--                      Closing Prices      Percent Return

-- Applied Materials Inc    51.12           58%
-- Becton Dickinson         214.06          29%
-- D. R. Horton             51.07           87%
-- The Walt Disney Company  107.51          3%
-- FedEx Corporation        249.54          34%
-- McKesson Corp.           155.95          11%
-- News Corp. Class A       16.21           41%
-- QUALCOMM Inc.            64.02           -2%
-- JM Smucker               124.24          -3%
-- Constellation Brands     228.57          49%

-- Total Return: 24%