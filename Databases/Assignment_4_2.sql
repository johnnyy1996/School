-- SELECT * FROM fundamentals LIMIT 5;
-- SELECT * FROM prices LIMIT 5;
-- SELECT * FROM securities LIMIT 5;

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
DROP TABLE IF EXISTS top_companies;

CREATE TABLE top_companies AS
SELECT 
    company,
    symbol,
    pct_return
        FROM
            (SELECT
                company,
                symbol,
                pct_return,
                ROW_NUMBER() OVER (PARTITION BY company ORDER BY pct_return DESC) AS num
            FROM annual_returns
                INNER JOIN securities
                    using(symbol)
            WHERE pct_return IS NOT NULL) a
WHERE num = 1
ORDER BY pct_return DESC
LIMIT 45;

SELECT * FROM top_companies;