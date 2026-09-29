Create database CRM_Analytics;
use CRM_Analytics;


SELECT * FROM crm_analytics.account;
SELECT * FROM crm_analytics.opportunity;
SELECT * FROM crm_analytics.lead;
SELECT * FROM crm_analytics.user;
SELECT * FROM crm_analytics.opportunity_product;


-- OPPORTUNITIES KPIS
-- TOTAL EXPECTED AMOUNT  KPI 1
SELECT 
    ROUND(SUM(`Expected Amount`), 2) AS Expected_Amount
FROM Opportunity
WHERE `Deleted` = FALSE;

-- Active Opportunities  KPI 2

SELECT 
    COUNT(`Opportunity ID`) AS Active_Opportunities
FROM Opportunity
WHERE `Closed` = FALSE
  AND `Deleted` = FALSE;
  
  -- Conversion Rate  KPI 3
  
  SELECT 
    ROUND(
        SUM(CASE WHEN `Won` = TRUE THEN 1 ELSE 0 END)
        * 100.0 / COUNT(*)
    , 2) AS Conversion_Rate
FROM Opportunity
WHERE `Deleted` = FALSE;

-- Win Rate  KPI 4

SELECT 
    ROUND(
        SUM(CASE WHEN `Stage` = 'Closed Won' THEN 1 ELSE 0 END)
        * 100.0 /
        NULLIF(
            SUM(CASE WHEN `Stage` IN ('Closed Won', 'Closed Lost') THEN 1 ELSE 0 END),
            0
        )
    , 2) AS Win_Rate
FROM Opportunity
WHERE `Deleted` = FALSE;

-- Loss Rate KPI 5

SELECT 
    ROUND(
        SUM(CASE WHEN `Stage` = 'Closed Lost' THEN 1 ELSE 0 END)
        * 100.0 / COUNT(`Opportunity ID`)
    , 2) AS Loss_Rate
FROM Opportunity
WHERE `Deleted` = FALSE;

-- Trend Analysis KPI 6

SELECT 
    `Forecast Category`,
    COUNT(*) AS Opportunity_Count
FROM Opportunity
WHERE `Deleted` = FALSE
GROUP BY `Forecast Category`
ORDER BY Opportunity_Count DESC;

-- Active vs Total Opportunities Trend  KPI 7

SELECT
    DATE_FORMAT(`Created Date`, '%Y-%m') AS Month,

    COUNT(*) AS Total_Opportunities,

    SUM(
        CASE 
            WHEN `Closed` = FALSE THEN 1
            ELSE 0
        END
    ) AS Active_Opportunities

FROM Opportunity
WHERE `Deleted` = FALSE

GROUP BY Month
ORDER BY Month;

-- Closed Won vs Total Opportunities KPI 8

SELECT
    DATE_FORMAT(`Created Date`, '%Y-%m') AS Month,

    COUNT(*) AS Total_Opportunities,

    SUM(
        CASE 
            WHEN `Won` = TRUE THEN 1
            ELSE 0
        END
    ) AS Closed_Won

FROM Opportunity
WHERE `Deleted` = FALSE

GROUP BY Month
ORDER BY Month;

-- Closed Won vs Total Closed KPI 9

SELECT
    DATE_FORMAT(`Created Date`, '%Y-%m') AS Month,

    SUM(
        CASE 
            WHEN `Closed` = TRUE THEN 1
            ELSE 0
        END
    ) AS Total_Closed,

    SUM(
        CASE 
            WHEN `Stage` = 'Closed Won' THEN 1
            ELSE 0
        END
    ) AS Closed_Won

FROM Opportunity
WHERE `Deleted` = FALSE

GROUP BY Month
ORDER BY Month;

-- Expected Amount by Opportunity Type

SELECT
    `Opportunity Type`,
    ROUND(SUM(`Expected Amount`), 2) AS Expected_Amount
FROM Opportunity
WHERE `Deleted` = FALSE
GROUP BY `Opportunity Type`
ORDER BY Expected_Amount DESC;

-- Opportunities by Industry KPI 8

SELECT
    `Industry`,
    COUNT(`Opportunity ID`) AS Opportunity_Count
FROM Opportunity
WHERE `Deleted` = FALSE
  AND `Industry` IS NOT NULL
  AND TRIM(`Industry`) <> ''
GROUP BY `Industry`
ORDER BY Opportunity_Count DESC;

-- LEAD KPIS

-- Total Lead KPI 1

SELECT
    COUNT(`Lead ID`) AS Total_Lead
FROM lead1
WHERE `Lead ID` IS NOT NULL;

-- Expected Amount from Converted Leads kpi 2

SELECT
    ROUND(SUM(o.`Expected Amount`), 2) AS Expected_Amount_From_Converted_Leads
FROM lead1 l
INNER JOIN Opportunity o
    ON l.`Converted Opportunity ID` = o.`Opportunity ID`
WHERE l.`Converted` = TRUE
  AND o.`Deleted` = FALSE;
  
-- Conversion Rate kpi 3

SELECT
    ROUND(
        SUM(CASE WHEN `Converted` = TRUE THEN 1 ELSE 0 END)
        * 100.0 / NULLIF(COUNT(`Lead ID`), 0),
        2
    ) AS Conversion_Rate
FROM lead1
WHERE `Lead ID` IS NOT NULL;

-- Converted Accounts kpi 4

SELECT
    COUNT(DISTINCT `Converted Account ID`) AS Converted_Accounts
FROM lead1
WHERE `Converted Account ID` IS NOT NULL;

-- Converted Opportunities kpi 5

SELECT
    COUNT(DISTINCT `Converted Opportunity ID`) AS Converted_Opportunities
FROM lead1
WHERE `Converted Opportunity ID` IS NOT NULL;

-- Leads by Source kpi 6

SELECT
    COALESCE(`Lead Source`, 'Unknown') AS Lead_Source,
    COUNT(`Lead ID`) AS Lead_Count
FROM Lead1
GROUP BY COALESCE(`Lead Source`, 'Unknown')
ORDER BY Lead_Count DESC;

-- Leads by Industry kpi 7

SELECT
    COALESCE(`Industry`, 'Unknown') AS Industry,
    COUNT(`Lead ID`) AS Lead_Count
FROM lead1
GROUP BY COALESCE(`Industry`, 'Unknown')
ORDER BY Lead_Count DESC;

-- Leads by Stage kpi8

SELECT
    COALESCE(`Status`, 'Unknown') AS Lead_Stage,
    COUNT(`Lead ID`) AS Lead_Count
FROM lead1
GROUP BY COALESCE(`Status`, 'Unknown')
ORDER BY Lead_Count DESC;








