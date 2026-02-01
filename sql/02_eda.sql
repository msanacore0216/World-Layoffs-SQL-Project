/* =========================================================
   Exploratory Data Analysis – Layoffs Dataset
   ========================================================= */

-- Exploratory Data Analysis

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Ranking Top 5 Companies in Total Layoffs by Year

SELECT *
FROM layoffs_staging2;

SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

SELECT company, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2
WHERE company = 'Blackbaud';

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

SELECT company, YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`),  SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_Year_Rank AS
(SELECT *, 
DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_Year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_Year_Rank
WHERE Ranking <= 5;

SELECT *
FROM layoffs_staging2
WHERE company = 'Swiggy';

-- Pandemic Effects on Industries

SELECT industry, YEAR(`date`) AS `year`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE industry IS NOT NULL AND YEAR(`date`) IS NOT NULL
GROUP BY industry, `year`
ORDER BY `year`, total_off DESC;

WITH industry_year AS 
(
SELECT industry, YEAR(`date`) AS `year`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE industry IS NOT NULL AND YEAR(`date`) IS NOT NULL
GROUP BY industry, `year`
ORDER BY `year`, total_off DESC
), industry_year_rank AS
(
SELECT *, 
DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_off DESC) AS ranking
FROM industry_year
)
SELECT *
FROM industry_year_rank
WHERE ranking <= 15;

WITH industry_year AS 
(
SELECT industry, YEAR(`date`) AS `year`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE industry IS NOT NULL AND YEAR(`date`) IS NOT NULL
GROUP BY industry, `year`
ORDER BY `year`, total_off DESC
), industry_year_rank AS
(
SELECT *, 
DENSE_RANK() OVER(PARTITION BY `year` ORDER BY total_off DESC) AS ranking
FROM industry_year
), industry_year_top10 AS
(
SELECT *
FROM industry_year_rank
WHERE ranking <= 10
)
SELECT *
FROM industry_year_top10
ORDER BY industry, `year`;

WITH industry_overall AS
(
SELECT industry, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE industry IS NOT NULL AND YEAR(`date`) IS NOT NULL
GROUP BY industry
ORDER BY total_off DESC
)
SELECT *,
DENSE_RANK() OVER(ORDER BY total_off DESC) AS ranking
FROM industry_overall;

-- Seasonality Exploration

SELECT *
FROM layoffs_staging2;

SELECT industry, SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE industry IS NOT NULL AND MONTH(`date`) IS NOT NULL AND industry = 'Consumer'
GROUP BY industry, `month`
ORDER BY `month`, total_off DESC;

SELECT SUBSTRING(`date`,1,7) AS `month`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `month`
ORDER BY `month`, total_off DESC;

SELECT industry, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY SUM(total_laid_off) DESC;

-- Overall Layoffs Over Time

SELECT YEAR(`date`) AS 'Year', 
	MONTH(`date`) AS 'Month',
    SUM(total_laid_off) AS total_layoffs,
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`), MONTH(`date`)
ORDER BY YEAR(`date`), MONTH(`date`);

WITH layoffs_over_time AS (
SELECT YEAR(`date`) AS 'Year', 
	MONTH(`date`) AS 'Month',
    SUM(total_laid_off) AS total_layoffs,
    COUNT(`date`) AS layoff_events,
    AVG(percentage_laid_off) AS percentage
FROM layoffs_staging2
WHERE YEAR(`date`) IS NOT NULL
GROUP BY YEAR(`date`), MONTH(`date`)
ORDER BY YEAR(`date`), MONTH(`date`)
)
SELECT `Year`,
	`Month`,
	CASE
		WHEN `Month` BETWEEN 1 AND 3 THEN 'Q1'
        WHEN `Month` BETWEEN 4 AND 6 THEN 'Q2'
        WHEN `Month` BETWEEN 7 AND 9 THEN 'Q3'
        ELSE 'Q4'
    END AS 'Quarter',
    total_layoffs,
    layoff_events,
    ROUND(percentage, 2)
FROM layoffs_over_time;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL
ORDER BY `date`;

SELECT *, (total_laid_off/percentage_laid_off)
FROM layoffs_staging2
WHERE company = 'EasyPost'
ORDER BY `date`;

SELECT *
FROM Overall_Time_based_View;

-- Company-Level Analysis

SELECT DENSE_RANK() OVER(ORDER BY SUM(total_laid_off) DESC) AS layoff_rank,
    company,
    COUNT(*) AS layoff_events,
    SUM(total_laid_off) AS total_layoffs,
    ROUND(AVG(percentage_laid_off),2) AS avg_percentage,
    MAX(percentage_laid_off) AS max_pct_laid_off,
    MIN(`date`) AS first_layoff_date,
    MAX(`date`) AS last_layoff_date,
    DATEDIFF(MAX(`date`), MIN(`date`)) AS layoff_duration_days
FROM layoffs_staging2
GROUP BY company
ORDER BY total_layoffs DESC;

WITH company_analysis AS (
SELECT DENSE_RANK() OVER(ORDER BY SUM(total_laid_off) DESC) AS layoff_rank,
    company,
    COUNT(*) AS layoff_events,
    SUM(total_laid_off) AS total_layoffs,
    ROUND(AVG(percentage_laid_off),2) AS avg_percentage,
    MAX(percentage_laid_off) AS max_pct_laid_off,
    MIN(`date`) AS first_layoff_date,
    MAX(`date`) AS last_layoff_date,
    DATEDIFF(MAX(`date`), MIN(`date`)) AS layoff_duration_days
FROM layoffs_staging2
GROUP BY company
ORDER BY total_layoffs DESC
)
SELECT *
FROM company_analysis
WHERE layoff_events > 1;
