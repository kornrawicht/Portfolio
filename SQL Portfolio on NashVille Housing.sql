DROP TABLE IF EXISTS housing;
CREATE TABLE housing (
	UniqueID INT);

-- After this, import data into table called housing

SET SQL_SAFE_UPDATES = 0;
-- Unlock update function

SELECT * FROM housing;

SELECT *
FROM housing
WHERE PropertyAddress IS NULL;
-- Find Null Value in PropertyAddress column

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress)
FROM housing a
JOIN housing b 
	ON a.ParcelID = b.ParcelID
    AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL;
-- Find different propertyaddress from ParcelID and UniqueID to replace

SELECT PropertyAddress
FROM housing;

SELECT 
SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress)-1)  AS Address,
SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress)+2, LENGTH(PropertyAddress)) AS City
FROM housing;
-- Cleanse PropertyAddress column by using SUBSTRING() to retreive value and divide it into Address and City Column

ALTER TABLE housing
ADD COLUMN PropertysplitAddress VARCHAR(100),
ADD COLUMN PropertysplitCity VARCHAR(100);
-- Add columns call PropertysplitAddress and PropertysplitCity into Table

UPDATE housing
SET PropertysplitAddress = SUBSTRING(PropertyAddress, 1, LOCATE(',', PropertyAddress)-1),
	PropertysplitCity = SUBSTRING(PropertyAddress, LOCATE(',', PropertyAddress)+2, LENGTH(PropertyAddress));
-- Use Update to load cleansed data into created columns

SELECT PropertysplitAddress, PropertysplitCity
FROM housing;
-- Verify new data

SELECT OwnerAddress
FROM housing;

SELECT OwnerAddress,
SUBSTRING_Index(OwnerAddress, ',', 1),
SUBSTRING_INDEX(SUBSTRING_Index(OwnerAddress, ',', 2),',',-1),
SUBSTRING_Index(OwnerAddress, ',', -1)
FROM housing;
-- Cleanse data in OwnerAddress column and divide it into 3 parts

ALTER TABLE housing
ADD COLUMN OwnersplitAddress VARCHAR(100),
ADD COLUMN OwnersplitCity VARCHAR(100),
ADD COLUMN OwnersplitState VARCHAR(100);
-- Add 3 new columns for cleansed data

UPDATE housing
SET OwnersplitAddress = SUBSTRING_Index(OwnerAddress, ',', 1),
	OwnersplitCity = SUBSTRING_INDEX(SUBSTRING_Index(OwnerAddress, ',', 2),',',-1),
    OwnersplitState = SUBSTRING_Index(OwnerAddress, ',', -1);
-- Add cleansed data into the 3 columns with prearranged codes

SELECT DISTINCT SoldAsVacant, Count(SoldAsVacant)
FROM housing
Group by SoldAsVacant;
-- Find inappropriate data in Sold As Vacant

SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant = 'Y' Then 'Yes'
		WHEN SoldAsVacant = 'N' Then 'No'
		ELSE SoldAsVacant
		END
FROM housing;
-- Find Y and N, then change it to Yes and No

UPDATE housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' Then 'Yes'
		WHEN SoldAsVacant = 'N' Then 'No'
		ELSE SoldAsVacant
		END;
-- Cleanse Y and N data to Yes and No by using Case()

SELECT *, 
		ROW_NUMBER() OVER (
		PARTITION BY ParcelID, 
					PropertyAddress, 
					SalePrice, 
					SaleDate, 
					LegalReference
					ORDER BY UniqueID) row_num
FROM housing
ORDER by row_num;
-- Find duplicated data by classifying ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference and add count row of duplicated data

ALTER TABLE housing
DROP COLUMN OwnerAddress, 
DROP COLUMN TaxDistrict, 
DROP COLUMN PropertyAddress;
-- Drop irrelevant columns

SELECT *
FROM housing
WHERE UniqueID IS NULL;
-- Find Null Value in UniqueID to delete

DELETE
FROM housing
WHERE UniqueID IS NULL;
-- Delete Null Value in UniqueID


-- This SQL Codes are written on MySQL. Some functions might not work in other SQL software.
-- This file is performed by Korn Towiwat.