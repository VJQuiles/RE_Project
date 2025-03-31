-- We will now do the tables we did for the multifamily sales data, for the residential lease portion

-- First Table

SELECT *
FROM `actives, sale ratio, rl, all`
;

DESCRIBE `actives, sale ratio, rl, all`
;

ALTER TABLE `actives, sale ratio, rl, all`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `actives, sale ratio, rl, all`
SET `Sale Price to Original Price Ratio` = REPLACE(`Sale Price to Original Price Ratio`, '%', '')
;

ALTER TABLE `actives, sale ratio, rl, all`
MODIFY COLUMN `Sale Price to Original Price Ratio` INT 
;

-- Table 2

SELECT * 
FROM `op vs so avg, rl, all`
;

DESCRIBE `op vs so avg, rl, all`
;

ALTER TABLE `op vs so avg, rl, all`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `op vs so avg, rl, all`
SET `Original Price, Average` = REPLACE(REPLACE(`Original Price, Average`, '$', ''), ',', '')
;

UPDATE `op vs so avg, rl, all`
SET `Sale Price, Average` = REPLACE(REPLACE(`Sale Price, Average`, '$', ''), ',', '')
;

ALTER TABLE `op vs so avg, rl, all`
MODIFY COLUMN `Original Price, Average` INT
;

ALTER TABLE `op vs so avg, rl, all`
MODIFY COLUMN `Sale Price, Average` INT
;
-- Table 3

SELECT *
FROM `average dom vs list price average, rl, all`
;

ALTER TABLE `average dom vs list price average, rl, all`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `average dom vs list price average, rl, all`
SET `List Price, Average` = REPLACE(REPLACE(`List Price, Average`, '$', ''), ',', '')
;

ALTER TABLE `average dom vs list price average, rl, all`
MODIFY COLUMN `List Price, Average` INT 
;

DESCRIBE `average dom vs list price average, rl, all`
;

-- Table 4

SELECT * 
FROM `median dom vs list price median, rl, all cc`
;

ALTER TABLE `median dom vs list price median, rl, all cc`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `median dom vs list price median, rl, all cc`
SET `List Price, Median` = REPLACE(REPLACE(`List Price, Median`, '$', ''), ',', '')
;

ALTER TABLE `median dom vs list price median, rl, all cc`
MODIFY COLUMN `List Price, Median` INT
;

DESCRIBE `median dom vs list price median, rl, all cc`
;

-- Table 5 

SELECT *
FROM `original price vs sold price, rl, all cc`
;

DESCRIBE `original price vs sold price, rl, all cc`
;

ALTER TABLE `original price vs sold price, rl, all cc`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `original price vs sold price, rl, all cc`
SET `Original Price, Median` = REPLACE(REPLACE(`Original Price, Median`, '$', ''), ',', '')
;

UPDATE `original price vs sold price, rl, all cc`
SET `Sale Price, Median` = REPLACE(REPLACE(`Sale Price, Median`, '$', ''), ',', '')
;

ALTER TABLE `original price vs sold price, rl, all cc`
MODIFY COLUMN `Original Price, Median` INT
;

ALTER TABLE `original price vs sold price, rl, all cc`
MODIFY COLUMN `Sale Price, Median` INT
;

-- First Mega Table

CREATE TABLE mega_table_rl_all AS
SELECT *
FROM `actives, sale ratio, rl, all`
JOIN `average dom vs list price average, rl, all`
USING(`Month`)
JOIN `median dom vs list price median, rl, all cc`
USING(`Month`)
JOIN `original price vs sold price, rl, all cc`
USING(`Month`)
JOIN `op vs so avg, rl, all`
USING(`Month`)
;

SELECT * 
FROM mega_table_rl_all
;

------------------------------------------------------------------------------------------------------------------------------------------

-- On to the top half of Camden County

-- Table 1

SELECT * 
FROM `top , actives, spop ratio, rl`
;

