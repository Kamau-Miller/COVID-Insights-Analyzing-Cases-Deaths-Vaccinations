*/

--Cleaning data in SQL Queries

*/

SELECT *
FROM NashvilleHousing

--Standardize Date Format(Change SaleDate)

SELECT SaleDateConverted, CONVERT(Date,SaleDate)
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SaleDate= CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
ADD SaleDateConverted Date; 

UPDATE NashvilleHousing
SET SaleDateConverted= CONVERT(Date,SaleDate)

--Populate Property Address Data

SELECT *
FROM NashvilleHousing
--WHERE PropertyAddress IS Null
ORDER BY ParcelID



SELECT A.ParcelID, A.PropertyAddress, B.ParcelID, B.PropertyAddress, ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashvilleHousing A
JOIN NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID] <> B.[UniqueID]
WHERE A.PropertyAddress IS NULL

UPDATE A
SET PropertyAddress = ISNULL(A.PropertyAddress, B.PropertyAddress)
FROM NashvilleHousing A
JOIN NashvilleHousing B
ON A.ParcelID = B.ParcelID
AND A.[UniqueID] <> B.[UniqueID]
WHERE A.PropertyAddress IS NULL


-- Breaking out Address into Individual Columns (Address, City, State)

SELECT PropertyAddress
FROM NashvilleHousing
--WHERE PropertyAddress IS Null
--ORDER BY ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress)) AS Address
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
ADD PropertySplitAddress NVARCHAR(255); 

UPDATE NashvilleHousing
SET PropertySplitAddress= SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)-1)


ALTER TABLE NashvilleHousing
ADD PropertySplitCity NVARCHAR(255); 

UPDATE NashvilleHousing
SET PropertySplitCity= SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress)+ 1, LEN(PropertyAddress))


SELECT *
FROM NashvilleHousing


SELECT OwnerAddress
FROM NashvilleHousing


SELECT
PARSENAME(REPLACE(OwnerAddress, ',','.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',','.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',','.') ,1)
FROM NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



SELECT *
FROM NashvilleHousing


--Change Y and N to Yes and No in "Sold as Vacant" field

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y'THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
FROM NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y'THEN 'Yes'
       WHEN SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

--Remove Duplicates

WITH RowNumCTE AS(
SELECT *,
  ROW_NUMBER() OVER (
  PARTITION BY ParcelID, 
               PropertyAddress,
			   SalePrice,
			   SaleDate,
			   LegalReference
			   ORDER BY 
			     UniqueID
				 ) ROW_Num
FROM NashvilleHousing
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE Row_Num > 1
ORDER BY PropertyAddress


SELECT *
FROM NashvilleHousing


--Delete Unused Columns (Do not do this to raw data)

SELECT *
FROM NashvilleHousing

ALTER TABLE  NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE  NashvilleHousing
DROP COLUMN SaleDate







