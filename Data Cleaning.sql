--- DATA CLEANING 

use word_layoffs1;

SELECT 
    *
FROM
    layoffs;
    
    
    CREATE TABLE LAYOFFS_STAGING
    LIKE LAYOFFS;
    
    DROP TABLE LAYOFF_STAGING;
    
    
    SELECT * FROM LAYOFFS_STAGING;
    
    INSERT LAYOFFS_STAGING
    SELECT * FROM LAYOFFS;
    
    --- REMOVE DUPLICATES 
    
    SELECT *,
    ROW_NUMBER() OVER(
    partition by country, industry, total_laid_off, percentage_laid_off, 'date')as row_num
    FROM LAYOFFS_STAGING;
    
with duplicates_cte as
(
SELECT *,
    ROW_NUMBER() OVER(
    partition by country,location,company, industry, total_laid_off, percentage_laid_off, 'date',
    stage, funds_raised_millions)as row_num
    FROM LAYOFFS_STAGING
)
select * 
from duplicates_cte 
where row_num > 1;

SELECT 
    *
FROM
    layoffs_staging
WHERE
    company = 'Casper';
    
    CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


select * from layoffs_staging2;

insert into layoffs_staging2
SELECT *,
    ROW_NUMBER() OVER(
    partition by country,location,company, industry, total_laid_off, percentage_laid_off, 'date',
    stage, funds_raised_millions)as row_num
    FROM LAYOFFS_STAGING;
    
    select * from layoffs_staging2
    where row_num > 1;
    
    SET SQL_SAFE_UPDATES = 0;

DELETE 
FROM layoffs_staging2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 1;

    
    select * from layoffs_staging2;
    
    
    --- Standardizing Data 
    
    select company, trim(company)
    from layoffs_staging2;
    
    update layoffs_staging2
    set  company = trim(company);
    
    select distinct industry
    from layoffs_staging2;
    
    update layoffs_staging2
    set industry ='crypto'
    where industry like 'crypto';
    
    select distinct country, trim(trailing '.' from country)
    from layoffs_staging2
order by 1;

update layoffs_staging2 
set country = trim(trailing '.' from country)
where country like 'United States%';
    
    select *
    from layoffs_staging2;
    
    --- CHANGE DATE FROM TEXT TO DATE/TIME
    
    select `date`
    from layoffs_staging2;
    
    update layoffs_staging2
    set `date` =     str_to_date(`date`, '%m/%d/%Y');
    
    alter table layoffs_staging2
    modify column `date` DATE;

--- REMOVING NULL VALUES
    select * 
    from layoffs_staging2
    where total_laid_off is null
    and percentage_laid_off is null;
    
    update layoffs_staging2
    set industry = null
    where industry = '';
    
    select * 
    from layoffs_staging
    where industry is null
    or industry = '';
    
    
    select * 
    from layoffs_staging2 
    where company = 'Airbnb';
    
    select t1.industry, t2.industry
    from layoffs_staging2 t1
    join layoffs_staging2 t2
      on t1.company = t2.company
      where (t1.industry is null or t1.industry = '')
      and t2.industry is not null;
      
      update layoffs_staging2 t1
      join layoffs_staging2 t2
      on t1.company = t2.company
      set t1.industry = t2.industry
      where t1.industry is null 
      and t2.industry is not null;
      
      --- REMOVING EMPTY ROWS AND COLUMNS
    
    select * 
    from layoffs_staging2
    where total_laid_off is null
    and percentage_laid_off is null;
    
    delete
    from layoffs_staging2
    where total_laid_off is null
    and percentage_laid_off is null;
    
    select * 
    from layoffs_staging2;
    
    alter table layoffs_staging2
    drop column row_num;