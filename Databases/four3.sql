CREATE TEMP TABLE annual_return AS
SELECT 
    symbol,
    date,
    open,
    close,
    ((close/open) - 1) AS pct_return
FROM
    prices
ORDER BY pct_return DESC;

CREATE TEMP TABLE top_companies AS
SELECT
    symbol,
    pct_return
FROM
    annual_return
WHERE symbol IN
    (SELECT symbol FROM securities)
ORDER BY pct_return DESC
LIMIT 45;

select * from top_companies;