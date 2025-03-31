-- Tables weren't showing in sidebar, but were in file path for import wizard, double checking table was created here

SHOW TABLES
;

SELECT COUNT(*) FROM `actives, sale ratio, mf, all cc`
;  

-- After some research, found that assigning the double data type to col_3 was preventing the data from being imported, so i chose text and it worked

SELECT *
FROM `actives, sale ratio, mf, all cc`
;

-- Achieve percentage by converting text data type to decimal

SELECT 
`Sale Price to Original Price Ratio`, 
REPLACE(`Sale Price to Original Price Ratio`,'%','')  
FROM `actives, sale ratio, mf, all cc`
;

ALTER TABLE `actives, sale ratio, mf, all cc`
MODIFY COLUMN `Sale Price to Original Price Ratio` DECIMAL(4,1) 
;

-- Checking to make sure data type converted successfully by performing an aggregate function 
SELECT AVG(`Sale Price to Original Price Ratio`)
FROM `actives, sale ratio, mf, all cc`
;

DESCRIBE `actives, sale ratio, mf, all cc`
;  

-- Fixing the 'ï»¿Month' column
ALTER TABLE `actives, sale ratio, mf, all cc`
RENAME COLUMN `ï»¿Month` TO `Month`
;

SELECT *
FROM `actives, sale ratio, mf, all cc`
;

-- Now we will do the same with 2 more tables before combining them

SELECT *
FROM `median dom vs list price median, mf, all cc`
;

SELECT 
`List Price, Median`, 
REPLACE(`List Price, Median`,'$','')  
FROM `median dom vs list price median, mf, all cc`
;

-- I was not able to successfuly alter the `List Price, Median` so I double checked to see if the commas were an issue

SELECT `List Price, Median`
FROM `median dom vs list price median, mf, all cc`
WHERE `List Price, Median` REGEXP'[^0-9]'
;

UPDATE `median dom vs list price median, mf, all cc`
SET `List Price, Median` = REPLACE(REPLACE(`List Price, Median`, '$', ''), ',', '' )
;

SELECT `List Price, Median`
FROM `median dom vs list price median, mf, all cc`
WHERE `List Price, Median` REGEXP'[^0-9]+$'
;

ALTER TABLE `median dom vs list price median, mf, all cc`
MODIFY COLUMN `List Price, Median` INT 
;

ALTER TABLE `median dom vs list price median, mf, all cc`
RENAME COLUMN `ï»¿Month` TO `Month`
;

DESCRIBE `median dom vs list price median, mf, all cc`
;

-- Now we will do our third table

SELECT *
FROM `original price vs sold price, mf, all cc`  
;

UPDATE `original price vs sold price, mf, all cc`
SET `Original Price, Median` = REPLACE(REPLACE(`Original Price, Median`, '$', ''), ',', '' ),
	`Sale Price, Median` = REPLACE(REPLACE(`Sale Price, Median`, '$', ''), ',', '' )
;

ALTER TABLE `original price vs sold price, mf, all cc`
MODIFY COLUMN `Original Price, Median` INT, 
MODIFY COLUMN `Sale Price, Median` INT
;

ALTER TABLE `original price vs sold price, mf, all cc`
RENAME COLUMN `ï»¿Month` TO `Month`
;

DESCRIBE `original price vs sold price, mf, all cc`
;

SELECT * 
FROM `original price vs sold price, mf, all cc`
;


-- We actually have 2 more tables, there is some useful info I overlooked

SELECT *
FROM `original price vs sold price, avg, mf, all cc`  
;

UPDATE `original price vs sold price, avg, mf, all cc`
SET `Original Price, Average` = REPLACE(REPLACE(`Original Price, Average`, '$', ''), ',', '' ),
	`Sale Price, Average` = REPLACE(REPLACE(`Sale Price, Average`, '$', ''), ',', '' )
;

ALTER TABLE `original price vs sold price, avg, mf, all cc`
MODIFY COLUMN `Original Price, Average` INT, 
MODIFY COLUMN `Sale Price, Average` INT
;

ALTER TABLE `original price vs sold price, avg, mf, all cc`
RENAME COLUMN `ï»¿Month` TO `Month`
;

DESCRIBE `original price vs sold price, avg, mf, all cc`
;

SELECT * 
FROM `original price vs sold price, avg, mf, all cc`
;

-- And the last table

