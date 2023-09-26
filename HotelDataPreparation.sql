--Checking the Data
SELECT *
FROM Project_BI..['2018$']

SELECT *
FROM Project_BI..['2019$']

SELECT *
FROM Project_BI..['2020$']


--Forming a union to append the data
SELECT *
FROM Project_BI..['2018$']
UNION
SELECT *
FROM Project_BI..['2019$']
UNION
SELECT *
FROM Project_BI..['2020$']
ORDER BY adr
--Using a CTE for the union querry
WITH Hotels AS (
SELECT *
FROM Project_BI..['2018$']
UNION
SELECT *
FROM Project_BI..['2019$']
UNION
SELECT *
FROM Project_BI..['2020$']
) 

SELECT *
FROM Hotels

--Get revenue from weeknights and weekend nights by year
WITH Hotels AS (
SELECT *
FROM Project_BI..['2018$']
UNION
SELECT *
FROM Project_BI..['2019$']
UNION
SELECT *
FROM Project_BI..['2020$']
) 

SELECT arrival_date_year,
     SUM ((stays_in_week_nights+stays_in_weekend_nights)*adr) AS Revenue
FROM Hotels
GROUP BY arrival_date_year

--Get revenue by year and hotel
WITH Hotels AS (
SELECT *
FROM Project_BI..['2018$']
UNION
SELECT *
FROM Project_BI..['2019$']
UNION
SELECT *
FROM Project_BI..['2020$']
) 

SELECT arrival_date_year, 
       hotel,
     ROUND(SUM ((stays_in_week_nights+stays_in_weekend_nights)*adr),2) AS Revenue
FROM Hotels
GROUP BY arrival_date_year,hotel
ORDER BY hotel

--Join with market segments to prepare for calculation of discounts

WITH Hotels AS (
SELECT *
FROM Project_BI..['2018$']
UNION
SELECT *
FROM Project_BI..['2019$']
UNION
SELECT *
FROM Project_BI..['2020$']
) 

SELECT*  
FROM Hotels
LEFT JOIN Project_BI..market_segment$
      ON Hotels.market_segment = Project_BI..market_segment$.market_segment

--include meals
LEFT JOIN Project_BI..meal_cost$
      ON Hotels.meal = Project_BI..meal_cost$.meal