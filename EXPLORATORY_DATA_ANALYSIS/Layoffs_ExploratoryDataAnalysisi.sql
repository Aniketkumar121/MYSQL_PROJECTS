--- EXPLORATORY DATA ANALYSIS ---

SELECT *
FROM layoffs_staging2;

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

SELECT *
FROM layoffs_staging2
WHERE percentage_laid_off = 1
ORDER BY funds_raised_millions DESC;

SELECT company , SUM(total_laid_Off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging2;

SELECT industry , SUM(total_laid_Off)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

SELECT *
FROM layoffs_staging2;

SELECT country , SUM(total_laid_Off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

SELECT `date` , SUM(total_laid_Off)
FROM layoffs_staging2
GROUP BY `date`
ORDER BY 1 DESC;

SELECT YEAR(`date`) , SUM(total_laid_Off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

SELECT stage , SUM(total_laid_Off)
FROM layoffs_staging2
GROUP BY stage
ORDER BY 2 DESC;

-- SELECT company , SUM(percentage_laid_off)
-- FROM layoffs_staging2
-- GROUP BY company
-- ORDER BY 2 DESC;

SELECT company , AVG(total_laid_Off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- SELECT SUBSTRING(`date`, 6, 2) AS `MONTH`
-- FROM layoffs_staging2;

-- SELECT SUBSTRING(`date`, 6, 2) AS `MONTH`, SUM(total_laid_off)
-- FROM layoffs_staging2
-- GROUP BY SUBSTRING(`date`, 6, 2);

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY SUBSTRING(`date`, 1, 7)
ORDER BY 1 ASC;

SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
-- GROUP BY SUBSTRING(`date`, 1, 7)
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`, 1, 7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`, 1, 7) IS NOT NULL
-- GROUP BY SUBSTRING(`date`, 1, 7)
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off ,
SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;


SELECT company , SUM(total_laid_Off)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- SELECT company , YEAR(`date`), SUM(total_laid_Off)
-- FROM layoffs_staging2
-- GROUP BY company, YEAR(`date`)
-- ORDER BY company ASC;

SELECT company , YEAR(`date`), SUM(total_laid_Off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
ORDER BY 3 DESC;


-- WITH Company_year (company, years, total_laid_off) AS
-- (
-- SELECT company , YEAR(`date`), SUM(total_laid_Off)
-- FROM layoffs_staging2
-- GROUP BY company, YEAR(`date`)
-- )
-- SELECT *, DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) 
-- FROM Company_year;

WITH Company_year (company, years, total_laid_off) AS
(
SELECT company , YEAR(`date`), SUM(total_laid_Off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
)
SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL
ORDER BY Ranking ASC;


WITH Company_year (company, years, total_laid_off) AS
(
SELECT company , YEAR(`date`), SUM(total_laid_Off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), Company_year_Rank AS 
(
SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) AS Ranking
FROM Company_year
WHERE years IS NOT NULL
)
SELECT *
FROM Company_year_Rank
WHERE Ranking <= 5;