SELECT *
FROM `list price, average, mf, all cc`
;

UPDATE `list price, average, mf, all cc`
SET `List Price, Average 2024` = REPLACE(REPLACE(`List Price, Average 2024`, '$', ''), ',', '' ),
	`List Price, Average 2025` = REPLACE(REPLACE(`List Price, Average 2025`, '$', ''), ',', '' )
;

SELECT DISTINCT `List Price, Average 2025`
FROM `list price, average, mf, all cc`
;

-- Because I have empty spaces in `List Price, Average 2025`, I can't do that with empty strings. I must convert them to Null first  

SELECT DISTINCT `List Price, Average 2025`
FROM `list price, average, mf, all cc`
;

UPDATE `list price, average, mf, all cc`
SET `List Price, Average 2025` = NULL
WHERE `List Price, Average 2025` = ''
;

-- Now I can alter the table and convert to integers

ALTER TABLE `list price, average, mf, all cc`
MODIFY COLUMN `List Price, Average 2024` INT, 
MODIFY COLUMN `List Price, Average 2025` INT
;

ALTER TABLE `list price, average, mf, all cc`
RENAME COLUMN `ï»¿Month` to `Month`
;

-- In order to keep structure consistent, I need to reformat into one column to keep the month format the same on all five tables  

INSERT INTO `list price, average, mf, all cc` (`Month`, `List Price, Average 2024`)
VALUES 
('Jan 2025', 310558),
('Feb 2025', 339432)
;


UPDATE `list price, average, mf, all cc` 
SET `Month`= 
CASE
WHEN LENGTH(`Month`) = 3 THEN CONCAT(`Month`,' 2024')
ELSE `Month`
END
;

ALTER TABLE `list price, average, mf, all cc` 
DROP COLUMN `List Price, Average 2025`
;

ALTER TABLE `list price, average, mf, all cc`
RENAME COLUMN `List Price, Average 2024` TO `List Price, Average`
;

SELECT *
FROM `list price, average, mf, all cc` 
;

-- I also need to add DOM avg

SELECT *
FROM `days to sell, avg, mf, all`
;

ALTER TABLE `days to sell, avg, mf, all`
RENAME COLUMN `ï»¿Month` TO `Month`
;

INSERT INTO `days to sell, avg, mf, all`(`Month`, `Days to Sell, Average 2024`)
VALUES
('Jan 2025', 47),
('Feb 2025', 48)
;

ALTER TABLE `days to sell, avg, mf, all`
DROP COLUMN `Days to Sell, Average 2025`
;

UPDATE `days to sell, avg, mf, all`
SET `Month` = 
CASE
WHEN LENGTH(`Month`) = 3 THEN CONCAT(`Month`, ' 2024')
ELSE `Month`
END
;

ALTER TABLE `days to sell, avg, mf, all`
RENAME COLUMN `Days to Sell, Average 2024` TO `Days to Sell, Average`
;

-- Now it's time to combine all the tables into 1

CREATE TABLE complete_mf_all AS
SELECT * 
FROM `actives, sale ratio, mf, all cc` 
JOIN `list price, average, mf, all cc` 
USING(`Month`)
JOIN `median dom vs list price median, mf, all cc`
USING(`Month`)
JOIN `original price vs sold price, avg, mf, all cc`
USING(`Month`)
JOIN `original price vs sold price, mf, all cc`
USING(`Month`)
JOIN `days to sell, avg, mf, all`
USING(`Month`)
;

SELECT *
FROM complete_mf_all
;

DESCRIBE complete_mf_all
;

ALTER TABLE complete_mf_all
MODIFY COLUMN `Active Listings, Number of` INT
; 

ALTER TABLE complete_mf_all
MODIFY COLUMN `Sale Price to Original Price Ratio` INT
;
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Now to do it all over again for the top half of camden county and the bottom half


-- Camden County Top

SELECT `Sale Price to Original Price Ratio`,
REPLACE(`Sale Price to Original Price Ratio`, '%', '')
FROM `top, actives, sale ratio, mf`
;
 
UPDATE `top, actives, sale ratio, mf`
SET `Sale Price to Original Price Ratio` = NULL
WHERE `Sale Price to Original Price Ratio` = ''
;

ALTER TABLE `top, actives, sale ratio, mf`
MODIFY COLUMN `Sale Price to Original Price Ratio` DECIMAL(4,1)
;

