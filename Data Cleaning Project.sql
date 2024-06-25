-- Data Cleaning

-- Select all records from the layoffs table
SELECT * 
FROM layoffs;

-- 1. Removing Duplicates
-- 2. Standardizing the Data
-- 3. Populating Null Values or Blank Values
-- 4. Remove Any Columns

-- Create a new table to store duplicated data
CREATE TABLE layoffs_staging 
LIKE layoffs;

-- Select all records from the new staging table
SELECT * 
FROM layoffs_staging;

-- Insert data from layoffs table into staging table
INSERT layoffs_staging 
SELECT * 
FROM layoffs;

-- 1. Removing Duplicates

-- Step 1: Identify duplicate rows using ROW_NUMBER
SELECT *,
ROW_NUMBER() OVER(PARTITION BY company, industry, total_laid_off, 
percentage_laid_off, 'date') AS row_num
FROM layoffs_staging;

-- Use CTE to find and list duplicate rows
WITH duplicate_cte AS (
  SELECT *,
  ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, 
  percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
  FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte 
WHERE row_num > 1;

-- Check for specific duplicates (e.g., company 'Casper')
SELECT * 
FROM layoffs_staging 
WHERE company = 'Casper';

-- Step 2: Create a new table for deduplicated data
CREATE TABLE layoffs_staging2 (
  company text,
  location text,
  industry text,
  total_laid_off int DEFAULT NULL,
  percentage_laid_off text,
  `date` text,
  stage text,
  country text,
  funds_raised_millions int DEFAULT NULL,
  row_num INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Select all records from the new deduplicated staging table
SELECT * 
FROM layoffs_staging2;

-- Step 3: Insert deduplicated data into the new table
INSERT INTO layoffs_staging2
SELECT *, ROW_NUMBER() 
OVER(PARTITION BY company, location, industry, total_laid_off, 
percentage_laid_off, 'date', stage, country, funds_raised_millions) AS row_num
FROM layoffs_staging;

-- Step 4: Delete duplicate rows based on row number
DELETE 
FROM layoffs_staging2 
WHERE row_num > 1;

-- Step 5: Verify the deduplicated data
SELECT * 
FROM layoffs_staging2;

-- 2. Standardizing the Data

-- Trim whitespace from company names
SELECT company, TRIM(company) 
FROM layoffs_staging2;

-- Update company names by trimming whitespace
UPDATE layoffs_staging2 
SET company = TRIM(company);

-- Check distinct industry names
SELECT DISTINCT industry 
FROM layoffs_staging2;

-- Standardize industry names (e.g., unify all variations of 'Crypto')
UPDATE layoffs_staging2 
SET industry = 'Crypto' 
WHERE industry LIKE 'Crypto%';

-- Trim trailing periods from country names
SELECT DISTINCT country, TRIM(TRAILING '.' FROM country) 
FROM layoffs_staging2 
ORDER BY 1;

-- Update country names to remove trailing periods
UPDATE layoffs_staging2 
SET country = TRIM(TRAILING '.' FROM country) 
WHERE country LIKE 'United States%';

-- Convert date format from string to date
SELECT `date`, STR_TO_DATE(`date`, '%m/%d/%Y') 
FROM layoffs_staging2;

-- Update date column to standard date format
UPDATE layoffs_staging2 
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Modify date column to be of DATE type
ALTER TABLE layoffs_staging2 
MODIFY COLUMN `date` DATE;

-- 3. Populating Null Values or Blank Values

-- Select all records from the staging table
SELECT * 
FROM layoffs_staging2;

-- Find records with null total_laid_off and percentage_laid_off
SELECT * FROM layoffs_staging2 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- Set industry to NULL where industry is blank
UPDATE layoffs_staging2 
SET industry = NULL 
WHERE industry = '';

-- Select records with null or blank industry
SELECT * 
FROM layoffs_staging2 
WHERE industry IS NULL 
OR industry = '';

-- Select records where company is 'Airbnb'
SELECT * 
FROM layoffs_staging2 
WHERE company = 'Airbnb';

-- Find matching industry values within the same company
SELECT t1.industry, t2.industry 
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2 
ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '') 
AND t2.industry IS NOT NULL;

-- Update null or blank industry values using matching company records
UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2 
ON t1.company = t2.company
SET t1.industry = t2.industry 
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- Select records with null total_laid_off and percentage_laid_off
SELECT * FROM layoffs_staging2 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- Delete records with null total_laid_off and percentage_laid_off
DELETE FROM layoffs_staging2 
WHERE total_laid_off IS NULL 
AND percentage_laid_off IS NULL;

-- 4. Remove Any Columns

-- Select all records from the final cleaned table
SELECT * 
FROM layoffs_staging2;

-- Drop the row_num column
ALTER TABLE layoffs_staging2 
DROP COLUMN row_num;

-- The End