ALTER TABLE `top , actives, spop ratio, rl`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `top , actives, spop ratio, rl`
SET `Sale Price to Original Price Ratio` = REPLACE(`Sale Price to Original Price Ratio`, '%', '')
;

ALTER TABLE `top , actives, spop ratio, rl`
MODIFY COLUMN `Sale Price to Original Price Ratio` INT
;

DESCRIBE `top , actives, spop ratio, rl`
;

-- Table 2

SELECT * 
FROM `top, dom avg vs list avg, rl`
;

ALTER TABLE `top, dom avg vs list avg, rl`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `top, dom avg vs list avg, rl`
SET `List Price, Average` = REPLACE(REPLACE(`List Price, Average`, '$', ''), ',', '')
;

ALTER TABLE `top, dom avg vs list avg, rl`
MODIFY COLUMN `List Price, Average` INT
;

DESCRIBE `top, dom avg vs list avg, rl`
;

-- Table 3

SELECT *
FROM `top, median dom vs list price median, rl`
;

ALTER TABLE `top, median dom vs list price median, rl`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `top, median dom vs list price median, rl`
SET `List Price, Median` = REPLACE(REPLACE(`List Price, Median`, '$', ''), ',', '')
;

ALTER TABLE `top, median dom vs list price median, rl`
MODIFY COLUMN `List Price, Median` INT 
;

DESCRIBE `top, median dom vs list price median, rl`
;

-- Table 4

SELECT * 
FROM `top, op v sp avg, rl`
;

ALTER TABLE `top, op v sp avg, rl`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `top, op v sp avg, rl`
SET `Original Price, Average` = REPLACE(REPLACE(`Original Price, Average`, '$', ''), ',', '')
;

UPDATE `top, op v sp avg, rl`
SET `Sale Price, Average` = REPLACE(REPLACE(`Sale Price, Average`, '$', ''), ',', '')
;

ALTER TABLE `top, op v sp avg, rl`
MODIFY COLUMN `Original Price, Average` INT 
;

ALTER TABLE `top, op v sp avg, rl`
MODIFY COLUMN `Sale Price, Average` INT 
;

-- Table 5

SELECT * 
FROM `top, original price vs sold price, rl`
;

ALTER TABLE `top, original price vs sold price, rl`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `top, original price vs sold price, rl`
SET `Original Price, Median` = REPLACE(REPLACE(`Original Price, Median`, '$', ''), ',', '')
;

UPDATE `top, original price vs sold price, rl`
SET `Sale Price, Median` = REPLACE(REPLACE(`Sale Price, Median`, '$', ''), ',', '')
;

ALTER TABLE `top, original price vs sold price, rl`
MODIFY COLUMN `Original Price, Median` INT
;

ALTER TABLE `top, original price vs sold price, rl`
MODIFY COLUMN `Sale Price, Median` INT
;

-- Top Mega Table

CREATE TABLE mega_table_rl_top AS
SELECT *
FROM `top , actives, spop ratio, rl`
JOIN `top, dom avg vs list avg, rl`
USING(`Month`)
JOIN `top, median dom vs list price median, rl`
USING(`Month`)
JOIN `top, op v sp avg, rl`
USING(`Month`)
JOIN `top, original price vs sold price, rl`
USING(`Month`)
;

SELECT *
FROM mega_table_rl_top
;

-----------------------------------------------------------------------------------------------------------------------------------------

-- Now for the final portion of tables

-- Table 1

SELECT * 
FROM `bottom, actives, spop rat, rl`
;

ALTER TABLE `bottom, actives, spop rat, rl`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `bottom, actives, spop rat, rl`
SET `Sale Price to Original Price Ratio` = REPLACE(`Sale Price to Original Price Ratio`, '%', '')
;

ALTER TABLE `bottom, actives, spop rat, rl`
MODIFY COLUMN `Sale Price to Original Price Ratio` INT
;

