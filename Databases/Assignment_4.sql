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
    