ALTER TABLE `top, actives, sale ratio, mf`
RENAME COLUMN `ï»¿Month` TO `Month`
;

SELECT * 
FROM `top, actives, sale ratio, mf`
;

-- Next Table

SELECT *
FROM `top, median dom vs list price median, mf`
;

DESCRIBE `top, median dom vs list price median, mf`
;

UPDATE `top, median dom vs list price median, mf`
SET `Days to Sell, Median` = NULL
WHERE `Days to Sell, Median` = ''
;

UPDATE `top, median dom vs list price median, mf`
SET `List Price, Median` = NULL
WHERE `List Price, Median` = ''
;

ALTER TABLE `top, median dom vs list price median, mf`
MODIFY COLUMN `Days to Sell, Median` INT
;

 UPDATE `top, median dom vs list price median, mf`
 SET `List Price, Median` = REPLACE(REPLACE(`List Price, Median`, '$', ''), ',', '')
 ;

ALTER TABLE `top, median dom vs list price median, mf`
MODIFY COLUMN `List Price, Median` INT 
;

ALTER TABLE `top, median dom vs list price median, mf`
RENAME COLUMN `ï»¿Month` TO `Month`
;

-- Next table 

SELECT * 
FROM `top, original price vs sold price, mf`
;

DESCRIBE `top, original price vs sold price, mf`
;

ALTER TABLE `top, original price vs sold price, mf`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `top, original price vs sold price, mf`
SET `Original Price, Median` = NULL 
WHERE `Original Price, Median` = ''
;

UPDATE `top, original price vs sold price, mf`
SET `Sale Price, Median` = NULL 
WHERE `Sale Price, Median` = ''
;

UPDATE `top, original price vs sold price, mf`
SET `Original Price, Median` = REPLACE(REPLACE(`Original Price, Median`, '$', ''), ',', '')
;

UPDATE `top, original price vs sold price, mf`
SET `Sale Price, Median` = REPLACE(REPLACE(`Sale Price, Median`, '$', ''), ',', '')
;

ALTER TABLE `top, original price vs sold price, mf`
MODIFY COLUMN `Original Price, Median` INT
;

ALTER TABLE `top, original price vs sold price, mf`
MODIFY COLUMN `Sale Price, Median` INT
;

-- Next table

SELECT *
FROM `top, op vs sp avg`
;

DESCRIBE `top, op vs sp avg`
;

UPDATE `top, op vs sp avg`
SET `Original Price, Average` = NULL
WHERE `Original Price, Average` = ''
;

UPDATE `top, op vs sp avg`
SET `Sale Price, Average` = NULL 
WHERE `Sale Price, Average` = ''
;

UPDATE `top, op vs sp avg`
SET `Original Price, Average` = REPLACE(REPLACE(`Original Price, Average`, '$', ''), ',', '')
;

UPDATE `top, op vs sp avg`
SET `Sale Price, Average` = REPLACE(REPLACE(`Sale Price, Average`, '$', ''), ',', '')
;

ALTER TABLE `top, op vs sp avg`
MODIFY COLUMN `Original Price, Average` INT 
;

ALTER TABLE `top, op vs sp avg`
MODIFY COLUMN `Sale Price, Average` INT 
;

ALTER TABLE `top, op vs sp avg`
RENAME COLUMN `ï»¿Month` TO `Month`
;

-- Next Table 

SELECT *
FROM `top, list price avg`
;

ALTER TABLE `top, list price avg`
RENAME COLUMN `ï»¿Month` TO `Month`
;


INSERT INTO `top, list price avg` (`Month`)
VALUES 
('Jan 2025'),
('Feb 2025')
;

ALTER TABLE `top, list price avg`
DROP COLUMN `List Price, Average 2025`
;

UPDATE `top, list price avg`
SET `List Price, Average 2024` = NULL
WHERE `List Price, Average 2024` = ''
;

UPDATE `top, list price avg`
SET `List Price, Average 2024` = REPLACE(REPLACE(`List Price, Average 2024`, '$', ''), ',', '')
;

UPDATE `top, list price avg`
SET `Month`= 
CASE
WHEN LENGTH(`Month`) = 3 THEN CONCAT(`Month`,' 2024')
ELSE `Month`
END
;

ALTER TABLE `top, list price avg`
RENAME COLUMN `List Price, Average 2024` TO `List Price, Average`
;

