## Global Layoffs Analysis Dashboard 

**Project Overview**

This project analyses a global layoffs dataset from Kaggle spanning 2020-2024, focusing on workforce reductions across industries, companies, and geographic regions. The goal is to understand which sectors were hit hardest, identify temporal trends in layoffs, and uncover patterns that reveal how different industries responded to economic pressures during this period. These insights could help job seekers, investors, and business strategists understand market dynamics and make informed decisions.

This project demonstrates an end-to-end data analysis workflow:

- Data Cleaning 
- Exploratory Analysis 
- Data Visualization 
- Business Insights & Recommendations


[Global Layoffs Dataset Source](https://www.kaggle.com/datasets/theakhilb/layoffs-data-2022)

**Data Structure Overview**

The dataset contains records of layoff events across multiple companies and industries worldwide.
Each record represents a specific layoff event, capturing details about the company, industry sector, geographic location, number of employees laid off, percentage of workforce affected, and the date of the layoff announcement.

With this data, we can identify which sectors faced the greatest challenges, track how layoff trends evolved year-over-year, and understand regional differences in workforce reductions.

Data cleaning was done to:

- Remove duplicate layoff records
- Standardize company names and industry categories
- Validate date formats and numeric fields

**Business Problem**

The 2020-2024 period saw unprecedented workforce volatility across industries. Key questions include:

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
   To answer business questions, I wrote some SQL queries:
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

Created an interactive dashboard with:

- KPI Cards: Total companies affected, top industry, peak layoff year
- Bar charts: Top N companies, industries, and countries by layoffs
- Line chart: Layoff trends over time (2020-2024)
- Clean, professional design for insightful communication

![Image Alt](https://github.com/computershy/Air-Quality/blob/main/Layoffs.png)

**Key Insights**

- Retail Leads in Volume: Retail experienced the highest total layoffs, indicating widespread restructuring in consumer-facing sectors
- Food industry Hit Hardest Proportionally: Food had the highest average percentage of workforce laid off, suggesting deeper cuts relative to company size
- 2023 Was the Peak Year
- Geographic Concentration: USA led in total layoffs, with India second
- Big Tech Drives Numbers: Amazon, Meta, and Tesla topped the list, showing how major employers set industry-wide trends

**Business Recommendations**

- For Job Seekers: Broaden your skill set and explore fields that tend to be more stable
- For Companies: The U.S. labor market reacts strongly to economic changes. Plan your staffing with that in mind
- For Analysts: Track both raw numbers and percentage changes to fully understand industry trends