DESCRIBE `bottom, actives, spop rat, rl`
;

-- Table 2

SELECT * 
FROM `bottom, dom avg, list price avg, rl`
;

ALTER TABLE `bottom, dom avg, list price avg, rl`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `bottom, dom avg, list price avg, rl`
SET `List Price, Average` = REPLACE(REPLACE(`List Price, Average`, '$', ''), ',', '')
;

ALTER TABLE `bottom, dom avg, list price avg, rl`
MODIFY COLUMN `List Price, Average` INT
;

-- Table 3

SELECT *
FROM `bottom, median dom vs list price median, rl`
;

DESCRIBE `bottom, median dom vs list price median, rl`
;

ALTER TABLE `bottom, median dom vs list price median, rl`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `bottom, median dom vs list price median, rl`
SET `List Price, Median` = REPLACE(REPLACE(`List Price, Median`, '$', ''), ',', '')
;

ALTER TABLE `bottom, median dom vs list price median, rl`
MODIFY COLUMN `List Price, Median` INT 
;
-- Table 4

SELECT * 
FROM `bottom, op v sp avg, rl`
;

DESCRIBE `bottom, op v sp avg, rl`
;

ALTER TABLE `bottom, op v sp avg, rl`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `bottom, op v sp avg, rl`
SET `Original Price, Average` = REPLACE(REPLACE(`Original Price, Average`, '$', ''), ',', '')
;

UPDATE `bottom, op v sp avg, rl`
SET `Sale Price, Average` = REPLACE(REPLACE(`Sale Price, Average`, '$', ''), ',', '')
;

ALTER TABLE `bottom, op v sp avg, rl`
MODIFY COLUMN `Original Price, Average` INT
;

ALTER TABLE `bottom, op v sp avg, rl`
MODIFY COLUMN `Sale Price, Average` INT
;

-- Table 5

SELECT * 
FROM `bottom, original price vs sold price, rl`
;

DESCRIBE `bottom, original price vs sold price, rl`
;

ALTER TABLE `bottom, original price vs sold price, rl`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `bottom, original price vs sold price, rl`
SET `Original Price, Median` = REPLACE(REPLACE(`Original Price, Median`, '$', ''), ',', '')
;

UPDATE `bottom, original price vs sold price, rl`
SET `Sale Price, Median` = REPLACE(REPLACE(`Sale Price, Median`, '$', ''), ',', '')
;

ALTER TABLE `bottom, original price vs sold price, rl`
MODIFY COLUMN `Original Price, Median` INT 
;

ALTER TABLE `bottom, original price vs sold price, rl`
MODIFY COLUMN `Sale Price, Median` INT
;

-- Bottom Mega Table

CREATE TABLE mega_table_rl_bottom AS
SELECT * 
FROM `bottom, actives, spop rat, rl`
JOIN `bottom, dom avg, list price avg, rl`
USING(`Month`)
JOIN `bottom, median dom vs list price median, rl`
USING(`Month`)
JOIN `bottom, op v sp avg, rl`
USING(`Month`)
JOIN `bottom, original price vs sold price, rl`
USING(`Month`)
;

SELECT *
FROM mega_table_rl_bottom
;

UPDATE mega_table_rl_bottom
  SET `List Price, Average` = REPLACE(REPLACE(`List Price, Average`, '$', ''), ',', '')
;
  
ALTER TABLE mega_table_rl_bottom
  MODIFY COLUMN `List Price, Average` INT
;
  
DESCRIBE mega_table_rl_bottom
;
  
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Table check 

SELECT *
FROM mega_table_rl_bottom
;

DESCRIBE mega_table_rl_bottom
;

SELECT *
FROM mega_table_rl_all
;

DESCRIBE mega_table_rl_all
;

SELECT *
FROM mega_table_rl_bottom
;

DESCRIBE mega_table_rl_bottom
;