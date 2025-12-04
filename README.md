## Global Layoffs Analysis Dashboard 

**Project Overview**

This project analyzes layoffs data to identify trends and patterns in workforce reductions. The dataset covers the period from 2020 to 2024.

Workflow:
- Data Cleaning 
- Exploratory Analysis 
- Data Visualization 
- Business Insights & Recommendations


[Global Layoffs Dataset Source](https://www.kaggle.com/datasets/theakhilb/layoffs-data-2022)

**Data Overview**


The dataset contains records of layoff events across multiple companies and industries worldwide. 

Each record represents a specific layoff event, industry sector, geographic location, number of employees laid off, percentage of workforce affected, and the date of the layoff announcement.

Data cleaning was done to:

- Remove duplicate layoff records
- Standardize company names and industry categories
- Validate date formats and numeric fields

**Key Questions**

- Which industries were most vulnerable?
- How did layoffs trend over time?
- Where were layoffs concentrated geographically?
- Which companies led workforce reductions?
- How can job seekers, investors, and business leaders use these insights to navigate uncertainty?

**Steps Taken**

1. Data Cleaning (SQL):

- Removed blanks & duplicates
- Standardized company names and industry categories
- Validated date formats and numeric fields

2. SQL Analysis
    While a full EDA was done in SQL, we will highlight only the queries done to find insights on the key questions: 
```sql
-- Layoffs by industry sector
-- Purpose: Identify which industries were hit hardest by workforce reductions
SELECT 
    industry,
    SUM(total_laid_off) AS total_employees_laid_off
FROM layoffs_staging2
GROUP BY industry
ORDER BY total_employees_laid_off DESC;
 ```

```sql
-- Industry with highest percentage laid off
   SELECT industry, AVG(percentage_laid_off) AS avg_percentage
   FROM layoffs_staging2
   WHERE percentage_laid_off IS NOT NULL
   GROUP BY industry
   ORDER BY avg_percentage DESC;
 ```

```sql
-- Annual layoff trends
-- Purpose: Analyze year-over-year layoff volumes to identify crisis periods
-- Business Insight: Helps identify economic downturns and recovery periods
SELECT 
    YEAR(`date`) AS layoff_year,
    SUM(total_laid_off) AS total_employees_laid_off
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY layoff_year DESC;
 ```

```sql
-- Top companies by total layoffs
   SELECT company, SUM(total_laid_off) AS total_layoffs
   FROM layoffs_staging2
   WHERE total_laid_off IS NOT NULL
   GROUP BY company
   ORDER BY total_layoffs DESC
   LIMIT 10;
 ```

**Tableau Dashboard**

Created an interactive dashboard:

![Image Alt](https://github.com/computershy/Air-Quality/blob/main/Layoffs.png)

**Key Insights**

- Retail Leads in Volume: Retail experienced the highest amount of total layoffs, indicating widespread restructuring in consumer-facing roles.
- Food industry Hit Hardest Proportionally: Food had the highest average percentage of workforce laid off which could suggest that deeper cuts were made relative to company size.
- 2023 Was the Peak Year: 2023 saw the highest total laid off.
- Geographic Concentration: USA led in total layoffs, with India second.
- Big Tech Drives Numbers: Amazon, Meta, and Tesla topped the list, showing how major employers have set trends concerning layoffs.

**Business Recommendations**

- For Job Seekers: Broaden your skill set and explore fields that tend to be more stable.
- For Companies: The U.S. labor market reacts strongly to economic changes. Plan your staffing with that in mind.
- For Analysts: Track both raw numbers and percentage changes to fully understand industry trends.


