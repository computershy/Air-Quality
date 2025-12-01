-- Data Cleaning

SELECT *
FROM layoffs;

-- Creating a new table

CREATE TABLE layoffs_staging
LIKE layoffs;

SELECT * 
FROM layoffs_staging;

INSERT layoffs_staging
SELECT *
FROM layoffs;

-- Removing Duplicates

SELECT *,
ROW_NUMBER() OVER( 
PARTITION BY Company, Industry, Laid_Off_Count, Percentage, `Date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER( 
PARTITION BY Company, Location_HQ, Industry, Laid_Off_Count, Percentage, `Date`, Stage, Country, Funds_Raised) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte
WHERE row_num > 1;

CREATE TABLE `layoffs_staging2` (
  `Company` text,
  `Location_HQ` text,
  `Industry` text,
  `Laid_Off_Count` text,
  `Date` text,
  `Source` text,
  `Funds_Raised` double DEFAULT NULL,
  `Stage` text,
  `Date_Added` text,
  `Country` text,
  `Percentage` text,
  `List_of_Employees_Laid_Off` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * 
FROM layoffs_staging2
WHERE row_num > 1;

Insert INTO layoffs_staging2
SELECT *,
ROW_NUMBER() OVER( 
PARTITION BY Company, Location_HQ, Industry, Laid_Off_Count, Percentage, `Date`, Stage, Country, Funds_Raised) AS row_num
FROM layoffs_staging;

DELETE
FROM layoffs_staging2
WHERE row_num > 1
LIMIT 2;

SELECT *
FROM layoffs_staging2;


-- Standardizing the data

SELECT Company, TRIM(Company)
FROM layoffs_staging2;

UPDATE layoffs_staging2
SET Company = TRIM(Company);

SELECT DISTINCT Industry
FROM layoffs_staging2
ORDER BY 1;

ALTER TABLE layoffs_staging2
MODIFY COLUMN `Date` DATE;

-- Removing Columns

ALTER TABLE layoffs_staging2
DROP COLUMN Date_Added,
DROP COLUMN Source,
DROP COLUMN List_of_Employees_Laid_Off,
DROP COLUMN row_num;



-- Renaming Columns
ALTER TABLE layoffs_staging2
RENAME COLUMN Company TO company,
RENAME COLUMN Location_HQ TO location,
Rename COLUMN Industry TO industry,
RENAME COLUMN Laid_Off_Count TO total_laid_off,
RENAME COLUMN Date TO `date`,
RENAME COLUMN Funds_Raised TO funds_raised_millions,
RENAME COLUMN Stage TO stage,
RENAME COLUMN Country TO country,
RENAME COLUMN Percentage TO percentage_laid_off;

-- Looking for empty data
SELECT * 
FROM layoffs_staging2
WHERE total_laid_off IS NULL
OR total_laid_off = '';

SELECT * 
FROM layoffs_staging2
WHERE percentage_laid_off IS NULL 
OR percentage_laid_off = '';

SELECT DISTINCT industry
from layoffs_staging2;

DELETE
FROM layoffs_staging2
WHERE (total_laid_off IS NULL OR total_laid_off = '');
  
  DESCRIBE layoffs_staging2;
  
UPDATE layoffs_staging2
SET total_laid_off = NULL
WHERE total_laid_off = '' OR total_laid_off IS NULL;

ALTER TABLE layoffs_staging2
MODIFY COLUMN total_laid_off INT;

UPDATE layoffs_staging2
SET percentage_laid_off = NULL
WHERE percentage_laid_off = '' OR percentage_laid_off IS NULL;

ALTER TABLE layoffs_staging2
MODIFY COLUMN percentage_laid_off DECIMAL(5,2);


SELECT * FROM layoffs_staging2;
