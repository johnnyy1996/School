DROP TABLE IF EXISTS companies_8;

CREATE TABLE companies_8(
ID INTEGER NOT NULL,
INDUSTRIAL_RISK TEXT NOT NULL,
MANAGEMENT_RISK TEXT NOT NULL,
FINANCIAL_FLEXIBILITY TEXT NOT NULL,
CREDIBILITY TEXT NOT NULL,
COMPETITIVENESS TEXT NOT NULL,
OPERATING_RISK TEXT NOT NULL,
CLASS TEXT NOT NULL
);

\COPY companies_8 FROM './ids.csv' DELIMITER ',' CSV;

-- SELECT * FROM companies_8;

/*
CREATE TABLE scores AS
SELECT 
    id,
    symbol,
    class
        FROM
            (SELECT
                id,
                SUM(CASE WHEN INDUSTRIAL_RISK='N' THEN 1.0 ELSE 0.0 + CASE WHEN MANAGEMENT_RISK='N' THEN 1.0 ELSE 0.0 +CASE WHEN FINANCIAL_FLEXIBILITY='N' THEN 1.0 ELSE 0.0 + CASE WHEN CREDIBILITY='N' THEN 1.0 ELSE 0.0 + CASE WHEN COMPETITIVENESS='N' THEN 1.0 ELSE 0.0 + CASE WHEN OPERATING_RISK='N' THEN 1.0 ELSE 0.0 END) AS total_score
             FROM companies_8) a
WHERE num = 1
ORDER BY pct_return DESC
LIMIT 45;
*/
CREATE TEMP TABLE scores AS
SELECT
    ID,
    SUM((CASE WHEN INDUSTRIAL_RISK='N' THEN 1.0 ELSE 0.0 END) + (CASE WHEN MANAGEMENT_RISK='N' THEN 1.0 ELSE 0.0 END) + (CASE WHEN FINANCIAL_FLEXIBILITY='N' THEN 1.0 ELSE 0.0 END) + (CASE WHEN CREDIBILITY='N' THEN 1.0 ELSE 0.0 END) + (CASE WHEN COMPETITIVENESS='N' THEN 1.0 ELSE 0.0 END) + (CASE WHEN OPERATING_RISK='N' THEN 1.0 ELSE 0.0 END)) AS risk_score,
    CLASS
FROM companies_8
GROUP BY id, class
ORDER BY id;

-- SELECT * FROM scores;

CREATE TEMP TABLE risk_levels AS
SELECT
    ID,
    risk_score,
    CLASS,
    CASE WHEN risk_score <= 2 THEN 'Low'
         WHEN risk_score < 4 THEN 'Medium'
         WHEN risk_score < 5 THEN 'Med-High'
         WHEN risk_score >= 5 THEN 'High'
    END AS RISK_LEVEL
FROM scores
GROUP BY id, class, risk_score
ORDER BY id;
    
-- SELECT * FROM risk_levels; 

-- Report the number of companies at each risk level from the bankrupt group
SELECT
    RISK_LEVEL,
    COUNT(*) AS total_class_b
FROM risk_levels
WHERE CLASS = 'B'
GROUP BY RISK_LEVEL;

-- Report the number of companies at each risk level from the non-bankrupt group
SELECT
    RISK_LEVEL,
    COUNT(*) AS total_class_nb
FROM risk_levels
WHERE CLASS = 'NB'
GROUP BY RISK_LEVEL;

-- Make a report of currently operating companies that are at a risk level of 'Medium' or higher.
SELECT 
    *
FROM risk_levels
WHERE risk_level IN ('Medium', 'Med-High', 'High') AND CLASS = 'NB'
ORDER BY risk_level DESC;