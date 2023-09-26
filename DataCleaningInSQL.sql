-- Select all data from nashville
SELECT*
FROM NashvilleHousing

--standardize date format
SELECT SaleDate, CONVERT(date,SaleDate)
FROM Projects..NashvilleHousing

ALTER TABLE Projects..NashvilleHousing
ADD SaleDateConverted Date;

UPDATE Projects..NashvilleHousing
SET SaleDateConverted =  CONVERT(Date, SaleDate)


SELECT SaleDateConverted,  CONVERT(Date, SaleDate)
FROM Projects..NashvilleHousing
-- Populate property address data
SELECT *
FROM Projects..NashvilleHousing
WHERE PropertyAddress IS NOT NULL
ORDER BY ParcelID

----Use Join
SELECT a.[UniqueID ],a.ParcelID,a.PropertyAddress,b.[UniqueID ],b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Projects..NashvilleHousing a 
JOIN Projects..NashvilleHousing b
     ON a.ParcelID = b.ParcelID 
	 AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

---replace the nulls with data
UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM Projects..NashvilleHousing a 
JOIN Projects..NashvilleHousing b
     ON a.ParcelID = b.ParcelID 
	 AND a.[UniqueID ]<>b.[UniqueID ]
WHERE a.PropertyAddress IS NULL

--Seperating into individual Columns i.e Address, City, State
SELECT PropertyAddress
FROM Projects..NashvilleHousing

--=Using SUBSTRING

SELECT PropertyAddress,
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) AS City
FROM Projects..NashvilleHousing

---Updating the Table using the Substrings we created above
---add tables
ALTER TABLE Projects..NashvilleHousing
ADD PropertySplitAddress nvarchar(255);

ALTER TABLE Projects..NashvilleHousing
ADD PropertySplitCity nvarchar(255);


UPDATE Projects..NashvilleHousing
SET PropertySplitAddress =  SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)


UPDATE Projects..NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) 

--Get Address, City, State from OwnerAddress using a different method
SELECT
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM Projects..NashvilleHousing

---add tables
ALTER TABLE Projects..NashvilleHousing
ADD OwnerSplitAddress nvarchar(255);

ALTER TABLE Projects..NashvilleHousing
ADD OwnerSplitCity nvarchar(255);

ALTER TABLE Projects..NashvilleHousing
ADD OwnerSplitState nvarchar(255);

---Update the tables

UPDATE Projects..NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

UPDATE Projects..NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


UPDATE Projects..NashvilleHousing
SET OwnerSplitState= PARSENAME(REPLACE(OwnerAddress,',','.'),1)

--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT (SoldAsVacant), COUNT(SoldAsVacant)
FROM Projects..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

-- Execute the replacement using case statements
SELECT SoldAsVacant,
       CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	        WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SoldAsVacant
		END
FROM Projects..NashvilleHousing

--Update the table to replace the values in DB
UPDATE Projects..NashvilleHousing
SET SoldAsVacant = 
     CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	        WHEN SoldAsVacant = 'N' THEN 'No'
			ELSE SoldAsVacant
     END

--Remove Duplicates & Using CTE in the process

WITH RowNumCTE AS(
SELECT*,
ROW_NUMBER () OVER (
PARTITION BY 
            ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			ORDER BY 
			UniqueID
			) row_num
FROM Projects..NashvilleHousing
)

---get the duplicates, (ie where row number is 2)
SELECT*
FROM RowNumCTE
WHERE row_num <>1
ORDER BY PropertyAddress

---Delete the Duplicates
DELETE
FROM RowNumCTE
WHERE row_num <>1

--Delete Unused Columns
SELECT*
FROM Projects..NashvilleHousing

ALTER TABLE Projects..NashvilleHousing
DROP COLUMN OwnerAddress,TaxDistrict, PropertyAddress


--Also Delete the SaleDate
ALTER TABLE Projects..NashvilleHousing
DROP COLUMN SaleDate