ALTER TABLE `top, list price avg`
MODIFY COLUMN `List Price, Average` INT
;

-- Last minute add of DOM Avg

SELECT *
FROM `top, dom, avg, ml`
;

ALTER TABLE `top, dom, avg, ml`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `top, dom, avg, ml`
SET `Days to Sell, Average 2024` = NULL
WHERE `Days to Sell, Average 2024` = ''
;

INSERT INTO `top, dom, avg, ml`(`Month`, `Days to Sell, Average 2024`)
VALUES
('Jan 2025', 56),
('Feb 2025', 97)
;

ALTER TABLE `top, dom, avg, ml`
DROP COLUMN `Days to Sell, Average 2025`
;

ALTER TABLE `top, dom, avg, ml`
RENAME COLUMN `Days to Sell, Average 2024` TO `Days to Sell, Average`
;

UPDATE `top, dom, avg, ml`
SET `Month` = 
CASE
WHEN LENGTH(`Month`) = 3 THEN CONCAT(`Month`, ' 2024')
ELSE `Month`
END
;
-- Second Combined table

CREATE TABLE complete_mf_top AS
SELECT * 
FROM `top, actives, sale ratio, mf` 
JOIN `top, list price avg` 
USING(`Month`)
JOIN `top, median dom vs list price median, mf`
USING(`Month`)
JOIN `top, op vs sp avg`
USING(`Month`)
JOIN `top, original price vs sold price, mf`
USING(`Month`)
JOIN `top, dom, avg, ml`
USING(`Month`)
;

SELECT *
FROM complete_mf_top
; 

DESCRIBE complete_mf_top
;

ALTER TABLE complete_mf_top
MODIFY COLUMN `Sale Price to Original Price Ratio` INT 
;

ALTER TABLE complete_mf_top
MODIFY COLUMN `Days to Sell, Average` INT 
;


-- Last Batch of Tables 

-- First one

SELECT * 
FROM `bottom, actives, sale ratio, mf`
;

ALTER TABLE `bottom, actives, sale ratio, mf`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `bottom, actives, sale ratio, mf`
SET `Sale Price to Original Price Ratio` = REPLACE(`Sale Price to Original Price Ratio`, '%', '')
;

UPDATE `bottom, actives, sale ratio, mf`
SET `Sale Price to Original Price Ratio` = NULL
WHERE `Sale Price to Original Price Ratio` = ''
;

ALTER TABLE `bottom, actives, sale ratio, mf`
MODIFY COLUMN `Sale Price to Original Price Ratio` INT 
;

DESCRIBE `bottom, actives, sale ratio, mf`
;

-- Second One

SELECT *
FROM `bottom, median dom vs list price median, mf`
;

DESCRIBE `bottom, median dom vs list price median, mf`
;

ALTER TABLE `bottom, median dom vs list price median, mf`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `bottom, median dom vs list price median, mf`
SET `List Price, Median` = NULL 
WHERE `List Price, Median` = ''
;

UPDATE `bottom, median dom vs list price median, mf`
SET `List Price, Median` = REPLACE(REPLACE(`List Price, Median`, '$', '') , ',' , '')
;

ALTER TABLE `bottom, median dom vs list price median, mf`
MODIFY COLUMN `List Price, Median` INT 
;

INSERT INTO `bottom, median dom vs list price median, mf`(`Month`, `Days to Sell, Median`, `List Price, Median`)
VALUES
('Jan 2025', NULL, 325000)
;

-- Third one

SELECT * 
FROM `bottom, op vs sp avg`
;

ALTER TABLE `bottom, op vs sp avg`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `bottom, op vs sp avg`
SET `Original Price, Average` = NULL 
WHERE `Original Price, Average` = ''
;

UPDATE `bottom, op vs sp avg`
SET `Sale Price, Average` = NULL 
WHERE `Sale Price, Average` = ''
;

UPDATE `bottom, op vs sp avg`
SET `Original Price, Average` = REPLACE(REPLACE(`Original Price, Average`, '$', ''), ',', '')
;

UPDATE `bottom, op vs sp avg`
SET `Sale Price, Average` = REPLACE(REPLACE(`Sale Price, Average`, '$', ''), ',', '')
;

ALTER TABLE `bottom, op vs sp avg`
MODIFY COLUMN `Original Price, Average` INT
;

ALTER TABLE `bottom, op vs sp avg`
MODIFY COLUMN `Sale Price, Average` INT
;

