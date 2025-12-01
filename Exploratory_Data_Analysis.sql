-- Global Layoffs Analysis (2020-2024)

SELECT *
FROM layoffs_staging2;

-- Asses layoff severity metrics
-- Purpose: Identify maximum layoff values to understand the scale of workforce reductions
SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

-- Identify complete company shutdowns
-- Purpose: Find companies with 100% reduction in workforce
SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Top companies by total layoffs (all-time)
-- Purpose: Identify which organizations had the highest cumulative workforce reductions
SELECT company, SUM(total_laid_off) AS total_employees_laid_off
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- Time range validation
-- Purpose: Understand the date range of available data 
SELECT 
	MIN(`date`) AS earliest_layoff_date,
	MAX(`date`) AS latest_layoff_date
FROM layoffs_staging2;

-- Annual layoff trends
-- Purpose: Analyze year-over-year layoff volumes to identify crisis periods
-- Business Insight: Helps identify economic downturns and recovery periods
SELECT 
    YEAR(`date`) AS layoff_year,
    SUM(total_laid_off) AS total_employees_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY layoff_year DESC;

-- Monthly layoff aggregation
-- Purpose: Granular time-series data for trend analysis and seasonality detection
SELECT 
    SUBSTRING(`date`, 1, 7) AS layoff_month,
    SUM(total_laid_off) AS monthly_layoffs
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
GROUP BY layoff_month
ORDER BY layoff_month ASC;

-- Cumulative layoff trend (rolling total)
-- Purpose: Calculate running total of layoffs to visualize cumulative impact over time
WITH Rolling_Total AS (
    SELECT 
        SUBSTRING(`date`, 1, 7) AS layoff_month,
        SUM(total_laid_off) AS monthly_layoffs
    FROM layoffs_staging2
    WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
    GROUP BY layoff_month
    ORDER BY layoff_month ASC
)
SELECT 
    layoff_month,
    monthly_layoffs,
    SUM(monthly_layoffs) OVER(ORDER BY layoff_month) AS cumulative_layoffs
FROM Rolling_Total;


-- Layoffs by industry sector
-- Purpose: Identify which industries were hit hardest by workforce reductions
SELECT 
    industry,
    SUM(total_laid_off) AS total_employees_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_employees_laid_off DESC;

-- Layoffs by country
-- Purpose: Geographic distribution of layoffs for international comparison
SELECT 
    country,
    SUM(total_laid_off) AS total_employees_laid_off
FROM layoffs_staging2
GROUP BY country
ORDER BY total_employees_laid_off DESC;

-- Top 5 companies by layoffs per year
WITH Company_Year AS (
    SELECT 
        company,
        YEAR(`date`) AS layoff_year,
        SUM(total_laid_off) AS total_employees_laid_off
    FROM layoffs_staging2
    GROUP BY company, YEAR(`date`)
), 
Company_Year_Rank AS (
    SELECT 
        company,
        layoff_year,
        total_employees_laid_off,
        DENSE_RANK() OVER (
            PARTITION BY layoff_year 
            ORDER BY total_employees_laid_off DESC
        ) AS yearly_rank
    FROM Company_Year
    WHERE layoff_year IS NOT NULL
)
SELECT 
    layoff_year,
    yearly_rank,
    company,
    total_employees_laid_off
FROM Company_Year_Rank
WHERE yearly_rank <= 5
ORDER BY layoff_year DESC, yearly_rank ASC;

-- Companies with multiple layoff events
-- Purpose: Identify companies with recurring workforce issues
SELECT 
    company,
    COUNT(*) AS num_layoff_events,
    SUM(total_laid_off) AS total_employees_laid_off,
    MIN(`date`) AS first_layoff_date,
    MAX(`date`) AS most_recent_layoff_date,
    DATEDIFF(MAX(`date`), MIN(`date`)) AS days_between_first_and_last
FROM layoffs_staging2
WHERE company IS NOT NULL
GROUP BY company
HAVING COUNT(*) >= 3  -- At least 3 separate layoff events
ORDER BY num_layoff_events DESC, total_employees_laid_off DESC;

-- Layoff patterns by company funding stage
-- Purpose: Analyze if startups vs. established companies laid off more
SELECT 
    stage,
    COUNT(DISTINCT company) AS num_companies_affected,
    SUM(total_laid_off) AS total_employees_laid_off,
    ROUND(AVG(total_laid_off), 0) AS avg_layoffs_per_event,
    ROUND(AVG(percentage_laid_off) * 100, 1) AS avg_percentage_laid_off
FROM layoffs_staging2
WHERE stage IS NOT NULL
GROUP BY stage
ORDER BY total_employees_laid_off DESC;