DESCRIBE `bottom, op vs sp avg`
;

-- Fourth One

SELECT * 
FROM `bottom, original price vs sold price, mf`
;

ALTER TABLE `bottom, original price vs sold price, mf`
RENAME COLUMN `ï»¿Month` TO `Month`
;

UPDATE `bottom, original price vs sold price, mf`
SET `Original Price, Median` = NULL 
WHERE `Original Price, Median` = ''
;

UPDATE `bottom, original price vs sold price, mf`
SET `Sale Price, Median` = NULL 
WHERE `Sale Price, Median` = ''
;

UPDATE `bottom, original price vs sold price, mf`
SET `Original Price, Median` = REPLACE(REPLACE(`Original Price, Median`, '$', ''), ',', '')
;

UPDATE `bottom, original price vs sold price, mf`
SET `Sale Price, Median` = REPLACE(REPLACE(`Sale Price, Median`, '$', ''), ',', '')
;

ALTER TABLE `bottom, original price vs sold price, mf`
MODIFY COLUMN `Original Price, Median` INT 
;

ALTER TABLE `bottom, original price vs sold price, mf`
MODIFY COLUMN `Sale Price, Median` INT 
;

-- Fifth One

SELECT * 
FROM `bottom, list price avg`
;

ALTER TABLE `bottom, list price avg`
RENAME COLUMN `ï»¿Month` TO `Month`
;

INSERT INTO `bottom, list price avg`(`Month`, `List Price, Average 2024`)
VALUES 
('Jan 2025', '$320,967'),
('Feb 2025', '$333,333')
;

ALTER TABLE `bottom, list price avg`
DROP COLUMN `List Price, Average 2025`
;

UPDATE `bottom, list price avg`
SET `List Price, Average 2024` = NULL 
WHERE `List Price, Average 2024` = ''
;

ALTER TABLE `bottom, list price avg`
RENAME COLUMN `List Price, Average 2024` TO `List Price, Average`
;

UPDATE `bottom, list price avg`
SET `List Price, Average` = REPLACE(REPLACE(`List Price, Average`, '$', ''), ',', '')
;

ALTER TABLE `bottom, list price avg`
MODIFY COLUMN `List Price, Average` INT
;

UPDATE `bottom, list price avg`
SET `Month` = 
CASE
WHEN LENGTH(`Month`) = 3 THEN CONCAT(`Month`, ' 2024')
ELSE `Month`
END
;

-- Last minute add of dom avg

SELECT *
FROM `bottom, days to sell, average, mf`
;

ALTER TABLE `bottom, days to sell, average, mf`
RENAME COLUMN `ï»¿Month` TO `Month`
;

INSERT INTO `bottom, days to sell, average, mf`(`Month`, `Days to Sell, Average 2024`)
VALUES
('Jan 2025', 8),
('Feb 2025', 49)
;

ALTER TABLE `bottom, days to sell, average, mf`
DROP COLUMN `Days to Sell, Average 2025`
;

ALTER TABLE `bottom, days to sell, average, mf`
RENAME COLUMN `Days to Sell, Average 2024` TO `Days to Sell, Average`
;

UPDATE `bottom, days to sell, average, mf`
SET `Month` = 
CASE 
WHEN LENGTH(`Month`) = 3 THEN CONCAT(`Month`, ' 2024')
ELSE `Month`
END
;

-- Now we join all the tables again

  CREATE TABLE complete_mf_bottom AS
  SELECT *
  FROM `bottom, actives, sale ratio, mf`
  JOIN `bottom, days to sell, average, mf`
  USING(`Month`)
  JOIN `bottom, median dom vs list price median, mf`
  USING(`Month`)
  JOIN `bottom, op vs sp avg`
  USING(`Month`)
  JOIN `bottom, original price vs sold price, mf`
  USING(`Month`)
  JOIN `bottom, list price avg`
  USING(`Month`)
  ;
  
  SELECT *
  FROM complete_mf_bottom
  ;
  
  
  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
-- Now to double check 3 complete tables before exporting

SELECT *
FROM complete_mf_all
;

DESCRIBE complete_mf_all
;

SELECT *
FROM complete_mf_top
;

DESCRIBE complete_mf_top
;

SELECT *
FROM complete_mf_bottom
;

DESCRIBE complete_mf_bottom
;
  